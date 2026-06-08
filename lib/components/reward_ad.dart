import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quzhi_app/utils/theme.dart';

class RewardAd extends StatefulWidget {
  final VoidCallback onClose;
  final int pointsEarned;

  const RewardAd({
    super.key,
    required this.onClose,
    this.pointsEarned = 500,
  });

  @override
  State<RewardAd> createState() => _RewardAdState();
}

class _RewardAdState extends State<RewardAd> {
  String _phase = 'watching';
  int _countdown = 15;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdown--;
      });
      if (_countdown <= 0) {
        timer.cancel();
        setState(() => _phase = 'reward');
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
    return Container(
      color: Colors.black.withOpacity(0.85),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          clipBehavior: Clip.antiAlias,
          child: _phase == 'watching' ? _buildWatching() : _buildReward(),
        ),
      ),
    );
  }

  Widget _buildWatching() {
    final progress = ((15 - _countdown) / 15).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(40),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text('$_countdown',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.play_circle_fill,
                size: 48, color: AppTheme.gold),
          ),
          const SizedBox(height: 24),
          const Text('激励视频广告',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text('看完视频即可领取大额积分',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.6), fontSize: 14)),
          const SizedBox(height: 24),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.brand),
            ),
          ),
          const SizedBox(height: 8),
          Text('剩余 $_countdown 秒',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.4), fontSize: 12)),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.gold.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.monetization_on,
                    size: 16, color: AppTheme.gold),
                const SizedBox(width: 8),
                Text('奖励 +${widget.pointsEarned} 积分',
                    style: const TextStyle(
                        color: AppTheme.gold,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReward() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF5A623), Color(0xFFFF6B35)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.monetization_on,
                size: 48, color: Colors.white),
          ),
          const SizedBox(height: 24),
          const Text('恭喜获得积分！',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          Text('+${widget.pointsEarned}',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text('积分已自动添加到账户',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.8), fontSize: 14)),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: widget.onClose,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppTheme.brand,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
              ),
              child: const Text('领取并关闭',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
