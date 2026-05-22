part of '../people_screen.dart';

class _UserCard extends StatelessWidget {
  const _UserCard({required this.user, this.isLoading = false, super.key});

  final User user;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      child: Container(
        height: 60,
        margin: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                  AppNavigator.push(context, UserPage(userId: user.id));
                },
                child: Row(
                  children: [
                    SizedBox(
                      height: 55,
                      width: 55,
                      child: UserImage(user: user),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        user.username,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                AppNavigator.withKeyOf(
                  context,
                  mainNavigatorKey,
                )!.push(ChatPage(chat: null, otherUser: user));
              },
              icon: const Icon(Icons.chat_outlined),
            ),
          ],
        ),
      ),
    );
  }
}