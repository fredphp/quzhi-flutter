import 'package:flutter/material.dart';
import 'package:quzhi_app/utils/theme.dart';

class ShareInviteModal extends StatelessWidget {
  final VoidCallback onClose;
  final String inviteCode;

  const ShareInviteModal({
    super.key,
    required this.onClose,
    required this.inviteCode,
  });

  static const _channels = [
    {'key': 'wechat', 'label': '微信好友', 'sub': '发送给朋友', 'color': Color(0xFF07C160)},
    {'key': 'moments', 'label': '朋友圈', 'sub': '分享到朋友圈', 'color': Color(0xFF07C160)},
    {'key': 'group', 'label': '微信群聊', 'sub': '发送到群组', 'color': Color(0xFF1AAD19)},
  ];

  @override
  Widget build(BuildContext context) {
    final inviteLink = 'https://quzhiapp.cn/invite?code=$inviteCode';

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
              bottom: 12,
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
                  onTap: onClose,
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
                const Text('邀请好友',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900)),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Reward banner
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFFF6B35),
                        Color(0xFFFFA726)
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.group, size: 36, color: Colors.white70),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('邀一人，双方各得 500 积分',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900)),
                            Text('好友注册时填写邀请码即可生效',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // QR code card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: AppTheme.cardDecoration(),
                  child: Column(
                    children: [
                      Container(
                        width: 176,
                        height: 176,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: CustomPaint(
                          painter: _QRCodePainter(inviteCode),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text('扫码立即注册，填写邀请码',
                          style: TextStyle(
                              color: Colors.grey[500], fontSize: 14)),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('邀请码 ',
                              style: TextStyle(
                                  color: Colors.grey[500], fontSize: 12)),
                          Text(inviteCode,
                              style: const TextStyle(
                                  color: AppTheme.gold,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2)),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.brand,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.copy,
                                    size: 12, color: Colors.white),
                                SizedBox(width: 4),
                                Text('复制码',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Share channels
                Text('分享给朋友',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[500])),
                const SizedBox(height: 12),
                ..._channels.map((ch) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [ch['color'] as Color, (ch['color'] as Color).withOpacity(0.8)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.chat,
                                  size: 24, color: Colors.white),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(ch['label'] as String,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900)),
                                  Text(ch['sub'] as String,
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.75),
                                          fontSize: 12)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text('去分享',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700)),
                            ),
                          ],
                        ),
                      ),
                    )),

                // Copy link
                Container(
                  decoration: AppTheme.cardDecoration(),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.copy,
                            size: 24, color: Colors.grey),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('复制邀请链接',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900)),
                            Text(inviteLink,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 12)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.brand,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('复制',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Share text
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('分享文案',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[500])),
                      const SizedBox(height: 8),
                      Text(
                        '🎉 我在用趣知App刷有趣内容还能赚积分，快来和我一起玩！\n'
                        '注册时填写我的邀请码 $inviteCode，我们各得500积分！\n'
                        '👉 $inviteLink',
                        style: const TextStyle(fontSize: 14, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QRCodePainter extends CustomPainter {
  final String code;

  _QRCodePainter(this.code);

  @override
  void paint(Canvas canvas, Size size) {
    final seed = code.split('').fold(0, (a, c) => a + c.codeUnitAt(0));
    final cellSize = size.width / 11;
    final paint = Paint()..color = const Color(0xFF1A1A1A);
    final bgPaint = Paint()..color = Colors.white;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Data cells
    for (int r = 0; r < 11; r++) {
      for (int c = 0; c < 11; c++) {
        final inTL = r < 4 && c < 4;
        final inTR = r < 4 && c > 6;
        final inBL = r > 6 && c < 4;
        if (inTL || inTR || inBL) continue;
        if ((seed * (r * 11 + c + 1) * 2654435761) % 3 != 0) {
          canvas.drawRect(
            Rect.fromLTWH(c * cellSize, r * cellSize, cellSize - 1, cellSize - 1),
            paint,
          );
        }
      }
    }

    // Position detection patterns
    _drawFinderPattern(canvas, 0, 0, cellSize);
    _drawFinderPattern(canvas, 7 * cellSize, 0, cellSize);
    _drawFinderPattern(canvas, 0, 7 * cellSize, cellSize);

    // Center logo
    final logoRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: 24,
      height: 24,
    );
    canvas.drawRect(logoRect, Paint()..color = Colors.white);
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: 20,
        height: 20,
      ),
      Paint()..color = AppTheme.brand,
    );
  }

  void _drawFinderPattern(Canvas canvas, double x, double y, double cellSize) {
    final paint = Paint()..color = const Color(0xFF1A1A1A);
    final whitePaint = Paint()..color = Colors.white;

    canvas.drawRect(Rect.fromLTWH(x, y, cellSize * 4, cellSize * 4), paint);
    canvas.drawRect(
        Rect.fromLTWH(x + cellSize * 0.4, y + cellSize * 0.4, cellSize * 3.2, cellSize * 3.2),
        whitePaint);
    canvas.drawRect(
        Rect.fromLTWH(x + cellSize * 0.9, y + cellSize * 0.9, cellSize * 2.2, cellSize * 2.2),
        paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
