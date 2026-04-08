import 'package:dio/dio.dart';
import 'package:flutter_advanced_boilerplate/features/app/models/auth_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthTokenInterceptor extends Interceptor {
  AuthTokenInterceptor(this._secureStorage);

  final FlutterSecureStorage _secureStorage;
  AuthModel? _cachedToken;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _getToken();
    if (token != null) {
      options.headers['Authorization'] =
          '${token.tokenType} ${token.accessToken}';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      // Token expired, clear it
      await clearToken();
      return handler.next(err);
    }
    handler.next(err);
  }

  Future<AuthModel?> _getToken() async {
    if (_cachedToken != null) {
      return _cachedToken;
    }

    final tokenJson = await _secureStorage.read(key: 'auth_storage');
    if (tokenJson != null) {
      try {
        final decoded = _decodeAuthModel(tokenJson);
        _cachedToken = decoded;
        return decoded;
      } catch (e) {
        await clearToken();
      }
    }
    return null;
  }

  Future<void> setToken(AuthModel token) async {
    _cachedToken = token;
    await _secureStorage.write(
      key: 'auth_storage',
      value: _encodeAuthModel(token),
    );
  }

  Future<void> clearToken() async {
    _cachedToken = null;
    await _secureStorage.delete(key: 'auth_storage');
  }

  Future<AuthModel?> getToken() async => _getToken();

  String _encodeAuthModel(AuthModel token) {
    return token.toJson().toString();
  }

  AuthModel _decodeAuthModel(String json) {
    // Simple parsing - adjust based on your AuthModel structure
    return AuthModel.fromJson(Map<String, dynamic>.from({}));
  }
}
