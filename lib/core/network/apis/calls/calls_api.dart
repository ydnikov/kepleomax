import 'package:dio/dio.dart';
import 'package:kepleomax/core/network/apis/calls/calls_dtos.dart';
import 'package:retrofit/retrofit.dart';

part 'calls_api.g.dart';

@RestApi()
abstract class CallsApi {
  factory CallsApi(Dio dio, String baseUrl) =>
      _CallsApi(dio, baseUrl: '$baseUrl/api/calls');

  @GET('/new')
  Future<HttpResponse<NewCallDto>> newCall({
    @Query('other_user_id') required int otherUserId,
    @Query('fcm_token') required String fcmToken,
  });

  @GET('/accept')
  Future<HttpResponse<void>> acceptCall({
    @Query('call_id') required String callId,
    @Query('fcm_token') required String fcmToken,
  });

  @GET('/status')
  Future<HttpResponse<CallStatusDto>> getStatusOfCall({
    @Query('call_id') required String callId,
  });

  @GET('/getOffer')
  Future<HttpResponse<CallGetOfferDto>> getOffer({
    @Query('call_id') required String callId,
  });

  @GET('/decline')
  Future<void> endCall({
    @Query('call_id') required String id,
    @Query('fcm_token') required String? fcmToken,
  });
}
