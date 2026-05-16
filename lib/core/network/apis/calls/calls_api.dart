import 'package:dio/dio.dart';
import 'package:kepleomax/core/network/apis/calls/calls_dtos.dart';
import 'package:retrofit/retrofit.dart';

part 'calls_api.g.dart';

@RestApi()
abstract class CallsApi {
  factory CallsApi(Dio dio, String baseUrl) =>
      _CallsApi(dio, baseUrl: '$baseUrl/api/calls');

  @GET('/status')
  Future<HttpResponse<CallStatusDto>> getStatusOfCall({
    @Query('call_id') required String callId,
  });

  @GET('/accept')
  Future<HttpResponse<void>> acceptCall({
    @Query('call_id') required String callId,
  });

  @GET('/newCall')
  Future<HttpResponse<NewCallDto>> newCall({
    @Query('other_user_id') required int otherUserId,
  });

  @GET('/declineCall')
  Future<void> endCall({
    @Query('call_id') required String id,
    @Query('fcm_token') required String? fcmToken,
  });
}
