// dart format width=200
// ignore_for_file: unawaited_futures

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:kepleomax/core/data/messenger/combine_cache_and_api.dart';
import 'package:kepleomax/core/data/messenger/messenger_repository.dart';
import 'package:kepleomax/core/data/models/messages_collection.dart';
import 'package:kepleomax/core/models/message.dart';
import 'package:kepleomax/core/network/apis/messages/message_dtos.dart';
import 'package:mockito/mockito.dart';

import 'mocks/fake_drafts_local_data_source.dart';
import 'mocks/fake_messages_web_socket.dart';
import 'mocks/mock_messages_local_data_source.dart';
import 'mocks/mockito_mocks.mocks.dart';

/// out, in, n, gaps are described in combine_cache_and_api.dart (CombineCacheAndApi)
void main() {
  group('messenger_repository_messages_test', () {
    late MessengerRepository repository;
    late StreamIterator<MessagesCollection> iterator;
    late MockMessagesLocalDataSource messagesLocal;
    late MockMessagesApiDataSource messagesApi;

    setUp(() {
      messagesLocal = MockMessagesLocalDataSource();
      messagesApi = MockMessagesApiDataSource();

      repository = MessengerRepositoryImpl(
        messengerWebSocket: FakeMessagesWebSocket(),
        chatsApiDataSource: MockChatsApiDataSource(),
        messagesApiDataSource: messagesApi,
        messagesLocalDataSource: messagesLocal,
        draftsLocalDataSource: FakeDraftsLocalDataSource(),
        chatsLocalDataSource: MockChatsLocalDataSource(),
        usersLocalDataSource: MockUsersLocalDataSource(),
        combiner: CombineCacheAndApi(messagesLocal),
      );

      iterator = StreamIterator(repository.messagesUpdatesStream);
    });

    tearDown(() {
      messagesLocal.deleteAllByChatId(0);
    });

    List<MessageDto> generateMessages(int from, int to, {int chatId = 0, bool fromCache = false}) => List.generate(from - to, (i) {
      /// from 5 to 0 => 4, 3, 2, 1, 0
      /// from 20 to 15 => 19, 18, 17, 16, 15
      final id = from - i - 1;
      return MessageDto(
        id: id,
        chatId: chatId,
        senderId: 1,
        message: 'MSG_${fromCache ? 'CACHE' : 'API'}_$id',
        isRead: true,
        createdAt: 800,
        editedAt: null,
        fromCache: fromCache,
      );
    });

    void getMessagesFromCacheMustReturn(List<MessageDto> messages, {int chatId = 0}) {
      messagesLocal.getMessagesMustReturn(messages);
    }

    void getMessagesMustReturn(List<MessageDto> messages, {int chatId = 0, int limit = 15, int? cursor}) {
      when(messagesApi.getMessages(chatId: chatId, limit: limit, cursor: cursor)).thenAnswer((_) async => messages);
    }

    List<MessageDto> generateGetMessagesFromCache(int from, int to, {int chatId = 0}) {
      final list = generateMessages(from, to, fromCache: true, chatId: chatId);
      getMessagesFromCacheMustReturn(list, chatId: chatId);
      return list;
    }

    List<MessageDto> generateGetMessages(int from, int to, {int chatId = 0}) {
      final list = generateMessages(from, to, chatId: chatId);
      getMessagesMustReturn(list, chatId: chatId);
      return list;
    }

    Future<void> checkNextState(List<MessageDto> messages, {bool fromCache = false, bool? allMessagesLoaded = false, bool checkLocal = false}) async {
      await iterator.moveNext();
      expect(
        iterator.current,
        MessagesCollection(chatId: 0, messages: messages.map(Message.fromDto).toList(), fromCache: fromCache, allMessagesLoaded: allMessagesLoaded),
        reason:
            '\nExpected messages (id, fromCache): ${messages.map((m) => '(${m.id}, ${m.fromCache})').toList()} - ${messages.length} in total\nActual messages (id, fromCache): ${iterator.current.messages.map((m) => '(${m.id}, ${m.fromCache})').toList()} - ${iterator.current.messages.length} in total',
      );
      if (checkLocal) {
        messagesLocal.checkCache(messages);
      }
    }

    Future<void> setupFirstLoad(List<MessageDto> cacheMessages, List<MessageDto> apiMessages) async {
      getMessagesFromCacheMustReturn(cacheMessages);
      getMessagesMustReturn(apiMessages);

      repository.loadMessages(chatId: 0);
      await checkNextState(cacheMessages, fromCache: true, allMessagesLoaded: null);
      await checkNextState([...apiMessages, if (apiMessages.length <= cacheMessages.length) ...cacheMessages.sublist(apiMessages.length)]);
    }

    /// ---------------------------------------------------------------------
    /// loadMessages() tests
    /// ---------------------------------------------------------------------
    test('load_messages_n_n_test', () async {
      final cacheMessages = generateGetMessagesFromCache(15, 0);
      final apiMessages = generateGetMessages(15, 0);

      repository.loadMessages(chatId: 0);
      await checkNextState(cacheMessages, fromCache: true, allMessagesLoaded: null);
      await checkNextState(apiMessages, checkLocal: true);
    });

    test('load_messages_n_out_test', () async {
      final cacheMessages = generateGetMessagesFromCache(15, 5);
      final apiMessages = generateGetMessages(15, 0);

      repository.loadMessages(chatId: 0);
      await checkNextState(cacheMessages, fromCache: true, allMessagesLoaded: null);
      await checkNextState(apiMessages, checkLocal: true);
    });

    test('load_messages_n_in_test', () async {
      final cacheMessages = generateGetMessagesFromCache(20, 0);
      final apiMessages = generateGetMessages(20, 5);

      repository.loadMessages(chatId: 0);
      await checkNextState(cacheMessages, fromCache: true, allMessagesLoaded: null);
      await checkNextState([...apiMessages, ...generateMessages(5, 0, fromCache: true)], checkLocal: true);
    });

    test('load_messages_n_in_all_messages_loaded_test', () async {
      final cacheMessages = generateGetMessagesFromCache(15, 0);
      final apiMessages = generateGetMessages(15, 5);

      repository.loadMessages(chatId: 0);
      await checkNextState(cacheMessages, fromCache: true, allMessagesLoaded: null);
      await checkNextState([...apiMessages], allMessagesLoaded: true, checkLocal: true);
    });

    test('load_messages_out_n_test', () async {
      final cacheMessages = generateGetMessagesFromCache(10, 0);
      final apiMessages = generateGetMessages(15, 0);

      repository.loadMessages(chatId: 0);
      await checkNextState(cacheMessages, fromCache: true, allMessagesLoaded: null);
      await checkNextState(apiMessages, checkLocal: true);
    });

    test('load_messages_out_out_test', () async {
      final cacheMessages = generateGetMessagesFromCache(10, 5);
      final apiMessages = generateGetMessages(15, 0);

      repository.loadMessages(chatId: 0);
      await checkNextState(cacheMessages, fromCache: true, allMessagesLoaded: null);
      await checkNextState(apiMessages, checkLocal: true);
    });

    test('load_messages_out_in_test', () async {
      final cacheMessages = generateGetMessagesFromCache(15, 0);
      final apiMessages = generateGetMessages(20, 5);

      repository.loadMessages(chatId: 0);
      await checkNextState(cacheMessages, fromCache: true, allMessagesLoaded: null);
      await checkNextState([...apiMessages, ...generateMessages(5, 0, fromCache: true)], checkLocal: true);
    });

    test('load_messages_out_in_all_messages_loaded_test', () async {
      final cacheMessages = generateGetMessagesFromCache(10, 0);
      final apiMessages = generateGetMessages(15, 5);

      repository.loadMessages(chatId: 0);
      await checkNextState(cacheMessages, fromCache: true, allMessagesLoaded: null);
      await checkNextState(apiMessages, allMessagesLoaded: true, checkLocal: true);
    });

    test('load_messages_in_n_test', () async {
      final cacheMessages = generateGetMessagesFromCache(20, 0);
      final apiMessages = generateGetMessages(15, 0);

      repository.loadMessages(chatId: 0);
      await checkNextState(cacheMessages, fromCache: true, allMessagesLoaded: null);
      await checkNextState(apiMessages, checkLocal: true);
    });

    test('load_messages_in_out_test', () async {
      final cacheMessages = generateGetMessagesFromCache(20, 5);
      final apiMessages = generateGetMessages(15, 0);

      repository.loadMessages(chatId: 0);
      await checkNextState(cacheMessages, fromCache: true, allMessagesLoaded: null);
      await checkNextState(apiMessages, checkLocal: true);
    });

    test('load_messages_in_in_test', () async {
      final cacheMessages = generateGetMessagesFromCache(25, 0);
      final apiMessages = generateGetMessages(20, 5);

      repository.loadMessages(chatId: 0);
      await checkNextState(cacheMessages, fromCache: true, allMessagesLoaded: null);
      await checkNextState([...apiMessages, ...generateMessages(5, 0, fromCache: true)], checkLocal: true);
    });

    test('load_messages_in_in_all_messages_loaded_test', () async {
      final cacheMessages = generateGetMessagesFromCache(25, 0);
      final apiMessages = generateGetMessages(15, 5);

      repository.loadMessages(chatId: 0);
      await checkNextState(cacheMessages, fromCache: true, allMessagesLoaded: null);
      await checkNextState(apiMessages, allMessagesLoaded: true, checkLocal: true);
    });

    test('load_messages_one_message_test', () async {
      final cacheMessages = generateGetMessagesFromCache(1, 0);
      final apiMessages = generateGetMessages(1, 0);

      repository.loadMessages(chatId: 0);
      await checkNextState(cacheMessages, fromCache: true, allMessagesLoaded: null);
      await checkNextState(apiMessages, allMessagesLoaded: true, checkLocal: true);
    });

    test('load_messages_0_api_messages_test', () async {
      final cacheMessages = generateGetMessagesFromCache(15, 0);
      final apiMessages = generateGetMessages(0, 0);

      repository.loadMessages(chatId: 0);
      await checkNextState(cacheMessages, fromCache: true, allMessagesLoaded: null);
      await checkNextState(apiMessages, allMessagesLoaded: true, checkLocal: true);
    });

    test('load_messages_0_cache_messages_test', () async {
      final cacheMessages = generateGetMessagesFromCache(0, 0);
      final apiMessages = generateGetMessages(15, 0);

      repository.loadMessages(chatId: 0);
      await checkNextState(cacheMessages, fromCache: true, allMessagesLoaded: null);
      await checkNextState(apiMessages, checkLocal: true);
    });

    test('load_messages_0_cache_and_api_messages_test', () async {
      final cacheMessages = generateGetMessagesFromCache(0, 0);
      final apiMessages = generateGetMessages(0, 0);

      repository.loadMessages(chatId: 0);
      await checkNextState(cacheMessages, fromCache: true, allMessagesLoaded: null);
      await checkNextState(apiMessages, allMessagesLoaded: true, checkLocal: true);
    });

    /// ---------------------------------------------------------------------
    /// loadMoreMessages() tests
    /// ---------------------------------------------------------------------
    test('load_more_messages_n_n_test', () async {
      final cacheMessages = generateMessages(30, 0, fromCache: true);
      final apiMessages = generateMessages(30, 15);
      await setupFirstLoad(cacheMessages, apiMessages);

      final nextApiMessages = generateMessages(15, 0);
      getMessagesMustReturn(nextApiMessages, cursor: 15);
      repository.loadMoreMessages(chatId: 0, toMessageId: 15);
      await checkNextState([...apiMessages, ...nextApiMessages], checkLocal: true);
    });

    test('load_more_messages_n_n_conflict_test', () async {
      final cacheMessages = generateMessages(35, 0, fromCache: true);
      final apiMessages = generateMessages(35, 20);
      await setupFirstLoad(cacheMessages, apiMessages);

      final nextApiMessages = [...generateMessages(20, 15), ...generateMessages(10, 0)];
      getMessagesMustReturn(nextApiMessages, cursor: 20);
      repository.loadMoreMessages(chatId: 0, toMessageId: 20);
      await checkNextState([...apiMessages, ...nextApiMessages], checkLocal: true);
    });

    test('load_more_messages_n_n_all_messages_loaded_test', () async {
      final cacheMessages = generateMessages(20, 0, fromCache: true);
      final apiMessages = generateMessages(20, 5);
      await setupFirstLoad(cacheMessages, apiMessages);

      final nextApiMessages = generateMessages(5, 0);
      getMessagesMustReturn(nextApiMessages, cursor: 5);
      repository.loadMoreMessages(chatId: 0, toMessageId: 5);
      await checkNextState([...apiMessages, ...nextApiMessages], allMessagesLoaded: true, checkLocal: true);
    });

    test('load_more_messages_n_out_test', () async {
      final cacheMessages = generateMessages(45, 15, fromCache: true);
      final apiMessages = generateMessages(45, 30);
      await setupFirstLoad(cacheMessages, apiMessages);

      final nextApiMessages = generateMessages(30, 0);
      getMessagesMustReturn(nextApiMessages, limit: 30, cursor: 30);
      repository.loadMoreMessages(chatId: 0, toMessageId: null);
      await checkNextState([...apiMessages, ...nextApiMessages], checkLocal: true);
    });

    test('load_more_messages_n_out_conflict_test', () async {
      final cacheMessages = generateMessages(50, 20, fromCache: true);
      final apiMessages = generateMessages(50, 35);
      await setupFirstLoad(cacheMessages, apiMessages);

      final nextApiMessages = [...generateMessages(35, 20), ...generateMessages(15, 0)];
      getMessagesMustReturn(nextApiMessages, limit: 30, cursor: 35);
      repository.loadMoreMessages(chatId: 0, toMessageId: null);
      await checkNextState([...apiMessages, ...nextApiMessages], checkLocal: true);
    });

    test('load_more_messages_n_out_all_messages_loaded_test', () async {
      final cacheMessages = generateMessages(25, 0, fromCache: true);
      final apiMessages = generateMessages(25, 10);
      await setupFirstLoad(cacheMessages, apiMessages);

      final nextApiMessages = generateMessages(10, 0);
      getMessagesMustReturn(nextApiMessages, limit: 25, cursor: 10);
      repository.loadMoreMessages(chatId: 0, toMessageId: null);
      await checkNextState([...apiMessages, ...nextApiMessages], allMessagesLoaded: true, checkLocal: true);
    });

    test('load_more_messages_n_in_test', () async {
      final cacheMessages = generateMessages(45, 0, fromCache: true);
      final apiMessages = generateMessages(45, 30);
      await setupFirstLoad(cacheMessages, apiMessages);

      final nextApiMessages = generateMessages(30, 15);
      getMessagesMustReturn(nextApiMessages, limit: 15, cursor: 30);
      repository.loadMoreMessages(chatId: 0, toMessageId: 30);
      await checkNextState([...apiMessages, ...nextApiMessages, ...generateMessages(15, 0, fromCache: true)], checkLocal: true);
    });

    test('load_more_messages_n_in_conflict_test', () async {
      final cacheMessages = generateMessages(45, 0, fromCache: true);
      final apiMessages = generateMessages(45, 30);
      await setupFirstLoad(cacheMessages, apiMessages);

      final nextApiMessages = [...generateMessages(30, 20), ...generateMessages(15, 10)];
      getMessagesMustReturn(nextApiMessages, limit: 15, cursor: 30);
      repository.loadMoreMessages(chatId: 0, toMessageId: 30);
      await checkNextState([...apiMessages, ...nextApiMessages, ...generateMessages(10, 0, fromCache: true)], checkLocal: true);
    });

    test('load_more_messages_n_in_all_messages_loaded_test', () async {
      final cacheMessages = generateMessages(45, 0, fromCache: true);
      final apiMessages = generateMessages(45, 30);
      await setupFirstLoad(cacheMessages, apiMessages);

      final nextApiMessages = generateMessages(30, 20);
      getMessagesMustReturn(nextApiMessages, limit: 15, cursor: 30);
      repository.loadMoreMessages(chatId: 0, toMessageId: 30);
      await checkNextState([...apiMessages, ...nextApiMessages], allMessagesLoaded: true, checkLocal: true);
    });

    test('load_more_messages_without_cache_test', () async {
      final cacheMessages = generateMessages(30, 0, fromCache: true);
      final apiMessages = generateMessages(30, 15);
      await setupFirstLoad(cacheMessages, apiMessages);

      final nextApiMessages = generateMessages(15, 0);
      getMessagesMustReturn(nextApiMessages, limit: 15, cursor: 15);
      repository.loadMoreMessages(chatId: 0, toMessageId: 15);
      await checkNextState([...apiMessages, ...nextApiMessages], checkLocal: true);
    });

    test('load_more_messages_without_cache_all_messages_loaded_test', () async {
      final cacheMessages = generateMessages(30, 0, fromCache: true);
      final apiMessages = generateMessages(30, 15);
      await setupFirstLoad(cacheMessages, apiMessages);

      final nextApiMessages = generateMessages(15, 5);
      getMessagesMustReturn(nextApiMessages, limit: 15, cursor: 15);
      repository.loadMoreMessages(chatId: 0, toMessageId: 15);
      await checkNextState([...apiMessages, ...nextApiMessages], allMessagesLoaded: true, checkLocal: true);
    });

    test('load_more_messages_n_out_gap_conflict_test', () async {
      final cacheMessages = generateMessages(45, 10, fromCache: true);
      final apiMessages = generateMessages(45, 30);
      await setupFirstLoad(cacheMessages, apiMessages);

      final nextApiMessages = generateMessages(20, 5);
      getMessagesMustReturn(nextApiMessages, limit: 15, cursor: 30);
      repository.loadMoreMessages(chatId: 0, toMessageId: 30);
      await checkNextState([...apiMessages, ...nextApiMessages], checkLocal: true);
    });

    test('load_more_messages_n_out_gap_conflict_all_messages_loaded_test', () async {
      final cacheMessages = generateMessages(45, 10, fromCache: true);
      final apiMessages = generateMessages(45, 30);
      await setupFirstLoad(cacheMessages, apiMessages);

      final nextApiMessages = generateMessages(15, 5);
      getMessagesMustReturn(nextApiMessages, limit: 15, cursor: 30);
      repository.loadMoreMessages(chatId: 0, toMessageId: 30);
      await checkNextState([...apiMessages, ...nextApiMessages], allMessagesLoaded: true, checkLocal: true);
    });

    test('load_more_messages_n_n_gap_conflict_test', () async {
      final cacheMessages = generateMessages(45, 0, fromCache: true);
      final apiMessages = generateMessages(45, 30);
      await setupFirstLoad(cacheMessages, apiMessages);

      final nextApiMessages = generateMessages(15, 0);
      getMessagesMustReturn(nextApiMessages, limit: 15, cursor: 30);
      repository.loadMoreMessages(chatId: 0, toMessageId: 30);
      await checkNextState([...apiMessages, ...nextApiMessages], checkLocal: true);
    });

    test('load_more_messages_n_n_gap_conflict_all_messages_loaded_test', () async {
      final cacheMessages = generateMessages(45, 0, fromCache: true);
      final apiMessages = generateMessages(45, 30);
      await setupFirstLoad(cacheMessages, apiMessages);

      final nextApiMessages = generateMessages(10, 0);
      getMessagesMustReturn(nextApiMessages, limit: 15, cursor: 30);
      repository.loadMoreMessages(chatId: 0, toMessageId: 30);
      await checkNextState([...apiMessages, ...nextApiMessages], allMessagesLoaded: true, checkLocal: true);
    });

    test('load_more_messages_n_in_gap_conflict_test', () async {
      final cacheMessages = generateMessages(45, 0, fromCache: true);
      final apiMessages = generateMessages(45, 30);
      await setupFirstLoad(cacheMessages, apiMessages);

      final nextApiMessages = generateMessages(20, 5);
      getMessagesMustReturn(nextApiMessages, limit: 15, cursor: 30);
      repository.loadMoreMessages(chatId: 0, toMessageId: 30);
      await checkNextState([...apiMessages, ...nextApiMessages, ...generateMessages(5, 0, fromCache: true)], checkLocal: true);
    });

    test('load_more_messages_n_in_gap_conflict_all_messages_loaded_test', () async {
      final cacheMessages = generateMessages(45, 0, fromCache: true);
      final apiMessages = generateMessages(45, 30);
      await setupFirstLoad(cacheMessages, apiMessages);

      final nextApiMessages = generateMessages(20, 10);
      getMessagesMustReturn(nextApiMessages, limit: 15, cursor: 30);
      repository.loadMoreMessages(chatId: 0, toMessageId: 30);
      await checkNextState([...apiMessages, ...nextApiMessages], allMessagesLoaded: true, checkLocal: true);
    });

    /// if messageId == null -> must load all cached messages + 15 more
    /// if messageId != null -> must load all cached messages before messageId, messageId, + 15 more
    test('load_more_messages_to_message_id_test', () async {
      final cacheMessages = generateMessages(45, 0, fromCache: true);
      final apiMessages = generateMessages(45, 30);
      await setupFirstLoad(cacheMessages, apiMessages);

      final nextApiMessages = generateMessages(30, 10);
      getMessagesMustReturn(nextApiMessages, limit: 20, cursor: 30);
      repository.loadMoreMessages(chatId: 0, toMessageId: 25);
      await checkNextState([...apiMessages, ...nextApiMessages, ...generateMessages(10, 0, fromCache: true)], checkLocal: true);
    });

    test('load_more_messages_to_message_id_all_messages_loaded_test', () async {
      final cacheMessages = generateMessages(45, 0, fromCache: true);
      final apiMessages = generateMessages(45, 30);
      await setupFirstLoad(cacheMessages, apiMessages);

      final nextApiMessages = generateMessages(30, 15);
      getMessagesMustReturn(nextApiMessages, limit: 20, cursor: 30);
      repository.loadMoreMessages(chatId: 0, toMessageId: 25);
      await checkNextState([...apiMessages, ...nextApiMessages], allMessagesLoaded: true, checkLocal: true);
    });
  });
}
