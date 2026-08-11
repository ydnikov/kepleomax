part of 'messenger_repository.dart';

extension _OnDeleteMessageExtension on MessengerRepositoryImpl {
  void _onDeletedMessage(DeletedMessageUpdate update) {
    if (update.deleteChat) {
      _chatsLocal.deleteById(update.chatId);
      _messagesLocal.deleteAllByChatId(update.chatId);
    } else {
      _messagesLocal.deleteById(update.deletedMessage.id);
    }

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
        _emitChatsCollection(ChatsCollection(chats: newChats));
      } else {
        /// update chat if needed
        /// TODO viewsCount == 0 will not work in group chats and channels with more
        /// than 1 viewer
        final decreaseUnreadCount =
            !update.deletedMessage.isCurrentUser &&
            update.deletedMessage.viewsCount == 0;
        final newUnreadCount =
            newChats[affectedChatIndex].unreadCount - (decreaseUnreadCount ? 1 : 0);

        if (update.newLastMessage != null || update.forceNewLastMessage) {
          newChats[affectedChatIndex] = newChats[affectedChatIndex].copyWith(
            lastMessage: update.newLastMessage == null
                ? null
                : Message.fromDto(update.newLastMessage!),
            unreadCount: newUnreadCount,
          );
        } else {
          newChats[affectedChatIndex] = newChats[affectedChatIndex].copyWith(
            unreadCount: newUnreadCount,
          );
        }
        newChats.sort(chatsSort);
        _emitChatsCollection(ChatsCollection(chats: newChats));
      }
    }
  }
}
