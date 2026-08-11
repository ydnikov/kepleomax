part of 'messenger_repository.dart';

extension _OnReadMessagesExtension on MessengerRepositoryImpl {
  Future<void> _onReadMessages(ReadMessagesUpdate update) async {
    _messagesLocal.readMessages(update).ignore();
    NotificationService.instance.closeNotifications(update.messagesIds);

    if (_currentMessagesCollection != null &&
        _currentMessagesCollection!.chatId == update.chatId) {
      /// if by currentUser, there will be 2 events, first with byCurrentUser is false,
      /// the second one with true. So on the second event we don't update viewsCount
      /// again (cause it was updated on the first one)
      final newList = _currentMessagesCollection!.messages.map(
        (m) => update.messagesIds.contains(m.id)
            ? m.copyWith(
                isReadByCurrentUser: update.byCurrentUser == true || m.isReadByCurrentUser,
                viewsCount: update.byCurrentUser == true
                    ? m.viewsCount
                    : m.viewsCount + 1,
              )
            : m,
      );
      _emitMessages(newList);
    }

    if (_currentChatsCollection != null) {
      if (update.byCurrentUser == true) {
        _chatsLocal
            .decreaseUnreadCount(update.chatId, update.messagesIds.length)
            .ignore();
        final newList = _currentChatsCollection!.chats.map(
          (chat) => chat.id == update.chatId
              ? chat.copyWith(
                  unreadCount: chat.unreadCount - update.messagesIds.length,
                )
              : chat,
        );
        _emitChatsCollection(ChatsCollection(chats: newList.toList()));
      }

      final updateLastMessage = update.messagesIds.contains(
        _currentChatsCollection!.chats
            .firstWhereOrNull((c) => c.id == update.chatId)
            ?.lastMessage
            ?.id,
      );

      if (updateLastMessage) {
        final newList = _currentChatsCollection!.chats.map((chat) {
          if (chat.id != update.chatId) return chat;

          final m = chat.lastMessage!;
          return chat.copyWith(
            lastMessage: m.copyWith(
              isReadByCurrentUser: update.byCurrentUser == true || m.isReadByCurrentUser,
              viewsCount: update.byCurrentUser == true
                  ? m.viewsCount
                  : m.viewsCount + 1,
            ),
          );
        });
        _emitChatsCollection(ChatsCollection(chats: newList.toList()));
      }
    }
  }
}
