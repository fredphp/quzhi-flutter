import 'package:flutter/material.dart';
import 'package:quzhi_app/utils/theme.dart';

class BannerAd extends StatelessWidget {
  final VoidCallback onView;
  final String variant;

  const BannerAd({
    super.key,
    required this.onView,
    this.variant = 'inline',
  });

  static const _ads = [
    {'bg': [Color(0xFF667EEA), Color(0xFF764BA2)], 'text': '🎯 精准推荐 — 发现好物', 'sub': '点击了解更多'},
    {'bg': [Color(0xFFF5A623), Color(0xFFFF6B35)], 'text': '🏆 积分商城火热开放', 'sub': '积分换好礼'},
    {'bg': [Color(0xFF11998E), Color(0xFF38EF7D)], 'text': '📱 全新APP上线', 'sub': '下载立领200积分'},
  ];

  @override
  Widget build(BuildContext context) {
    final ad = _ads[DateTime.now().millisecond % _ads.length];
    // Trigger onView after a short delay
    Future.microtask(() => onView());

    return GestureDetector(
      onTap: onView,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: ad['bg'] as List<Color>,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ad['text'] as String,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(ad['sub'] as String,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.75),
                          fontSize: 12)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('查看',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}
