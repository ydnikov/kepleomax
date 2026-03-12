import 'package:dio/dio.dart';
import 'package:kepleomax/core/network/apis/fcm/fcm_api.dart';
import 'package:retrofit/dio.dart';

class FakeFcmApi implements FcmApi {
  @override
  Future<HttpResponse<void>> addFCMToken({required String token}) async =>
      HttpResponse(
        null,
        Response(requestOptions: RequestOptions(), statusCode: 200),
      );

  @override
  Future<HttpResponse<void>> deleteFCMToken({required String token}) async =>
      HttpResponse(
        null,
        Response(requestOptions: RequestOptions(), statusCode: 200),
      );
}
