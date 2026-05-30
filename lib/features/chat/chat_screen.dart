import 'dart:async';
import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:kepleomax/core/app_constants.dart';
import 'package:kepleomax/core/data/connection_repository.dart';
import 'package:kepleomax/core/data/messenger/messenger_repository.dart';
import 'package:kepleomax/core/di/dependencies.dart';
import 'package:kepleomax/core/di/dependencies_multi_provider.dart';
import 'package:kepleomax/core/extensions/build_context_extensions.dart';
import 'package:kepleomax/core/flavor.dart';
import 'package:kepleomax/core/logger.dart';
import 'package:kepleomax/core/models/chat.dart';
import 'package:kepleomax/core/models/message.dart';
import 'package:kepleomax/core/models/user.dart';
import 'package:kepleomax/core/navigation/app_navigator.dart';
import 'package:kepleomax/core/navigation/pages.dart';
import 'package:kepleomax/core/network/websockets/messenger_web_socket.dart';
import 'package:kepleomax/core/presentation/channel_image_widget.dart';
import 'package:kepleomax/core/presentation/channel_official_widget.dart';
import 'package:kepleomax/core/presentation/colors.dart';
import 'package:kepleomax/core/presentation/ellipsis_text_widget.dart';
import 'package:kepleomax/core/presentation/klm_app_bar.dart';
import 'package:kepleomax/core/presentation/klm_error_widget.dart';
import 'package:kepleomax/core/presentation/klm_textfield.dart';
import 'package:kepleomax/core/presentation/parse_time.dart';
import 'package:kepleomax/core/presentation/user_image_widget.dart';
import 'package:kepleomax/core/services/notifications_service.dart';
import 'package:kepleomax/features/channel/data/channel_repository.dart';
import 'package:kepleomax/features/chat/bloc/chat_bloc.dart';
import 'package:kepleomax/features/chat/bloc/chat_state.dart';
import 'package:kepleomax/features/chat/widgets/empty_chat_widget.dart';
import 'package:kepleomax/features/chat/widgets/message_widget.dart';
import 'package:kepleomax/features/chats/chats_screen_navigator.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:visibility_detector/visibility_detector.dart';

part 'widgets/channel_chat_bottom.dart';

part 'widgets/chat_bottom.dart';

part 'widgets/read_button.dart';

/// screen
class ChatScreen extends StatefulWidget {
  const ChatScreen({required this.chat, required this.otherUser, super.key});

  final Chat? chat;
  final User otherUser;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _scrollController = ScrollController();
  late ChatBloc _chatBloc;

  /// callbacks
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// build
  @override
  Widget build(BuildContext context) {
    return DependenciesMultiProvider(
      providers: {
        ChannelRepository: Dependencies.of(context).channelRepositoryBuilder(),
      },
      child: BlocProvider(
        create: (context) {
          final dp = Dependencies.of(context);
          return _chatBloc = ChatBloc(
            chatsRepository: dp.chatsRepositoryBuilder(),
            messengerRepository: dp.read<MessengerRepository>(),
            connectionRepository: dp.read<ConnectionRepository>(),
            messengerWebSocket: dp.read<MessengerWebSocket>(),
            channelRepository: dp.read<ChannelRepository>(),
          )..add(ChatEventInit(chat: widget.chat, otherUser: widget.otherUser));
        },
        lazy: false,
        child: FocusDetector(
          onFocusGained: () {
            _chatBloc.add(const ChatEventForceRebuild());
          },
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            floatingActionButton: _ReadButton(
              scrollController: _scrollController,
              chatId: widget.chat?.id ?? -1, // TODO
            ),
            appBar: const _AppBar(key: Key('chat_appbar')),
            body: _Body(
              scrollController: _scrollController,
              onRetry: () {
                _chatBloc.add(
                  ChatEventLoad(
                    chat: widget.chat,
                    otherUser: widget.otherUser,
                    withCache: false,
                  ),
                );
              },
              key: const Key('chat_body'),
            ),
          ),
        ),
      ),
    );
  }
}

/// body
class _Body extends StatefulWidget {
  const _Body({required this.scrollController, required this.onRetry, super.key});

  final ScrollController scrollController;
  final VoidCallback onRetry;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  bool _isScreenActive = false;
  late final ChatBloc _chatBloc;
  late final ListObserverController _observerController;
  late final ChatScrollObserver _chatObserver;
  final _textController = TextEditingController();

  /// callbacks
  @override
  void initState() {
    _chatBloc = context.read<ChatBloc>();
    widget.scrollController.addListener(_onScrollListener);

    _observerController = ListObserverController(controller: widget.scrollController)
      ..cacheJumpIndexOffset = false;

    _chatObserver = ChatScrollObserver(_observerController)
      ..toRebuildScrollViewCallback = () {
        setState(() {});
      };

    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    widget.scrollController.removeListener(_onScrollListener);
    super.dispose();
  }

  void _onResume(int chatId) {
    _isScreenActive = true;
    NotificationService.instance.blockNotificationsFromChat(chatId);
    _onScrollListener();
  }

  void _onPause() {
    _isScreenActive = false;
    NotificationService.instance.enableAllNotifications();
  }

  /// build
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      buildWhen: (oldState, newState) {
        if (newState is ChatStateMessage || oldState is ChatStateMessage)
          return false;

        if (oldState is ChatStateBase && newState is ChatStateBase) {
          final oldData = oldState.data;
          final newData = newState.data;
          if (oldData.messages.length != newData.messages.length &&
              oldData.messages.firstOrNull != newData.messages.firstOrNull) {
            _chatObserver.standby();
          }
          return oldState.forceRebuildKey != newState.forceRebuildKey ||
              oldData.isLoading != newData.isLoading ||
              oldData.isConnected != newData.isConnected ||
              oldData.isBottomBarLoading != newData.isBottomBarLoading ||
              oldData.chat != newData.chat ||
              !listEquals(oldData.messages, newData.messages) ||
              oldData.isAllMessagesLoaded != newData.isAllMessagesLoaded;
        }

        return true;
      },
      listener: (context, state) {
        if (state is ChatStateMessage && !flavor.isRelease) {
          context.showSnackBar(
            text: state.message,
            color: state.isError ? KlmColors.errorRed : Colors.green,
          );
        }
        if (state is ChatStateUpdateTextField) {
          _textController.text = state.message;
        }
      },
      builder: (context, state) {
        if (state is ChatStateError) {
          return KlmErrorWidget(
            errorMessage: state.message,
            onRetry: widget.onRetry,
          );
        }

        if (state is! ChatStateBase) return const SizedBox();

        final data = state.data;
        return FocusDetector(
          key: Key('focus_detector_${data.chat.id}'),
          onForegroundGained: () => _onResume(data.chat.id),
          onForegroundLost: _onPause,
          onVisibilityGained: () => _onResume(data.chat.id),
          onVisibilityLost: _onPause,
          child: Column(
            children: [
              Expanded(
                child: ColoredBox(
                  color: Colors.blue.shade100,
                  child: data.isLoading && data.messages.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : data.messages.isEmpty
                      ? EmptyChatWidget(channelRole: data.chat.channelData?.userRole)
                      : ListViewObserver(
                          controller: _observerController,
                          autoTriggerObserveTypes: const [
                            ObserverAutoTriggerObserveType.scrollEnd,
                          ],
                          triggerOnObserveType:
                              ObserverTriggerOnObserveType.directly,
                          child: ListView.builder(
                            key: const Key('messages_list_view'),
                            controller: widget.scrollController,
                            physics: ChatObserverClampingScrollPhysics(
                              observer: _chatObserver,
                            ),
                            shrinkWrap: _chatObserver.isShrinkWrap,
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            reverse: true,
                            itemCount:
                                data.messages.length +
                                (data.isAllMessagesLoaded ||
                                        data.messages.length <
                                            AppConstants.msgPagingLimit ||
                                        flavor.isTesting
                                    ? 0
                                    : 3),
                            itemBuilder: (context, i) => i >= data.messages.length
                                ? MessageWidget(
                                    message: Message.loading(),
                                    user: data.otherUser,
                                    onDelete: () {},
                                  )
                                : VisibilityDetector(
                                    /// DateTime to check visibility on every messagesList changes
                                    /// (like the change of some fromCache statuses)
                                    key: Key(
                                      'visibility_detector_$i-${DateTime.now().millisecondsSinceEpoch}',
                                    ),
                                    onVisibilityChanged: (info) =>
                                        _onVisibilityChanged(info, data.messages[i]),
                                    child: MessageWidget(
                                      key: Key('message_${data.messages[i].id}'),
                                      onDelete: () {
                                        _chatBloc.add(
                                          ChatEventDeleteMessage(
                                            messageId: data.messages[i].id,
                                          ),
                                        );
                                      },
                                      user: data.otherUser,
                                      message: data.messages[i],
                                    ),
                                  ),
                          ),
                        ),
                ),
              ),
              if (data.chat.channelData?.userRole.isOwner ?? true)
                _ChatBottom(
                  onSend: (message) {
                    if (data.isLoading || !data.isConnected) return;
                    _chatBloc.add(ChatEventSendMessage(value: message));

                    if (widget.scrollController.hasClients) {
                      widget.scrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOut,
                      );
                    }
                  },
                  onEdit: (message) {
                    _chatBloc.add(ChatEventEditText(text: message));
                  },
                  isLoading: data.isLoading,
                  isChannel: data.chat.isChannel,
                  controller: _textController,
                  key: const Key('chat_bottom'),
                )
              else
                _ChannelChatBottom(
                  role: data.chat.channelData!.userRole,
                  isLoading: data.isBottomBarLoading,
                  isSubscribeClickable: !data.isLoading && data.isConnected,
                  onSubscribeTap: () {
                    _chatBloc.add(const ChatEventSubscribeOnChannel());
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  /// listeners
  void _onVisibilityChanged(VisibilityInfo info, Message message) {
    if (_chatBloc.isClosed) return;

    final isVisible = info.visibleFraction > 0.6;
    if (!message.isRead &&
        !message.isCurrentUser &&
        !message.fromCache &&
        isVisible) {
      _chatBloc.add(ChatEventReadMessagesBeforeTime(time: message.createdAt));
    }
    if (message.fromCache && !_chatBloc.isClosed) {
      // print('KlmLog visibleMessageFromCache: ${data.messages[i].message}');
      _chatBloc.add(ChatEventLoadMore(toMessageId: message.id));
    }
  }

  void _onScrollListener() {
    if (!widget.scrollController.hasClients || !_isScreenActive) return;

    if (widget.scrollController.offset >
        widget.scrollController.position.maxScrollExtent - 500) {
      _chatBloc.add(const ChatEventLoadMore(toMessageId: null));
    }
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      buildWhen: (oldState, newState) {
        if (newState is! ChatStateBase) return false;

        if (oldState is! ChatStateBase) return true;

        final oldData = oldState.data;
        final newData = newState.data;
        return oldData.otherUser != newData.otherUser ||
            oldData.chat != newData.chat ||
            oldData.isLoading != newData.isLoading ||
            oldData.isConnected != newData.isConnected ||
            oldData.isTyping != newData.isTyping;
      },
      builder: (context, state) {
        if (state is! ChatStateBase) return const SizedBox();

        final data = state.data;
        return AppBar(
          key: Key('chat_app_bar_${data.chat.id}'),
          leading: const KlmBackButton(),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          titleSpacing: 0,
          title: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              AppNavigator.withKeyOf(context, mainNavigatorKey)!.push(
                data.chat.isChannel
                    ? ChannelPage(channelData: data.chat.channelData!)
                    : UserPage(userId: data.otherUser.id),
              );
            },
            child: Row(
              children: [
                if (data.chat.isChannel)
                  ChannelImageWidget(image: data.chat.channelData!.image, size: 40)
                else
                  UserImageWidget(size: 40, user: data.otherUser),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ChannelOfficialIconWidget(
                        leftWidget: Text(
                          data.chat.channelData?.name ?? data.otherUser.username,
                          key: const Key('chat_username'),
                          style: context.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            height: 1,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        isOfficial: data.chat.channelData?.isOfficial ?? false,
                      ),
                      if (data.isLoading || !data.isConnected)
                        Text(
                          !data.isConnected ? 'Connecting...' : 'Updating...',
                          key: const Key('chat_app_bar_status_text'),
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade600,
                          ),
                        )
                      else if (!data.isLoading && data.isConnected)
                        if (data.chat.isChannel)
                          Text(
                            '${data.chat.channelData!.subscribersCount ?? 0} subscriber${ParseTime.isSingular(data.chat.channelData!.subscribersCount ?? 0) ? '' : 's'}',
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade600,
                            ),
                          )
                        else
                          FittedBox(child: _UserStatusWidget(data: data)),
                    ],
                  ),
                ),
                if (!data.chat.isChannel)
                  IconButton(
                    onPressed: () {
                      if (!data.isConnected) return;

                      AppNavigator.of(
                        context,
                      )!.push(CallPage(otherUser: data.otherUser, doCall: true));
                    },
                    style: IconButton.styleFrom(padding: EdgeInsets.zero),
                    icon: const Icon(
                      Icons.videocam_outlined,
                      color: KlmColors.primaryColor,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _UserStatusWidget extends StatefulWidget {
  const _UserStatusWidget({required this.data});

  final ChatData data;

  @override
  State<_UserStatusWidget> createState() => _UserStatusWidgetState();
}

class _UserStatusWidgetState extends State<_UserStatusWidget> {
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EllipsisTextWidget(
      widget.data.isTyping ? 'typing' : _onlineStatusText(widget.data.otherUser),
      ellipsis: widget.data.isTyping,
      textKey: const Key('user_status_text'),
      style: context.textTheme.bodyMedium?.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: Colors.grey.shade600,
      ),
    );
  }

  String _onlineStatusText(User user) {
    if (user.showOnlineStatus) {
      _timer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!user.showOnlineStatus) {
          setState(() {});
          timer.cancel();
        }
      });
      return 'online';
    } else {
      _timer?.cancel();
      _timer = null;
      return ParseTime.toOnlineStatus(
        DateTime.fromMillisecondsSinceEpoch(user.lastActivityTime),
      );
    }
  }
}
