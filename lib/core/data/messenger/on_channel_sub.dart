part of 'messenger_repository.dart';

extension _OnChannelSubUpdateExtension on MessengerRepositoryImpl {
  void _onChannelSub(ChannelSubscriptionUpdate update) {
    if (_currentChatsCollection == null) return;

    final currentChats = _currentChatsCollection!.chats;
    // TODO optimize sort here (big O)
    final newChats = [update.chat, ...currentChats]..sort(chatsSort);

    _emitChatsCollection(
      ChatsCollection(
        chats: newChats,
        fromCache: _currentChatsCollection!.fromCache,
      ),
    );
  }
}
