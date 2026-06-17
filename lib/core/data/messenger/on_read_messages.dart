part of 'messenger_repository.dart';

extension _OnReadMessagesExtension on MessengerRepositoryImpl {
  Future<void> _onReadMessages(ReadMessagesUpdate update) async {
    _messagesLocal.readMessages(update).ignore();
    NotificationService.instance.closeNotifications(update.messagesIds);

    if (_currentMessagesCollection != null &&
        _currentMessagesCollection!.chatId == update.chatId) {
      final newList = _currentMessagesCollection!.messages.map(
        (m) => update.messagesIds.contains(m.id) ? m.copyWith(isRead: true) : m,
      );
      _emitMessages(newList);
    }

    if (_currentChatsCollection != null) {
      /// TODO now doesn't support group chats (now they don't exist)
      final allMessagesByCurrentUser =
          update.messagesData.first.senderId != AuthController.currentUserId;
      if (allMessagesByCurrentUser) {
        _chatsLocal
            .decreaseUnreadCount(update.chatId, update.messagesData.length)
            .ignore();
        final newList = _currentChatsCollection!.chats.map(
          (chat) => chat.id == update.chatId
              ? chat.copyWith(
                  unreadCount: chat.unreadCount - update.messagesData.length,
                )
              : chat,
        );
        _emitChatsCollection(ChatsCollection(chats: newList.toList()));
      } else if (update.messagesIds.contains(
        _currentChatsCollection!.chats
            .firstWhereOrNull((c) => c.id == update.chatId)
            ?.lastMessage
            ?.id,
      )) {
        final newList = _currentChatsCollection!.chats.map(
          (chat) => chat.id == update.chatId
              ? chat.copyWith(lastMessage: chat.lastMessage!.copyWith(isRead: true))
              : chat,
        );
        _emitChatsCollection(ChatsCollection(chats: newList.toList()));
      }
    }
  }
}
