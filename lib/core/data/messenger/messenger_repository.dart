import 'dart:async';
import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:kepleomax/core/app_constants.dart';
import 'package:kepleomax/core/data/data_sources/chats_api_data_sources.dart';
import 'package:kepleomax/core/data/data_sources/messages_api_data_sources.dart';
import 'package:kepleomax/core/data/local_data_sources/chats_local_data_source.dart';
import 'package:kepleomax/core/data/local_data_sources/drafts_local_data_source.dart';
import 'package:kepleomax/core/data/local_data_sources/messages_local_data_source.dart';
import 'package:kepleomax/core/data/local_data_sources/users_local_data_source.dart';
import 'package:kepleomax/core/data/messenger/combine_cache_and_api.dart';
import 'package:kepleomax/core/data/models/channel_update.dart';
import 'package:kepleomax/core/data/models/chats_collection.dart';
import 'package:kepleomax/core/data/models/messages_collection.dart';
import 'package:kepleomax/core/di/disposable.dart';
import 'package:kepleomax/core/models/chat.dart';
import 'package:kepleomax/core/models/message.dart';
import 'package:kepleomax/core/models/message_draft.dart';
import 'package:kepleomax/core/network/apis/messages/message_dtos.dart';
import 'package:kepleomax/core/network/websockets/messenger_web_socket.dart';
import 'package:kepleomax/core/network/websockets/models/channel_subscription_update.dart';
import 'package:kepleomax/core/network/websockets/models/channel_unsubscription_update.dart';
import 'package:kepleomax/core/network/websockets/models/deleted_message_update.dart';
import 'package:kepleomax/core/network/websockets/models/new_message_update.dart';
import 'package:kepleomax/core/network/websockets/models/online_status_update.dart';
import 'package:kepleomax/core/network/websockets/models/read_messages_update.dart';
import 'package:kepleomax/core/network/websockets/models/typing_activity_update.dart';
import 'package:kepleomax/core/services/notifications_service.dart';
import 'package:kepleomax/core/utils/stateful_stream.dart';

part 'on_channel_deleted.dart';
part 'on_channel_sub.dart';
part 'on_channel_unsub.dart';
part 'on_channel_update.dart';
part 'on_delete_message.dart';
part 'on_new_message.dart';
part 'on_online_update.dart';
part 'on_read_messages.dart';
part 'on_typing_update.dart';

abstract class MessengerRepository implements Disposable {
  /// api/db calls
  /// on BlocInit call loadChatsFromCache(); on ws connected call loadChats()
  Future<void> loadCachedChats();

  Future<void> loadChats();

  Future<void> loadMessages({
    required int chatId,
    bool withCache = true,
    bool loadCacheInTwoSteps = false,
  });

  Future<void> loadMoreMessages({required int chatId, required int? toMessageId});

  Future<String?> getDraft({required int chatId});

  Future<void> saveDraft({required String message, required int chatId});

  /// subscribes on messages from that userId, is used when chatId == -1
  void listenToMessagesWithOtherUserId({required int? otherUserId});

  void subscribeOnUserOnlineUpdates({required int userId});

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
    required DraftsLocalDataSource draftsLocalDataSource,
    required ChatsLocalDataSource chatsLocalDataSource,
    required UsersLocalDataSource usersLocalDataSource,
    required CombineCacheAndApi combiner,
  }) : _webSocket = messengerWebSocket,
       _chatsApi = chatsApiDataSource,
       _messagesApi = messagesApiDataSource,
       _chatsLocal = chatsLocalDataSource,
       _messagesLocal = messagesLocalDataSource,
       _draftsLocal = draftsLocalDataSource,
       _usersLocal = usersLocalDataSource,
       _combiner = combiner {
    _subs.addAll([
      _webSocket.newMessageUpdatesStream.listen(_onNewMessageUpdate),
      _webSocket.readMessagesStream.listen(_onReadMessages),
      _webSocket.deletedMessageStream.listen(_onDeletedMessage),
      _webSocket.onlineUpdatesStream.listen(_onOnlineUpdate),
      _webSocket.typingUpdatesStream.listen(_onTypingUpdate),
      _webSocket.channelSubscriptionUpdatesStream.listen(_onChannelSub),
      _webSocket.channelUnsubscriptionUpdatesStream.listen(_onChannelUnsub),
      _webSocket.channelUpdatesStream.listen(_onChannelUpdate),
      _webSocket.channelDeletedStream.listen(_onChannelDeleted),
    ]);
  }

  final MessengerWebSocket _webSocket;

  final ChatsApiDataSource _chatsApi;
  final MessagesApiDataSource _messagesApi;

  final MessagesLocalDataSource _messagesLocal;
  final DraftsLocalDataSource _draftsLocal;
  final ChatsLocalDataSource _chatsLocal;
  final UsersLocalDataSource _usersLocal;

  final CombineCacheAndApi _combiner;

  /// uses when chatId == -1 (it's a new chat with new user)
  int? _currentChatOtherUserId;
  int _currentChatId = -1;
  final List<StreamSubscription<void>> _subs = [];

  final _messagesUpdatesController = StatefulStreamController<MessagesCollection>();
  final _chatsUpdatesController = StatefulStreamController<ChatsCollection>();

  MessagesCollection? get _currentMessagesCollection =>
      _messagesUpdatesController.currentValue;

  ChatsCollection? get _currentChatsCollection =>
      _chatsUpdatesController.currentValue;

  @override
  ChatsCollection? get currentChatsCollection => _currentChatsCollection;

  /// emitters
  void _emitMessagesCollection(MessagesCollection collection) {
    _messagesUpdatesController.add(collection);

    // TODO also subscribe on user
    if (!collection.fromCache && collection.chatId >= 0) {
      _webSocket.subscribeOnChatsUpdatesIfNot(ids: [collection.chatId]);
    }
  }

  void _emitMessages(Iterable<Message> messages) {
    final collection = _currentMessagesCollection!.copyWith(messages: messages);
    _messagesUpdatesController.add(collection);
  }

  void _emitChatsCollection(ChatsCollection collection) {
    _chatsUpdatesController.add(collection);

    if (!collection.fromCache && collection.chats.isNotEmpty) {
      _webSocket
        ..subscribeOnChatsUpdatesIfNot(
          ids: collection.chats.map((c) => c.id).toList(),
        )
        ..subscribeOnOnlineStatusUpdatesIfNot(
          usersIds: collection.chats
              .where((c) => !c.isChannel && c.otherUser.id >= 0)
              .map((c) => c.otherUser.id)
              .toList(),
        );
    }
  }

  /// api calls
  @override
  Future<void> loadCachedChats() async {
    final cache = await _chatsLocal.getChats();
    _emitChatsCollection(
      ChatsCollection(
        chats: cache.map((chat) => Chat.fromDto(chat, fromCache: true)).toList(),
        fromCache: true,
      ),
    );
  }

  @override
  Future<void> loadChats() async {
    final chats = await _chatsApi.getChats();

    /// calculate drafts
    final cacheChats = _currentChatsCollection?.fromCache == true
        ? _currentChatsCollection!.chats
        : (await _chatsLocal.getChats())
              .map((chat) => Chat.fromDto(chat, fromCache: true))
              .toList();

    final cacheChatsHashMap = HashMap<int, Chat>();
    for (final cacheChat in cacheChats) {
      cacheChatsHashMap[cacheChat.id] = cacheChat;
    }
    final newList = <Chat>[];
    for (var chat in chats) {
      final cacheChat = cacheChatsHashMap[chat.id];
      if (cacheChat?.draft != null) {
        chat = chat.copyWithNewDraft(cacheChat!.draft);
      }
      newList.add(Chat.fromDto(chat, fromCache: false));
    }

    /// emit
    _emitChatsCollection(ChatsCollection(chats: newList, fromCache: false));

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
  void subscribeOnUserOnlineUpdates({required int userId}) {
    _webSocket.subscribeOnOnlineStatusUpdatesIfNot(usersIds: [userId]);
  }

  @override
  Future<void> loadMessages({
    required int chatId,
    int? otherUserId,
    bool withCache = true,
    bool loadCacheInTwoSteps = false,
  }) async {
    /// TODO maybe reset messagesCollection here?
    /// _currentChatOtherUserId != null means it's a new chat. If delete this line, provided
    /// chatId may broke something check the integration test: "open_deleted_chat_from_notification_test"
    /// and also there are that check in other places in this method
    if (_currentChatOtherUserId != null) return;
    _currentChatId = chatId;

    if (otherUserId != null) {
      _webSocket.subscribeOnOnlineStatusUpdatesIfNot(usersIds: [otherUserId]);
    }

    /// start loading api
    final apiMessagesDtosCompleter = Completer<List<MessageDto>>();
    unawaited(
      _messagesApi
          .getMessages(chatId: chatId, limit: AppConstants.msgPagingLimit)
          .then(apiMessagesDtosCompleter.complete),
    );

    /// emit data from cache
    List<MessageDto> cache = [];
    if (withCache) {
      cache = await _messagesLocal.getMessagesByChatId(
        chatId,
        limit: loadCacheInTwoSteps ? 50 : 500,
      );
      if (_currentChatOtherUserId != null || _currentChatId != chatId) return;
      _emitMessagesCollection(
        MessagesCollection(
          messages: cache.map(Message.fromDto),
          chatId: chatId,
          fromCache: true,
        ),
      );
      if (loadCacheInTwoSteps) {
        final cacheAll = await _messagesLocal.getMessagesByChatId(
          chatId,
          offset: cache.length,
          limit: 500,
        );
        cache = [...cache, ...cacheAll];
        if (_currentChatOtherUserId != null || _currentChatId != chatId) return;
        _emitMessagesCollection(
          MessagesCollection(
            messages: cache.map(Message.fromDto),
            chatId: chatId,
            fromCache: true,
          ),
        );
      }
    }

    /// emit data from api
    final apiMessagesDtos = await apiMessagesDtosCompleter.future;
    if (_currentChatOtherUserId != null || _currentChatId != chatId) return;
    final newList = _combiner.combineLoad(cache, apiMessagesDtos);

    _emitMessagesCollection(
      MessagesCollection(
        messages: newList.map(Message.fromDto),
        chatId: chatId,
        allMessagesLoaded: newList.length < AppConstants.msgPagingLimit,
        fromCache: false,
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
        : (messagesFromCache.indexWhere((m) => m.id == toMessageId) + 1);
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
          fromCache: false,
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
        fromCache: false,
        allMessagesLoaded: newLimit > api.length,
      ),
    );
  }

  @override
  Future<void> saveDraft({required String message, required int chatId}) async {
    if (message.isEmpty) {
      await _draftsLocal.deleteByChatId(chatId);
    } else {
      await _draftsLocal.insert(text: message, chatId: chatId);
    }

    if (_currentChatsCollection != null) {
      final newChats = _currentChatsCollection!.chats.toList();
      final index = newChats.indexWhere((chat) => chat.id == chatId);
      if (index == -1) return;
      newChats[index] = newChats[index].copyWith(
        draft: message.isEmpty
            ? null
            : MessageDraft(
                message: message,
                chatId: chatId,
                createdAt: DateTime.now().millisecondsSinceEpoch,
              ),
      );
      _emitChatsCollection(ChatsCollection(chats: newChats));
    }
  }

  @override
  Future<String?> getDraft({required int chatId}) =>
      _draftsLocal.getByChatId(chatId);

  @override
  void dispose() {
    _messagesUpdatesController.close();
    _chatsUpdatesController.close();
    for (final sub in _subs) {
      sub.cancel();
    }
  }

  /// streams
  @override
  Stream<MessagesCollection> get messagesUpdatesStream =>
      _messagesUpdatesController.stream;

  @override
  Stream<ChatsCollection> get chatsUpdatesStream => _chatsUpdatesController.stream;
}
