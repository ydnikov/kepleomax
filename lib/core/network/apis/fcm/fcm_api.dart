import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'fcm_api.g.dart';

@RestApi()
abstract class FcmApi {
  factory FcmApi(Dio dio, String baseUrl) =>
      _FcmApi(dio, baseUrl: '$baseUrl/api/fcmToken');

  @POST('/')
  Future<HttpResponse<void>> addFCMToken({@Query('token') required String token});

  @DELETE('/')
  Future<HttpResponse<void>> deleteFCMToken({@Query('token') required String token});
}
