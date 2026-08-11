part of 'messenger_repository.dart';

extension _OnNewMessageUpdateExtension on MessengerRepositoryImpl {
  Future<void> _onNewMessageUpdate(NewMessageUpdate update) async {
    final MessageDto messageDto = update.message;
    _messagesLocal.insert(messageDto).ignore();

    if (_currentMessagesCollection != null) {
      if (_currentMessagesCollection!.chatId == messageDto.chatId) {
        final newList = <Message>[
          Message.fromDto(messageDto),
          ..._currentMessagesCollection!.messages,
        ];
        _emitMessages(newList);
      }
    }

    if (_currentChatsCollection != null) {
      final newChats = List<Chat>.from(_currentChatsCollection!.chats);
      final affectedChat = newChats.firstWhereOrNull(
        (chat) => chat.id == messageDto.chatId,
      );
      if (affectedChat != null) {
        if (!messageDto.isCurrentUser && !messageDto.isReadByCurrentUser) {
          _chatsLocal.increaseUnreadCountBy1(affectedChat.id).ignore();
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
                  (!messageDto.isCurrentUser && !messageDto.isReadByCurrentUser
                      ? 1
                      : 0),
            ),
          );
        _emitChatsCollection(ChatsCollection(chats: newChats));
      } else if (update.createdChatInfo != null) {
        /// it's a new chat
        final newChat = await _chatsApi.getChatWithId(
          update.createdChatInfo!.chatId.toString(),
        );
        _chatsLocal.insert(newChat!).ignore();
        _emitChatsCollection(
          ChatsCollection(
            chats: [Chat.fromDto(newChat, fromCache: false), ...newChats],
          ),
        );
      }
    }
  }
}
