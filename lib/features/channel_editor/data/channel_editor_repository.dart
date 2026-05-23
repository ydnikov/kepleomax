import 'package:kepleomax/core/network/apis/channels/channel_api.dart';
import 'package:kepleomax/core/network/apis/channels/channel_dtos.dart';

abstract class ChannelEditorRepository {
  Future<void> createNewChannel({
    required String name,
    required String description,
    required String tag,
  });
}

class ChannelEditorRepositoryImpl implements ChannelEditorRepository {
  ChannelEditorRepositoryImpl({required ChannelApi channelApi}) : _api = channelApi;

  final ChannelApi _api;

  @override
  Future<void> createNewChannel({
    required String name,
    required String description,
    required String tag,
  }) async {
    final res = await _api.createNewChannel(
      body: ChannelRequestDto(
        name: name,
        imageUrl: null,
        description: description,
        tag: tag,
      ),
    );

    if (res.response.statusCode! < 200 || res.response.statusCode! > 299) {
      throw Exception(
        res.data.message ??
            'Failed to create new channel, code: ${res.response.statusCode}',
      );
    }
  }
}
