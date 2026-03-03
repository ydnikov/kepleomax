part of 'message_widget.dart';

class _UnreadMessagesWidget extends StatelessWidget {
  const _UnreadMessagesWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      width: double.infinity,
      height: 20,
      color: Colors.grey.shade100,
      child: Center(
        child: Text(
          'Unread Messages',
          style: context.textTheme.bodyMedium?.copyWith(
            color: KlmColors.primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
