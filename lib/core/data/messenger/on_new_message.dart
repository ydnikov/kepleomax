part of 'messenger_repository.dart';

extension _OnNewMessageUpdateExtension on MessengerRepositoryImpl {
  void _onNewMessageUpdate(NewMessageUpdate update) async {
    final MessageDto messageDto = update.message;
    _messagesLocal.insert(messageDto);

    if (_currentMessagesCollection != null) {
      if (_currentMessagesCollection!.chatId == messageDto.chatId) {
        final newList = <Message>[
          Message.fromDto(messageDto),
          ..._currentMessagesCollection!.messages,
        ];
        _emitMessages(newList);
      } else if (update.createdChatInfo != null &&
          _currentMessagesCollection!.chatId == -1 &&
          update.createdChatInfo!.usersIds.contains(_currentChatOtherUserId)) {
        /// it's a new chat
        final newList = <Message>[Message.fromDto(messageDto)];
        _emitMessagesCollection(
          MessagesCollection(
            chatId: messageDto.chatId,
            messages: newList,
            allMessagesLoaded: true,
          ),
        );
      }
    }

    if (_currentChatsCollection != null) {
      final newChats = List<Chat>.from(_currentChatsCollection!.chats);
      final affectedChat = newChats.firstWhereOrNull(
        (chat) => chat.id == messageDto.chatId,
      );
      if (affectedChat != null) {
        if (!messageDto.isCurrentUser && !messageDto.isRead) {
          _chatsLocal.increaseUnreadCountBy1(affectedChat.id);
        }
        newChats
          ..remove(affectedChat)
          ..insert(
            0,
            affectedChat.copyWith(
              lastMessage: Message.fromDto(messageDto),
              lastTypingActivityTime: null,
              unreadCount:
                  affectedChat.unreadCount +
                  (!messageDto.isCurrentUser && !messageDto.isRead ? 1 : 0),
            ),
          );
        _emitChatsCollection(ChatsCollection(chats: newChats));
      } else {
        /// it's a new chat
        final newChat = await _chatsApi.getChatWithId(messageDto.chatId.toString());
        if (newChat == null) return;
        _chatsLocal.insert(newChat);
        _emitChatsCollection(
          ChatsCollection(
            chats: [Chat.fromDto(newChat, fromCache: false), ...newChats],
          ),
        );
      }
    }
  }
}
