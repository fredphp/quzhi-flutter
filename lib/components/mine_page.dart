import 'package:flutter/material.dart';
import 'package:quzhi_app/utils/theme.dart';
import 'package:quzhi_app/components/points_badge.dart';
import 'package:quzhi_app/components/address_page.dart';
import 'package:quzhi_app/components/agreement_page.dart';
import 'package:provider/provider.dart';
import 'package:quzhi_app/providers/app_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  bool _showAddress = false;
  String? _showAgreement;
  bool _isLoggingOut = false;

  Future<void> _logout() async {
    setState(() => _isLoggingOut = true);
    await context.read<AppProvider>().logout();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> _deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('确认注销'),
        content: const Text('注销账号后数据将无法恢复，确定要注销吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
            ),
            child: const Text('确认注销'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = context.watch<AppProvider>().userState;

    return Stack(
      children: [
        ListView(
          padding: EdgeInsets.zero,
          children: [
            // Profile header
            Container(
              padding: const EdgeInsets.only(top: 56, left: 16, right: 16, bottom: 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF6B35), Color(0xFFFFA726), Color(0xFFFFD166)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  // Decorative circles
                  Positioned(
                    right: -40,
                    top: -40,
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 40,
                    top: 64,
                    child: Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(32),
                                child: CachedNetworkImage(
                                  imageUrl: userState.avatar,
                                  width: 64,
                                  height: 64,
                                  fit: BoxFit.cover,
                                  placeholder: (_, __) => Container(
                                    width: 64,
                                    height: 64,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.person, size: 32, color: Colors.white),
                                  ),
                                  errorWidget: (_, __, ___) => Container(
                                    width: 64,
                                    height: 64,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.person, size: 32),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.green[400],
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(userState.nickname.isNotEmpty ? userState.nickname : '未设置昵称',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900)),
                                Text('ID: ${userState.uid}',
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 12)),
                                const SizedBox(height: 8),
                                PointsBadge(
                                  points: userState.points,
                                  todayEarned: userState.todayEarned,
                                  compact: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Invite code
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('我的邀请码',
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 12)),
                                Text(userState.inviteCode.isNotEmpty ? userState.inviteCode : '-',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 3)),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.copy,
                                      size: 12, color: Colors.white),
                                  SizedBox(width: 4),
                                  Text('复制',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Points overview
            Transform.translate(
              offset: const Offset(0, -16),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: AppTheme.cardDecoration(),
                child: Row(
                  children: [
                    _StatItem(
                        label: '我的积分',
                        value: '${userState.points}',
                        unit: '分'),
                    _StatItem(
                        label: '今日获得',
                        value: '+${userState.todayEarned}',
                        unit: '分'),
                    _StatItem(
                        label: '已邀请',
                        value: '${userState.inviteCount}',
                        unit: '人'),
                  ],
                ),
              ),
            ),

            // Ad points section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: AppTheme.cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('📺 今日可获积分',
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _AdPointsCard(
                          label: '插屏广告',
                          pts: '+50',
                          desc: '每5分钟一次',
                          color: Colors.purple),
                      const SizedBox(width: 8),
                      _AdPointsCard(
                          label: '激励广告',
                          pts: '+500',
                          desc: '剩余10次',
                          color: AppTheme.brand),
                      const SizedBox(width: 8),
                      _AdPointsCard(
                          label: 'Banner广告',
                          pts: '+10',
                          desc: '自动计算',
                          color: Colors.blue),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Menu groups
            _buildMenuGroup('账户管理', [
              _MenuItem(icon: Icons.monetization_on, label: '积分明细', color: AppTheme.gold),
              _MenuItem(icon: Icons.shopping_bag, label: '兑换记录', color: Colors.blue),
              _MenuItem(icon: Icons.favorite, label: '我的收藏', color: Colors.red),
            ]),
            _buildMenuGroup('推广中心', [
              _MenuItem(icon: Icons.share, label: '邀请好友', value: '邀请${userState.inviteCount}人', color: Colors.purple),
              _MenuItem(icon: Icons.card_giftcard, label: '奖励活动', value: '新活动', color: AppTheme.brand),
              _MenuItem(icon: Icons.trending_up, label: '推广数据', color: Colors.green),
            ]),
            _buildMenuGroup('其他', [
              _MenuItem(
                  icon: Icons.map, label: '收货地址', color: Colors.green,
                  onTap: () => setState(() => _showAddress = true)),
              _MenuItem(icon: Icons.help, label: '帮助中心', color: Colors.blue),
              _MenuItem(icon: Icons.settings, label: '设置', color: Colors.grey),
            ]),
            _buildMenuGroup('法律条款', [
              _MenuItem(
                  icon: Icons.shield, label: '隐私协议', color: Colors.blue,
                  onTap: () => setState(() => _showAgreement = 'privacy')),
              _MenuItem(
                  icon: Icons.description, label: '用户协议', color: Colors.blue,
                  onTap: () => setState(() => _showAgreement = 'terms')),
            ]),

            const SizedBox(height: 16),

            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  OutlinedButton(
                    onPressed: _isLoggingOut ? null : _deleteAccount,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      side: const BorderSide(
                          color: Color(0xFFEF4444), width: 0.5),
                      foregroundColor: const Color(0xFFEF4444),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: _isLoggingOut
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFEF4444)))
                        : const Text('注销账号',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 14)),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: _isLoggingOut ? null : _logout,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      side: BorderSide(color: Colors.grey[300]!),
                      foregroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('退出登录',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),

        // Address overlay
        if (_showAddress)
          AddressPage(onBack: () => setState(() => _showAddress = false)),

        // Agreement overlay
        if (_showAgreement != null)
          AgreementPage(
            type: _showAgreement!,
            onBack: () => setState(() => _showAgreement = null),
          ),
      ],
    );
  }

  Widget _buildMenuGroup(String title, List<_MenuItem> items) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(title,
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500)),
          ),
          ...items.asMap().entries.map((e) {
            final item = e.value;
            final isLast = e.key == items.length - 1;
            return Column(
              children: [
                GestureDetector(
                  onTap: item.onTap,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(item.icon,
                              size: 16, color: item.color),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(item.label,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500)),
                        ),
                        if (item.value != null)
                          Text(item.value!,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.brand,
                                  fontWeight: FontWeight.w500)),
                        const SizedBox(width: 4),
                        const Icon(Icons.chevron_right,
                            size: 16, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                if (!isLast)
                  const Padding(
                    padding: EdgeInsets.only(left: 60),
                    child: Divider(height: 1),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const _StatItem({required this.label, required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              text: value,
              style: const TextStyle(
                  color: AppTheme.brand,
                  fontSize: 18,
                  fontWeight: FontWeight.w900),
              children: [
                TextSpan(
                  text: unit,
                  style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                  color: Colors.grey[500], fontSize: 12)),
        ],
      ),
    );
  }
}

class _AdPointsCard extends StatelessWidget {
  final String label;
  final String pts;
  final String desc;
  final Color color;

  const _AdPointsCard({
    required this.label,
    required this.pts,
    required this.desc,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(pts,
                style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.w900)),
            Text(label,
                style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
            Text(desc,
                style: TextStyle(
                    color: color.withOpacity(0.7), fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final String? value;
  final Color color;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    this.value,
    required this.color,
    this.onTap,
  });
}
