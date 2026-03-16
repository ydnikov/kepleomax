import 'dart:async';

import 'package:collection/collection.dart';
import 'package:kepleomax/core/app_constants.dart';
import 'package:kepleomax/core/data/data_sources/chats_api_data_sources.dart';
import 'package:kepleomax/core/data/data_sources/messages_api_data_sources.dart';
import 'package:kepleomax/core/data/local_data_sources/chats_local_data_source.dart';
import 'package:kepleomax/core/data/local_data_sources/messages_local_data_source.dart';
import 'package:kepleomax/core/data/local_data_sources/users_local_data_source.dart';
import 'package:kepleomax/core/data/messenger/combine_cache_and_api.dart';
import 'package:kepleomax/core/data/models/chats_collection.dart';
import 'package:kepleomax/core/data/models/messages_collection.dart';
import 'package:kepleomax/core/models/chat.dart';
import 'package:kepleomax/core/models/message.dart';
import 'package:kepleomax/core/network/apis/messages/message_dtos.dart';
import 'package:kepleomax/core/network/websockets/messages_web_socket.dart';
import 'package:kepleomax/core/network/websockets/models/deleted_message_update.dart';
import 'package:kepleomax/core/network/websockets/models/new_message_update.dart';
import 'package:kepleomax/core/network/websockets/models/online_status_update.dart';
import 'package:kepleomax/core/network/websockets/models/read_messages_update.dart';
import 'package:kepleomax/core/network/websockets/models/typing_activity_update.dart';
import 'package:kepleomax/core/services/notifications_service.dart';

part 'on_delete_message.dart';

part 'on_new_message.dart';

part 'on_online_update.dart';

part 'on_read_messages.dart';

part 'on_typing_update.dart';

abstract class MessengerRepository {
  /// api/db calls
  /// on BlocInit call loadChatsFromCache(); on ws connected call loadChats()
  Future<void> loadCachedChats();

  Future<void> loadChats();

  Future<void> loadMessages({required int chatId, bool withCache = true});

  /// subscribes on messages from that userId, uses when chatId == -1
  void listenToMessagesWithOtherUserId({required int? otherUserId});

  Future<void> loadMoreMessages({required int chatId, required int? toMessageId});

  Future<void> dispose();

  /// ws streams
  Stream<MessagesCollection> get messagesUpdatesStream;

  Stream<ChatsCollection> get chatsUpdatesStream;

  ChatsCollection? get currentChatsCollection;
}

class MessengerRepositoryImpl implements MessengerRepository {
  MessengerRepositoryImpl({
    required MessengerWebSocket messengerWebSocket,
    required ChatsApiDataSource chatsApiDataSource,
    required MessagesApiDataSource messagesApiDataSource,
    required MessagesLocalDataSource messagesLocalDataSource,
    required ChatsLocalDataSource chatsLocalDataSource,
    required UsersLocalDataSource usersLocalDataSource,
    required CombineCacheAndApi combiner,
  }) : _webSocket = messengerWebSocket,
       _chatsApi = chatsApiDataSource,
       _messagesApi = messagesApiDataSource,
       _chatsLocal = chatsLocalDataSource,
       _messagesLocal = messagesLocalDataSource,
       _usersLocal = usersLocalDataSource,
       _combiner = combiner {
    _subs.addAll([
      _webSocket.newMessageUpdatesStream.listen(_onNewMessageUpdate),
      _webSocket.readMessagesStream.listen(_onReadMessages),
      _webSocket.deletedMessageStream.listen(_onDeletedMessage),
      _webSocket.onlineUpdatesStream.listen(_onOnlineUpdate),
      _webSocket.typingUpdatesStream.listen(_onTypingUpdate),
    ]);
  }

  final MessengerWebSocket _webSocket;

  final ChatsApiDataSource _chatsApi;
  final MessagesApiDataSource _messagesApi;

  final MessagesLocalDataSource _messagesLocal;
  final ChatsLocalDataSource _chatsLocal;
  final UsersLocalDataSource _usersLocal;

  final CombineCacheAndApi _combiner;

  /// uses when chatId == -1 (it's a new chat with new user)
  int? _currentChatOtherUserId;
  int _currentChatId = -1;
  final List<StreamSubscription<void>> _subs = [];

  final _messagesUpdatesController =
      StreamController<MessagesCollection>.broadcast();
  final _chatsUpdatesController = StreamController<ChatsCollection>.broadcast();
  MessagesCollection? _currentMessagesCollection;
  ChatsCollection? _currentChatsCollection;

  @override
  ChatsCollection? get currentChatsCollection => _currentChatsCollection;

  /// emitters
  void _emitMessagesCollection(MessagesCollection collection) {
    _messagesUpdatesController.add(collection);
    _currentMessagesCollection = collection;
  }

  void _emitMessages(Iterable<Message> messages) {
    final collection = _currentMessagesCollection!.copyWith(messages: messages);
    _messagesUpdatesController.add(collection);
    _currentMessagesCollection = collection;
  }

  void _emitChatsCollection(ChatsCollection collection) {
    _chatsUpdatesController.add(collection);
    _currentChatsCollection = collection;
  }

  /// api calls
  @override
  Future<void> loadCachedChats() async {
    // final stopWatch = Stopwatch()..start();
    final cache = await _chatsLocal.getChats();
    _emitChatsCollection(
      ChatsCollection(
        chats: cache.map((chat) => Chat.fromDto(chat, fromCache: true)).toList(),
        fromCache: true,
      ),
    );
    // print('KlmLog loadCachedChats: ${stopWatch.elapsedMilliseconds}ms');
    // stopWatch.stop();
  }

  @override
  Future<void> loadChats() async {
    final chats = await _chatsApi.getChats();
    _emitChatsCollection(
      ChatsCollection(
        chats: chats.map((chat) => Chat.fromDto(chat, fromCache: false)).toList(),
        fromCache: false,
      ),
    );
    _webSocket.subscribeOnOnlineStatusUpdates(
      usersIds: chats.map((c) => c.otherUser.id),
    );

    /// cache
    unawaited(_chatsLocal.clearAndInsertChatsAndLastMessages(chats));
  }

  @override
  void listenToMessagesWithOtherUserId({required int? otherUserId}) {
    _currentChatOtherUserId = otherUserId;

    if (otherUserId == null) return;

    _emitMessagesCollection(
      const MessagesCollection(chatId: -1, messages: [], allMessagesLoaded: true),
    );
  }

  @override
  Future<void> loadMessages({required int chatId, bool withCache = true}) async {
    /// TODO maybe reset messagesCollection here?
    /// _currentChatOtherUserId != null means it's a new chat. If delete this line, provided
    /// chatId may broke something check the integration test: "open_deleted_chat_from_notification_test"
    /// and also there are that check in other places in this method
    if (_currentChatOtherUserId != null) return;
    _currentChatId = chatId;

    /// emit data from cache
    List<MessageDto> cache = [];
    if (withCache) {
      cache = await _messagesLocal.getMessagesByChatId(chatId);
      if (_currentChatOtherUserId != null || _currentChatId != chatId) return;
      _emitMessagesCollection(
        MessagesCollection(
          messages: cache.map(Message.fromDto),
          chatId: chatId,
          maintainLoading: true,
        ),
      );
    }

    /// emit data from api
    final apiMessagesDtos = await _messagesApi.getMessages(
      chatId: chatId,
      limit: AppConstants.msgPagingLimit,
    );
    if (_currentChatOtherUserId != null || _currentChatId != chatId) return;
    final newList = _combiner.combineLoad(cache, apiMessagesDtos);

    _emitMessagesCollection(
      MessagesCollection(
        messages: newList.map(Message.fromDto),
        chatId: chatId,
        allMessagesLoaded: newList.length < AppConstants.msgPagingLimit,
        maintainLoading: false,
      ),
    );
  }

  @override
  Future<void> loadMoreMessages({
    required int chatId,
    required int? toMessageId,
  }) async {
    if (_currentMessagesCollection == null) return;
    final messages = _currentMessagesCollection!.messages;

    /// TODO refactor
    /// if toMessageId is null, it means we are on top and have to load more
    /// messages AND all that have not been loaded
    final messagesFromCache = messages.where((m) => m.fromCache).toList();
    final limitCorrection = toMessageId == null
        ? messagesFromCache.length
        : messagesFromCache.indexWhere((m) => m.id == toMessageId);
    final newLimit = limitCorrection == -1
        ? AppConstants.msgPagingLimit
        : limitCorrection + AppConstants.msgPagingLimit;
    final api = await _messagesApi.getMessages(
      chatId: chatId,
      limit: newLimit,
      cursor: messages.lastWhereOrNull((e) => !e.fromCache)?.id,
    );
    if (_currentChatId != chatId) return;

    if (api.isEmpty) {
      _emitMessagesCollection(
        MessagesCollection(
          messages: messages,
          chatId: chatId,
          maintainLoading: false,
          allMessagesLoaded: true,
        ),
      );
      return;
    }

    final newList = _combiner.combineLoadMore(
      messages.toList(),
      api,
      limit: newLimit,
    );
    _emitMessagesCollection(
      MessagesCollection(
        messages: newList,
        chatId: chatId,
        maintainLoading: false,
        allMessagesLoaded: newLimit > api.length,
      ),
    );
  }

  @override
  Future<void> dispose() async {
    await _webSocket.dispose();
    await _messagesUpdatesController.close();
    await _chatsUpdatesController.close();
    for (final sub in _subs) {
      await sub.cancel();
    }
  }

  /// streams
  @override
  Stream<MessagesCollection> get messagesUpdatesStream =>
      _messagesUpdatesController.stream;

  @override
  Stream<ChatsCollection> get chatsUpdatesStream => _chatsUpdatesController.stream;
}
