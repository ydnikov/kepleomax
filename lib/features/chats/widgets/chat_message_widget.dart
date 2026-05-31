part of '../chats_screen.dart';

class _ChatMessageWidget extends StatefulWidget {
  const _ChatMessageWidget({required this.chat});

  final Chat chat;

  @override
  State<_ChatMessageWidget> createState() => _ChatMessageWidgetState();
}

class _ChatMessageWidgetState extends State<_ChatMessageWidget> {
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
