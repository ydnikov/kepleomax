part of '../chats_screen.dart';

class _ChatEmptyMessageWidget extends StatelessWidget {
  const _ChatEmptyMessageWidget({required this.channelRole});

  final UserChannelRole? channelRole; // null if it's not a channel

  @override
  Widget build(BuildContext context) {
    return Text(
      channelRole == null
          ? 'No Messages'
          : channelRole!.isSubscriber
          ? 'You Subscribed'
          : 'Your channel',
      style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
    );
  }
}
