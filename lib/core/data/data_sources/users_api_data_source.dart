import 'package:kepleomax/core/network/apis/user/users_api.dart';
import 'package:kepleomax/core/network/common/user_dto.dart';

abstract class UsersApiDataSource {
  Future<UserDto> getUser({required int userId});

  Future<List<UserDto>> searchUsers({
    required String search,
    required int limit,
    required int? cursor,
  });
}

class UsersApiDataSourceImpl implements UsersApiDataSource {
  UsersApiDataSourceImpl({required UsersApi usersApi}) : _usersApi = usersApi;

  final UsersApi _usersApi;

  @override
  Future<UserDto> getUser({required int userId}) async {
    final res = await _usersApi.getUser(userId: userId);

    if (res.response.statusCode != 200) {
      throw Exception(
        res.data.message ?? 'Failed to get users: ${res.response.statusCode}',
      );
    }

    return res.data.data!;
  }

  @override
  Future<List<UserDto>> searchUsers({
    required String search,
    required int limit,
    required int? cursor,
  }) async {
    final res = await _usersApi.searchUsers(
      search: search,
      limit: limit,
      cursor: cursor,
    );

    if (res.response.statusCode != 200) {
      throw Exception(
        res.data.message ?? 'Failed to get users: ${res.response.statusCode}',
      );
    }

    return res.data.data;
  }
}
