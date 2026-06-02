import 'dart:async';

import 'package:kepleomax/core/network/apis/messages/message_dtos.dart';
import 'package:kepleomax/core/network/websockets/messenger_web_socket.dart';
import 'package:kepleomax/core/network/websockets/models/deleted_message_update.dart';
import 'package:kepleomax/core/network/websockets/models/new_message_update.dart';
import 'package:kepleomax/core/network/websockets/models/online_status_update.dart';
import 'package:kepleomax/core/network/websockets/models/read_messages_update.dart';
import 'package:kepleomax/core/network/websockets/models/typing_activity_update.dart';

class MockMessengerWebSocket implements MessengerWebSocket {
  /// testing stuff
  int? _nextSendMessageId;
  final _readMessagesBeforeTimeWasCalls = <(int, DateTime)>[];
  final _readAllCalls = <int>[];
  final _deleteMessageCalls = <int>[];

  void addMessage(MessageDto messageDto, {CreatedChatInfo? createdChatInfo}) =>
      _messageController.add(
        NewMessageUpdate(message: messageDto, createdChatInfo: createdChatInfo),
      );

  void addReadMessagesUpdate(ReadMessagesUpdate update) =>
      _readMessagesController.add(update);

  void addDeletedMessagesUpdate(DeletedMessageUpdate update) =>
      _deletedMessageController.add(update);

  void addOnlineUpdate(OnlineStatusUpdate update) =>
      _onlineUpdatesController.add(update);

  void addTypingUpdate(TypingActivityUpdate update) =>
      _typingUpdatesController.add(update);

  void setNextSendMessageId(int value) {
    _nextSendMessageId = value;
  }

  bool isRaadBeforeTimeWasCalledWith(int chatId, DateTime time) {
    final last = _readMessagesBeforeTimeWasCalls.lastOrNull;
    return last?.$1 == chatId && last?.$2 == time;
  }

  bool isReadAllCalledWith(int chatId) {
    return _readAllCalls.lastOrNull == chatId;
  }

  bool isDeleteMessageCalledWith(int messageId) {
    return _deleteMessageCalls.lastOrNull == messageId;
  }

  int get readBeforeTimeCalledTimes => _readMessagesBeforeTimeWasCalls.length;

  int get readAllCalledTimes => _readAllCalls.length;

  int get deleteMessageCalledTimes => _deleteMessageCalls.length;

  /// streams
  final StreamController<NewMessageUpdate> _messageController =
      StreamController.broadcast();
  final StreamController<ReadMessagesUpdate> _readMessagesController =
      StreamController.broadcast();
  final StreamController<DeletedMessageUpdate> _deletedMessageController =
      StreamController.broadcast();
  final StreamController<OnlineStatusUpdate> _onlineUpdatesController =
      StreamController.broadcast();
  final StreamController<TypingActivityUpdate> _typingUpdatesController =
      StreamController.broadcast();

  @override
  Stream<NewMessageUpdate> get newMessageUpdatesStream => _messageController.stream;

  @override
  Stream<ReadMessagesUpdate> get readMessagesStream =>
      _readMessagesController.stream;

  @override
  Stream<DeletedMessageUpdate> get deletedMessageStream =>
      _deletedMessageController.stream;

  @override
  Stream<OnlineStatusUpdate> get onlineUpdatesStream =>
      _onlineUpdatesController.stream;

  @override
  Stream<TypingActivityUpdate> get typingUpdatesStream =>
      _typingUpdatesController.stream;

  /// events
  @override
  void sendMessage({required String message, required int recipientId}) {
    if (_nextSendMessageId == null) {
      throw Exception('id to new message is not specified');
    }

    _messageController.add(
      NewMessageUpdate(
        message: MessageDto(
          id: _nextSendMessageId!,
          chatId: 0,
          senderId: 0,
          isCurrentUser: true,
          message: '$message FIX THIS METHOD',
          type: 'message',
          isRead: false,
          createdAt: 2000,
          editedAt: null,
          fromCache: false,
        ),
        createdChatInfo: null,
      ),
    );
  }

  @override
  void deleteMessage({required int messageId}) {
    _deleteMessageCalls.add(messageId);
  }

  @override
  void readAllMessages({required int chatId}) {
    _readAllCalls.add(chatId);
  }

  @override
  void readMessagesBeforeTime({required int chatId, required DateTime time}) {
    _readMessagesBeforeTimeWasCalls.add((chatId, time));
  }

  @override
  void subscribeOnOnlineStatusUpdatesIfNot({required Iterable<int> usersIds}) {}

  @override
  void typingActivityDetected({required int chatId}) {}

  @override
  void dispose() {}
}
