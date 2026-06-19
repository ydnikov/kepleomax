import 'dart:async';

import 'package:kepleomax/core/data/models/channel_update.dart';
import 'package:kepleomax/core/network/websockets/messenger_web_socket.dart';
import 'package:kepleomax/core/network/websockets/models/channel_subscription_update.dart';
import 'package:kepleomax/core/network/websockets/models/channel_unsubscription_update.dart';
import 'package:kepleomax/core/network/websockets/models/deleted_message_update.dart';
import 'package:kepleomax/core/network/websockets/models/new_message_update.dart';
import 'package:kepleomax/core/network/websockets/models/online_status_update.dart';
import 'package:kepleomax/core/network/websockets/models/read_messages_update.dart';
import 'package:kepleomax/core/network/websockets/models/typing_activity_update.dart';

class FakeMessagesWebSocket implements MessengerWebSocket {
  /// send events
  @override
  void deleteMessage({required int messageId}) {}

  @override
  void sendMessage({required String message, required int recipientId}) {}

  @override
  void sendChannelMessage({required String message, required int chatId}) {}

  @override
  void readAllMessages({required int chatId}) {}

  @override
  void readMessagesBeforeTime({required int chatId, required DateTime time}) {}

  @override
  void subscribeOnOnlineStatusUpdatesIfNot({required Iterable<int> usersIds}) {}

  @override
  void typingActivityDetected({required int chatId}) {}

  @override
  void subscribeOnChatsUpdatesIfNot({required List<int> ids}) {}

  /// receive events
  @override
  Stream<DeletedMessageUpdate> get deletedMessageStream =>
      StreamController<DeletedMessageUpdate>.broadcast().stream;

  @override
  Stream<NewMessageUpdate> get newMessageUpdatesStream =>
      StreamController<NewMessageUpdate>.broadcast().stream;

  @override
  Stream<OnlineStatusUpdate> get onlineUpdatesStream =>
      StreamController<OnlineStatusUpdate>.broadcast().stream;

  @override
  Stream<ReadMessagesUpdate> get readMessagesStream =>
      StreamController<ReadMessagesUpdate>.broadcast().stream;

  @override
  Stream<TypingActivityUpdate> get typingUpdatesStream =>
      StreamController<TypingActivityUpdate>.broadcast().stream;

  @override
  Stream<int> get channelDeletedStream => StreamController<int>.broadcast().stream;

  @override
  Stream<ChannelSubscriptionUpdate> get channelSubscriptionUpdatesStream =>
      StreamController<ChannelSubscriptionUpdate>.broadcast().stream;

  @override
  Stream<ChannelUnsubscriptionUpdate> get channelUnsubscriptionUpdatesStream =>
      StreamController<ChannelUnsubscriptionUpdate>.broadcast().stream;

  @override
  Stream<ChannelUpdate> get channelUpdatesStream =>
      StreamController<ChannelUpdate>.broadcast().stream;

  @override
  void dispose() {}
}
