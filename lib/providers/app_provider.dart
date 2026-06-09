import 'package:flutter/material.dart';
import 'package:quzhi_app/models/app_models.dart';
import 'package:quzhi_app/api/api_service.dart';
import 'package:quzhi_app/api/http_client.dart';

class AppProvider extends ChangeNotifier {
  TabKey _activeTab = TabKey.home;
  TabKey get activeTab => _activeTab;

  UserState _userState = const UserState();
  UserState get userState => _userState;

  AdState _adState = const AdState();
  AdState get adState => _adState;

  bool _showInterstitial = false;
  bool get showInterstitial => _showInterstitial;

  bool _showReward = false;
  bool get showReward => _showReward;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ContentItem? _selectedItem;
  ContentItem? get selectedItem => _selectedItem;

  bool _showNotification = false;
  bool get showNotification => _showNotification;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  static const int interstitialInterval = 5 * 60 * 1000;
  static const int interstitialMaxDaily = 8;
  static const int rewardInterval = 30 * 60 * 1000;
  static const int rewardDailyMax = 10;
  static const int bannerMinInterval = 60 * 1000;
  static const int pointsPerInterstitial = 50;
  static const int pointsPerReward = 500;
  static const int pointsPerBanner = 10;

  void setActiveTab(TabKey tab) {
    _activeTab = tab;
    _selectedItem = null;
    notifyListeners();
  }

  /// Login with mobile + captcha via real API
  Future<bool> login(String mobile, String captcha) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await ApiService.mobileLogin(
        mobile: mobile,
        captcha: captcha,
      );
      final data = result['data'] as Map<String, dynamic>? ?? result;
      // Save token and userId
      final token = data['token']?.toString() ?? data['userinfo']?['token']?.toString();
      final userId = data['user_id'] ?? data['userinfo']?['id'];
      if (token != null && token.isNotEmpty) {
        await HttpClient().setToken(token);
      }
      if (userId != null) {
        await HttpClient().setUserId(userId is int ? userId : int.tryParse(userId.toString()) ?? 0);
      }
      _isLoggedIn = true;
      // Auto-load user info after login
      await loadUserInfo();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('ApiException(', '').replaceAll('): ', ': ').replaceAll(')', '');
      notifyListeners();
      return false;
    }
  }

  /// Load user info from API
  Future<void> loadUserInfo() async {
    try {
      final result = await ApiService.getUserInfo();
      final data = result['data'] as Map<String, dynamic>? ?? result;
      _userState = UserState.fromJson(data);
      notifyListeners();
    } catch (e) {
      debugPrint('loadUserInfo error: $e');
    }
  }

  /// Logout via real API
  Future<void> logout() async {
    try {
      await ApiService.logout();
    } catch (e) {
      // Even if API call fails, clear local state
      debugPrint('logout API error: $e');
    }
    await HttpClient().clearToken();
    _isLoggedIn = false;
    _userState = const UserState();
    notifyListeners();
  }

  /// Check if user is already logged in (from saved token)
  Future<bool> checkLogin() async {
    final loggedIn = await HttpClient().isLoggedIn();
    if (loggedIn) {
      _isLoggedIn = true;
      notifyListeners();
      await loadUserInfo();
    }
    return loggedIn;
  }

  void selectItem(ContentItem item) {
    _selectedItem = item;
    notifyListeners();
  }

  void clearSelectedItem() {
    _selectedItem = null;
    notifyListeners();
  }

  void setShowNotification(bool val) {
    _showNotification = val;
    notifyListeners();
  }

  void addPoints(int pts) {
    _userState = _userState.copyWith(
      points: _userState.points + pts,
      todayEarned: _userState.todayEarned + pts,
    );
    notifyListeners();
  }

  void triggerInterstitial() {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (_adState.interstitialCount < interstitialMaxDaily &&
        now - _adState.lastInterstitialTime >= interstitialInterval) {
      _showInterstitial = true;
      _adState = _adState.copyWith(
        interstitialCount: _adState.interstitialCount + 1,
        lastInterstitialTime: now,
      );
      notifyListeners();
    }
  }

  void closeInterstitial() {
    _showInterstitial = false;
    addPoints(pointsPerInterstitial);
    notifyListeners();
  }

  void triggerReward() {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (_adState.rewardCount <= 0) return;
    if (now - _adState.lastRewardTime < rewardInterval) return;
    _showReward = true;
    _adState = _adState.copyWith(
      rewardCount: _adState.rewardCount - 1,
      lastRewardTime: now,
    );
    notifyListeners();
  }

  void closeReward() {
    _showReward = false;
    addPoints(pointsPerReward);
    notifyListeners();
  }

  void onBannerView() {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - _adState.lastBannerTime >= bannerMinInterval) {
      _adState = _adState.copyWith(lastBannerTime: now);
      addPoints(pointsPerBanner);
    }
  }

  /// Record ad view via API
  Future<void> recordAdView({required String adType, required String adpid}) async {
    try {
      await ApiService.recordAdView(adType: adType, adpid: adpid);
    } catch (e) {
      debugPrint('recordAdView error: $e');
    }
  }

  /// Ad callback via API
  Future<void> adCallback({
    required String adType,
    required String adpid,
    String adProvider = 'uniad',
    String adSource = 'app',
  }) async {
    try {
      await ApiService.adCallback(
        adType: adType,
        adpid: adpid,
        adProvider: adProvider,
        adSource: adSource,
      );
    } catch (e) {
      debugPrint('adCallback error: $e');
    }
  }
}
