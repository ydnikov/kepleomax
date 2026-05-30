part of '../channel_screen.dart';

class _ChannelUserWidget extends StatelessWidget {
  const _ChannelUserWidget({
    required this.user,
    this.onDelete,
    this.isLoading = false,
    super.key,
  });

  final User user;
  final bool isLoading;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      child: ListTile(
        onTap: isLoading
            ? null
            : () {
                AppNavigator.push(context, UserPage(userId: user.id));
              },
        title: Row(
          children: [
            ClipOval(
              child: SizedBox(
                height: 40,
                width: 40,
                child: isLoading
                    ? const ColoredBox(color: Colors.grey)
                    : user.profileImage == null
                    ? const UserDefaultIconWidget()
                    : UserImageWidget(user: user),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                user.username,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (user.isCurrent)
              Container(
                margin: const EdgeInsets.only(left: 8, right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.purple.shade50,
                ),
                child: const Text(
                  'owner',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.purple,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        ),
        contentPadding: const EdgeInsets.only(left: 16),
        trailing: user.isCurrent || isLoading
            ? const SizedBox(width: 2)
            : IconButton(
                onPressed: () {
                  AppNavigator.showGeneralDialog(
                    context,
                    _DeleteUserDialog(
                      user: user,
                      onDelete: () {
                        Navigator.pop(context);
                        onDelete?.call();
                      },
                    ),
                    barrierDismissible: true,
                  );
                },
                icon: const Icon(Icons.clear, color: Colors.red),
              ),
      ),
    );
  }
}

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
      content: Container(
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
          onPressed: onDelete,
          child: const Text(
            'Delete',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
