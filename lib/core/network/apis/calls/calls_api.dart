import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'calls_api.g.dart';

@RestApi()
abstract class CallsApi {
  factory CallsApi(Dio dio, String baseUrl) =>
      _CallsApi(dio, baseUrl: '$baseUrl/api/calls');

  @GET('/declineCall')
  Future<void> declineCall({@Query('otherUserId') required int otherUserId});
}