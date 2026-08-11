import 'dart:async';

import 'package:kepleomax/core/data/models/channel_update.dart';
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
  void sendMessage(String message, {required int chatId});

  void deleteMessage(int messageId);

  void readAllMessages({required int chatId});

  void readMessagesBeforeTime({required int chatId, required DateTime time});

  void subscribeOnChatsUpdatesIfNot(List<int> ids);

  void subscribeOnOnlineStatusUpdatesIfNot(List<int> usersIds);

  void typingActivityDetected({required int chatId});

  /// streams
  Stream<NewMessageUpdate> get newMessageUpdatesStream;

  Stream<ReadMessagesUpdate> get readMessagesStream;

  Stream<DeletedMessageUpdate> get deletedMessageStream;

  Stream<OnlineStatusUpdate> get onlineUpdatesStream;

  Stream<TypingActivityUpdate> get typingUpdatesStream;

  Stream<ChannelSubscriptionUpdate> get channelSubscriptionUpdatesStream;

  Stream<ChannelUnsubscriptionUpdate> get channelUnsubscriptionUpdatesStream;

  Stream<ChannelUpdate> get channelUpdatesStream;

  Stream<int> get chatDeletedStream;
}

class MessengerWebSocketImpl implements MessengerWebSocket {
  MessengerWebSocketImpl({required KlmWebSocket klmWebSocket})
    : _klmWebSocket = klmWebSocket {
    _subs.addAll([
      _klmWebSocket.eventsStream.listen((event) {
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
                ChannelDataDto.fromJson(data['new_channel'] as Map<String, dynamic>),
              ),
            );
          case 'chat_deleted':
            _onChatDeleted(data['chat_id'] as int);
        }
      }),
      _klmWebSocket.connectionStateStream.listen((isConnected) {
        if (!isConnected) {
          _subscribedOnChatsIds.clear();
          _subscribedOnUsersIds.clear();
        }
      }),
    ]);
  }

  final KlmWebSocket _klmWebSocket;
  final List<StreamSubscription<void>> _subs = [];

  /// actions
  @override
  void sendMessage(String message, {required int chatId}) {
    _klmWebSocket.emit('message', {'chat_id': chatId, 'message': message});
  }

  @override
  void deleteMessage(int messageId) {
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

  final Set<int> _subscribedOnChatsIds = {};
  final Set<int> _subscribedOnUsersIds = {};

  @override
  void subscribeOnChatsUpdatesIfNot(List<int> ids) {
    final subscribeOn = <int>[];
    for (final id in ids) {
      if (!_subscribedOnChatsIds.contains(id)) {
        subscribeOn.add(id);
        _subscribedOnChatsIds.add(id);
      }
    }

    if (subscribeOn.isNotEmpty) {
      // print('KlmLogSubs subscribeOnChats: $subscribeOn');
      _klmWebSocket.emit('subscribe_on_chats_updates', {'ids': subscribeOn});
    }
  }

  @override
  void subscribeOnOnlineStatusUpdatesIfNot(List<int> usersIds) {
    final subscribeOn = <int>[];
    for (final id in usersIds) {
      if (!_subscribedOnUsersIds.contains(id)) {
        subscribeOn.add(id);
        _subscribedOnUsersIds.add(id);
      }
    }

    if (subscribeOn.isNotEmpty) {
      // print('KlmLogSubs subscribeOnUsers: $subscribeOn');
      _klmWebSocket.emit('subscribe_on_online_status_updates', {
        'users_ids': subscribeOn,
      });
    }
  }

  @override
  void typingActivityDetected({required int chatId}) {
    _klmWebSocket.emit('typing_activity_detected', {'chat_id': chatId});
  }

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
  final StreamController<ChannelUpdate> _channelUpdatesController =
      StreamController.broadcast();
  final StreamController<int> _chatDeletedController =
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
  Stream<ChannelUpdate> get channelUpdatesStream => _channelUpdatesController.stream;

  @override
  Stream<int> get chatDeletedStream => _chatDeletedController.stream;

  /// events handlers
  void _onNewMessage(NewMessageUpdate messageUpdate) {
    _messagesController.add(messageUpdate);
    if (!messageUpdate.message.isCurrentUser) {
      final typingUpdate = TypingActivityUpdate(
        chatId: messageUpdate.message.chatId,
        userId: messageUpdate.message.senderId,
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
      ChannelUpdate(channelId: channelData.id, newChannelData: channelData),
    );
  }

  void _onChatDeleted(int channelId) {
    _chatDeletedController.add(channelId);
  }

  @override
  void dispose() {
    _messagesController.close();
    _readMessagesController.close();
    _deletedMessageController.close();
    _onlineUpdatesController.close();
    _typingUpdatesController.close();
    _channelSubUpdatesController.close();
    _channelUnsubUpdatesController.close();
    _channelUpdatesController.close();
    _chatDeletedController.close();
    for (final sub in _subs) {
      sub.cancel();
    }
  }
}
