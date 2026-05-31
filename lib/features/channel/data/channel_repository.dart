import 'dart:async';
import 'dart:io';

import 'package:kepleomax/core/data/models/channel_on_chat_screen_update.dart';
import 'package:kepleomax/core/di/disposable.dart';
import 'package:kepleomax/core/models/chat.dart';
import 'package:kepleomax/core/models/user.dart';
import 'package:kepleomax/core/network/apis/channels/channel_api.dart';
import 'package:kepleomax/core/network/apis/channels/channel_dtos.dart';
import 'package:kepleomax/core/network/apis/chats/chats_api.dart';
import 'package:kepleomax/core/network/apis/files/files_api.dart';
import 'package:kepleomax/core/network/websockets/klm_web_socket.dart';
import 'package:kepleomax/core/network/websockets/messenger_web_socket.dart';
import 'package:kepleomax/core/utils/stateful_stream.dart';
import 'package:kepleomax/features/channel_editor/bloc/channel_editor_state.dart';

const int _channelSubsPagingLimit = 10;

abstract class ChannelRepository implements ChannelEditorRepository, Disposable {
  Future<int> getSubscribersCount({required int channelId});

  Future<void> loadSubscribers({required int channelId});

  Future<void> loadMoreSubscribers({required int channelId});

  Future<void> subscribe({required int channelId});

  /// userId is used when owner tries to delete subscriber
  Future<void> unsubscribe({required int channelId, int? userId});

  Stream<List<User>> get usersStream;

  Stream<ChannelOnChatScreenUpdate> get channelOnChatScreenUpdatesStream;
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
    required MessengerWebSocket messengerWebSocket,
  }) : _filesApi = filesApi,
       _webSocket = messengerWebSocket,
       _api = channelApi {
    _usersStreamController = StatefulStreamController<List<User>>(initialValue: []);
    _channelUpdatesController =
        StreamController<ChannelOnChatScreenUpdate>.broadcast();

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
      _webSocket.channelUpdatesStream.listen((update) {
        _channelUpdatesController.add(update);
      }),
      // _baseWebSocket.connectionStateStream.listen((isConnected) {
      //   if (isConnected) {
      //
      //   }
      // })
    ]);
  }

  final ChannelApi _api;
  // final ChatsApi _chatsApi;
  final FilesApi _filesApi;
  final MessengerWebSocket _webSocket;
  // final KlmWebSocket _baseWebSocket;
  late final StatefulStreamController<List<User>> _usersStreamController;
  late final StreamController<ChannelOnChatScreenUpdate> _channelUpdatesController;
  final List<StreamSubscription<void>> _subs = [];

  int _cachedSubsCount = 0;

  // Future<void> _updateChannelData() async {
  //   final res = await _chatsApi.getChatWithId(chatId: chatId);
  //
  //   if (res.response.statusCode! < 200 || res.response.statusCode! > 299) {
  //     throw Exception(
  //       res.data.message ?? 'Failed to update channel: ${res.response.statusCode}',
  //     );
  //   }
  //
  //   _channelUpdatesController
  // }

  @override
  Future<int> getSubscribersCount({required int channelId}) async {
    final res = await _api.getSubscribersCount(channelId: channelId);

    if (res.response.statusCode! < 200 || res.response.statusCode! > 299) {
      throw Exception(
        res.data.message ?? 'Failed to get subs count: ${res.response.statusCode}',
      );
    }

    return _cachedSubsCount = res.data.count!;
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

    _cachedSubsCount = res.data.totalCount!;
    _channelUpdatesController.add(
      ChannelOnChatScreenUpdate(
        channelId: channelId,
        newSubsCount: _cachedSubsCount,
      ),
    );
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

    if (userId != null) {
      _usersStreamController.add(
        _usersStreamController.currentValue!.where((u) => u.id != userId).toList(),
      );

      _cachedSubsCount--;
      _channelUpdatesController.add(
        ChannelOnChatScreenUpdate(
          channelId: channelId,
          newSubsCount: _cachedSubsCount,
        ),
      );
    }
  }

  @override
  Future<void> loadMoreSubscribers({required int channelId}) {
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
  Stream<ChannelOnChatScreenUpdate> get channelOnChatScreenUpdatesStream =>
      _channelUpdatesController.stream;
}
