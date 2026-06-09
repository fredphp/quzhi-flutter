import 'package:flutter/material.dart';
import 'package:quzhi_app/models/app_models.dart';
import 'package:quzhi_app/data/mock_data.dart';
import 'package:quzhi_app/utils/theme.dart';
import 'package:quzhi_app/components/points_badge.dart';
import 'package:quzhi_app/components/banner_ad.dart';
import 'package:quzhi_app/api/api_service.dart';
import 'package:quzhi_app/providers/address_provider.dart';
import 'package:provider/provider.dart';
import 'package:quzhi_app/providers/app_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MallPage extends StatefulWidget {
  const MallPage({super.key});

  @override
  State<MallPage> createState() => _MallPageState();
}

class _MallPageState extends State<MallPage> {
  String _activeFilter = '全部';
  List<MallProduct> _products = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
    }
    setState(() => _isLoading = !refresh);

    try {
      final result = await ApiService.getMallProducts(
        filter: _activeFilter == '全部' ? null : _activeFilter,
        page: _currentPage,
      );
      final data = result['data'] as Map<String, dynamic>? ?? result;
      final list = data['list'] as List<dynamic>? ?? data['rows'] as List<dynamic>? ?? [];
      final total = data['total'] as int? ?? 0;
      final items = list.map((e) => MallProduct.fromJson(e as Map<String, dynamic>)).toList();

      setState(() {
        if (refresh || _currentPage == 1) {
          _products = items;
        } else {
          _products.addAll(items);
        }
        _hasMore = _products.length < total;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    setState(() => _isLoadingMore = true);
    _currentPage++;
    try {
      final result = await ApiService.getMallProducts(
        filter: _activeFilter == '全部' ? null : _activeFilter,
        page: _currentPage,
      );
      final data = result['data'] as Map<String, dynamic>? ?? result;
      final list = data['list'] as List<dynamic>? ?? data['rows'] as List<dynamic>? ?? [];
      final total = data['total'] as int? ?? 0;
      final items = list.map((e) => MallProduct.fromJson(e as Map<String, dynamic>)).toList();

      setState(() {
        _products.addAll(items);
        _hasMore = _products.length < total;
        _isLoadingMore = false;
      });
    } catch (e) {
      _currentPage--;
      setState(() => _isLoadingMore = false);
    }
  }

  void _onFilterChanged(String filter) {
    setState(() => _activeFilter = filter);
    _loadProducts(refresh: true);
  }

  Future<void> _exchangeProduct(MallProduct product) async {
    final addressProvider = context.read<AddressProvider>();
    final addresses = addressProvider.addresses;

    if (addresses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先添加收货地址')),
      );
      return;
    }

    // Show address selector dialog
    Address? selectedAddr = addresses.firstWhere((a) => a.isDefault, orElse: () => addresses.first);

    final addrId = await showDialog<String>(
      context: context,
      builder: (ctx) {
        Address? temp = selectedAddr;
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              title: const Text('选择收货地址'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: addresses.map((a) {
                  final isSelected = temp?.id == a.id;
                  return ListTile(
                    leading: Icon(
                      isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                      color: isSelected ? AppTheme.brand : Colors.grey,
                    ),
                    title: Text(a.name),
                    subtitle: Text('${a.province} ${a.city} ${a.district} ${a.detail}'),
                    onTap: () {
                      setDialogState(() => temp = a);
                    },
                  );
                }).toList(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('取消'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(ctx, temp?.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.brand,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('确认兑换'),
                ),
              ],
            );
          },
        );
      },
    );

    if (addrId == null) return;

    try {
      await ApiService.exchangeProduct(
        productId: int.tryParse(product.id) ?? 0,
        addressId: int.tryParse(addrId) ?? 0,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('兑换成功！')),
      );
      // Refresh user state
      context.read<AppProvider>().loadUserInfo();
    } catch (e) {
      if (!mounted) return;
      final msg = e.toString().replaceAll('ApiException(', '').replaceAll('): ', ': ').replaceAll(')', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg.isNotEmpty ? msg : '兑换失败，请重试')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = context.watch<AppProvider>().userState;
    final products = _products;
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
                      onTap: () => _onFilterChanged(f),
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
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () => _loadProducts(refresh: true),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollEndNotification &&
                          notification.metrics.pixels >= notification.metrics.maxScrollExtent - 200 &&
                          !_isLoadingMore && _hasMore) {
                        _loadMore();
                      }
                      return false;
                    },
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
                        : ListView(
                            padding: const EdgeInsets.all(12),
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: leftCol
                                          .map((p) => Padding(
                                                padding: const EdgeInsets.only(bottom: 12),
                                                child: _ProductCard(
                                                  product: p,
                                                  onExchange: () => _exchangeProduct(p),
                                                ),
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
                                                child: _ProductCard(
                                                  product: p,
                                                  onExchange: () => _exchangeProduct(p),
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                ],
                              ),
                              if (_isLoadingMore)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                  ),
                ),
        ),
      ],
    );
  }
}

class _ProductCard extends StatefulWidget {
  final MallProduct product;
  final VoidCallback onExchange;

  const _ProductCard({required this.product, required this.onExchange});

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
                child: CachedNetworkImage(
                  imageUrl: p.image,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    height: 120,
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                  errorWidget: (_, __, ___) => Container(
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
                      widget.onExchange();
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
