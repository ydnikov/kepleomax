import 'dart:async';

import 'package:kepleomax/core/data/models/channel_on_chat_screen_update.dart';
import 'package:kepleomax/core/models/chat.dart';
import 'package:kepleomax/core/models/user.dart';
import 'package:kepleomax/core/network/apis/channels/channel_api.dart';
import 'package:kepleomax/core/network/websockets/messenger_web_socket.dart';
import 'package:kepleomax/core/utils/stateful_stream.dart';

const int _channelSubsPagingLimit = 10;

abstract class ChannelRepository {
  Future<int> getSubscribersCount({required int channelId});

  Future<void> loadSubscribers({required int channelId});

  Future<void> loadMoreSubscribers({required int channelId});

  Future<void> subscribe({required int channelId});

  /// userId is used when owner tries to delete subscriber
  Future<void> unsubscribe({required int channelId, int? userId});

  Future<void> dispose();

  Stream<List<User>> get usersStream;

  Stream<ChannelOnChatScreenUpdate> get channelOnChatScreenUpdatesStream;
}

class ChannelRepositoryImpl implements ChannelRepository {
  ChannelRepositoryImpl({
    required ChannelApi channelApi,
    required MessengerWebSocket messengerWebSocket,
    bool initStreams = true,
  }) : _webSocket = messengerWebSocket,
       _api = channelApi {
    if (!initStreams) return;

    _usersStreamController = StatefulStreamController<List<User>>(initialValue: []);
    _channelUpdatesController =
        StatefulStreamController<ChannelOnChatScreenUpdate>();

    _subs.addAll([
      _webSocket.channelSubscriptionUpdatesStream.listen((update) {
        _channelUpdatesController.add(
          ChannelOnChatScreenUpdate(
            channelId: update.chat.id,
            newChannelData: update.chat.channelData,
          ),
        );
      }),
      _webSocket.channelUnsubscriptionUpdatesStream.listen((update) {
        _channelUpdatesController.add(
          ChannelOnChatScreenUpdate(
            channelId: update.chatId,
            newUserRole: UserChannelRole.none,
            newSubsCount: update.subsCount,
          ),
        );
      }),
    ]);
  }

  final ChannelApi _api;
  final MessengerWebSocket _webSocket;
  late final StatefulStreamController<List<User>> _usersStreamController;
  late final StatefulStreamController<ChannelOnChatScreenUpdate>
  _channelUpdatesController;
  final List<StreamSubscription<void>> _subs = [];

  @override
  Future<int> getSubscribersCount({required int channelId}) async {
    final res = await _api.getSubscribersCount(channelId: channelId);

    if (res.response.statusCode! < 200 || res.response.statusCode! > 299) {
      throw Exception(
        res.data.message ?? 'Failed to get subs count: ${res.response.statusCode}',
      );
    }

    return res.data.count!;
  }

  @override
  Future<void> loadSubscribers({required int channelId}) async {
    final res = await _api.getSubscribers(
      channelId: channelId,
      limit: _channelSubsPagingLimit,
      cursor: null,
    );

    if (res.response.statusCode! < 200 || res.response.statusCode! > 299) {
      throw Exception(
        res.data.message ?? 'Failed to get subs count: ${res.response.statusCode}',
      );
    }

    _usersStreamController.add(res.data.data!.map(User.fromDto).toList());
  }

  @override
  Future<void> subscribe({required int channelId}) async {
    final res = await _api.subscribe(channelId: channelId);

    if (res.response.statusCode! < 200 || res.response.statusCode! > 299) {
      throw Exception(
        res.response.statusCode == 409
            ? 'You are already subscribed'
            : 'Failed to subscribe: ${res.response.statusCode}',
      );
    }
  }

  @override
  Future<void> unsubscribe({required int channelId, int? userId}) async {
    final res = await _api.unsubscribe(channelId: channelId, userId: userId);

    if (res.response.statusCode! < 200 || res.response.statusCode! > 299) {
      throw Exception(
        res.response.statusCode == 404
            ? 'You are not a subscriber'
            : 'Failed to unsubscribe: ${res.response.statusCode}',
      );
    }
  }

  @override
  Future<void> loadMoreSubscribers({required int channelId}) {
    // TODO: implement loadMoreSubscribers
    throw UnimplementedError();
  }

  @override
  Future<void> dispose() async {
    for (final sub in _subs) {
      unawaited(sub.cancel());
    }
    await _usersStreamController.close();
  }

  @override
  Stream<List<User>> get usersStream => _usersStreamController.stream;

  @override
  Stream<ChannelOnChatScreenUpdate> get channelOnChatScreenUpdatesStream =>
      _channelUpdatesController.stream;
}
