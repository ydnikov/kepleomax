part of '../chats_screen.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({required this.chat, super.key});

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      height: 70,
      child: InkWell(
        onTap: chat.isLoadingChat
            ? null
            : () {
                AppNavigator.withKeyOf(
                  context,
                  mainNavigatorKey,
                )!.push(ChatPage(chatId: chat.id, otherUser: chat.otherUser));
              },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                key: ValueKey(chat.otherUser.showOnlineStatus),
                height: 60,
                width: 60,
                child: UserImage(user: chat.otherUser, showOnlineIndicator: true),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat.otherUser.username,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    if (chat.lastMessage != null || chat.draft != null) ...[
                      FittedBox(
                        /// TODO is this key needed?
                        key: ValueKey(
                          chat.lastTypingActivityTime?.millisecondsSinceEpoch,
                        ),
                        child: _MessageTextWidget(chat: chat),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 10),
              if (chat.lastMessage?.isCurrentUser ?? false)
                Icon(chat.lastMessage!.isRead ? Icons.check_box : Icons.check)
              else if (chat.lastMessage != null && chat.unreadCount > 0)
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: KlmColors.primaryColor,
                  ),
                  padding: const EdgeInsets.all(6),
                  child: Text(
                    chat.unreadCount.clamp(0, 999).toString(),
                    key: const Key('chat_unread_count_text'),
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageTextWidget extends StatefulWidget {
  const _MessageTextWidget({required this.chat});

  final Chat chat;

  @override
  State<_MessageTextWidget> createState() => _MessageTextWidgetState();
}

class _MessageTextWidgetState extends State<_MessageTextWidget> {
  late Timer _timer;
  bool _isTyping = false;

  bool get _isTypingRightNow => widget.chat.isTypingRightNow;

  bool get _isDraft => widget.chat.draft != null;

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_isTypingRightNow != _isTyping) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _isTyping = _isTypingRightNow;
    return _isTyping
        ? EllipsisTextWidget(
            'typing',
            style: context.textTheme.bodyLarge?.copyWith(
              fontSize: 15,
              color: Colors.grey.shade700,
            ),
          )
        : Row(
            children: [
              if (_isDraft)
                Text(
                  'Draft: ',
                  style: context.textTheme.bodyLarge?.copyWith(color: Colors.red),
                )
              else if (widget.chat.lastMessage!.isCurrentUser)
                Text(
                  'You: ',
                  style: context.textTheme.bodyLarge?.copyWith(color: Colors.grey),
                ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth:
                      context.screenSize.width *
                      (widget.chat.isLoadingChat ? 0.8 : 0.3),
                ),
                child: Text(
                  widget.chat.draft?.message ?? widget.chat.lastMessage!.message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontSize: 15,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              if (!widget.chat.isLoadingChat && !_isDraft)
                Text(
                  ' • ${ParseTime.toShortPassTime(widget.chat.lastMessage!.createdAt)}',
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
            ],
          );
  }
}
