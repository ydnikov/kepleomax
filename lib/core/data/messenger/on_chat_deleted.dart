part of 'messenger_repository.dart';

extension _OnChatDeletedExtension on MessengerRepositoryImpl {
  void _onChatDeleted(int chatId) {
    _chatsLocal.deleteById(chatId).ignore();
    _messagesLocal.deleteAllByChatId(chatId).ignore();

    if (_currentChatsCollection != null) {
      final currentChats = _currentChatsCollection!.chats;
      final newChats = currentChats.where((c) => c.id != chatId).toList();
      _emitChatsCollection(
        ChatsCollection(
          chats: newChats,
          fromCache: _currentChatsCollection!.fromCache,
        ),
      );
    }

    if (_currentMessagesCollection?.chatId == chatId) {
      _emitMessagesCollection(
        MessagesCollection(chatId: chatId, messages: [], allMessagesLoaded: true),
      );
    }
  }
}
