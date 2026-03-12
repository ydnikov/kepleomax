import 'package:kepleomax/core/network/apis/fcm/fcm_api.dart';

abstract class FcmApiDataSource {
  /// if true - success, false - failed
  Future<bool> addToken(String token);

  Future<void> deleteToken(String token);
}

class FcmApiDataSourceImpl implements FcmApiDataSource {
  FcmApiDataSourceImpl({required FcmApi fcmApi}) : _api = fcmApi;

  final FcmApi _api;

  @override
  Future<bool> addToken(String token) async {
    final result = await _api.addFCMToken(token: token);
    return result.response.statusCode == 200;
  }

  @override
  Future<void> deleteToken(String token) => _api.deleteFCMToken(token: token);
}
