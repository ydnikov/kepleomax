import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kepleomax/core/app_constants.dart';
import 'package:kepleomax/core/models/chat.dart';
import 'package:kepleomax/features/channel/data/channel_repository.dart';
import 'package:kepleomax/features/chats/data/chats_repository.dart';
import 'package:kepleomax/core/data/connection_repository.dart';
import 'package:kepleomax/core/data/messenger/messenger_repository.dart';
import 'package:kepleomax/core/data/models/messages_collection.dart';
import 'package:kepleomax/core/flavor.dart';
import 'package:kepleomax/core/logger.dart';
import 'package:kepleomax/core/models/message.dart';
import 'package:kepleomax/core/models/user.dart';
import 'package:kepleomax/core/network/websockets/messages_web_socket.dart';
import 'package:kepleomax/core/network/websockets/models/online_status_update.dart';
import 'package:kepleomax/core/network/websockets/models/typing_activity_update.dart';
import 'package:kepleomax/core/services/notifications_service.dart';
import 'package:kepleomax/core/presentation/user_error_message.dart';
import 'package:kepleomax/features/chat/bloc/chat_state.dart';
import 'package:rxdart/rxdart.dart';

part 'chat_events.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({
    required MessengerRepository messengerRepository,
    required ChatsRepository chatsRepository,
    required ConnectionRepository connectionRepository,
    required MessengerWebSocket messengerWebSocket,
    required ChannelRepository channelRepository,
  }) : _channelRepository = channelRepository,
       _messengerRepository = messengerRepository,
       _chatsRepository = chatsRepository,
       _connectionRepository = connectionRepository,
       _messagesWebSocket = messengerWebSocket,
       super(ChatStateBase.initial()) {
    /// subscribes
    _messagesUpdatesSub = _messengerRepository.messagesUpdatesStream.listen(
      (data) {
        add(_ChatEventEmitMessages(data: data));
      },
      onError: (Object e, StackTrace st) {
        add(_ChatEventEmitError(e, stackTrace: st));
      },
    );
    _chatUpdatesSub = _messengerRepository.chatsUpdatesStream.listen((newList) {
      final currentChat = newList.chats
          .where((e) => e.id == _data.chat.id)
          .firstOrNull;
      if (currentChat != null) {
        add(_ChatEventEmitUnreadCount(newCount: currentChat.unreadCount));
      }
    });
    _connectionStateSub = _connectionRepository.connectionStateStream.listen(
      (isConnected) => add(_ChatEventConnectingChanged(isConnected)),
    );
    _onlineUpdatesSub = _messagesWebSocket.onlineUpdatesStream.listen((update) {
      if (update.userId != _data.otherUser.id) return;
      add(_ChatEventOnlineStatusUpdate(update));
    });
    _typingUpdatesSub = _messagesWebSocket.typingUpdatesStream.listen((update) {
      if (_data.chat.id != update.chatId) return;
      add(_ChatEventTypingUpdate(update));
    });

    /// events
    on<ChatEvent>(
      (event, emit) => switch (event) {
        final ChatEventLoad event => _onLoad(event, emit),

        /// TODO can it be called before _onLoad()?
        /// needs here, because we don't have to read messages before they are loaded
        final ChatEventReadMessagesBeforeTime event => _onReadMessagesBeforeTime(
          event,
          emit,
        ),
        _ => () {},
      },
      transformer: sequential(),
    );
    on<ChatEventLoadMore>(
      _onLoadMore,
      transformer: (events, mapper) => events
          .throttle(
            (_) => Stream<void>.periodic(const Duration(milliseconds: 500)).take(1),
            trailing: true,
          )
          .exhaustMap(mapper),
    );
    on<ChatEventInit>(_onInit);
    on<ChatEventSendMessage>(_onSendMessage);
    on<ChatEventDeleteMessage>(_onDeleteMessage);
    on<ChatEventReadAllMessages>(_onReadAllMessages);
    on<ChatEventEditText>(_onEditText);
    on<ChatEventSubscribeOnChannel>(_onSubscribeOnChannel);

    /// local events
    on<_ChatEventTypingUpdate>(_onTypingUpdate, transformer: restartable());
    on<_ChatEventEmitOtherUser>(_onEmitOtherUser);
    on<_ChatEventOnlineStatusUpdate>(_onOnlineStatusUpdate);
    on<_ChatEventEmitError>(_onEmitError);
    on<_ChatEventEmitMessages>(_onEmitMessages);
    on<_ChatEventConnectingChanged>(_onConnectionChanged);
    on<_ChatEventEmitUnreadCount>(_onEmitUnreadCount);
  }

  final MessengerRepository _messengerRepository;
  final ChatsRepository _chatsRepository;
  final ConnectionRepository _connectionRepository;
  final ChannelRepository _channelRepository;
  final MessengerWebSocket _messagesWebSocket;
  late final StreamSubscription<void> _messagesUpdatesSub;
  late final StreamSubscription<void> _connectionStateSub;
  late final StreamSubscription<void> _chatUpdatesSub;
  late final StreamSubscription<void> _onlineUpdatesSub;
  late final StreamSubscription<void> _typingUpdatesSub;
  late ChatData _data = ChatData.initial();

  void _onInit(ChatEventInit event, Emitter<ChatState> emit) {
    _data = _data.copyWith(
      chat: event.chat ?? Chat.loading(),
      otherUser: event.otherUser,
    );
    emit(ChatStateBase(data: _data));

    add(
      ChatEventLoad(
        chat: event.chat ?? Chat.loading(),
        otherUser: event.otherUser,
        withCache: true,
      ),
    );
  }

  /// needed cause onLoad can be called on init and on connectionChanged at the same time
  int _lastTimeLoadWasCalled = 0;

  Future<void> _onLoad(ChatEventLoad event, Emitter<ChatState> emit) async {
    /// TODO make better flavor.isTesting
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - 1000 < _lastTimeLoadWasCalled && !flavor.isTesting) {
      return;
    }
    _lastTimeLoadWasCalled = now;

    /// set isConnected cause it can be called at init bloc
    _data = _data.copyWith(
      isConnected: _connectionRepository.isConnected,
      isLoading: true,
      isAllMessagesLoaded: false,
    );
    emit(ChatStateBase(data: _data));

    try {
      Chat chat = event.chat ?? Chat.loading();

      /// either chatId == -1 and we have otherUser, or otherUser == null and we have chatId
      if (chat.id == -1) {
        /// if someday the logic will be changed so chatId will be able to change, this is a potential bug spot
        /// because if we have cache, we don't check actual data from api. Now chats cache will be cleared
        /// everytime when chats are loaded. So if chatId will be changed cache will be updated after next
        /// LoadChatsEvent() in chats_bloc
        final cachedChat = await _chatsRepository.getChatWithUserFromCache(
          event.otherUser.id,
        );
        if (cachedChat != null) {
          chat = cachedChat;
        } else {
          final newChat = await _chatsRepository.getChatWithUser(event.otherUser.id);
          if (newChat != null) {
            chat = newChat;
          }
        }

        if (chat.id == -1) {
          /// it's a new chat with new user
          _data = _data.copyWith(
            chat: Chat.loading(),
            isLoading: false,
            messages: [],
          );
          emit(ChatStateBase(data: _data));
          _messengerRepository.listenToMessagesWithOtherUserId(
            otherUserId: event.otherUser.id,
          );
          _connectionRepository.listenOnlineStatusUpdates(
            usersIds: [_data.otherUser.id],
          );
          return;
        }

        /// it's an existing chat with otherUser, but opened not from the chat screen
        _data = _data.copyWith(chat: chat);
      }

      /// get user and check updates, because online status can be changed
      if (chat.isChannel) {
        final subsCount = await _channelRepository.getSubscribersCount(
          channelId: chat.channelData!.id,
        );
        _data = _data.copyWith(
          chat: _data.chat.copyWith(
            channelData: _data.chat.channelData!.copyWith(
              subscribersCount: subsCount,
            ),
          ),
        );
      } else {
        unawaited(
          Future(() async {
            final newChat = await _chatsRepository.getChatWithId(chat.id.toString());
            if (newChat == null) {
              /// chat with chatId is no longer exists
              logger.d('chat with id ${chat.id} is no longer exists');
              _messengerRepository.listenToMessagesWithOtherUserId(
                otherUserId: _data.otherUser.id,
              );
            } else if (chat.otherUser != _data.otherUser) {
              add(_ChatEventEmitOtherUser(chat.otherUser));
            }
          }).onError((e, st) {
            add(_ChatEventEmitError(e, stackTrace: st));
          }),
        );

        /// set unreadCount and isTyping
        if (chat.isTypingRightNow == true) {
          add(
            _ChatEventTypingUpdate(
              TypingActivityUpdate(chatId: chat.id, isTyping: true),
            ),
          );
        }
        _data = _data.copyWith(unreadCount: chat.unreadCount);
      }
      emit(ChatStateBase(data: _data));

      /// TODO now it works because we always open the chat at the very bottom of scroll list
      NotificationService.instance.closeWithChatId(chat.id);
      _connectionRepository.listenOnlineStatusUpdate(userId: _data.otherUser.id);

      final draft = await _messengerRepository.getDraft(chatId: chat.id);
      if (draft != null) {
        emit(ChatStateUpdateTextField(draft));
        emit(ChatStateBase(data: _data));
      }

      await _messengerRepository.loadMessages(
        chatId: chat.id,
        withCache: event.withCache,
        loadCacheInTwoSteps: true,
      );
    } catch (e, st) {
      _data = _data.copyWith(isLoading: false);
      add(_ChatEventEmitError(e, stackTrace: st));
    }
  }

  Future<void> _onLoadMore(ChatEventLoadMore event, Emitter<ChatState> emit) async {
    if (!_data.isConnected || _data.isAllMessagesLoaded || _data.isLoading) return;

    try {
      await _messengerRepository.loadMoreMessages(
        chatId: _data.chat.id,
        toMessageId: event.toMessageId,
      );
    } catch (e, st) {
      _data = _data.copyWith(isAllMessagesLoaded: true);
      add(_ChatEventEmitError(e, stackTrace: st));
    }
  }

  void _onReadMessagesBeforeTime(
    ChatEventReadMessagesBeforeTime event,
    Emitter<ChatState> emit,
  ) {
    if (_data.isLoading || !_data.isConnected) return;
    _messagesWebSocket.readMessagesBeforeTime(
      chatId: _data.chat.id,
      time: event.time,
    );
  }

  void _onReadAllMessages(ChatEventReadAllMessages event, Emitter<ChatState> emit) {
    _messagesWebSocket.readAllMessages(chatId: _data.chat.id);
  }

  void _onSendMessage(ChatEventSendMessage event, Emitter<ChatState> emit) {
    _messengerRepository.safeDraft(message: '', chatId: _data.chat.id);

    _messagesWebSocket.sendMessage(
      message: event.value,
      recipientId: _data.otherUser.id,
    );
  }

  void _onDeleteMessage(ChatEventDeleteMessage event, Emitter<ChatState> emit) {
    _messagesWebSocket.deleteMessage(messageId: event.messageId);
  }

  int _lastTimeActivityWasSent = 0;

  void _onEditText(ChatEventEditText event, Emitter<ChatState> emit) {
    print('KlmLog chatBloc onEditText: ${event.text}');
    _messengerRepository.safeDraft(message: event.text, chatId: _data.chat.id);

    /// sent typingActivity
    final now = DateTime.now().millisecondsSinceEpoch;
    if (_lastTimeActivityWasSent + 1000 < now) {
      if (event.text.isNotEmpty) {
        _messagesWebSocket.typingActivityDetected(chatId: _data.chat.id);
      }
      _lastTimeActivityWasSent = now;
    }
  }

  Future<void> _onSubscribeOnChannel(
    ChatEventSubscribeOnChannel event,
    Emitter<ChatState> emit,
  ) async {
    if (_data.isLoading || !_data.isConnected) return;

    _data = _data.copyWith(isBottomBarLoading: true);
    emit(ChatStateBase(data: _data));

    try {
      if (!_data.chat.isChannel) {
        throw Exception('Failed to subscribe: chat is not a channel');
      }

      final fakeDelay = AppConstants.fakeDelay;
      await _channelRepository.subscribe(channelId: _data.chat.channelData!.id);

      _data = _data.copyWith(
        chat: _data.chat.copyWith(
          channelData: _data.chat.channelData!.copyWith(
            userRole: UserChannelRole.subscriber,
            subscribersCount: _data.chat.channelData!.subscribersCount! + 1,
          ),
        ),
      );

      await fakeDelay;
    } catch (e, st) {
      add(_ChatEventEmitError(e, stackTrace: st));
    } finally {
      _data = _data.copyWith(isBottomBarLoading: false);
      emit(ChatStateBase(data: _data));
    }
  }

  /// private events
  Future<void> _onEmitMessages(
    _ChatEventEmitMessages event,
    Emitter<ChatState> emit,
  ) async {
    try {
      final messages = event.data.messages.toList();
      final newMessages = <Message>[];

      /// save unreadMessages widget position
      final unreadMessagesIsRequired =
          messages.isNotEmpty && !messages[0].isCurrentUser && !messages[0].isRead;
      final handleUnreadMessages =
          messages.isNotEmpty &&
          !_data.unreadMessagesValue.isLocked &&
          (event.data.maintainLoading == false || messages.length > 1);

      /// event.data.maintainLoading == false || messages.length > 1 means:
      /// either messages are from api, not from cache, OR messages from cache, but
      /// if there is only 1 message -> that means the message from chat.lastMessage
      /// and chat is not loaded
      if (unreadMessagesIsRequired && handleUnreadMessages) {
        _data = _data.copyWith(
          unreadMessagesValue: UnreadMessagesValue(
            isLocked: !event.data.maintainLoading,
            firstReadMessageCreatedAt:
                messages.firstWhereOrNull((m) => m.isRead)?.createdAt ??
                DateTime.fromMillisecondsSinceEpoch(0),
          ),
        );
      } else if (handleUnreadMessages) {
        _data = _data.copyWith(
          unreadMessagesValue: UnreadMessagesValue(
            isLocked: !event.data.maintainLoading,
            firstReadMessageCreatedAt: null,
          ),
        );
      }
      // here after first emit not from cache, unreadMessages will be established, and will never change

      for (int i = 0; i < messages.length; i++) {
        newMessages.add(messages[i]);

        final createdAt1 = messages[i].createdAt;
        final createdAt2 = messages.elementAtOrNull(i + 1)?.createdAt;

        /// add unreadMessages widget
        if (_data.unreadMessagesValue.firstReadMessageCreatedAt != null) {
          final firstReadMessageCreatedAt = _data
              .unreadMessagesValue
              .firstReadMessageCreatedAt!
              .millisecondsSinceEpoch;
          if (createdAt1.millisecondsSinceEpoch > firstReadMessageCreatedAt &&
              (createdAt2?.millisecondsSinceEpoch ?? 0) <=
                  firstReadMessageCreatedAt) {
            newMessages.add(Message.unreadMessages());
          }
        }

        /// add date widgets
        if (createdAt2 == null ||
            createdAt1.day > createdAt2.day ||
            createdAt1.month > createdAt2.month ||
            createdAt1.year > createdAt2.year) {
          newMessages.add(Message.date(createdAt1));
        }
      }

      /// emit
      if (event.data.chatId == -1) {
        /// chatId can be changed if initially it was -1 OR last message was deleted
        /// and chatId will be set to -1
        _data = _data.copyWith(chat: Chat.loading());
      } else if (event.data.chatId != _data.chat.id) {
        print(
          'event.data.chatId: ${event.data.chatId}, _data.chat.id: ${_data.chat.id}',
        );
        final chat = await _chatsRepository.getChatWithId(
          event.data.chatId.toString(),
        );
        _data = _data.copyWith(chat: chat ?? Chat.loading());
      }

      _data = _data.copyWith(
        messages: newMessages,
        isLoading: event.data.maintainLoading,
      );
      if (event.data.allMessagesLoaded != null) {
        _data = _data.copyWith(isAllMessagesLoaded: event.data.allMessagesLoaded!);
      }
      if (event.data.chatId == -1) {
        _data = _data.copyWith(unreadMessagesValue: UnreadMessagesValue.initial());
      }
      emit(ChatStateBase(data: _data));
    } catch (e, st) {
      add(_ChatEventEmitError(e, stackTrace: st));
    }
  }

  void _onConnectionChanged(
    _ChatEventConnectingChanged event,
    Emitter<ChatState> emit,
  ) {
    _data = _data.copyWith(isConnected: event.isConnected);
    emit(ChatStateBase(data: _data));

    if (event.isConnected && _data.chat.id != -1) {
      add(
        ChatEventLoad(chat: _data.chat, otherUser: _data.otherUser, withCache: true),
      );
    }
  }

  void _onEmitError(_ChatEventEmitError event, Emitter<ChatState> emit) {
    logger.e(event.error, stackTrace: event.stackTrace);
    emit(
      ChatStateMessage(
        message: event.error?.userErrorMessage ?? 'Something went wrong',
        isError: true,
      ),
    );
    emit(ChatStateBase(data: _data));
  }

  void _onEmitOtherUser(_ChatEventEmitOtherUser event, Emitter<ChatState> emit) {
    _data = _data.copyWith(otherUser: event.otherUser);
    emit(ChatStateBase(data: _data));
  }

  void _onEmitUnreadCount(_ChatEventEmitUnreadCount event, Emitter<ChatState> emit) {
    _data = _data.copyWith(unreadCount: event.newCount);
    emit(ChatStateBase(data: _data));
  }

  void _onOnlineStatusUpdate(
    _ChatEventOnlineStatusUpdate event,
    Emitter<ChatState> emit,
  ) {
    _data = _data.copyWith(
      otherUser: _data.otherUser.copyWith(
        isOnline: event.update.isOnline,
        lastActivityTime: event.update.lastActivityTime,
      ),
    );
    emit(ChatStateBase(data: _data));
  }

  Future<void> _onTypingUpdate(
    _ChatEventTypingUpdate event,
    Emitter<ChatState> emit,
  ) async {
    _data = _data.copyWith(isTyping: event.update.isTyping);
    emit(ChatStateBase(data: _data));
    if (!event.update.isTyping) return;

    await Future<void>.delayed(AppConstants.showTypingAfterActivity);
    _data = _data.copyWith(isTyping: false);
    emit(ChatStateBase(data: _data));
  }

  @override
  Future<void> close() {
    _messagesUpdatesSub.cancel();
    _connectionStateSub.cancel();
    _chatUpdatesSub.cancel();
    _onlineUpdatesSub.cancel();
    _typingUpdatesSub.cancel();
    _messengerRepository.listenToMessagesWithOtherUserId(otherUserId: null);
    return super.close();
  }
}
