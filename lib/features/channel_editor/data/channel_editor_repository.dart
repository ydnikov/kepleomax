import 'package:kepleomax/core/models/chat.dart';
import 'package:kepleomax/core/network/apis/channels/channel_api.dart';
import 'package:kepleomax/core/network/apis/channels/channel_dtos.dart';
import 'package:kepleomax/features/channel_editor/bloc/channel_editor_state.dart';

abstract class ChannelEditorRepository {
  Future<ChannelData> createNewChannel({required ChannelEditingUiData channelData});

  Future<ChannelData> editChannel({
    required int channelId,
    required ChannelEditingUiData channelData,
  });
}

class ChannelEditorRepositoryImpl implements ChannelEditorRepository {
  ChannelEditorRepositoryImpl({required ChannelApi channelApi}) : _api = channelApi;

  final ChannelApi _api;

  @override
  Future<ChannelData> createNewChannel({required ChannelEditingUiData channelData}) async {
    final res = await _api.createNewChannel(
      body: ChannelRequestDto(
        name: channelData.name,
        imageUrl: null,
        description: channelData.description,
        tag: channelData.tag,
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
    required ChannelEditingUiData channelData,
  }) async {
    final res = await _api.editChannel(
      channelId: channelId,
      body: ChannelRequestDto(
        name: channelData.name,
        imageUrl: null,
        description: channelData.description,
        tag: channelData.tag,
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
}
