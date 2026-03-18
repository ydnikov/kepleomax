import 'package:flutter_test/flutter_test.dart';
import 'package:kepleomax/core/data/local_data_sources/messages_local_data_source.dart';
import 'package:kepleomax/core/network/apis/messages/message_dtos.dart';
import 'package:kepleomax/core/network/websockets/models/read_messages_update.dart';

class MockMessagesLocalDataSource implements MessagesLocalDataSource {
  final Map<int, MessageDto> _cache = {};

  void checkCache(List<MessageDto> expected) {
    expect(
      _cache.values.map((m) => (m.id)).toSet(),
      expected.map((m) => (m.id)).toSet(),
      reason:
          '\nExpected: ${expected.map((m) => (m.id)).toSet().toList()}\nActual: ${_cache.values.map((m) => (m.id)).toSet().toList()}',
    );
    expect(_cache.length, expected.length);
  }

  @override
  Future<void> insert(MessageDto message) async {
    _cache[message.id] = message;
  }

  @override
  Future<void> insertAll(Iterable<MessageDto> messages) async {
    for (final m in messages) {
      _cache[m.id] = m;
    }
  }

  @override
  Future<void> update(MessageDto message) async {
    _cache[message.id] = message;
  }

  @override
  Future<void> deleteById(int id) async {
    _cache.remove(id);
  }

  @override
  Future<void> deleteAllWithIds(Iterable<int> ids) async {
    for (final id in ids) {
      _cache.remove(id);
    }
  }

  @override
  Future<void> deleteAllByChatId(int chatId) async {
    _cache.clear();
  }

  List<MessageDto> _getMessagesReturnValue = [];

  void getMessagesMustReturn(List<MessageDto> messages) {
    for (final m in messages) {
      _cache[m.id] = m;
    }
    _getMessagesReturnValue = messages;
  }

  @override
  Future<List<MessageDto>> getMessagesByChatId(
    int chatId, {
    int offset = 0,
    int limit = 9999,
  }) async => _getMessagesReturnValue;

  @override
  Future<void> readMessages(ReadMessagesUpdate data) async {}
}
