import 'dart:async';
import 'dart:io';

import 'package:kepleomax/core/data/data_sources/chats_api_data_sources.dart';
import 'package:kepleomax/core/di/disposable.dart';
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

  Stream<ChannelData> get channelOnChatScreenUpdatesStream;
}

abstract class ChannelEditorRepository {
  Future<ChannelData> createNewChannel({
    required ChannelEditingUiData channelUiData,
  });

  Future<ChannelData> editChannel({
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
       _api = channelApi {
    _usersStreamController = StatefulStreamController<List<User>>(initialValue: []);
    _channelUpdatesController = StatefulStreamController<ChannelData>();

    _subs.addAll([
      _webSocket.channelSubscriptionUpdatesStream.listen((update) {
        _channelUpdatesController.add(update.chat.channelData!);
      }),
      _webSocket.channelUnsubscriptionUpdatesStream.listen((update) {
        final newChannelData = _currentChannelData.copyWith(
          userRole: UserChannelRole.none,
          subscribersCount: update.subsCount,
        );

        _channelUpdatesController.add(newChannelData);
      }),
      _webSocket.channelUpdatesStream.listen((update) {
        if (update.newChannelData != null) {
          _channelUpdatesController.add(update.newChannelData!);
        } else {
          _channelUpdatesController.add(
            _currentChannelData.copyWith(
              userRole: update.newUserRole ?? _currentChannelData.userRole,
              subscribersCount:
                  update.newSubsCount ?? _currentChannelData.subscribersCount,
            ),
          );
        }
      }),
      _baseWebSocket.connectionStateStream.listen((isConnected) {
        if (isConnected) {
          _updateChannelData();
        }
      }),
    ]);
  }

  final ChannelApi _api;
  final ChatsApiDataSource _chatsApiDataSource;
  final FilesApi _filesApi;
  final MessengerWebSocket _webSocket;
  final KlmWebSocket _baseWebSocket;
  late final StatefulStreamController<List<User>> _usersStreamController;
  late final StatefulStreamController<ChannelData> _channelUpdatesController;
  final List<StreamSubscription<void>> _subs = [];

  ChannelData get _currentChannelData {
    if (_channelUpdatesController.currentValue == null) {
      throw Exception('call init() before any other methods');
    }
    return _channelUpdatesController.currentValue!;
  }

  Future<void> _updateChannelData() async {
    final chatDto = await _chatsApiDataSource.getChatWithId(
      _currentChannelData.id.toString(),
    );
    print('KlmLog newRole: ${chatDto.channelData!.userChannelRole}');
    _channelUpdatesController.add(ChannelData.fromDto(chatDto.channelData!));
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
      data = ChannelData.fromDto(chatDto.channelData!);
    }

    _channelUpdatesController.add(data, notify: false);
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
  Future<ChannelData> createNewChannel({
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

    return ChannelData.fromDto(res.data.data!);
  }

  @override
  Future<ChannelData> editChannel({
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

    return ChannelData.fromDto(res.data.data!);
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
  Future<void> dispose() async {
    for (final sub in _subs) {
      unawaited(sub.cancel());
    }
    await _usersStreamController.close();
    await _channelUpdatesController.close();
  }

  @override
  Stream<List<User>> get usersStream => _usersStreamController.stream;

  @override
  Stream<ChannelData> get channelOnChatScreenUpdatesStream =>
      _channelUpdatesController.stream;
}
