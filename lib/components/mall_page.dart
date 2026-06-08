import 'package:flutter/material.dart';
import 'package:quzhi_app/models/app_models.dart';
import 'package:quzhi_app/data/mock_data.dart';
import 'package:quzhi_app/utils/theme.dart';
import 'package:quzhi_app/components/points_badge.dart';
import 'package:quzhi_app/components/banner_ad.dart';
import 'package:provider/provider.dart';
import 'package:quzhi_app/providers/app_provider.dart';

class MallPage extends StatefulWidget {
  const MallPage({super.key});

  @override
  State<MallPage> createState() => _MallPageState();
}

class _MallPageState extends State<MallPage> {
  String _activeFilter = '全部';

  List<MallProduct> get _filteredProducts {
    if (_activeFilter == '全部') return MALL_PRODUCTS;
    return MALL_PRODUCTS.where((p) => p.tag == _activeFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final userState = context.watch<AppProvider>().userState;
    final products = _filteredProducts;
    final leftCol = <MallProduct>[];
    final rightCol = <MallProduct>[];
    for (var i = 0; i < products.length; i++) {
      if (i % 2 == 0) {
        leftCol.add(products[i]);
      } else {
        rightCol.add(products[i]);
      }
    }

    return Column(
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
          padding: const EdgeInsets.only(top: 48, left: 16, right: 16, bottom: 12),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.shopping_bag,
                      size: 24, color: Colors.white),
                  const SizedBox(width: 8),
                  const Text('福利商城',
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
              const SizedBox(height: 12),
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: MALL_FILTERS.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, idx) {
                    final f = MALL_FILTERS[idx];
                    final isActive = _activeFilter == f;
                    return GestureDetector(
                      onTap: () => setState(() => _activeFilter = f),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: isActive
                              ? Colors.white
                              : Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(f,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color:
                                  isActive ? AppTheme.brand : Colors.white,
                            )),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        // Info bar
        Container(
          color: const Color(0xFFFFF3E0),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.info, size: 16, color: AppTheme.brand),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '积分可通过阅读文章、观看广告、邀请好友获得；积分永久有效',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ),
            ],
          ),
        ),

        // Banner
        BannerAd(onView: () => context.read<AppProvider>().onBannerView()),

        // Products grid
        Expanded(
          child: products.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_bag,
                          size: 56, color: Colors.grey.withOpacity(0.3)),
                      const SizedBox(height: 12),
                      Text('该分类暂无商品',
                          style: TextStyle(
                              color: Colors.grey[500], fontSize: 14)),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: leftCol
                              .map((p) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _ProductCard(product: p),
                                  ))
                              .toList(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          children: rightCol
                              .map((p) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _ProductCard(product: p),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}

class _ProductCard extends StatefulWidget {
  final MallProduct product;

  const _ProductCard({required this.product});

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _tapped = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Container(
      decoration: AppTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  p.image,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 120,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image, color: Colors.grey),
                  ),
                ),
              ),
              if (p.tag != null)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [AppTheme.brand, AppTheme.brandLight]),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Text(p.tag!,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w900)),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star,
                        size: 14, color: AppTheme.gold),
                    const SizedBox(width: 4),
                    Text(p.points.toString(),
                        style: const TextStyle(
                            color: AppTheme.gold,
                            fontWeight: FontWeight.w900,
                            fontSize: 14)),
                    const SizedBox(width: 4),
                    Text('积分',
                        style: TextStyle(
                            color: Colors.grey[500], fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.sell, size: 12, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text('剩余 ${p.stock} 件',
                        style: TextStyle(
                            color: Colors.grey[500], fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 36,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() => _tapped = true);
                      Future.delayed(const Duration(milliseconds: 1200),
                          () {
                        if (mounted) setState(() => _tapped = false);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _tapped ? Colors.green : AppTheme.brand,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      _tapped ? '✓ 已申请' : '立即兑换',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w900),
                    ),
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
