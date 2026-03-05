import 'dart:async';
import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:kepleomax/core/di/dependencies.dart';
import 'package:kepleomax/core/flavor.dart';
import 'package:kepleomax/core/logger.dart';
import 'package:kepleomax/core/models/message.dart';
import 'package:kepleomax/core/models/user.dart';
import 'package:kepleomax/core/navigation/app_navigator.dart';
import 'package:kepleomax/core/navigation/pages.dart';
import 'package:kepleomax/core/presentation/colors.dart';
import 'package:kepleomax/core/extensions/build_context_extensions.dart';
import 'package:kepleomax/core/presentation/klm_app_bar.dart';
import 'package:kepleomax/core/presentation/klm_error_widget.dart';
import 'package:kepleomax/core/presentation/klm_textfield.dart';
import 'package:kepleomax/core/presentation/parse_time.dart';
import 'package:kepleomax/core/presentation/user_image.dart';
import 'package:kepleomax/core/services/notifications_service.dart';
import 'package:kepleomax/features/chat/bloc/chat_bloc.dart';
import 'package:kepleomax/features/chat/bloc/chat_state.dart';
import 'package:kepleomax/features/chat/widgets/message_widget.dart';
import 'package:kepleomax/features/chats/chats_screen_navigator.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:visibility_detector/visibility_detector.dart';

part 'widgets/chat_bottom.dart';
part 'widgets/read_button.dart';
part 'widgets/tech_message.dart';

/// screen
class ChatScreen extends StatefulWidget {
  const ChatScreen({required this.chatId, required this.otherUser, super.key});

  final int chatId;
  final User otherUser;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _scrollController = ScrollController();
  late ChatBloc _chatBloc;

  /// callbacks
  @override
  void initState() {
    final dp = Dependencies.of(context);
    _chatBloc = ChatBloc(
      chatsRepository: dp.chatsRepository,
      messengerRepository: dp.messengerRepository,
      connectionRepository: dp.connectionRepository,
      messengerWebSocket: dp.messengerWebSocket,
      chatId: widget.chatId,
    )..add(ChatEventInit(chatId: widget.chatId, otherUser: widget.otherUser));
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// build
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _chatBloc,
      child: Builder(
        builder: (context) {
          /// ping to call init
          context.read<ChatBloc>();

          return Scaffold(
            resizeToAvoidBottomInset: true,
            floatingActionButton: _ReadButton(
              scrollController: _scrollController,
              chatId: widget.chatId,
            ),
            appBar: const _AppBar(key: Key('chat_appbar')),
            body: _Body(
              scrollController: _scrollController,
              onRetry: () {
                _chatBloc.add(
                  ChatEventLoad(
                    chatId: widget.chatId,
                    otherUser: widget.otherUser,
                    withCache: false,
                  ),
                );
              },
              key: const Key('chat_body'),
            ),
          );
        },
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
          return oldData.isLoading != newData.isLoading ||
              oldData.isConnected != newData.isConnected ||
              !listEquals(oldData.messages, newData.messages) ||
              oldData.isAllMessagesLoaded != newData.isAllMessagesLoaded;
        }

        return true;
      },
      listener: (context, state) {
        if (state is ChatStateMessage) {
          context.showSnackBar(
            text: state.message,
            color: state.isError ? KlmColors.errorRed : Colors.green,
          );
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
          key: Key('focus_detector_${data.chatId}'),
          onForegroundGained: () => _onResume(data.chatId),
          onForegroundLost: _onPause,
          onVisibilityGained: () => _onResume(data.chatId),
          onVisibilityLost: _onPause,
          child: Column(
            children: [
              Expanded(
                child: ColoredBox(
                  color: Colors.blue.shade100,
                  child: data.isLoading && data.messages.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : data.messages.isEmpty
                      ? const Center(
                          child: _TechMessage(
                            key: Key('no_messages_widget'),
                            text: '\nNo messages here yet...\n\nWrite something\n',
                          ),
                        )
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
                            padding: EdgeInsets.only(
                              bottom: 4,
                              top: data.isAllMessagesLoaded ? 4 : 20,
                            ),
                            reverse: true,
                            itemCount: data.messages.length,
                            itemBuilder: (context, i) => VisibilityDetector(
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
                  _chatBloc.add(ChatEventEditText(value: message));
                },
                isLoading: data.isLoading,
                key: const Key('chat_bottom'),
              ),
            ],
          ),
        );
      },
    );
  }

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

  /// listeners
  void _onScrollListener() {
    if (!widget.scrollController.hasClients || !_isScreenActive) return;

    if (widget.scrollController.offset >
        widget.scrollController.position.maxScrollExtent - 300) {
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
            oldData.isLoading != newData.isLoading ||
            oldData.isConnected != newData.isConnected ||
            oldData.isTyping != newData.isTyping;
      },
      builder: (context, state) {
        if (state is! ChatStateBase) return const SizedBox();

        final data = state.data;
        return AppBar(
          key: Key('chat_app_bar_${data.otherUser.id}'),
          leading: const KlmBackButton(),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          titleSpacing: 0,
          title: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              AppNavigator.withKeyOf(
                context,
                mainNavigatorKey,
              )!.push(UserPage(userId: data.otherUser.id));
            },
            child: Row(
              children: [
                UserImage(size: 40, user: data.otherUser),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.otherUser.username,
                        key: const Key('chat_username'),
                        style: context.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          height: 1,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (data.isLoading || !data.isConnected)
                        Text(
                          !data.isConnected
                              ? 'Connecting..'
                              : data.isLoading
                              ? 'Updating..'
                              : '',
                          key: const Key('chat_app_bar_status_text'),
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      if (!data.isLoading && data.isConnected)
                        _UserStatusWidget(data: data),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (data.isLoading || !data.isConnected) return;

                    AppNavigator.of(context)!.push(
                      CallPage(
                        otherUser: data.otherUser,
                        doCall: true,
                      ),
                    );
                  },
                  icon: const Icon(Icons.call, color: KlmColors.primaryColor),
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
    return Text(
      widget.data.isTyping ? 'typing..' : _onlineStatusText(widget.data.otherUser),
      key: const Key('user_status_text'),
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
