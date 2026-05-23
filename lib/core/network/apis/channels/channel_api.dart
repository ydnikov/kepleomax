import 'package:dio/dio.dart';
import 'package:kepleomax/core/network/apis/channels/channel_dtos.dart';
import 'package:retrofit/retrofit.dart';

part 'channel_api.g.dart';

@RestApi()
abstract class ChannelApi {
  factory ChannelApi(Dio dio, String baseUrl) =>
      _ChannelApi(dio, baseUrl: '$baseUrl/api/channel');

  @POST('/new')
  Future<HttpResponse<CreateNewChannelResponseDto>> createNewChannel({
    @Body() required ChannelRequestDto body,
  });
}
