import 'package:flutter/material.dart';
import 'package:quzhi_app/models/app_models.dart';
import 'package:quzhi_app/data/mock_data.dart';
import 'package:quzhi_app/utils/theme.dart';
import 'package:quzhi_app/api/api_service.dart';
import 'package:provider/provider.dart';
import 'package:quzhi_app/providers/app_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DetailPage extends StatefulWidget {
  final ContentItem item;
  final VoidCallback onBack;

  const DetailPage({
    super.key,
    required this.item,
    required this.onBack,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool _liked = false;
  bool _saved = false;
  late int _likeCount;
  String _commentText = '';
  bool _showEarnTip = true;
  bool _isLoading = true;
  ContentItem? _detailItem;
  List<Map<String, dynamic>> _comments = [];
  bool _isLiking = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _liked = widget.item.isLiked;
    _saved = widget.item.isBookmarked;
    _likeCount = widget.item.likes;
    _loadDetail();
    _loadComments();
    _earnReadPoints();
  }

  Future<void> _loadDetail() async {
    setState(() => _isLoading = true);
    try {
      final id = int.tryParse(widget.item.id) ?? 0;
      final result = await ApiService.getContentDetail(id: id);
      final data = result['data'] as Map<String, dynamic>? ?? result;
      _detailItem = ContentItem.fromJson(data);
      setState(() {
        _liked = _detailItem!.isLiked;
        _saved = _detailItem!.isBookmarked;
        _likeCount = _detailItem!.likes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      // Fallback to passed item data
    }
  }

  Future<void> _loadComments() async {
    try {
      final id = int.tryParse(widget.item.id) ?? 0;
      final result = await ApiService.getComments(id: id);
      final data = result['data'] as Map<String, dynamic>? ?? result;
      final list = data['list'] as List<dynamic>? ?? data['rows'] as List<dynamic>? ?? [];
      setState(() {
        _comments = list.map((e) => e as Map<String, dynamic>).toList();
      });
    } catch (e) {
      // Comments failed to load, keep empty
    }
  }

  Future<void> _earnReadPoints() async {
    try {
      final id = int.tryParse(widget.item.id) ?? 0;
      await ApiService.earnReadPoints(id: id);
    } catch (e) {
      // Silently fail - not critical
    }
  }

  String get _content {
    if (_detailItem?.body != null && _detailItem!.body!.isNotEmpty) {
      return _detailItem!.body!;
    }
    return widget.item.body ?? '''这是一篇精彩的内容，涵盖了丰富的知识与有趣的见闻。

无论是历史上那些叱咤风云的人物，还是日常生活中的小智慧，趣知App都为你一一收录。每一个故事背后都有值得深思的道理，每一条知识都能让你在聊天时多一分谈资。

继续浏览，探索更多精彩内容，同时别忘了观看广告赚取积分，用积分换取丰厚礼品！''';
  }

  Future<void> _toggleLike() async {
    if (_isLiking) return;
    setState(() => _isLiking = true);
    try {
      final id = int.tryParse(widget.item.id) ?? 0;
      await ApiService.likeContent(id: id);
      setState(() {
        _liked = !_liked;
        _likeCount += _liked ? 1 : -1;
        _isLiking = false;
      });
    } catch (e) {
      setState(() => _isLiking = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('操作失败，请重试')),
      );
    }
  }

  Future<void> _toggleBookmark() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);
    try {
      final id = int.tryParse(widget.item.id) ?? 0;
      await ApiService.bookmarkContent(id: id);
      setState(() {
        _saved = !_saved;
        _isSaving = false;
      });
    } catch (e) {
      setState(() => _isSaving = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('操作失败，请重试')),
      );
    }
  }

  Future<void> _share() async {
    try {
      final id = int.tryParse(widget.item.id) ?? 0;
      await ApiService.shareContent(id: id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('分享成功！')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('分享失败')),
      );
    }
  }

  Future<void> _addComment() async {
    if (_commentText.trim().isEmpty) return;
    try {
      final id = int.tryParse(widget.item.id) ?? 0;
      await ApiService.addComment(id: id, content: _commentText.trim());
      setState(() => _commentText = '');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('评论成功！')),
      );
      _loadComments();
    } catch (e) {
      if (!mounted) return;
      final msg = e.toString().replaceAll('ApiException(', '').replaceAll('): ', ': ').replaceAll(')', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg.isNotEmpty ? msg : '评论失败，请重试')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayItem = _detailItem ?? widget.item;
    final catColor = CATEGORY_COLORS[displayItem.category] ?? CATEGORY_COLORS['all']!;
    final catLabel = CATEGORY_LABELS[displayItem.category] ?? '其他';

    return Container(
      color: const Color(0xFFFAFAFA),
      child: Column(
        children: [
          // Top nav
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16,
              right: 16,
              bottom: 12,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: widget.onBack,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.arrow_back, size: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(catLabel,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis),
                ),
                GestureDetector(
                  onTap: _share,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.share, size: 20, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),

          // Scrollable content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      // Cover image
                      CachedNetworkImage(
                        imageUrl: displayItem.image,
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          height: 220,
                          color: Colors.grey[200],
                          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          height: 220,
                          color: Colors.grey[200],
                          child: const Icon(Icons.image, size: 48, color: Colors.grey),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Category tag
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Color(catColor['bg']!),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(catLabel,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(catColor['text']!),
                                  )),
                            ),
                            const SizedBox(height: 12),
                            // Title
                            Text(displayItem.title,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    height: 1.3)),
                            const SizedBox(height: 8),
                            // Stats
                            Row(
                              children: [
                                const Icon(Icons.visibility,
                                    size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text('${displayItem.views} 阅读',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey[500])),
                                const SizedBox(width: 16),
                                const Icon(Icons.favorite,
                                    size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text('$_likeCount 点赞',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey[500])),
                                const Spacer(),
                                Text('刚刚更新',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey[500])),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Earn tip
                            if (_showEarnTip)
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.monetization_on,
                                        size: 20, color: AppTheme.gold),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text.rich(
                                        TextSpan(
                                          text: '阅读完整内容可获得 ',
                                          style: const TextStyle(fontSize: 14),
                                          children: [
                                            TextSpan(
                                              text: '+5积分',
                                              style: const TextStyle(
                                                  color: AppTheme.brand,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            const TextSpan(text: '，看广告最高 '),
                                            TextSpan(
                                              text: '+500积分',
                                              style: const TextStyle(
                                                  color: AppTheme.brand,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () =>
                                          setState(() => _showEarnTip = false),
                                      child: Text('知道了',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[500])),
                                    ),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 16),

                            // Content
                            Text(_content,
                                style: const TextStyle(
                                    fontSize: 16, height: 1.8)),
                            const SizedBox(height: 24),

                            // Summary box
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFFF3ED),
                                    Color(0xFFFFF8F0)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('📌 一句话总结',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.brand)),
                                  const SizedBox(height: 4),
                                  Text(displayItem.summary,
                                      style: const TextStyle(
                                          fontSize: 14, height: 1.4)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Action buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _ActionButton(
                                  icon: Icons.thumb_up,
                                  label: _likeCount.toString(),
                                  isActive: _liked,
                                  activeColor: AppTheme.brand,
                                  onTap: _toggleLike,
                                ),
                                _ActionButton(
                                  icon: Icons.bookmark,
                                  label: _saved ? '已收藏' : '收藏',
                                  isActive: _saved,
                                  activeColor: Colors.purple,
                                  onTap: _toggleBookmark,
                                ),
                                _ActionButton(
                                  icon: Icons.comment,
                                  label:
                                      '${_comments.length}条评论',
                                  isActive: false,
                                  activeColor: AppTheme.brand,
                                  onTap: () {},
                                ),
                                _ActionButton(
                                  icon: Icons.share,
                                  label: '分享',
                                  isActive: false,
                                  activeColor: AppTheme.brand,
                                  onTap: _share,
                                ),
                              ],
                            ),
                            const Divider(height: 32),

                            // Comments
                            Text(
                                '评论 (${_comments.length})',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 16),
                            ..._comments.map((c) => Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20),
                                        child: CachedNetworkImage(
                                          imageUrl: c['avatar']?.toString() ?? '',
                                          width: 36,
                                          height: 36,
                                          fit: BoxFit.cover,
                                          placeholder: (_, __) => Container(
                                            width: 36,
                                            height: 36,
                                            color: Colors.grey[300],
                                          ),
                                          errorWidget: (_, __, ___) => Container(
                                            width: 36,
                                            height: 36,
                                            color: Colors.grey[300],
                                            child: const Icon(Icons.person, size: 18, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(c['nickname']?.toString() ?? c['name']?.toString() ?? '匿名用户',
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight
                                                                .w600)),
                                                Text(c['createtime']?.toString() ?? c['time']?.toString() ?? '',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            Colors.grey[500])),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(c['content']?.toString() ?? c['text']?.toString() ?? '',
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    height: 1.4)),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                const Icon(Icons.favorite,
                                                    size: 14,
                                                    color: Colors.grey),
                                                const SizedBox(width: 4),
                                                Text('${c['likes'] ?? c['like_count'] ?? 0}',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            Colors.grey[500])),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            if (_comments.isEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 24),
                                child: Center(
                                  child: Text('暂无评论，快来发表你的看法吧',
                                      style: TextStyle(color: Colors.grey[500], fontSize: 14)),
                                ),
                              ),
                            const SizedBox(height: 60),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),

          // Comment input
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: MediaQuery.of(context).padding.bottom + 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (v) => setState(() => _commentText = v),
                    decoration: InputDecoration(
                      hintText: '写下你的想法...',
                      hintStyle: TextStyle(
                          color: Colors.grey[400], fontSize: 14),
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      isDense: true,
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _commentText.trim().isNotEmpty ? _addComment : null,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _commentText.trim().isNotEmpty
                          ? AppTheme.brand
                          : const Color(0xFFF5F5F5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.send,
                        size: 20,
                        color: _commentText.trim().isNotEmpty
                            ? Colors.white
                            : Colors.grey),
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

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isActive ? activeColor : const Color(0xFFF5F5F5),
              shape: BoxShape.circle,
            ),
            child: Icon(icon,
                size: 24,
                color: isActive ? Colors.white : Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isActive ? activeColor : Colors.grey,
              )),
        ],
      ),
    );
  }
}
