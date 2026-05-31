part of '../channel_screen.dart';

class _DeleteUserDialog extends StatelessWidget {
  const _DeleteUserDialog({required this.user, required this.onDelete});

  final User user;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text(
        'Delete this user? Later they can subscribe back',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      content: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadiusGeometry.circular(24),
        ),
        child: ListTile(
          title: Row(
            children: [
              ClipOval(
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: user.profileImage == null
                      ? const UserDefaultIconWidget()
                      : UserImageWidget(user: user),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  user.username,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Close',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onDelete();
          },
          child: const Text(
            'Delete',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}