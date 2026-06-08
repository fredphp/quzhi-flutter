import 'package:flutter/material.dart';
import 'package:quzhi_app/models/app_models.dart';

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

  ContentItem? _selectedItem;
  ContentItem? get selectedItem => _selectedItem;

  bool _showNotification = false;
  bool get showNotification => _showNotification;

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

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
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
}
