part of 'messenger_repository.dart';

extension _OnTypingUpdateExtension on MessengerRepositoryImpl {
  void _onTypingUpdate(TypingActivityUpdate update) {
    if (update.userId == AuthController.currentUserId) return;

    if (_currentChatsCollection != null) {
      final newChats = List.of(_currentChatsCollection!.chats);
      for (int i = 0; i < newChats.length; i++) {
        if (newChats[i].id == update.chatId) {
          newChats[i] = newChats[i].copyWith(
            lastTypingActivityTime: update.isTyping ? DateTime.now() : null,
          );
          _emitChatsCollection(ChatsCollection(chats: newChats));
          break;
        }
      }
    }
  }
}
