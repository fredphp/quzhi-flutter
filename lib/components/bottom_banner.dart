import 'package:flutter/material.dart';
import 'package:quzhi_app/utils/theme.dart';

class BottomBanner extends StatelessWidget {
  final VoidCallback onView;

  const BottomBanner({super.key, required this.onView});

  static const _ads = [
    {'bg': [Color(0xFFFF6B35), Color(0xFFFFA726)], 'text': '🔥 限时特惠 全场8折', 'cta': '立即查看'},
    {'bg': [Color(0xFF667EEA), Color(0xFF764BA2)], 'text': '⭐ 邀请好友 共赚积分', 'cta': '去邀请'},
    {'bg': [Color(0xFF11998E), Color(0xFF38EF7D)], 'text': '🎁 新人专属礼包 领取啦', 'cta': '领取'},
  ];

  @override
  Widget build(BuildContext context) {
    final ad = _ads[DateTime.now().millisecond % _ads.length];

    return GestureDetector(
      onTap: onView,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 20),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(ad['text'] as String,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700)),
                  Text('点击了解详情',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.75),
                          fontSize: 11)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(ad['cta'] as String,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}
