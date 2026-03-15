part of 'message_widget.dart';

class _GeneralMessageWidget extends StatelessWidget {
  const _GeneralMessageWidget({
    required this.message,
    required this.messageContainerGlobalKey,
    required this.onDelete,
    this.highlightCacheMessages = false,
    super.key,
  });

  final Message message;
  final bool highlightCacheMessages;
  final GlobalKey messageContainerGlobalKey;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: message.isSystem
          ? null
          : () {
              showMessagesMenu(
                context,
                globalKey: messageContainerGlobalKey,
                isCurrentUser: message.isCurrentUser,
                items: _menuItems,
              );
            },
      child: Skeletonizer(
        enabled: message.type == MessageType.loading,
        child: Skeleton.leaf(
          child: Container(
            key: messageContainerGlobalKey,
            constraints: BoxConstraints(maxWidth: context.screenSize.width * 0.78),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: (message.isCurrentUser ? KlmColors.currentUserBg : Colors.white)
                  .withGreen(message.fromCache && highlightCacheMessages ? 150 : 255),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: message.isCurrentUser
                    ? const Radius.circular(16)
                    : Radius.zero,
                bottomRight: message.isCurrentUser
                    ? Radius.zero
                    : const Radius.circular(16),
              ),
            ),
            child: Stack(
              children: [
                /// text for time
                // Text(
                //   '${message.message}${_isCurrent ? '    ' : '  '}${ParseTime.unixTimeToTime(message.createdAt)}',
                //   style: context.textTheme.bodyMedium?.copyWith(
                //     fontSize: 15,
                //     color: Colors.red,
                //   ),
                // ),
                Linkify(
                  onOpen: (link) async {
                    await launchUrl(Uri.parse(link.url));
                  },
                  text:
                      '${message.message}${message.isCurrentUser ? '     ' : ' '}         ',
                  style: context.textTheme.bodyMedium?.copyWith(fontSize: 15),
                  options: const LinkifyOptions(removeWww: true),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Row(
                    children: [
                      Tooltip(
                        message: ParseTime.toPreciseDate(message.createdAt),
                        triggerMode: TooltipTriggerMode.longPress,
                        preferBelow: false,
                        showDuration: const Duration(seconds: 5),
                        child: Text(
                          ParseTime.toTime(message.createdAt),
                          textScaler: TextScaler.noScaling,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: message.isCurrentUser
                                ? KlmColors.readMessage
                                : Colors.grey,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      if (message.isCurrentUser)
                        Icon(
                          message.isRead ? Icons.check_box : Icons.check,
                          size: 14,
                          color: KlmColors.readMessage,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<MessageMenuItem> get _menuItems => [
    if (!message.fromCache) MessageMenuItem('Reply', Icons.reply, () {}),
    MessageMenuItem('Copy', Icons.copy, () {
      Clipboard.setData(ClipboardData(text: message.message));
    }),
    if (message.isCurrentUser && !message.fromCache) ...[
      MessageMenuItem('Edit', Icons.edit, () {}),
      MessageMenuItem(
        'Delete',
        Icons.delete,
        onDelete,
        color: Colors.red,
        key: const Key('delete_message_popup_button'),
      ),
    ],
  ];
}
