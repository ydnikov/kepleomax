import 'dart:async';
import 'dart:io';

import 'package:kepleomax/core/data/data_sources/chats_api_data_sources.dart';
import 'package:kepleomax/core/di/disposable.dart';
import 'package:kepleomax/core/logger.dart';
import 'package:kepleomax/core/models/chat.dart';
import 'package:kepleomax/core/models/user.dart';
import 'package:kepleomax/core/network/apis/channels/channel_api.dart';
import 'package:kepleomax/core/network/apis/channels/channel_dtos.dart';
import 'package:kepleomax/core/network/apis/files/files_api.dart';
import 'package:kepleomax/core/network/websockets/klm_web_socket.dart';
import 'package:kepleomax/core/network/websockets/messenger_web_socket.dart';
import 'package:kepleomax/core/utils/stateful_stream.dart';
import 'package:kepleomax/features/channel_editor/bloc/channel_editor_state.dart';

const int _channelSubsPagingLimit = 10;

abstract class ChannelRepository implements ChannelEditorRepository, Disposable {
  Future<ChannelData> init({ChannelData? channelData, int? channelId});

  Future<void> loadSubscribersCount();

  Future<void> loadSubscribers();

  Future<void> loadMoreSubscribers();

  Future<void> subscribe();

  /// userId is used when owner tries to delete subscriber
  Future<void> unsubscribe({int? userId});

  Stream<List<User>> get usersStream;

  Stream<ChannelData> get channelUpdatesStream;

  Stream<int> get channelDeletedStream;
}

abstract class ChannelEditorRepository {
  Future<Chat> createNewChannel({required ChannelEditingUiData channelUiData});

  Future<Chat> editChannel({
    required int channelId,
    required ChannelEditingUiData channelUiData,
  });

  Future<void> deleteChannel({required int channelId});
}

class ChannelRepositoryImpl implements ChannelRepository {
  ChannelRepositoryImpl({
    required ChannelApi channelApi,
    required FilesApi filesApi,
    required ChatsApiDataSource chatsApiDataSource,
    required KlmWebSocket klmWebSocket,
    required MessengerWebSocket messengerWebSocket,
  }) : _filesApi = filesApi,
       _chatsApiDataSource = chatsApiDataSource,
       _baseWebSocket = klmWebSocket,
       _webSocket = messengerWebSocket,
       _api = channelApi;

  final ChannelApi _api;
  final ChatsApiDataSource _chatsApiDataSource;
  final FilesApi _filesApi;
  final MessengerWebSocket _webSocket;
  final KlmWebSocket _baseWebSocket;

  final StatefulStreamController<List<User>> _usersStreamController =
      StatefulStreamController(initialValue: []);
  final StatefulStreamController<ChannelData> _channelUpdatesController =
      StatefulStreamController();
  final StreamController<int> _deletedController = StreamController.broadcast();

  final List<StreamSubscription<void>> _subs = [];

  ChannelData get _currentChannelData {
    if (_channelUpdatesController.currentValue == null) {
      throw Exception('ChannelRepository has no initial data');
    }
    return _channelUpdatesController.currentValue!;
  }

  Future<void> _updateChannelData() async {
    try {
      final chatDto = await _chatsApiDataSource.getChatWithId(
        _currentChannelData.id.toString(),
      );

      if (chatDto == null) {
        _deletedController.add(_currentChannelData.id);
      }

      _channelUpdatesController.add(ChannelData.fromDto(chatDto!.channelData!));
    } catch (e) {
      logger.e(e);
    }
  }

  @override
  Future<ChannelData> init({ChannelData? channelData, int? channelId}) async {
    if (channelData == null && channelId == null) {
      throw Exception("ChannelData and channelId can't both be null");
    } else if (channelData != null && channelId != null) {
      throw Exception("ChannelData and channelId can't both be not null");
    }

    ChannelData data;
    if (channelData != null) {
      data = channelData;
    } else {
      final chatDto = await _chatsApiDataSource.getChatWithId(channelId!.toString());

      if (chatDto == null) {
        _deletedController.add(channelId);
        throw Exception('Channel is deleted');
      }

      data = ChannelData.fromDto(chatDto.channelData!);
    }

    _channelUpdatesController.add(data, notify: false);

    if (_subs.isEmpty) {
      _subs.addAll([
        _webSocket.channelSubscriptionUpdatesStream.listen((update) {
          if (update.chat.id != _currentChannelData.id) return;

          _channelUpdatesController.add(update.chat.channelData!);
        }),
        _webSocket.channelUnsubscriptionUpdatesStream.listen((update) {
          if (update.channelId != _currentChannelData.id) return;

          final newChannelData = _currentChannelData.copyWith(
            userRole: UserChannelRole.none,
            subscribersCount: update.subsCount,
          );

          _channelUpdatesController.add(newChannelData);
        }),
        _webSocket.channelDeletedStream.listen((channelId) {
          if (channelId != _currentChannelData.id) return;

          _deletedController.add(channelId);
        }),
        _webSocket.channelUpdatesStream.listen((update) {
          if (update.channelId != _currentChannelData.id) return;

          ChannelData channelData;

          if (update.newChannelData != null) {
            channelData = update.newChannelData!;
          } else {
            channelData = _currentChannelData.copyWith(
              userRole: update.newUserRole ?? _currentChannelData.userRole,
              subscribersCount:
                  update.newSubsCount ?? _currentChannelData.subscribersCount,
            );
          }

          _channelUpdatesController.add(
            channelData.keepRoleIfNeeded(_currentChannelData.userRole),
          );
        }),
        _baseWebSocket.connectionStateStream.listen((isConnected) {
          if (isConnected) {
            _updateChannelData();
          }
        }),
      ]);
    }

    return data;
  }

  @override
  Future<void> loadSubscribersCount() async {
    final res = await _api.getSubscribersCount(channelId: _currentChannelData.id);

    if (res.response.statusCode! < 200 || res.response.statusCode! > 299) {
      throw Exception(
        res.data.message ?? 'Failed to get subs count: ${res.response.statusCode}',
      );
    }

    _channelUpdatesController.add(
      _currentChannelData.copyWith(subscribersCount: res.data.count),
    );
  }

  @override
  Future<void> loadSubscribers() async {
    final res = await _api.getSubscribers(
      channelId: _currentChannelData.id,
      limit: _channelSubsPagingLimit,
      cursor: null,
    );

    if (res.response.statusCode! < 200 || res.response.statusCode! > 299) {
      throw Exception(
        res.data.message ?? 'Failed to get subs count: ${res.response.statusCode}',
      );
    }

    _usersStreamController.add(res.data.data!.map(User.fromDto).toList());
    _channelUpdatesController.add(
      _currentChannelData.copyWith(subscribersCount: res.data.totalCount),
    );
  }

  @override
  Future<void> subscribe() async {
    final res = await _api.subscribe(channelId: _currentChannelData.id);

    if (res.response.statusCode! < 200 || res.response.statusCode! > 299) {
      throw Exception(
        res.response.statusCode == 409
            ? 'You are already subscribed'
            : 'Failed to subscribe: ${res.response.statusCode}',
      );
    }
  }

  @override
  Future<void> unsubscribe({int? userId}) async {
    final res = await _api.unsubscribe(
      channelId: _currentChannelData.id,
      userId: userId,
    );

    if (res.response.statusCode! < 200 || res.response.statusCode! > 299) {
      throw Exception(
        res.response.statusCode == 404
            ? 'You are not a subscriber'
            : 'Failed to unsubscribe: ${res.response.statusCode}',
      );
    }

    if (userId != null) {
      _usersStreamController.add(
        _usersStreamController.currentValue!.where((u) => u.id != userId).toList(),
      );
      _channelUpdatesController.add(
        _currentChannelData.copyWith(
          subscribersCount: _currentChannelData.subscribersCount! - 1,
        ),
      );
    }
  }

  @override
  Future<void> loadMoreSubscribers() {
    // TODO: implement loadMoreSubscribers
    throw UnimplementedError();
  }

  @override
  Future<Chat> createNewChannel({
    required ChannelEditingUiData channelUiData,
  }) async {
    String? imageUrl;
    if (channelUiData.imagePath != null) {
      final imageRes = await _filesApi.uploadFile(File(channelUiData.imagePath!));
      if (imageRes.response.statusCode! < 200 ||
          imageRes.response.statusCode! > 299) {
        throw Exception(
          imageRes.data.message ??
              'Failed to upload image: ${imageRes.response.statusCode}',
        );
      }
      imageUrl = imageRes.data.data!.path;
    }

    final res = await _api.createNewChannel(
      body: ChannelRequestDto(
        name: channelUiData.name,
        image: imageUrl,
        description: channelUiData.description,
        tag: channelUiData.tag,
      ),
    );

    if (res.response.statusCode! < 200 || res.response.statusCode! > 299) {
      throw Exception(
        res.data.message ??
            'Failed to create new channel, code: ${res.response.statusCode}',
      );
    }

    return Chat.fromDto(res.data.data!);
  }

  @override
  Future<Chat> editChannel({
    required int channelId,
    required ChannelEditingUiData channelUiData,
  }) async {
    String? imageUrl;
    if (channelUiData.imagePath != null) {
      final imageRes = await _filesApi.uploadFile(File(channelUiData.imagePath!));
      if (imageRes.response.statusCode! < 200 ||
          imageRes.response.statusCode! > 299) {
        throw Exception(
          imageRes.data.message ??
              'Failed to upload image: ${imageRes.response.statusCode}',
        );
      }
      imageUrl = imageRes.data.data!.path;
    }

    final res = await _api.editChannel(
      channelId: channelId,
      body: ChannelRequestDto(
        name: channelUiData.name,
        image: imageUrl,
        description: channelUiData.description,
        tag: channelUiData.tag,
      ),
    );

    if (res.response.statusCode! < 200 || res.response.statusCode! > 299) {
      throw Exception(
        res.data.message ?? 'Failed to edit, code: ${res.response.statusCode}',
      );
    }

    return Chat.fromDto(res.data.data!);
  }

  @override
  Future<void> deleteChannel({required int channelId}) async {
    final res = await _api.deleteChannel(channelId: channelId);

    if (res.response.statusCode! < 200 || res.response.statusCode! > 299) {
      // TODO make better texts
      throw Exception('Failed to delete, code: ${res.response.statusCode}');
    }
  }

  @override
  void dispose() {
    for (final sub in _subs) {
      sub.cancel();
    }
    _subs.clear();
    _usersStreamController.close();
    _channelUpdatesController.close();
    _deletedController.close();
  }

  @override
  Stream<List<User>> get usersStream => _usersStreamController.stream;

  @override
  Stream<ChannelData> get channelUpdatesStream => _channelUpdatesController.stream;

  @override
  Stream<int> get channelDeletedStream => _deletedController.stream;
}
