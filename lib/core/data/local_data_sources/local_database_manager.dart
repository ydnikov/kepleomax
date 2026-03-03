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
    version: 1,
    onCreate: (db, _) async {
      await db.execute('''CREATE TABLE messages (
          id INT PRIMARY KEY, 
          chat_id INT NOT NULL, 
          sender_id INT NOT NULL, 
          is_current_user BIT, 
          message VARCHAR(4000) NOT NULL, 
          type VARCHAR(50) NOT NULL, 
          is_read BIT DEFAULT FALSE NOT NULL, 
          created_at BIGINT NOT NULL, 
          edited_at BIGINT
          )''');
      await db.execute('CREATE INDEX messages_chat_id_index ON messages (chat_id)');

      await db.execute('''CREATE TABLE chats (
          id INT PRIMARY KEY,
          other_user_id INT NOT NULL,
          unread_count INT NOT NULL
        )''');

      await db.execute('''CREATE TABLE users (
          id SERIAL PRIMARY KEY, 
          username VARCHAR(50) NOT NULL,
          profile_image VARCHAR(32),
          is_current BIT NOT NULL,
          is_online BIT NOT NULL,
          last_activity_time BIGINT NOT NULL)
          ''');

      // don't forget to add each new table into reset()
    },
    onUpgrade: (db, oldV, newV) async {},
  );

  static Future<void> reset() async {
    if (_db != null) {
      // await deleteDatabase(_db!.path);
      // _db = null;
      await _db!.transaction((transaction) async {
        await transaction.delete('messages');
        await transaction.delete('chats');
        await transaction.delete('users');
      });
    }
  }
}
