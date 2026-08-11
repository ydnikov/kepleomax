part of '../chats_screen.dart';

class _ChatInfoBottomSheet extends StatelessWidget {
  const _ChatInfoBottomSheet({required this.chat});

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            Text(
              chat.isChannel ? 'Channel info:' : 'Chat info:',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                SizedBox(
                  key: ValueKey(chat.otherUser.showOnlineStatus),
                  height: 60,
                  width: 60,
                  child: chat.isChannel
                      ? ChannelImageWidget(image: chat.channelData!.image, size: 40)
                      : UserImageWidget(
                          user: chat.otherUser,
                          showOnlineIndicator: true,
                        ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ChannelOfficialIconWidget(
                        leftWidget: Text(
                          chat.channelData?.name ?? chat.otherUser.username,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                        isOfficial: chat.channelData?.isOfficial ?? false,
                      ),
                      if (chat.lastMessage != null || chat.draft != null)
                        FittedBox(
                          child: _ChatMessageWidget(chat: chat, showDate: false),
                        )
                      else
                        _ChatEmptyMessageWidget(
                          channelRole: chat.channelData?.userRole,
                        ),
                    ],
                  ),
                ),
              ],
            ),

            const DividerWithPadding(verticalPadding: 12),

            Column(
              spacing: 12,
              children: [
                if (chat.isChannel) ...[
                  _info(
                    'Created at:',
                    ParseTime.toPreciseDate(chat.channelData!.createdAt),
                  ),
                  _info('Joined at:', ParseTime.toPreciseDate(chat.createdAt)),
                  _info('Subs count:', chat.channelData!.subsCount.toString()),
                  if (chat.channelData!.isOfficial == true)
                    _info('Official:', 'Yes'),
                  if (chat.channelData!.userRole.isOwner)
                    _info('Owner:', 'Yes'),
                ] else ...[
                  _info(
                    'Created at:',
                    chat.createdAt.millisecondsSinceEpoch > 0
                        ? ParseTime.toPreciseDate(chat.createdAt)
                        : 'In 2026',
                  ),
                ],
              ],
            ),
            const DividerWithPadding(verticalPadding: 12),

            if (!chat.fromCache) ...[
              if (!chat.isChannel)
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      context.read<ChatsBloc>().add(
                        ChatsEventDelete(chatId: chat.id),
                      );
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      shape: LinearBorder.none,
                      surfaceTintColor: Colors.red,
                      overlayColor: Colors.red,
                    ),
                    child: const Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _info(String title, String content) => Row(
    children: [
      Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      const SizedBox(width: 6),
      Text(content),
    ],
  );
}
