part of 'message_widget.dart';

class _CallWidget extends StatelessWidget {
  const _CallWidget({
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
    final call = message.callData!;
    final callType = call.getCallType();

    return InkWell(
      onTap: () {
        if (!message.isCurrentUser) return;

        showMessagesMenu(
          context,
          globalKey: messageContainerGlobalKey,
          isCurrentUser: message.isCurrentUser,
          items: [
            MessageMenuItem('Delete', Icons.delete, onDelete, color: Colors.red),
          ],
        );
      },
      child: Container(
        key: messageContainerGlobalKey,
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
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  callType.userString,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                ),
                Row(
                  children: [
                    Icon(callType.arrowIcon, color: callType.arrowColor, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${ParseTime.toTime(call.createdAt)}${_getDuration(message.callData!) == null ? '' : ', ${_getDuration(message.callData!)}'}',
                      style: const TextStyle(),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(width: 12),
            const Icon(Icons.call_outlined),
          ],
        ),
      ),
    );
  }

  String? _getDuration(CallModel call) {
    if (call.startTime != null && call.endTime != null) {
      return ParseTime.toDuration(
        Duration(
          milliseconds:
              call.endTime!.millisecondsSinceEpoch -
              call.startTime!.millisecondsSinceEpoch,
        ),
      );
    }
    return null;
  }
}
