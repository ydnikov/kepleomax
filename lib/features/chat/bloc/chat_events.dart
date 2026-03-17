part of 'chat_bloc.dart';

/// events
abstract class ChatEvent {}

class ChatEventInit implements ChatEvent {
  const ChatEventInit({required this.chatId, required this.otherUser});

  final int chatId;
  final User otherUser;
}

class ChatEventLoad implements ChatEvent {
  const ChatEventLoad({
    required this.chatId,
    required this.otherUser,
    required this.withCache,
  });

  final int chatId;
  final User otherUser;
  final bool withCache;
}

class ChatEventLoadMore implements ChatEvent {
  const ChatEventLoadMore({required this.toMessageId});

  /// to load more if list was significantly scrolled on top
  final int? toMessageId;
}

class ChatEventSendMessage implements ChatEvent {
  const ChatEventSendMessage({required this.value});

  final String value;
}

class ChatEventDeleteMessage implements ChatEvent {
  ChatEventDeleteMessage({required this.messageId});

  final int messageId;
}

class ChatEventReadAllMessages implements ChatEvent {
  const ChatEventReadAllMessages();
}

class ChatEventReadMessagesBeforeTime implements ChatEvent {
  ChatEventReadMessagesBeforeTime({required this.time});

  final DateTime time;
}

class ChatEventEditText implements ChatEvent {
  ChatEventEditText({required this.text});

  final String text;
}

class _ChatEventConnectingChanged implements ChatEvent {
  const _ChatEventConnectingChanged(this.isConnected);

  final bool isConnected;
}

class _ChatEventEmitOtherUser implements ChatEvent {
  _ChatEventEmitOtherUser(this.otherUser);

  final User otherUser;
}

class _ChatEventOnlineStatusUpdate implements ChatEvent {
  _ChatEventOnlineStatusUpdate(this.update);

  final OnlineStatusUpdate update;
}

class _ChatEventTypingUpdate implements ChatEvent {
  _ChatEventTypingUpdate(this.update);

  final TypingActivityUpdate update;
}

class _ChatEventEmitUnreadCount implements ChatEvent {
  _ChatEventEmitUnreadCount({required this.newCount});

  final int newCount;
}

class _ChatEventEmitMessages implements ChatEvent {
  const _ChatEventEmitMessages({required this.data});

  final MessagesCollection data;
}

class _ChatEventEmitError implements ChatEvent {
  const _ChatEventEmitError(this.error, {this.stackTrace});

  final Object? error;
  final StackTrace? stackTrace;
}
