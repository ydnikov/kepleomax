part of '../chat_screen.dart';

class _ChannelChatBottom extends StatelessWidget {
  const _ChannelChatBottom({
    required this.role,
    required this.isLoading,
    required this.isSubscribeClickable,
    required this.onSubscribeTap,
  });

  final UserChannelRole role;
  final bool isLoading;
  final bool isSubscribeClickable;
  final VoidCallback? onSubscribeTap;

  @override
  Widget build(BuildContext context) {
    final isSubscriber = role.isSubscriber;

    return SafeArea(
      top: false,
      left: false,
      right: false,
      child: InkWell(
        onTap: isSubscriber || isLoading || !isSubscribeClickable
            ? null
            : onSubscribeTap,
        child: Container(
          width: context.screenSize.width,
          height: 50,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(),
                  )
                : Text(
                    isSubscriber ? 'Subscribed' : 'Subscribe',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSubscriber ? Colors.grey : Colors.blue,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
