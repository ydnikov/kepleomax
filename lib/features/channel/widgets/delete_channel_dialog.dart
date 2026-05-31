part of '../channel_screen.dart';

class _DeleteChannelDialog extends StatefulWidget {
  const _DeleteChannelDialog({required this.onDelete});

  final VoidCallback onDelete;

  @override
  State<_DeleteChannelDialog> createState() => _DeleteChannelDialogState();
}

class _DeleteChannelDialogState extends State<_DeleteChannelDialog> {
  bool _deleteButtonWasClicked = false;
  bool _checkboxValue = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text(
        'Are you sure you want to delete your channel?',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      titlePadding: const EdgeInsets.only(left: 24, right: 24, top: 24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!_deleteButtonWasClicked)
            const Text(
              'This action cannot be undone!',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w400),
            )
          else
            Row(
              children: [
                Checkbox(
                  activeColor: Colors.blue,
                  value: _checkboxValue,
                  onChanged: (newValue) {
                    setState(() {
                      _checkboxValue = newValue!;
                    });
                  },
                ),
                const Text(
                  "I know what I'm doing",
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
        ],
      ),
      contentPadding: EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: _deleteButtonWasClicked ? 0 : 24,
        top: 8,
      ),
      actions: [
        TextButton(
          onPressed: !_deleteButtonWasClicked
              ? () {
                  setState(() {
                    _deleteButtonWasClicked = true;
                  });
                }
              : !_checkboxValue
              ? null
              : () {
                  widget.onDelete();
                  Navigator.pop(context);
                },
          style: TextButton.styleFrom(overlayColor: Colors.red),
          child: const Text(
            '💀Delete forever💀',
            style: TextStyle(color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Close', style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }
}
