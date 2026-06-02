import 'package:kepleomax/core/network/apis/messages/message_dtos.dart';
import 'package:kepleomax/core/network/websockets/models/read_messages_update.dart';
import 'package:sqflite/sqflite.dart';

abstract class MessagesLocalDataSource {
  Future<List<MessageDto>> getMessagesByChatId(int chatId, {int offset, int limit});

  Future<void> insert(MessageDto message);

  Future<void> insertAll(Iterable<MessageDto> messages);

  Future<void> readMessages(ReadMessagesUpdate data);

  Future<void> update(MessageDto message);

  Future<void> deleteById(int id);

  Future<void> deleteAllWithIds(Iterable<int> ids);

  Future<void> deleteAllByChatId(int chatId);
}

class MessagesLocalDataSourceImpl implements MessagesLocalDataSource {
  MessagesLocalDataSourceImpl({required Database database}) : _database = database;
  final Database _database;

  @override
  Future<List<MessageDto>> getMessagesByChatId(int chatId, {int offset = 0, int limit = 150}) async {
    final query = await _database.query(
      'messages',
      where: 'chat_id = ?',
      whereArgs: [chatId],
      limit: limit,
      offset: offset,
      orderBy: 'created_at DESC',
    );
    return query.map((m) => MessageDto.fromJson(m, fromCache: true)).toList();
  }

  @override
  Future<void> insert(MessageDto message) async {
    await _database.insert(
      'messages',
      message.toLocalJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> insertAll(Iterable<MessageDto> messages) async {
    final list = messages.toList();
    await _database.transaction((transaction) async {
      for (final message in list) {
        await transaction.insert(
          'messages',
          message.toLocalJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  @override
  Future<void> readMessages(ReadMessagesUpdate data) async {
    for (final id in data.messagesIds) {
      await _database.update(
        'messages',
        {'is_read': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  @override
  Future<void> update(MessageDto message) async {
    await _database.update('messages', message.toJson());
  }

  @override
  Future<void> deleteById(int id) async {
    await _database.delete('messages', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<void> deleteAllWithIds(Iterable<int> ids) async {
    final list = ids.toList();
    await _database.transaction((transaction) async {
      for (final id in list) {
        await transaction.delete('messages', where: 'id = ?', whereArgs: [id]);
      }
    });
  }

  @override
  Future<void> deleteAllByChatId(int chatId) async {
    await _database.delete('messages', where: 'chat_id = ?', whereArgs: [chatId]);
  }
}
