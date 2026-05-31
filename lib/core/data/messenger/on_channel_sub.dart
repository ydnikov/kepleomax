part of 'messenger_repository.dart';

extension _OnChannelSubUpdateExtension on MessengerRepositoryImpl {
  void _onChannelSub(ChannelSubscriptionUpdate update) {
    if (_currentChatsCollection == null) return;

    final currentChats = _currentChatsCollection!.chats;
    final newChats = [update.chat, ...currentChats];

    _emitChatsCollection(
      ChatsCollection(
        chats: newChats,
        fromCache: _currentChatsCollection!.fromCache,
      ),
    );
  }
}
