part of 'messenger_repository.dart';

extension _OnChannelDeletedExtension on MessengerRepositoryImpl {
  void _onChannelDeleted(int channelId) {
    if (_currentChatsCollection != null) {
      final currentChats = _currentChatsCollection!.chats;
      final newChats = currentChats.where((c) => c.id != channelId).toList();
      _emitChatsCollection(
        ChatsCollection(
          chats: newChats,
          fromCache: _currentChatsCollection!.fromCache,
        ),
      );
    }

    if (_currentMessagesCollection != null) {
      _emitMessagesCollection(
        MessagesCollection(
          chatId: channelId,
          messages: [],
          allMessagesLoaded: true,
        ),
      );
    }
  }
}
