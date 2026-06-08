import 'package:flutter/material.dart';
import 'package:quzhi_app/models/app_models.dart';
import 'package:quzhi_app/data/mock_data.dart';
import 'package:quzhi_app/utils/theme.dart';
import 'package:quzhi_app/components/points_badge.dart';
import 'package:quzhi_app/components/banner_ad.dart';
import 'package:quzhi_app/components/content_card.dart';
import 'package:provider/provider.dart';
import 'package:quzhi_app/providers/app_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _activeCat = 'all';
  bool _compactHeader = false;
  bool _showSearch = false;
  String _searchTerm = '';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _compactHeader = _scrollController.offset > 120;
    });
  }

  List<ContentItem> get _filteredItems {
    var items = _activeCat == 'all'
        ? CONTENT_ITEMS
        : CONTENT_ITEMS.where((i) => i.category == _activeCat).toList();
    if (_searchTerm.trim().isNotEmpty) {
      items = items
          .where((i) =>
              i.title.toLowerCase().contains(_searchTerm.toLowerCase()) ||
              i.summary.toLowerCase().contains(_searchTerm.toLowerCase()))
          .toList();
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final userState = provider.userState;
    final items = _filteredItems;
    final leftCol = <ContentItem>[];
    final rightCol = <ContentItem>[];
    for (var i = 0; i < items.length; i++) {
      if (i % 2 == 0) {
        leftCol.add(items[i]);
      } else {
        rightCol.add(items[i]);
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
          child: Column(
            children: [
              // Main header row
              Padding(
                padding:
                    const EdgeInsets.only(top: 48, left: 16, right: 16, bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: const Text('趣',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 14)),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: _compactHeader ? 0 : null,
                      child: _compactHeader
                          ? const SizedBox.shrink()
                          : const Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Text('趣知',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900)),
                            ),
                    ),
                    const Spacer(),
                    PointsBadge(
                      points: userState.points,
                      todayEarned: userState.todayEarned,
                      compact: true,
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => provider.setShowNotification(true),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.notifications,
                            size: 20, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => setState(() => _showSearch = true),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.search,
                            size: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),

              // Search panel
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _showSearch ? 120 : 0,
                child: _showSearch
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                children: [
                                  const Icon(Icons.search,
                                      size: 16, color: Colors.grey),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      onChanged: (v) =>
                                          setState(() => _searchTerm = v),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: '搜索内容、资讯…',
                                        hintStyle: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 14),
                                        isDense: true,
                                        contentPadding: const EdgeInsets
                                            .symmetric(vertical: 10),
                                      ),
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => setState(() {
                                      _showSearch = false;
                                      _searchTerm = '';
                                    }),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                      child: const Text('取消',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (_searchTerm.isEmpty)
                              Wrap(
                                spacing: 8,
                                children: RECENT_SEARCHES
                                    .map((tag) => GestureDetector(
                                          onTap: () =>
                                              setState(() => _searchTerm = tag),
                                          child: Container(
                                            padding: const EdgeInsets
                                                .symmetric(
                                                horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(tag,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ),
                                        ))
                                    .toList(),
                              )
                            else
                              Text.rich(
                                TextSpan(
                                  text: '找到 ',
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 12),
                                  children: [
                                    TextSpan(
                                      text: '${items.length}',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    const TextSpan(text: ' 条相关内容'),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              // Category tabs
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: CATEGORIES.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, idx) {
                    final cat = CATEGORIES[idx];
                    final isActive = _activeCat == cat.key;
                    return GestureDetector(
                      onTap: () => setState(() => _activeCat = cat.key),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isActive
                              ? Colors.white
                              : Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Text(cat.emoji, style: const TextStyle(fontSize: 14)),
                            const SizedBox(width: 4),
                            Text(cat.label,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: isActive
                                      ? AppTheme.brand
                                      : Colors.white,
                                )),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),

        // Content area
        Expanded(
          child: ListView(
            controller: _scrollController,
            padding: const EdgeInsets.only(bottom: 140),
            children: [
              // Banner ad
              BannerAd(
                onView: () => provider.onBannerView(),
                variant: 'inline',
              ),

              if (items.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 80),
                    child: Column(
                      children: [
                        Icon(Icons.search,
                            size: 64, color: Colors.grey.withOpacity(0.2)),
                        const SizedBox(height: 16),
                        Text('没有找到「$_searchTerm」相关内容',
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 14)),
                      ],
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left column
                      Expanded(
                        child: Column(
                          children: leftCol
                              .map((item) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: ContentCard(
                                      item: item,
                                      onClick: (item) =>
                                          provider.selectItem(item),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Right column
                      Expanded(
                        child: Column(
                          children: rightCol
                              .map((item) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: ContentCard(
                                      item: item,
                                      onClick: (item) =>
                                          provider.selectItem(item),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
