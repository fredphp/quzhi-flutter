import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quzhi_app/utils/theme.dart';

class InterstitialAd extends StatefulWidget {
  final VoidCallback onClose;
  final int pointsEarned;

  const InterstitialAd({
    super.key,
    required this.onClose,
    this.pointsEarned = 50,
  });

  @override
  State<InterstitialAd> createState() => _InterstitialAdState();
}

class _InterstitialAdState extends State<InterstitialAd> {
  int _countdown = 5;
  Timer? _timer;

  static const _ads = [
    {
      'bg': [Color(0xFF667EEA), Color(0xFF764BA2)],
      'title': '省钱达人必备',
      'subtitle': '优惠券平台 每天省百元',
      'cta': '立即领取',
      'badge': '插屏广告',
    },
    {
      'bg': [Color(0xFFF093FB), Color(0xFFF5576C)],
      'title': '全网最低价手机',
      'subtitle': '限时特惠 直降1000元',
      'cta': '抢购',
      'badge': '精选推广',
    },
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdown--;
      });
      if (_countdown <= 0) {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _ads[DateTime.now().millisecond % _ads.length];

    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ad content
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: ad['bg'] as List<Color>,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    // Badge
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(ad['badge'] as String,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 10)),
                      ),
                    ),
                    // Points indicator
                    Positioned(
                      top: 0,
                      right: 48,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.gold.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.monetization_on,
                                size: 12, color: Colors.white),
                            Text('+${widget.pointsEarned} 积分',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10)),
                          ],
                        ),
                      ),
                    ),
                    // Close button
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _countdown <= 0 ? widget.onClose : null,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: _countdown <= 0
                                ? Colors.white.withOpacity(0.3)
                                : Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: _countdown > 0
                              ? Text('$_countdown',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700))
                              : const Icon(Icons.close,
                                  size: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    // Main content
                    Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Column(
                        children: [
                          const Text('📱', style: TextStyle(fontSize: 40)),
                          const SizedBox(height: 24),
                          Text(ad['title'] as String,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(height: 8),
                          Text(ad['subtitle'] as String,
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14)),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.purple,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 12),
                            ),
                            child: Text(ad['cta'] as String,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 16)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Bottom
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('观看广告即可获得积分奖励',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey[500])),
                    GestureDetector(
                      onTap: _countdown <= 0 ? widget.onClose : null,
                      child: Text(
                        _countdown > 0
                            ? '$_countdown s后关闭'
                            : '关闭',
                        style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.brand,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
