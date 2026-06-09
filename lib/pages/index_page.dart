import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quzhi_app/providers/app_provider.dart';
import 'package:quzhi_app/models/app_models.dart';
import 'package:quzhi_app/components/home_page.dart';
import 'package:quzhi_app/components/mall_page.dart';
import 'package:quzhi_app/components/promote_page.dart';
import 'package:quzhi_app/components/mine_page.dart';
import 'package:quzhi_app/components/bottom_tab.dart';
import 'package:quzhi_app/components/float_ball.dart';
import 'package:quzhi_app/components/interstitial_ad.dart';
import 'package:quzhi_app/components/reward_ad.dart';
import 'package:quzhi_app/components/bottom_banner.dart';
import 'package:quzhi_app/components/detail_page.dart';
import 'package:quzhi_app/components/notification_page.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  void initState() {
    super.initState();
    // Trigger first interstitial after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        context.read<AppProvider>().triggerInterstitial();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    if (!provider.isLoggedIn) {
      // Redirect handled by routing
    }

    return Scaffold(
      body: Stack(
        children: [
          // Main tab pages
          if (provider.activeTab == TabKey.home)
            const HomePage()
          else if (provider.activeTab == TabKey.mall)
            const MallPage()
          else if (provider.activeTab == TabKey.promote)
            const PromotePage()
          else if (provider.activeTab == TabKey.mine)
            const MinePage(),

          // Bottom banner (above bottom tab)
          Positioned(
            left: 0,
            right: 0,
            bottom: 56,
            child: BottomBanner(
              onView: () => provider.onBannerView(),
            ),
          ),

          // Bottom tab
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomTab(
              activeTab: provider.activeTab,
              onTabChange: (tab) => provider.setActiveTab(tab),
            ),
          ),

          // Float ball
          Positioned(
            right: 16,
            bottom: 124,
            child: FloatBall(
              rewardCount: provider.adState.rewardCount,
              canTrigger: provider.adState.rewardCount > 0,
              onClick: () => provider.triggerReward(),
            ),
          ),

          // Detail page overlay
          if (provider.selectedItem != null)
            Positioned.fill(
              child: DetailPage(
                item: provider.selectedItem!,
                onBack: () => provider.clearSelectedItem(),
              ),
            ),

          // Notification page overlay
          if (provider.showNotification)
            Positioned.fill(
              child: NotificationPage(
                onClose: () => provider.setShowNotification(false),
              ),
            ),

          // Interstitial ad
          if (provider.showInterstitial)
            InterstitialAd(
              onClose: () => provider.closeInterstitial(),
              pointsEarned: AppProvider.pointsPerInterstitial,
            ),

          // Reward ad
          if (provider.showReward)
            RewardAd(
              onClose: () => provider.closeReward(),
              pointsEarned: AppProvider.pointsPerReward,
            ),
        ],
      ),
    );
  }
}
