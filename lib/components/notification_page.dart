import 'package:flutter/material.dart';
import 'package:quzhi_app/utils/theme.dart';
import 'package:quzhi_app/models/app_models.dart';
import 'package:quzhi_app/providers/notification_provider.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  final VoidCallback onClose;

  const NotificationPage({super.key, required this.onClose});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  static const _typeConfig = {
    'points': {'icon': Icons.star, 'bg': Color(0xFFFFF9C4), 'color': Color(0xFFF9A825)},
    'invite': {'icon': Icons.person_add, 'bg': Color(0xFFE8F5E9), 'color': Color(0xFF4CAF50)},
    'system': {'icon': Icons.info, 'bg': Color(0xFFE3F2FD), 'color': Color(0xFF2196F3)},
    'reward': {'icon': Icons.card_giftcard, 'bg': Color(0xFFFFF3E0), 'color': Color(0xFFFF9800)},
    'achievement': {'icon': Icons.emoji_events, 'bg': Color(0xFFF3E5F5), 'color': Color(0xFF9C27B0)},
  };

  @override
  void initState() {
    super.initState();
    // Load notifications when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().loadNotifications();
      context.read<NotificationProvider>().loadUnreadCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();
    final notifications = provider.notifications;
    final unreadCount = provider.unreadCount;

    return Container(
      color: const Color(0xFFFAFAFA),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF6B35), Color(0xFFFFA726)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: widget.onClose,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.arrow_back,
                        size: 20, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.notifications,
                    size: 20, color: Colors.white),
                const SizedBox(width: 8),
                const Text('消息通知',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900)),
                if (unreadCount > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      unreadCount > 9 ? '9+' : '$unreadCount',
                      style: const TextStyle(
                          color: AppTheme.brand,
                          fontSize: 10,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                ],
                const Spacer(),
                GestureDetector(
                  onTap: () => provider.markAllRead(),
                  child: Text('全部已读',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),

          // Notification list
          Expanded(
            child: provider.isLoading && notifications.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => provider.loadNotifications(),
                    child: notifications.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.notifications,
                                    size: 64,
                                    color: Colors.grey.withOpacity(0.3)),
                                const SizedBox(height: 16),
                                Text('暂无消息',
                                    style: TextStyle(
                                        color: Colors.grey[500], fontSize: 14)),
                              ],
                            ),
                          )
                        : ListView.separated(
                            itemCount: notifications.length,
                            separatorBuilder: (_, __) => Divider(
                                height: 1,
                                indent: 72,
                                endIndent: 16,
                                color: Colors.grey[200]!),
                            itemBuilder: (_, idx) {
                              final n = notifications[idx];
                              final cfg = _typeConfig[n.type] ??
                                  _typeConfig['system']!;
                              return GestureDetector(
                                onTap: () => provider.markRead(n.id),
                                child: Container(
                                  color: n.read
                                      ? null
                                      : const Color(0xFFFFF8F0),
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: cfg['bg'] as Color,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(cfg['icon'] as IconData,
                                            size: 20,
                                            color: cfg['color'] as Color),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(n.title,
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight
                                                                  .w700)),
                                                ),
                                                if (!n.read)
                                                  Container(
                                                    width: 8,
                                                    height: 8,
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: AppTheme.brand,
                                                      shape:
                                                          BoxShape.circle,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(n.body,
                                                maxLines: 2,
                                                overflow:
                                                    TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey[500],
                                                    height: 1.4)),
                                            const SizedBox(height: 6),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(n.time,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            Colors.grey[500])),
                                                if (n.points != null)
                                                  Container(
                                                    padding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 8,
                                                            vertical: 2),
                                                    decoration: BoxDecoration(
                                                        color: AppTheme
                                                            .goldLight,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12)),
                                                    child: Text(
                                                        '+${n.points} 积分',
                                                        style:
                                                            const TextStyle(
                                                                color: AppTheme
                                                                    .gold,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700)),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                ),
          ),
        ],
      ),
    );
  }
}
