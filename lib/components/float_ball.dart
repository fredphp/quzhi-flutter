import 'package:flutter/material.dart';
import 'package:quzhi_app/utils/theme.dart';

class FloatBall extends StatelessWidget {
  final int rewardCount;
  final bool canTrigger;
  final VoidCallback onClick;

  const FloatBall({
    super.key,
    required this.rewardCount,
    required this.canTrigger,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    final isReady = canTrigger && rewardCount > 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Badge count
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 4,
                  offset: const Offset(0, 2)),
            ],
          ),
          alignment: Alignment.center,
          child: Text('$rewardCount',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: 4),
        // Main ball
        GestureDetector(
          onTap: isReady ? onClick : null,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: isReady
                  ? AppTheme.goldGradient
                  : const LinearGradient(
                      colors: [Color(0xFFAAAAAA), Color(0xFFCCCCCC)]),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4)),
              ],
            ),
            child: isReady
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.play_circle_fill,
                          size: 20, color: Colors.white),
                      Text('+500',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700)),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.monetization_on,
                          size: 20, color: Colors.white70),
                      Text('等待',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 9,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 2),
        Text('积分',
            style: TextStyle(
                fontSize: 10,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500)),
      ],
    );
  }
}
