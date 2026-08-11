import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kepleomax/core/app_constants.dart';
import 'package:kepleomax/core/auth/auth_controller.dart';
import 'package:kepleomax/core/data/connection_repository.dart';
import 'package:kepleomax/core/data/messenger/messenger_repository.dart';
import 'package:kepleomax/core/data/models/messages_collection.dart';
import 'package:kepleomax/core/extensions/fake_delay_extension.dart';
import 'package:kepleomax/core/flavor.dart';
import 'package:kepleomax/core/logger.dart';
import 'package:kepleomax/core/models/chat.dart';
import 'package:kepleomax/core/models/message.dart';
import 'package:kepleomax/core/models/user.dart';
import 'package:kepleomax/core/network/websockets/messenger_web_socket.dart';
import 'package:kepleomax/core/network/websockets/models/online_status_update.dart';
import 'package:kepleomax/core/network/websockets/models/typing_activity_update.dart';
import 'package:kepleomax/core/presentation/user_error_message.dart';
import 'package:kepleomax/core/services/notifications_service.dart';
import 'package:kepleomax/features/channel/data/channel_repository.dart';
import 'package:kepleomax/features/chat/bloc/chat_state.dart';
import 'package:kepleomax/features/chats/data/chats_repository.dart';
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
    /// subscriptions
    _subs.addAll([
      _messengerRepository.messagesUpdatesStream.listen(
        (data) {
          add(_ChatEventEmitMessages(data: data));
        },
        onError: (Object e, StackTrace st) {
          add(_ChatEventEmitError(e, stackTrace: st));
        },
      ),
      _messengerRepository.chatsUpdatesStream.listen((collection) {
        final currentChatInUpdatedList = collection.chats
            .where((e) => e.id == _data.chat.id)
            .firstOrNull;
        if (currentChatInUpdatedList != null) {
          add(_ChatEventEmitChat(chat: currentChatInUpdatedList));
        }
      }),
      _messagesWebSocket.newMessageUpdatesStream.listen((update) {
        if (update.message.chatId != _data.chat.id) return;

        final chatWillBeUpdatedViaChatsUpdateStream =
            _messengerRepository.currentChatsCollection?.chats
                .where((c) => c.id == update.message.chatId)
                .isNotEmpty ??
            false;
        if (!chatWillBeUpdatedViaChatsUpdateStream) {
          add(
            _ChatEventEmitChat(
              chat: _data.chat.copyWith(unreadCount: _data.chat.unreadCount + 1),
            ),
          );
        }
      }),
      _messagesWebSocket.readMessagesStream.listen((update) {
        if (update.chatId != _data.chat.id || update.byCurrentUser != true) return;

        final chatWillBeUpdatedViaChatsUpdateStream =
            _messengerRepository.currentChatsCollection?.chats
                .where((c) => c.id == update.chatId)
                .isNotEmpty ??
            false;

        if (!chatWillBeUpdatedViaChatsUpdateStream) {
          add(
            _ChatEventEmitChat(
              chat: _data.chat.copyWith(
                unreadCount: _data.chat.unreadCount - update.messagesIds.length,
              ),
            ),
          );
        }
      }),
      _connectionRepository.connectionStateStream.listen(
        (isConnected) => add(_ChatEventConnectingChanged(isConnected)),
      ),
      _messagesWebSocket.onlineUpdatesStream.listen((update) {
        if (update.userId != _data.otherUser.id) return;
        add(_ChatEventOnlineStatusUpdate(update));
      }),
      _messagesWebSocket.typingUpdatesStream.listen((update) {
        if (update.chatId != _data.chat.id ||
            update.userId == AuthController.currentUserId) {
          return;
        }
        add(_ChatEventTypingUpdate(update));
      }),
      _channelRepository.channelUpdatesStream.listen((channelData) {
        if (channelData.id != _data.chat.id) return;
        add(_ChatEventEmitChannelUpdate(channelData: channelData));
      }),
      _channelRepository.channelDeletedStream.listen((channelId) {
        if (channelId != _data.chat.id) return;
        add(const _ChatEventChannelDeleted());
      }),
    ]);

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
    on<ChatEventForceRebuild>(_onForceRebuild);

    /// local events
    on<_ChatEventTypingUpdate>(_onTypingUpdate, transformer: restartable());
    on<_ChatEventEmitOtherUser>(_onEmitOtherUser);
    on<_ChatEventOnlineStatusUpdate>(_onOnlineStatusUpdate);
    on<_ChatEventEmitError>(_onEmitError);
    on<_ChatEventEmitMessages>(_onEmitMessages, transformer: restartable());
    on<_ChatEventConnectingChanged>(_onConnectionChanged);
    on<_ChatEventEmitChat>(_onEmitChat);
    on<_ChatEventEmitChannelUpdate>(_onEmitChannelUpdate);
    on<_ChatEventChannelDeleted>(_onChannelDeleted);
  }

  final MessengerRepository _messengerRepository;
  final ChatsRepository _chatsRepository;
  final ConnectionRepository _connectionRepository;
  final ChannelRepository _channelRepository;
  final MessengerWebSocket _messagesWebSocket;
  final List<StreamSubscription<void>> _subs = [];
  late ChatData _data = ChatData.initial();

  void _onInit(ChatEventInit event, Emitter<ChatState> emit) {
    _data = _data.copyWith(
      chat: event.chat ?? Chat.loading(),
      otherUser: event.otherUser,
    );
    emit(ChatStateBase(_data));

    add(
      ChatEventLoad(chat: event.chat, otherUser: event.otherUser, withCache: true),
    );
  }

  /// needed cause onLoad can be called on init and on connectionChanged at the same time
  int _lastTimeLoadWasCalled = 0;

  Future<void> _onLoad(ChatEventLoad event, Emitter<ChatState> emit) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - 1000 < _lastTimeLoadWasCalled && !flavor.isTesting) {
      return;
    }
    _lastTimeLoadWasCalled = now;

    /// set isConnected cause it can be called at init bloc
    _data = _data.copyWith(
      chat: event.chat ?? Chat.loading(),
      isConnected: _connectionRepository.isConnected,
      isLoading: true,
      isAllMessagesLoaded: false,
    );
    emit(ChatStateBase(_data));

    try {
      Chat? chat = event.chat;

      if (chat == null || chat.id < 0) {
        /// if chat is null, the chat screen was opened from user_screen or people_screen
        /// that means it can't be a channel
        final cachedChat = await _chatsRepository.getChatWithUserFromCache(
          event.otherUser.id,
        );
        if (cachedChat != null) {
          chat = cachedChat;
          unawaited(_getUserAndCheckUpdates(chatId: chat.id));
        } else {
          chat = await _chatsRepository.getChatWithUser(event.otherUser.id);
        }

        _data = _data.copyWith(chat: chat);
      }

      if (chat.isChannel) {
        unawaited(_channelRepository.init(channelData: chat.channelData));
      } else {
        _checkAndSetIsTyping(chat: chat);
      }
      emit(ChatStateBase(_data));

      /// subscribe on user online status
      if (!chat.isChannel && chat.otherUser.id > 0) {
        _messengerRepository.subscribeOnUserOnlineUpdates(userId: chat.otherUser.id);
      }

      /// set draft
      await _checkDraftAndSet(chatId: chat.id, emit: emit);

      /// now it works because chat always opens at the very bottom of the scroll list
      NotificationService.instance.closeWithChatId(chat.id);

      /// load
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

  Future<void> _getUserAndCheckUpdates({required int chatId}) async {
    try {
      final newChat = await _chatsRepository.getChatWithId(chatId.toString());
      if (newChat != null && newChat.otherUser != _data.otherUser) {
        add(_ChatEventEmitOtherUser(newChat.otherUser));
      }
    } catch (e, st) {
      add(_ChatEventEmitError(e, stackTrace: st));
    }
  }

  void _checkAndSetIsTyping({required Chat chat}) {
    if (chat.isTypingRightNow == true) {
      add(
        _ChatEventTypingUpdate(
          TypingActivityUpdate(chatId: chat.id, isTyping: true),
        ),
      );
    }
  }

  Future<void> _checkDraftAndSet({
    required int chatId,
    required Emitter<ChatState> emit,
  }) async {
    final draft = await _messengerRepository.getDraft(chatId: chatId);
    if (draft != null) {
      emit(ChatStateUpdateTextField(draft));
      emit(ChatStateBase(_data));
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
    _messengerRepository.saveDraft('', chatId: _data.chat.id);

    _messagesWebSocket.sendMessage(event.value, chatId: _data.chat.id);
  }

  void _onDeleteMessage(ChatEventDeleteMessage event, Emitter<ChatState> emit) {
    _messagesWebSocket.deleteMessage(event.messageId);
  }

  int _lastTimeActivityWasSent = 0;

  void _onEditText(ChatEventEditText event, Emitter<ChatState> emit) {
    _messengerRepository.saveDraft(event.text, chatId: _data.chat.id);

    if (_data.chat.isChannel) return;

    /// sent typingActivity
    final now = DateTime.now().millisecondsSinceEpoch;
    if (_lastTimeActivityWasSent + 1000 < now) {
      if (event.text.isNotEmpty) {
        _messagesWebSocket.typingActivityDetected(chatId: _data.chat.id);
        print('send typing activity');
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
    emit(ChatStateBase(_data));

    try {
      if (!_data.chat.isChannel) {
        throw Exception('Failed to subscribe: chat is not a channel');
      }

      await _channelRepository.subscribe().withFakeDelay();

      /// don't set subsCount, cause it will be set via ws update
      _data = _data.copyWith(
        chat: _data.chat.copyWith(
          channelData: _data.chat.channelData!.copyWith(
            userRole: UserChannelRole.subscriber,
          ),
        ),
      );
    } catch (e, st) {
      add(_ChatEventEmitError(e, stackTrace: st));
    } finally {
      _data = _data.copyWith(isBottomBarLoading: false);
      emit(ChatStateBase(_data));
    }
  }

  void _onForceRebuild(ChatEventForceRebuild event, Emitter<ChatState> emit) {
    emit(
      ChatStateBase(_data, forceRebuildKey: DateTime.now().millisecondsSinceEpoch),
    );
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
          messages.isNotEmpty &&
          !messages[0].isCurrentUser &&
          !messages[0].isReadByCurrentUser;
      final handleUnreadMessages =
          messages.isNotEmpty &&
          !_data.unreadMessagesValue.isLocked &&
          (event.data.fromCache == false || messages.length > 1);

      /// event.data.fromCache == false || messages.length > 1 means:
      /// either messages are from api, not from cache, OR messages from cache, but
      /// if there is only 1 message -> that means the message from chat.lastMessage
      /// and chat is not loaded
      if (unreadMessagesIsRequired && handleUnreadMessages) {
        _data = _data.copyWith(
          unreadMessagesValue: UnreadMessagesValue(
            isLocked: !event.data.fromCache,
            firstReadMessageCreatedAt:
                messages
                    .firstWhereOrNull(
                      (m) => m.isReadByCurrentUser || m.isCurrentUser,
                    )
                    ?.createdAt ??
                DateTime.fromMillisecondsSinceEpoch(0),
          ),
        );
      } else if (handleUnreadMessages) {
        _data = _data.copyWith(
          unreadMessagesValue: UnreadMessagesValue(
            isLocked: !event.data.fromCache,
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
        // print(
        //   'KlmLog event.data.chatId: ${event.data.chatId}, _data.chat.id: ${_data.chat.id}',
        // );
        final chat = await _chatsRepository.getChatWithId(
          event.data.chatId.toString(),
        );
        _data = _data.copyWith(chat: chat ?? Chat.loading());
      }

      _data = _data.copyWith(messages: newMessages, isLoading: event.data.fromCache);
      if (event.data.allMessagesLoaded != null) {
        _data = _data.copyWith(isAllMessagesLoaded: event.data.allMessagesLoaded!);
      }
      if (event.data.chatId == -1) {
        _data = _data.copyWith(unreadMessagesValue: UnreadMessagesValue.initial());
      }
      emit(ChatStateBase(_data));
    } catch (e, st) {
      add(_ChatEventEmitError(e, stackTrace: st));
    }
  }

  void _onConnectionChanged(
    _ChatEventConnectingChanged event,
    Emitter<ChatState> emit,
  ) {
    _data = _data.copyWith(isConnected: event.isConnected);
    emit(ChatStateBase(_data));

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
    emit(ChatStateBase(_data));
  }

  void _onEmitOtherUser(_ChatEventEmitOtherUser event, Emitter<ChatState> emit) {
    _data = _data.copyWith(otherUser: event.otherUser);
    emit(ChatStateBase(_data));
  }

  void _onEmitChat(_ChatEventEmitChat event, Emitter<ChatState> emit) {
    _data = _data.copyWith(chat: event.chat);
    emit(ChatStateBase(_data));
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
    emit(ChatStateBase(_data));
  }

  Future<void> _onTypingUpdate(
    _ChatEventTypingUpdate event,
    Emitter<ChatState> emit,
  ) async {
    _data = _data.copyWith(isTyping: event.update.isTyping);
    emit(ChatStateBase(_data));
    if (!event.update.isTyping) return;

    await Future<void>.delayed(AppConstants.showTypingAfterActivity);
    _data = _data.copyWith(isTyping: false);
    emit(ChatStateBase(_data));
  }

  void _onEmitChannelUpdate(
    _ChatEventEmitChannelUpdate event,
    Emitter<ChatState> emit,
  ) {
    _data = _data.copyWith(
      chat: _data.chat.copyWith(channelData: event.channelData),
    );
    emit(ChatStateBase(_data));
  }

  void _onChannelDeleted(_ChatEventChannelDeleted event, Emitter<ChatState> emit) {
    /// TODO better to pass toastMessage: 'Channel deleted', but if user opens
    /// channel_screen and screen will be deleted, toast also will be shown there,
    /// so I need to somehow handle it, OR delete toast in one place. Now there
    /// is toast on channel_screen, but here is not
    emit(const ChatStateExit());
  }

  @override
  Future<void> close() {
    for (final sub in _subs) {
      sub.cancel();
    }
    return super.close();
  }
}
