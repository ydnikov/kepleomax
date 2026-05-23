import 'package:flutter/material.dart';

class DeleteChannelDialog extends StatelessWidget {
  const DeleteChannelDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text(
        'Are you sure you want to delete your channel?',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      titlePadding: const EdgeInsets.only(left: 24, right: 24, top: 24),
      content: const Text(
        'This action cannot be undone!',
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.w400),
      ),
      contentPadding: const EdgeInsets.only(left: 24, right: 24, bottom: 24, top: 8),
      actions: [
        TextButton(
          onPressed: () {},
          child: const Text('💀Delete forever💀', style: TextStyle(color: Colors.red)),
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
