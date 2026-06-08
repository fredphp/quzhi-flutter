import 'package:flutter/material.dart';
import 'package:quzhi_app/models/app_models.dart';
import 'package:quzhi_app/data/mock_data.dart';

class NotificationProvider extends ChangeNotifier {
  List<AppNotification> _notifications = List.from(NOTIFICATIONS);
  List<AppNotification> get notifications => _notifications;

  int get unreadCount => _notifications.where((n) => !n.read).length;

  void markRead(String id) {
    _notifications = _notifications.map((n) {
      if (n.id == id) return n.copyWith(read: true);
      return n;
    }).toList();
    notifyListeners();
  }

  void markAllRead() {
    _notifications = _notifications.map((n) => n.copyWith(read: true)).toList();
    notifyListeners();
  }
}
