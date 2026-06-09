import 'package:flutter/material.dart';
import 'package:quzhi_app/utils/theme.dart';
import 'package:quzhi_app/components/points_badge.dart';
import 'package:quzhi_app/components/share_invite_modal.dart';
import 'package:quzhi_app/api/api_service.dart';
import 'package:provider/provider.dart';
import 'package:quzhi_app/providers/app_provider.dart';

class PromotePage extends StatefulWidget {
  const PromotePage({super.key});

  @override
  State<PromotePage> createState() => _PromotePageState();
}

class _PromotePageState extends State<PromotePage> {
  bool _codeCopied = false;
  bool _showShare = false;
  bool _isLoading = true;
  String _inviteCode = '';
  int _inviteCount = 0;
  int _totalEarned = 0;

  static const _benefits = [
    {'icon': Icons.card_giftcard, 'color': 0xFFFF6B35, 'label': '成功邀请', 'desc': '双方各得 500 积分'},
    {'icon': Icons.trending_up, 'color': 0xFF667EEA, 'label': '无上限', 'desc': '邀请越多积分越多'},
    {'icon': Icons.verified_user, 'color': 0xFF11998E, 'label': '安全可靠', 'desc': '官方认证 实时结算'},
    {'icon': Icons.group, 'color': 0xFFFC466B, 'label': '团队奖励', 'desc': '邀请10人额外+2000'},
  ];

  static const _rules = [
    '受邀好友须为新用户，注册时填写您的邀请码方可生效',
    '好友完成注册后，双方各获得 500 积分，实时到账',
    '邀请奖励无上限，邀请越多积分越多',
    '每人仅可使用一个邀请码，不可重复使用',
    '如发现刷量等违规行为，平台有权扣除积分并封号',
  ];

  @override
  void initState() {
    super.initState();
    _loadInviteData();
  }

  Future<void> _loadInviteData() async {
    setState(() => _isLoading = true);
    try {
      // Load invite overview
      final overviewResult = await ApiService.getInviteOverview();
      final overviewData = overviewResult['data'] as Map<String, dynamic>? ?? overviewResult;
      _inviteCount = overviewData['invite_count'] ?? overviewData['inviteCount'] ?? 0;
      _totalEarned = overviewData['total_earned'] ?? overviewData['totalEarned'] ?? overviewData['total_coin'] ?? 0;

      // Load invite code
      final codeResult = await ApiService.getMyInviteCode();
      final codeData = codeResult['data'] as Map<String, dynamic>? ?? codeResult;
      _inviteCode = codeData['invite_code'] ?? codeData['inviteCode'] ?? codeData['code'] ?? '';

      setState(() => _isLoading = false);
    } catch (e) {
      // Fallback to userState data
      final userState = context.read<AppProvider>().userState;
      _inviteCode = userState.inviteCode;
      _inviteCount = userState.inviteCount;
      _totalEarned = _inviteCount * 500;
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = context.watch<AppProvider>().userState;

    return Stack(
      children: [
        Column(
          children: [
            // Header
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF6B35), Color(0xFFFFA726)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.only(top: 48, left: 16, right: 16, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.campaign, size: 24, color: Colors.white),
                      const SizedBox(width: 8),
                      const Text('推广赚积分',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w900)),
                      const Spacer(),
                      PointsBadge(
                        points: userState.points,
                        todayEarned: userState.todayEarned,
                        compact: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('邀请好友注册，双方各得500积分',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.8), fontSize: 14)),
                ],
              ),
            ),

            // Content
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        // Invite data card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: AppTheme.cardDecoration(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('已邀请好友',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey[500])),
                                  Text('$_inviteCount',
                                      style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w900,
                                          color: AppTheme.brand)),
                                  Text('累计获得 $_totalEarned 积分',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey[500])),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('我的邀请码',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey[500])),
                                  Text(_inviteCode,
                                      style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w900,
                                          color: AppTheme.gold,
                                          letterSpacing: 2)),
                                  const SizedBox(height: 6),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() => _codeCopied = true);
                                      Future.delayed(const Duration(seconds: 2),
                                          () {
                                        if (mounted)
                                          setState(() => _codeCopied = false);
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _codeCopied
                                            ? Colors.green
                                            : AppTheme.brand,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                              _codeCopied
                                                  ? Icons.check
                                                  : Icons.copy,
                                              size: 12,
                                              color: Colors.white),
                                          const SizedBox(width: 4),
                                          Text(
                                              _codeCopied ? '已复制' : '复制码',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Share button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () => setState(() => _showShare = true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.brand,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                            ),
                            child: const Text('📤 分享邀请链接',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w900)),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Benefits
                        Container(
                          decoration: AppTheme.cardDecoration(),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    const Icon(Icons.card_giftcard,
                                        size: 20, color: AppTheme.brand),
                                    const SizedBox(width: 8),
                                    const Text('推广大使权益',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w900)),
                                  ],
                                ),
                              ),
                              const Divider(height: 1),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          for (var i = 0; i < _benefits.length; i++)
                                            if (i % 2 == 0)
                                              _BenefitCard(benefit: _benefits[i]),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          for (var i = 0; i < _benefits.length; i++)
                                            if (i % 2 != 0)
                                              _BenefitCard(benefit: _benefits[i]),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Rules
                        Container(
                          decoration: AppTheme.cardDecoration(),
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(16),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('活动规则',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900)),
                                ),
                              ),
                              const Divider(height: 1),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: _rules.asMap().entries.map((e) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 20,
                                            height: 20,
                                            decoration: const BoxDecoration(
                                              color: AppTheme.brand,
                                              shape: BoxShape.circle,
                                            ),
                                            alignment: Alignment.center,
                                            child: Text('${e.key + 1}',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w900)),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(e.value,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey[500],
                                                    height: 1.4)),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 120),
                      ],
                    ),
            ),
          ],
        ),

        // Share modal
        if (_showShare)
          ShareInviteModal(
            inviteCode: _inviteCode,
            onClose: () => setState(() => _showShare = false),
          ),
      ],
    );
  }
}

class _BenefitCard extends StatelessWidget {
  final Map<String, dynamic> benefit;

  const _BenefitCard({required this.benefit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(benefit['color'] as int).withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(benefit['icon'] as IconData,
                size: 20, color: Color(benefit['color'] as int)),
          ),
          const SizedBox(height: 6),
          Text(benefit['label'] as String,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(benefit['desc'] as String,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                  height: 1.2)),
        ],
      ),
    );
  }
}
