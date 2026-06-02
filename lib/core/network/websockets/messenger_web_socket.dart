import 'dart:async';

import 'package:kepleomax/core/data/models/channel_on_chat_screen_update.dart';
import 'package:kepleomax/core/di/disposable.dart';
import 'package:kepleomax/core/models/chat.dart';
import 'package:kepleomax/core/network/apis/chats/chats_dtos.dart';
import 'package:kepleomax/core/network/websockets/klm_web_socket.dart';
import 'package:kepleomax/core/network/websockets/models/channel_subscription_update.dart';
import 'package:kepleomax/core/network/websockets/models/channel_unsubscription_update.dart';
import 'package:kepleomax/core/network/websockets/models/deleted_message_update.dart';
import 'package:kepleomax/core/network/websockets/models/new_message_update.dart';
import 'package:kepleomax/core/network/websockets/models/online_status_update.dart';
import 'package:kepleomax/core/network/websockets/models/read_messages_update.dart';
import 'package:kepleomax/core/network/websockets/models/typing_activity_update.dart';

abstract class MessengerWebSocket implements Disposable {
  /// actions
  void sendMessage({required String message, required int recipientId});

  void deleteMessage({required int messageId});

  void readAllMessages({required int chatId});

  void readMessagesBeforeTime({required int chatId, required DateTime time});

  void subscribeOnOnlineStatusUpdates({required List<int> usersIds});

  void subscribeOnChatsUpdates({required List<int> ids});

  void typingActivityDetected({required int chatId});

  /// streams
  Stream<NewMessageUpdate> get newMessageUpdatesStream;

  Stream<ReadMessagesUpdate> get readMessagesStream;

  Stream<DeletedMessageUpdate> get deletedMessageStream;

  Stream<OnlineStatusUpdate> get onlineUpdatesStream;

  Stream<TypingActivityUpdate> get typingUpdatesStream;

  Stream<ChannelSubscriptionUpdate> get channelSubscriptionUpdatesStream;

  Stream<ChannelUnsubscriptionUpdate> get channelUnsubscriptionUpdatesStream;

  Stream<ChannelOnChatScreenUpdate> get channelUpdatesStream;

  Stream<int> get channelDeletedStream;
}

class MessengerWebSocketImpl implements MessengerWebSocket {
  MessengerWebSocketImpl({required KlmWebSocket klmWebSocket})
    : _klmWebSocket = klmWebSocket {
    _eventsSub = _klmWebSocket.eventsStream.listen((event) {
      final data = event.$2 as Map<String, dynamic>;
      switch (event.$1) {
        case 'new_message':
          _onNewMessage(NewMessageUpdate.fromJson(data));
        case 'read_messages':
          _onReadMessages(ReadMessagesUpdate.fromJson(data));
        case 'deleted_message':
          _onDeletedMessage(DeletedMessageUpdate.fromJson(data));
        case 'online_status_update':
          _onOnlineStatusUpdate(OnlineStatusUpdate.fromJson(data));
        case 'typing_activity':
          _onTypingActivity(TypingActivityUpdate.fromJson(data, isTyping: true));
        case 'subscribe_on_channel':
          _onSubscribeOnChannel(ChannelSubscriptionUpdate.fromJson(data));
        case 'unsubscribe_from_channel':
          _onUnsubscribeOnChannel(ChannelUnsubscriptionUpdate.fromJson(data));
        case 'channel_edited':
          _onChannelEdited(
            ChannelData.fromDto(
              ChatChannelDataDto.fromJson(
                data['new_channel'] as Map<String, dynamic>,
              ),
            ),
          );
        case 'channel_deleted':
          _onChannelDeleted(data['channel_id'] as int);
      }
    });
  }

  final KlmWebSocket _klmWebSocket;
  late final StreamSubscription<void> _eventsSub;

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
  final StreamController<ChannelSubscriptionUpdate> _channelSubUpdatesController =
      StreamController.broadcast();
  final StreamController<ChannelUnsubscriptionUpdate>
  _channelUnsubUpdatesController = StreamController.broadcast();
  final StreamController<ChannelOnChatScreenUpdate> _channelUpdatesController =
      StreamController.broadcast();
  final StreamController<int> _channelDeletedController =
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

  @override
  Stream<ChannelSubscriptionUpdate> get channelSubscriptionUpdatesStream =>
      _channelSubUpdatesController.stream;

  @override
  Stream<ChannelUnsubscriptionUpdate> get channelUnsubscriptionUpdatesStream =>
      _channelUnsubUpdatesController.stream;

  @override
  Stream<ChannelOnChatScreenUpdate> get channelUpdatesStream =>
      _channelUpdatesController.stream;

  @override
  Stream<int> get channelDeletedStream => _channelDeletedController.stream;

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

  void _onReadMessages(ReadMessagesUpdate update) {
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

  void _onSubscribeOnChannel(ChannelSubscriptionUpdate update) {
    _channelSubUpdatesController.add(update);
  }

  void _onUnsubscribeOnChannel(ChannelUnsubscriptionUpdate update) {
    _channelUnsubUpdatesController.add(update);
  }

  void _onChannelEdited(ChannelData channelData) {
    _channelUpdatesController.add(
      ChannelOnChatScreenUpdate(
        channelId: channelData.id,
        newChannelData: channelData,
      ),
    );
  }

  void _onChannelDeleted(int channelId) {
    _channelDeletedController.add(channelId);
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
  void subscribeOnOnlineStatusUpdates({required List<int> usersIds}) {
    _klmWebSocket.emit('subscribe_on_online_status_updates', {
      'users_ids': usersIds,
    });
  }

  @override
  void subscribeOnChatsUpdates({required List<int> ids}) {
    _klmWebSocket.emit('subscribe_on_chats_updates', {'ids': ids});
  }

  @override
  void typingActivityDetected({required int chatId}) {
    _klmWebSocket.emit('typing_activity_detected', {'chat_id': chatId});
  }

  @override
  Future<void> dispose() async {
    _messagesController.close();
    _readMessagesController.close();
    _deletedMessageController.close();
    _onlineUpdatesController.close();
    _typingUpdatesController.close();
    _channelSubUpdatesController.close();
    _channelUnsubUpdatesController.close();
    _channelUpdatesController.close();
    _channelDeletedController.close();
    _eventsSub.cancel();
  }
}
