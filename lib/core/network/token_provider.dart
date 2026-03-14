import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:kepleomax/core/flavor.dart';
import 'package:kepleomax/core/logger.dart';
import 'package:kepleomax/core/network/common/ntp_time.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';

abstract class TokenProvider {
  Future<void> saveAccessToken(String token);

  Future<String?> getAccessToken({
    bool refreshIfNeeded = true,
    Function? onLogoutCallback,
  });

  Future<void> saveRefreshToken(String token);

  Future<String?> getRefreshToken();

  Future<void> clearAll();
}

class TokenProviderImpl implements TokenProvider {

  TokenProviderImpl({
    required SharedPreferences prefs,
    required FlutterSecureStorage secureStorage,
    required Dio dio,
  }) : _secureStorage = secureStorage,
       _prefs = prefs,
       _dio = dio;
  final SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage;
  final Dio _dio;

  final _lock = Lock();

  static const _accessTokenKey = 'access_token_key';
  static const _refreshTokenKey = 'refresh_token_key';

  @override
  Future<void> saveAccessToken(String token) async {
    await _prefs.setString(_accessTokenKey, token);
  }

  @override
  Future<String?> getAccessToken({
    bool refreshIfNeeded = true,
    Function? onLogoutCallback,
  }) => _lock.synchronized(() async {
    final accessToken = _prefs.getString(_accessTokenKey);
    if (accessToken == null) {
      onLogoutCallback?.call();
      logger.e('no accessToken');
      return null;
    }

    if (!refreshIfNeeded) {
      return accessToken;
    }

    final now = await NTPTime.now().onError((e, st) {
      logger.e(e, stackTrace: st);
      return DateTime.now();
    });
    final isExpired = now.isAfter(JwtDecoder.getExpirationDate(accessToken));

    if (!isExpired) {
      return accessToken;
    } else {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) {
        onLogoutCallback?.call();
        logger.e('no refreshToken');
        return null;
      }
      final isRefreshExpired = now.isAfter(
        JwtDecoder.getExpirationDate(refreshToken),
      );
      if (isRefreshExpired) {
        onLogoutCallback?.call();
        logger.e('refreshToken is expired');
        return null;
      }

      try {
        logger.i('try to refresh accessToken');
        final response = await _dio.post<Map<String, dynamic>>(
          '${flavor.baseUrl}/api/auth/refresh',
          data: {'refreshToken': refreshToken},
        );

        if (response.statusCode == 401 ||
            response.statusCode == 403 ||
            response.statusCode == 404) {
          logger.e('forbidden to refresh the accessToken: ${response.statusCode}');
          onLogoutCallback?.call();
          return null;
        }

        if (response.statusCode == 200) {
          final token = response.data!['accessToken'] as String;
          logger.i('accessToken is successfully refreshed');
          await saveAccessToken(token);
          return token;
        } else {
          throw Exception(
            'failed to refresh the accessToken: ${response.statusCode}, $response',
          );
        }
      } catch (e, st) {
        logger.e(e, stackTrace: st);
        return null;
      }
    }
  });

  @override
  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: _refreshTokenKey, value: token);
  }

  @override
  Future<String?> getRefreshToken() => _secureStorage.read(key: _refreshTokenKey);

  @override
  Future<void> clearAll() async {
    _prefs.remove(_accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
  }
}
