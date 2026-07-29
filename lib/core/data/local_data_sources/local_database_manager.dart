import 'package:sqflite/sqflite.dart';

class LocalDatabaseManager {
  LocalDatabaseManager._();

  static Database? _db;

  static Future<Database> getDatabase() async {
    _db ??= await _openDatabase();
    return _db!;
  }

  static Future<Database> _openDatabase() => openDatabase(
    'klm_database.db',
    version: 5,
    onCreate: (db, _) async {
      await db.execute('''
        CREATE TABLE messages (
          id INT PRIMARY KEY, 
          chat_id INT NOT NULL, 
          sender_id INT NOT NULL, 
          is_current_user BIT, 
          message VARCHAR(4000) NOT NULL, 
          type VARCHAR(50) NOT NULL, 
          is_read BIT DEFAULT FALSE NOT NULL, 
          created_at BIGINT NOT NULL, 
          edited_at BIGINT,
          views_count INT NOT NULL
          )''');
      await db.execute('CREATE INDEX messages_chat_id_index ON messages (chat_id)');

      await db.execute('''
        CREATE TABLE drafts (
          chat_id INT PRIMARY KEY,
          message VARCHAR(4000) NOT NULL,
          created_at BIGINT NOT NULL
        )''');

      await db.execute('''
        CREATE TABLE chats (
          id INT PRIMARY KEY,
          other_user_id INT NOT NULL,
          unread_count INT NOT NULL,
          created_at INT NOT NULL,
          channel_data JSON
        )''');

      await db.execute('''
        CREATE TABLE users (
          id SERIAL PRIMARY KEY, 
          username VARCHAR(50) NOT NULL,
          profile_image VARCHAR(32),
          is_current BIT NOT NULL,
          is_online BIT NOT NULL,
          last_activity_time BIGINT NOT NULL
        )''');
    },
    onUpgrade: (db, oldV, newV) async {
      for (int i = oldV + 1; i <= newV; i++) {
        if (i == 3) {
          await db.execute(
            'ALTER TABLE messages ADD COLUMN views_count INT NOT NULL DEFAULT 0',
          );
          await db.execute('ALTER TABLE messages ALTER COLUMN DROP DEFAULT');
        } else if (i == 5) {
          await db.execute('DELETE FROM chats');
          await db.execute('ALTER TABLE chats ADD COLUMN created_at INT NOT NULL');
          await db.execute('ALTER TABLE chats ADD COLUMN channel_data JSON');
        }
      }
    },
  );

  static Future<void> reset() async {
    if (_db == null) return;

    await _db!.transaction((transaction) async {
      final tableNames = (await transaction.query(
        'sqlite_master',
        columns: ['name'],
        where: 'type = ?',
        whereArgs: ['table'],
      )).map((row) => row['name']! as String);

      for (final name in tableNames) {
        if (name.startsWith('sqlite_')) continue;

        await transaction.delete(name);
      }
    });
  }
}
