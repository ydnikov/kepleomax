part of '../chat_screen.dart';

class _ChannelChatBottom extends StatelessWidget {
  const _ChannelChatBottom();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      left: false,
      right: false,
      child: Container(
        width: context.screenSize.width,
        height: 50,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: const Center(
          child: Text(
            'Channel',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
