part of '../chats_screen.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({required this.chat, super.key});

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      height: 70,
      child: InkWell(
        onTap: chat.isLoadingChat
            ? null
            : () {
                AppNavigator.withKeyOf(
                  context,
                  mainNavigatorKey,
                )!.push(ChatPage(chat: chat, otherUser: chat.otherUser));
              },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        /// TODO is this key needed?
                        key: ValueKey(
                          chat.lastTypingActivityTime?.millisecondsSinceEpoch,
                        ),
                        child: _ChatMessageWidget(chat: chat),
                      )
                    else
                      _ChatEmptyMessageWidget(
                        channelRole: chat.channelData?.userRole,
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              if (chat.lastMessage?.isCurrentUser ?? false)
                Icon(chat.lastMessage!.isRead ? Icons.check_box : Icons.check)
              else if (chat.lastMessage != null && chat.unreadCount > 0)
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: KlmColors.primaryColor,
                  ),
                  padding: const EdgeInsets.all(6),
                  child: Text(
                    chat.unreadCount.clamp(0, 999).toString(),
                    key: const Key('chat_unread_count_text'),
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
