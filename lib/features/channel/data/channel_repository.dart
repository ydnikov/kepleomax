import 'package:kepleomax/core/models/user.dart';
import 'package:kepleomax/core/network/apis/channels/channel_api.dart';
import 'package:kepleomax/core/utils/stateful_stream.dart';

const int _channelSubsPagingLimit = 10;

abstract class ChannelRepository {
  Future<int> getSubscribersCount({required int channelId});

  Future<void> loadSubscribers({required int channelId});

  Future<void> loadMoreSubscribers({required int channelId});

  Future<void> subscribe({required int channelId});

  Future<void> unsubscribe({required int channelId});

  Future<void> dispose();

  Stream<List<User>> get usersStream;
}

class ChannelRepositoryImpl implements ChannelRepository {
  ChannelRepositoryImpl({required ChannelApi channelApi, bool initSubsStream = true})
    : _api = channelApi {
    if (initSubsStream) {
      _usersStreamController = StatefulStreamController<List<User>>(
        initialValue: [],
      );
    }
  }

  final ChannelApi _api;
  late final StatefulStreamController<List<User>> _usersStreamController;

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
  Future<void> unsubscribe({required int channelId}) async {
    final res = await _api.unsubscribe(channelId: channelId);

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
    await _usersStreamController.close();
  }

  @override
  Stream<List<User>> get usersStream => _usersStreamController.stream;
}
