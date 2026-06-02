part of 'messenger_repository.dart';

extension _OnChannelUpdateExtension on MessengerRepositoryImpl {
  void _onChannelUpdate(ChannelOnChatScreenUpdate update) {
    if (_currentChatsCollection != null) {
      final newChats = _currentChatsCollection!.chats
          .map(
            (c) => c.id == update.channelId
                ? c.copyWith(
                    channelData: update.newChannelData!.keepRoleIfNeeded(
                      c.channelData!.userRole,
                    ),
                  )
                : c,
          )
          .toList();

      _emitChatsCollection(
        ChatsCollection(
          chats: newChats,
          fromCache: _currentChatsCollection!.fromCache,
        ),
      );
    }
  }
}
