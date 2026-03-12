import 'package:dio/dio.dart';
import 'package:kepleomax/core/network/apis/user/get_user_dtos.dart';
import 'package:retrofit/retrofit.dart';

part 'users_api.g.dart';

@RestApi()
abstract class UsersApi {
  factory UsersApi(Dio dio, String baseUrl) =>
      _UsersApi(dio, baseUrl: '$baseUrl/api/user');

  @GET('/')
  Future<HttpResponse<GetUserResponse>> getUser({@Query('userId') required int userId});

  @GET('/search')
  Future<HttpResponse<GetUsersResponse>> searchUsers({
    @Query('search') required String search,
    @Query('limit') required int limit,
    @Query('cursor') required int? cursor,
  });
}
