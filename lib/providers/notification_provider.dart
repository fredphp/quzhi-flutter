import 'package:flutter/material.dart';
import 'package:quzhi_app/models/app_models.dart';
import 'package:quzhi_app/api/api_service.dart';

class NotificationProvider extends ChangeNotifier {
  List<AppNotification> _notifications = [];
  List<AppNotification> get notifications => _notifications;

  int _unreadCount = 0;
  int get unreadCount => _unreadCount;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Load notifications from API
  Future<void> loadNotifications({int page = 1}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await ApiService.getMessageList(page: page);
      final data = result['data'] as Map<String, dynamic>? ?? result;
      final list = data['list'] as List<dynamic>? ?? data['rows'] as List<dynamic>? ?? [];
      if (page == 1) {
        _notifications = list.map((e) => AppNotification.fromJson(e as Map<String, dynamic>)).toList();
      } else {
        _notifications.addAll(list.map((e) => AppNotification.fromJson(e as Map<String, dynamic>)).toList());
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Load unread count from API
  Future<void> loadUnreadCount() async {
    try {
      final result = await ApiService.getUnreadCount();
      final data = result['data'] as Map<String, dynamic>? ?? result;
      _unreadCount = data['count'] ?? data['unread_count'] ?? data['unreadCount'] ?? 0;
      notifyListeners();
    } catch (e) {
      debugPrint('loadUnreadCount error: $e');
    }
  }

  /// Mark a single notification as read via API
  Future<void> markRead(String id) async {
    try {
      await ApiService.markMessageRead(messageId: int.tryParse(id) ?? 0);
      _notifications = _notifications.map((n) {
        if (n.id == id) return n.copyWith(read: true);
        return n;
      }).toList();
      if (_unreadCount > 0) _unreadCount--;
      notifyListeners();
    } catch (e) {
      debugPrint('markRead error: $e');
    }
  }

  /// Mark all notifications as read via API
  Future<void> markAllRead() async {
    try {
      await ApiService.markMessageRead(messageId: 0);
      _notifications = _notifications.map((n) => n.copyWith(read: true)).toList();
      _unreadCount = 0;
      notifyListeners();
    } catch (e) {
      debugPrint('markAllRead error: $e');
    }
  }
}
