import 'package:kepleomax/core/network/apis/channels/channel_api.dart';
import 'package:kepleomax/core/network/apis/channels/channel_dtos.dart';

abstract class ChannelEditorRepository {
  Future<void> createNewChannel({required String name});
}

class ChannelEditorRepositoryImpl implements ChannelEditorRepository {
  ChannelEditorRepositoryImpl({required ChannelApi channelApi}) : _api = channelApi;

  final ChannelApi _api;

  @override
  Future<void> createNewChannel({required String name}) async {
    final res = await _api.createNewChannel(
      body: ChannelRequestDto(name: name, imageUrl: null),
    );

    if (res.response.statusCode! < 200 || res.response.statusCode! > 299) {
      throw Exception(
        res.data.message ??
            'Failed to create new channel, code: ${res.response.statusCode}',
      );
    }
  }
}
