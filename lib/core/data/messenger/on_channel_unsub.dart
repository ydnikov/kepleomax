part of 'messenger_repository.dart';

extension _OnChannelUnsubUpdateExtension on MessengerRepositoryImpl {
  void _onChannelUnsub(ChannelUnsubscriptionUpdate update) {
    if (_currentChatsCollection != null) {
      final currentChats = _currentChatsCollection!.chats;
      final newChats = currentChats.where((c) => c.id != update.chatId).toList();
      _emitChatsCollection(
        ChatsCollection(
          chats: newChats,
          fromCache: _currentChatsCollection!.fromCache,
        ),
      );
    }
  }
}
