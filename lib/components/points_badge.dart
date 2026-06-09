import 'package:flutter/material.dart';
import 'package:quzhi_app/utils/theme.dart';

class PointsBadge extends StatelessWidget {
  final int points;
  final int todayEarned;
  final bool compact;

  const PointsBadge({
    super.key,
    required this.points,
    this.todayEarned = 0,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.monetization_on, size: 16, color: Color(0xFFFFD54F)),
            const SizedBox(width: 4),
            Text(
              points.toString(),
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14),
            ),
            const SizedBox(width: 2),
            Text('分',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.7), fontSize: 12)),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.goldGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.monetization_on,
                    size: 20, color: Colors.white),
                const SizedBox(width: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      points.toString(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 16),
                    ),
                    Text('我的积分',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 10)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                Text('+$todayEarned',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 12)),
                Text('今日',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.7), fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
