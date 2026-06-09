import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  factory HttpClient() => _instance;

  late final Dio _dio;

  HttpClient._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: _onRequest,
      onResponse: _onResponse,
      onError: _onError,
    ));
  }

  Dio get dio => _dio;

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Add token to request if available
    final token = await getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['token'] = token;
    }
    // Add user_id if available
    final userId = await getUserId();
    if (userId != null) {
      options.headers['user_id'] = userId;
    }
    handler.next(options);
  }

  void _onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    handler.next(response);
  }

  Future<void> _onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      // Token expired - clear and redirect to login
      await clearToken();
    }
    handler.next(err);
  }

  // Token management
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(ApiConfig.tokenKey);
  }

  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ApiConfig.tokenKey, token);
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(ApiConfig.userIdKey);
  }

  Future<void> setUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(ApiConfig.userIdKey, userId);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(ApiConfig.tokenKey);
    await prefs.remove(ApiConfig.userIdKey);
    await prefs.remove(ApiConfig.userInfoKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Convenience methods
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.get(path, queryParameters: queryParameters);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response =
        await _dio.post(path, data: data, queryParameters: queryParameters);
    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(Response response) {
    final data = response.data as Map<String, dynamic>;
    if (data['code'] == 1) {
      return data;
    } else {
      throw ApiException(
        code: data['code'] ?? -1,
        msg: data['msg'] ?? '请求失败',
      );
    }
  }
}

class ApiException implements Exception {
  final int code;
  final String msg;

  ApiException({required this.code, required this.msg});

  @override
  String toString() => 'ApiException($code): $msg';
}
