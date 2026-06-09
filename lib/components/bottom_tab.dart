import 'package:flutter/material.dart';
import 'package:quzhi_app/models/app_models.dart';
import 'package:quzhi_app/utils/theme.dart';

class BottomTab extends StatelessWidget {
  final TabKey activeTab;
  final ValueChanged<TabKey> onTabChange;

  const BottomTab({
    super.key,
    required this.activeTab,
    required this.onTabChange,
  });

  static const _tabs = [
    TabKey.home,
    TabKey.mall,
    TabKey.promote,
    TabKey.mine,
  ];

  static const _labels = {
    TabKey.home: '首页',
    TabKey.mall: '福利商城',
    TabKey.promote: '推广',
    TabKey.mine: '我的',
  };

  static const _icons = {
    TabKey.home: Icons.home,
    TabKey.mall: Icons.shopping_bag,
    TabKey.promote: Icons.share,
    TabKey.mine: Icons.person,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!, width: 0.5)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom,
      ),
      child: Row(
        children: _tabs.map((tab) {
          final isActive = activeTab == tab;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTabChange(tab),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _icons[tab],
                      size: 22,
                      color: isActive ? AppTheme.brand : const Color(0xFF9CA3AF),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _labels[tab]!,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: isActive ? AppTheme.brand : const Color(0xFF9CA3AF),
                      ),
                    ),
                    if (isActive)
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: AppTheme.brand,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
