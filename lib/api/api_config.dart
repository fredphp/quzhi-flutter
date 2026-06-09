class ApiConfig {
  // TODO: Change to your actual server URL
  static const String baseUrl = 'http://your-server.com';
  // For emulator: 'http://10.0.2.2' (Android) or 'http://localhost' (iOS)

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // Token storage key
  static const String tokenKey = 'quzhi_token';
  static const String userInfoKey = 'quzhi_user_info';
  static const String userIdKey = 'quzhi_user_id';
}
