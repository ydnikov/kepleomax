import 'package:sqflite/sqflite.dart';

abstract class DraftsLocalDataSource {
  Future<void> insert({required String text, required int chatId});

  Future<void> deleteByChatId(int chatId);

  Future<String?> getByChatId(int chatId);
}

class DraftsLocalDataSourceImpl implements DraftsLocalDataSource {
  DraftsLocalDataSourceImpl({required Database database}) : _database = database;
  final Database _database;

  @override
  Future<void> insert({required String text, required int chatId}) async {
    await _database.insert('drafts', {
      'chat_id': chatId,
      'message': text,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> deleteByChatId(int chatId) async {
    await _database.delete('drafts', where: 'chat_id = ?', whereArgs: [chatId]);
  }

  @override
  Future<String?> getByChatId(int chatId) async {
    final query = await _database.query(
      'drafts',
      where: 'chat_id = ?',
      whereArgs: [chatId],
    );
    if (query.isEmpty) return null;
    return query.first['message']! as String;
  }
}
