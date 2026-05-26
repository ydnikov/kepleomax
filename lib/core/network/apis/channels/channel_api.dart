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

  @PUT('/edit')
  Future<HttpResponse<CreateNewChannelResponseDto>> editChannel({
    @Query('channel_id') required int channelId,
    @Body() required ChannelRequestDto body,
  });

  @GET('/subsCount')
  Future<HttpResponse<GetSubscribersCountResponseDto>> getSubscribersCount({
    @Query('channel_id') required int channelId,
  });

  @GET('/subs')
  Future<HttpResponse<GetSubscribersResponseDto>> getSubscribers({
    @Query('channel_id') required int channelId,
    @Query('limit') required int limit,
    @Query('cursor') required int? cursor,
  });

  @POST('/subscribe')
  Future<HttpResponse<void>> subscribe({
    @Query('channel_id') required int channelId,
  });

  @DELETE('/unsubscribe')
  Future<HttpResponse<void>> unsubscribe({
    @Query('channel_id') required int channelId,
  });
}
