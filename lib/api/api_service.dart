import 'package:dio/dio.dart';
import 'http_client.dart';

class ApiService {
  static final HttpClient _http = HttpClient();

  // ============ Auth ============

  /// Send SMS verification code
  static Future<Map<String, dynamic>> sendSms({
    required String mobile,
    String event = 'mobilelogin',
  }) async {
    return await _http.post('/api/sms/send', data: {
      'mobile': mobile,
      'event': event,
    });
  }

  /// Login with mobile + captcha
  static Future<Map<String, dynamic>> mobileLogin({
    required String mobile,
    required String captcha,
  }) async {
    return await _http.post('/api/user/mobilelogin', data: {
      'mobile': mobile,
      'captcha': captcha,
    });
  }

  /// Logout
  static Future<Map<String, dynamic>> logout() async {
    final result = await _http.post('/api/user/logout');
    await _http.clearToken();
    return result;
  }

  // ============ User ============

  /// Get user info
  static Future<Map<String, dynamic>> getUserInfo() async {
    return await _http.get('/api/user/index');
  }

  /// Update user profile
  static Future<Map<String, dynamic>> updateProfile({
    String? avatar,
    String? nickname,
    String? gender,
    String? birthday,
    String? bio,
  }) async {
    final data = <String, dynamic>{};
    if (avatar != null) data['avatar'] = avatar;
    if (nickname != null) data['nickname'] = nickname;
    if (gender != null) data['gender'] = gender;
    if (birthday != null) data['birthday'] = birthday;
    if (bio != null) data['bio'] = bio;
    return await _http.post('/api/user/profile', data: data);
  }

  // ============ Content ============

  /// Get content categories
  static Future<Map<String, dynamic>> getContentCategories() async {
    return await _http.get('/api/content/categories');
  }

  /// Get content list
  static Future<Map<String, dynamic>> getContentList({
    String? category,
    int page = 1,
    int limit = 20,
    String? keyword,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    if (category != null && category != 'all') params['category'] = category;
    if (keyword != null && keyword.isNotEmpty) params['keyword'] = keyword;
    return await _http.get('/api/content/list', queryParameters: params);
  }

  /// Get content detail
  static Future<Map<String, dynamic>> getContentDetail({required int id}) async {
    return await _http.get('/api/content/detail', queryParameters: {'id': id});
  }

  /// Search content
  static Future<Map<String, dynamic>> searchContent({
    required String keyword,
    int page = 1,
    int limit = 20,
  }) async {
    return await _http.get('/api/content/search', queryParameters: {
      'keyword': keyword,
      'page': page,
      'limit': limit,
    });
  }

  /// Like/unlike content
  static Future<Map<String, dynamic>> likeContent({required int id}) async {
    return await _http.post('/api/content/like', data: {'id': id});
  }

  /// Bookmark/unbookmark content
  static Future<Map<String, dynamic>> bookmarkContent({required int id}) async {
    return await _http.post('/api/content/bookmark', data: {'id': id});
  }

  /// Add comment
  static Future<Map<String, dynamic>> addComment({
    required int id,
    required String content,
    int? pid,
  }) async {
    final data = <String, dynamic>{'id': id, 'content': content};
    if (pid != null) data['pid'] = pid;
    return await _http.post('/api/content/comment', data: data);
  }

  /// Get comments
  static Future<Map<String, dynamic>> getComments({
    required int id,
    int page = 1,
    int limit = 20,
  }) async {
    return await _http.get('/api/content/comments', queryParameters: {
      'id': id,
      'page': page,
      'limit': limit,
    });
  }

  /// Share content
  static Future<Map<String, dynamic>> shareContent({
    required int id,
    String platform = 'link',
  }) async {
    return await _http.post('/api/content/share', data: {
      'id': id,
      'platform': platform,
    });
  }

  /// Earn points for reading
  static Future<Map<String, dynamic>> earnReadPoints({required int id}) async {
    return await _http.post('/api/content/earnPoints', data: {'id': id});
  }

  // ============ Mall ============

  /// Get mall products
  static Future<Map<String, dynamic>> getMallProducts({
    String? filter,
    int page = 1,
    int limit = 20,
    int? categoryId,
  }) async {
    final params = <String, dynamic>{'page': page, 'limit': limit};
    if (filter != null) params['filter'] = filter;
    if (categoryId != null) params['category_id'] = categoryId;
    return await _http.get('/api/mall/products', queryParameters: params);
  }

  /// Get product detail
  static Future<Map<String, dynamic>> getProductDetail({required int id}) async {
    return await _http.get('/api/mall/detail', queryParameters: {'id': id});
  }

  /// Exchange product
  static Future<Map<String, dynamic>> exchangeProduct({
    required int productId,
    required int addressId,
    int nums = 1,
  }) async {
    return await _http.post('/api/mall/exchange', data: {
      'product_id': productId,
      'address_id': addressId,
      'nums': nums,
    });
  }

  /// Get exchange records
  static Future<Map<String, dynamic>> getExchangeRecords({
    int page = 1,
    int limit = 20,
    String? status,
  }) async {
    final params = <String, dynamic>{'page': page, 'limit': limit};
    if (status != null) params['status'] = status;
    return await _http.get('/api/mall/records', queryParameters: params);
  }

  // ============ Address ============

  /// Get address list
  static Future<Map<String, dynamic>> getAddressList() async {
    return await _http.get('/api/address/lists');
  }

  /// Add address
  static Future<Map<String, dynamic>> addAddress({
    required String name,
    required String phone,
    required String province,
    required String city,
    required String district,
    required String detail,
    bool isDefault = false,
  }) async {
    return await _http.post('/api/address/add', data: {
      'name': name,
      'phone': phone,
      'province': province,
      'city': city,
      'district': district,
      'detail': detail,
      'isDefault': isDefault ? 1 : 0,
    });
  }

  /// Update address
  static Future<Map<String, dynamic>> updateAddress({
    required int id,
    String? name,
    String? phone,
    String? province,
    String? city,
    String? district,
    String? detail,
    bool? isDefault,
  }) async {
    final data = <String, dynamic>{'id': id};
    if (name != null) data['name'] = name;
    if (phone != null) data['phone'] = phone;
    if (province != null) data['province'] = province;
    if (city != null) data['city'] = city;
    if (district != null) data['district'] = district;
    if (detail != null) data['detail'] = detail;
    if (isDefault != null) data['isDefault'] = isDefault ? 1 : 0;
    return await _http.post('/api/address/update', data: data);
  }

  /// Delete address
  static Future<Map<String, dynamic>> deleteAddress({required int id}) async {
    return await _http.post('/api/address/delete', data: {'id': id});
  }

  /// Set default address
  static Future<Map<String, dynamic>> setDefaultAddress({required int id}) async {
    return await _http.post('/api/address/setDefault', data: {'id': id});
  }

  // ============ Invite/Promote ============

  /// Get invite overview
  static Future<Map<String, dynamic>> getInviteOverview() async {
    return await _http.get('/api/invite/overview');
  }

  /// Get my invite code
  static Future<Map<String, dynamic>> getMyInviteCode() async {
    return await _http.get('/api/invite/myCode');
  }

  /// Get team list
  static Future<Map<String, dynamic>> getTeamList({
    int level = 1,
    int page = 1,
    int limit = 20,
  }) async {
    return await _http.get('/api/invite/teamList', queryParameters: {
      'level': level,
      'page': page,
      'limit': limit,
    });
  }

  // ============ Coin/Points ============

  /// Get coin balance
  static Future<Map<String, dynamic>> getCoinBalance() async {
    return await _http.get('/api/coin/balance');
  }

  /// Get coin logs
  static Future<Map<String, dynamic>> getCoinLogs({
    int page = 1,
    String? type,
    String? month,
  }) async {
    final params = <String, dynamic>{'page': page};
    if (type != null) params['type'] = type;
    if (month != null) params['month'] = month;
    return await _http.get('/api/coin/logs', queryParameters: params);
  }

  // ============ Message/Notification ============

  /// Get message list
  static Future<Map<String, dynamic>> getMessageList({
    int page = 1,
    int pagesize = 20,
    String? type,
  }) async {
    final params = <String, dynamic>{'page': page, 'pagesize': pagesize};
    if (type != null) params['type'] = type;
    return await _http.get('/api/message/list', queryParameters: params);
  }

  /// Get unread message count
  static Future<Map<String, dynamic>> getUnreadCount() async {
    return await _http.get('/api/message/unreadCount');
  }

  /// Mark message as read
  static Future<Map<String, dynamic>> markMessageRead({int messageId = 0}) async {
    return await _http.post('/api/message/markRead', data: {'message_id': messageId});
  }

  // ============ Ad ============

  /// Ad callback
  static Future<Map<String, dynamic>> adCallback({
    required String adType,
    required String adpid,
    String adProvider = 'uniad',
    String adSource = 'app',
  }) async {
    return await _http.post('/api/ad/callback', data: {
      'ad_type': adType,
      'adpid': adpid,
      'ad_provider': adProvider,
      'ad_source': adSource,
    });
  }

  /// Record ad view
  static Future<Map<String, dynamic>> recordAdView({
    required String adType,
    required String adpid,
  }) async {
    return await _http.post('/api/ad/recordView', data: {
      'ad_type': adType,
      'adpid': adpid,
    });
  }

  /// Get ad overview
  static Future<Map<String, dynamic>> getAdOverview() async {
    return await _http.get('/api/ad/overview');
  }

  // ============ Signin ============

  /// Get signin index
  static Future<Map<String, dynamic>> getSigninIndex() async {
    return await _http.get('/api/signin/index');
  }

  /// Do signin
  static Future<Map<String, dynamic>> doSignin() async {
    return await _http.post('/api/signin/dosign');
  }

  // ============ Withdraw ============

  /// Get withdraw config
  static Future<Map<String, dynamic>> getWithdrawConfig() async {
    return await _http.get('/api/withdraw/config');
  }

  /// Apply withdraw
  static Future<Map<String, dynamic>> applyWithdraw({
    required int coinAmount,
    required String withdrawType,
    required String withdrawAccount,
    required String withdrawName,
  }) async {
    return await _http.post('/api/withdraw/apply', data: {
      'coin_amount': coinAmount,
      'withdraw_type': withdrawType,
      'withdraw_account': withdrawAccount,
      'withdraw_name': withdrawName,
    });
  }

  /// Get withdraw list
  static Future<Map<String, dynamic>> getWithdrawList({
    int page = 1,
    int limit = 20,
    String? status,
  }) async {
    final params = <String, dynamic>{'page': page, 'limit': limit};
    if (status != null) params['status'] = status;
    return await _http.get('/api/withdraw/list', queryParameters: params);
  }

  // ============ Upload ============

  /// Upload file
  static Future<Map<String, dynamic>> uploadFile(dynamic file) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: file.name),
    });
    return await _http.post('/api/common/upload', data: formData);
  }
}
