import 'dart:async';

import 'package:collection/collection.dart';
import 'package:kepleomax/core/network/apis/chats/chats_dtos.dart';
import 'package:sqflite/sqflite.dart';

abstract class ChatsLocalDataSource {
  Future<List<ChatDto>> getChats();

  Future<ChatDto?> getChat(int chatId);

  Future<ChatDto?> getChatByOtherUserId(int otherUserId);

  Future<void> clearAndInsertChatsAndLastMessages(Iterable<ChatDto> chats);

  Future<void> insert(ChatDto chat);

  Future<void> update(ChatDto chat);

  Future<void> deleteById(int chatId);

  Future<void> increaseUnreadCountBy1(int chatId);

  Future<void> decreaseUnreadCount(int chatId, int amount);
}

class ChatsLocalDataSourceImpl implements ChatsLocalDataSource {
  ChatsLocalDataSourceImpl({required Database database}) : _database = database;
  final Database _database;

  @override
  Future<ChatDto?> getChat(int chatId) async {
    final query = await _database.query(
      'chats',
      where: 'id = ?',
      whereArgs: [chatId],
    );

    if (query.isEmpty) return null;

    final otherUser = await _database.query(
      'users',
      where: 'id = ?',
      whereArgs: [query.first['other_user_id']],
    );
    if (otherUser.isEmpty) {
      throw Exception('otherUser in cache not found');
    }
    final newJson = Map<String, dynamic>.from(query.first);
    newJson['other_user_id'] = null;
    newJson['other_user'] = otherUser.firstOrNull;
    return ChatDto.fromJson(newJson);
  }

  @override
  Future<ChatDto?> getChatByOtherUserId(int otherUserId) async {
    final query = await _database.query(
      'chats',
      where: 'other_user_id = ?',
      whereArgs: [otherUserId],
    );
    if (query.isEmpty) return null;

    final otherUser = await _database.query(
      'users',
      where: 'id = ?',
      whereArgs: [query.first['other_user_id']],
    );
    if (otherUser.isEmpty) {
      throw Exception('otherUser in cache not found');
    }
    final newJson = Map<String, dynamic>.from(query.first);
    newJson['other_user_id'] = null;
    newJson['other_user'] = otherUser.firstOrNull;
    return ChatDto.fromJson(newJson);
  }

  @override
  Future<List<ChatDto>> getChats() async {
    /// chats.* should be the last in the select. id will be id of the chat, and
    /// there are user_id and message_id fields
    final query = await _database.rawQuery('''
      SELECT users.id AS user_id, messages.id as message_id, users.*, messages.*, chats.* FROM chats 
      LEFT JOIN users ON users.id = chats.other_user_id 
      LEFT JOIN messages ON messages.id = (SELECT id FROM messages WHERE chat_id = chats.id ORDER BY created_at DESC LIMIT 1)
      ''');

    final result = <ChatDto>[];
    await _database.transaction((ts) async {
      for (final chatJson in query) {
        // print('KlmLog, chatJson: $chatJson');
        if (chatJson['username'] == null) {
          unawaited(
            ts.delete(
              'chats',
              where: 'other_user_id = ?',
              whereArgs: [chatJson['other_user_id']],
            ),
          );
          continue;
        }

        result.add(ChatDto.fromLocalJson(chatJson));
      }
    });

    return result.sorted(
      (a, b) => (b.lastMessage?.createdAt ?? 0) - (a.lastMessage?.createdAt ?? 0),
    );
  }

  @override
  Future<void> insert(ChatDto chat) async {
    await _database.insert(
      'chats',
      chat.toLocalJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> update(ChatDto chat) async {
    await _database.update(
      'chats',
      chat.toLocalJson(),
      where: 'id = ?',
      whereArgs: [chat.id],
    );
  }

  @override
  Future<void> deleteById(int chatId) async {
    await _database.delete('chats', where: 'id = ?', whereArgs: [chatId]);
  }

  @override
  Future<void> clearAndInsertChatsAndLastMessages(Iterable<ChatDto> chats) async {
    /// delete lastMessages
    final oldChats = await getChats();
    final chatsMap = <int, ChatDto>{};
    for (final chat in chats) {
      chatsMap[chat.id] = chat;
    }
    await _database.transaction((transaction) async {
      for (int i = 0; i < oldChats.length; i++) {
        if (oldChats[i].lastMessage == null) continue;

        final newChat = chatsMap[oldChats[i].id];
        if (newChat == null) {
          await transaction.delete(
            'messages',
            where: 'chat_id = ?',
            whereArgs: [oldChats[i].id],
          );
        } else if (oldChats[i].lastMessage!.createdAt >
            (newChat.lastMessage?.createdAt ?? -1)) {
          await transaction.delete(
            'messages',
            where: 'id = ?',
            whereArgs: [oldChats[i].lastMessage!.id],
          );
        }
      }
    });

    /// delete and insert chats
    await _database.transaction((transaction) async {
      /// delete
      await transaction.delete('chats');

      /// insert
      for (final chat in chats) {
        await transaction.insert(
          'chats',
          chat.toLocalJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        await transaction.insert(
          'users',
          chat.otherUser.toLocalJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        if (chat.lastMessage != null) {
          await transaction.insert(
            'messages',
            chat.lastMessage!.toLocalJson(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }
    });
  }

  @override
  Future<void> increaseUnreadCountBy1(int chatId) async {
    await _database.rawUpdate(
      'UPDATE chats SET unread_count = unread_count + 1 WHERE id = ?',
      [chatId],
    );
  }

  @override
  Future<void> decreaseUnreadCount(int chatId, int amount) async {
    await _database.rawUpdate(
      'UPDATE chats SET unread_count = unread_count - ? WHERE id = ?',
      [amount, chatId],
    );
  }
}
