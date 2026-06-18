import 'package:dio/dio.dart' hide Headers;
import 'package:kepleomax/core/network/apis/auth/login_dtos.dart';
import 'package:kepleomax/core/network/apis/auth/logout_dtos.dart';
import 'package:kepleomax/core/network/common/message_response_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, String baseUrl) =>
      _AuthApi(dio, baseUrl: '$baseUrl/api/auth');

  @POST('/register')
  @Headers(<String, dynamic>{'requiresToken': false})
  Future<HttpResponse<MessageResponseDto>> register({@Body() required LoginRequestDto data});

  @POST('/login')
  @Headers(<String, dynamic>{'requiresToken': false})
  Future<HttpResponse<LoginResponseDto>> login({
    @Body() required LoginRequestDto data,
  });

  @POST('/logout')
  @Headers(<String, dynamic>{'requiresToken': false})
  Future<void> logout({@Body() required LogoutRequestDto data});
}
