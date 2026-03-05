import 'dart:async';

import 'package:kepleomax/core/network/websockets/klm_web_socket.dart';
import 'package:kepleomax/core/network/websockets/models/deleted_message_update.dart';
import 'package:kepleomax/core/network/websockets/models/new_message_update.dart';
import 'package:kepleomax/core/network/websockets/models/online_status_update.dart';
import 'package:kepleomax/core/network/websockets/models/read_messages_update.dart';
import 'package:kepleomax/core/network/websockets/models/typing_activity_update.dart';

abstract class MessengerWebSocket {
  /// actions
  void sendMessage({required String message, required int recipientId});

  void deleteMessage({required int messageId});

  void readAllMessages({required int chatId});

  void readMessagesBeforeTime({required int chatId, required DateTime time});

  void subscribeOnOnlineStatusUpdates({required Iterable<int> usersIds});

  void typingActivityDetected({required int chatId});

  /// streams
  Stream<NewMessageUpdate> get newMessageUpdatesStream;

  Stream<ReadMessagesUpdate> get readMessagesStream;

  Stream<DeletedMessageUpdate> get deletedMessageStream;

  Stream<OnlineStatusUpdate> get onlineUpdatesStream;

  Stream<TypingActivityUpdate> get typingUpdatesStream;
}

class MessengerWebSocketImpl implements MessengerWebSocket {
  MessengerWebSocketImpl({required KlmWebSocket klmWebSocket})
    : _klmWebSocket = klmWebSocket {
    _klmWebSocket.eventsStream.listen((event) {
      final data = event.$2;
      switch (event.$1) {
        case 'new_message': _onNewMessage(NewMessageUpdate.fromJson(data as Map<String, dynamic>));
        case 'read_messages': _onReadMessages(ReadMessagesUpdate.fromJson(data as Map<String, dynamic>));
        case 'deleted_message': _onDeletedMessage(DeletedMessageUpdate.fromJson(data as Map<String, dynamic>));
        case 'online_status_update': _onOnlineStatusUpdate(OnlineStatusUpdate.fromJson(data as Map<String, dynamic>));
        case 'typing_activity': _onTypingActivity(TypingActivityUpdate.fromJson(
          data as Map<String, dynamic>,
          isTyping: true,
        ));
      }
    });
  }

  final KlmWebSocket _klmWebSocket;

  /// streams controllers
  final StreamController<NewMessageUpdate> _messagesController =
      StreamController.broadcast();
  final StreamController<ReadMessagesUpdate> _readMessagesController =
      StreamController.broadcast();
  final StreamController<DeletedMessageUpdate> _deletedMessageController =
      StreamController.broadcast();
  final StreamController<OnlineStatusUpdate> _onlineUpdatesController =
      StreamController.broadcast();
  final StreamController<TypingActivityUpdate> _typingUpdatesController =
      StreamController.broadcast();

  /// streams
  @override
  Stream<NewMessageUpdate> get newMessageUpdatesStream => _messagesController.stream;

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

  /// events handlers
  void _onNewMessage(NewMessageUpdate messageUpdate) {
    _messagesController.add(messageUpdate);
    if (!messageUpdate.message.isCurrentUser) {
      final typingUpdate = TypingActivityUpdate(
        chatId: messageUpdate.message.chatId,
        isTyping: false,
      );
      _typingUpdatesController.add(typingUpdate);
    }
  }

  void _onReadMessages(ReadMessagesUpdate update){
    _readMessagesController.add(update);
  }

  void _onDeletedMessage(DeletedMessageUpdate update) {
    _deletedMessageController.add(update);
  }

  void _onOnlineStatusUpdate(OnlineStatusUpdate update) {
    _onlineUpdatesController.add(update);
  }

  void _onTypingActivity(TypingActivityUpdate update) {
    _typingUpdatesController.add(update);
  }

  /// events
  @override
  void sendMessage({required String message, required int recipientId}) {
    _klmWebSocket.emit('message', {'recipient_id': recipientId, 'message': message});
  }

  @override
  void deleteMessage({required int messageId}) {
    _klmWebSocket.emit('delete_message', {'message_id': messageId});
  }

  @override
  void readAllMessages({required int chatId}) {
    _klmWebSocket.emit('read_all', {'chat_id': chatId});
  }

  @override
  void readMessagesBeforeTime({required int chatId, required DateTime time}) {
    _klmWebSocket.emit('read_before_time', {
      'chat_id': chatId,
      'time': time.millisecondsSinceEpoch,
    });
  }

  @override
  void subscribeOnOnlineStatusUpdates({required Iterable<int> usersIds}) {
    _klmWebSocket.emit('subscribe_on_online_status_updates', {
      'users_ids': usersIds.toList(),
    });
  }

  @override
  void typingActivityDetected({required int chatId}) {
    _klmWebSocket.emit('typing_activity_detected', {'chat_id': chatId});
  }
}
