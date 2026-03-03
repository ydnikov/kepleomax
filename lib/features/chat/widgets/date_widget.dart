part of 'message_widget.dart';

class _ChatDateWidget extends StatelessWidget {
  const _ChatDateWidget({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: KlmColors.primaryColor.shade700.withAlpha(65),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          ParseTime.toDate(date),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}