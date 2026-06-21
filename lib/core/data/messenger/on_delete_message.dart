part of 'messenger_repository.dart';

extension _OnDeleteMessageExtension on MessengerRepositoryImpl {
  void _onDeletedMessage(DeletedMessageUpdate update) {
    _messagesLocal.deleteById(update.deletedMessage.id);

    if (_currentMessagesCollection != null &&
        _currentMessagesCollection!.chatId == update.chatId) {
      final newList = _currentMessagesCollection!.messages.where(
        (m) => m.id != update.deletedMessage.id,
      );
      _emitMessages(newList);
    }

    if (_currentChatsCollection != null) {
      final newChats = List<Chat>.from(_currentChatsCollection!.chats);
      final affectedChatIndex = newChats.indexWhere(
        (chat) => chat.id == update.chatId,
      );
      if (affectedChatIndex == -1) {
        return;
      } else if (update.deleteChat) {
        /// delete chat
        newChats.removeWhere((c) => c.id == update.chatId);
        _chatsLocal.deleteById(update.chatId);
        _messagesLocal.deleteAllByChatId(update.chatId);
        _emitChatsCollection(ChatsCollection(chats: newChats));
        if (_currentMessagesCollection?.chatId == update.chatId) {
          _emitMessagesCollection(_currentMessagesCollection!.copyWith(chatId: -1));
          listenToMessagesWithOtherUserId(
            otherUserId: update.deletedMessage.senderId,
          );
        }
      } else {
        /// update chat if needed
        final decreaseUnreadCount =
            !update.deletedMessage.isCurrentUser && !update.deletedMessage.isReadByCurrentUser;
        final newUnreadCount =
            newChats[affectedChatIndex].unreadCount - (decreaseUnreadCount ? 1 : 0);
        if (update.newLastMessage != null) {
          newChats[affectedChatIndex] = newChats[affectedChatIndex].copyWith(
            lastMessage: Message.fromDto(update.newLastMessage!),
            unreadCount: newUnreadCount,
          );
        } else {
          newChats[affectedChatIndex] = newChats[affectedChatIndex].copyWith(
            unreadCount: newUnreadCount,
          );
        }
        newChats.sort(
          (a, b) =>
              (b.lastMessage?.createdAt.millisecondsSinceEpoch ?? b.createdAt) -
              (a.lastMessage?.createdAt.millisecondsSinceEpoch ?? a.createdAt),
        );
        _emitChatsCollection(ChatsCollection(chats: newChats));
      }
    }
  }
}
