import 'package:flutter/material.dart';
import 'package:quzhi_app/models/app_models.dart';
import 'package:quzhi_app/data/mock_data.dart';
import 'package:quzhi_app/utils/theme.dart';

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

  static const _mockComments = [
    {'avatar': 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=60&q=80', 'name': '知识达人', 'text': '涨知识了！以前不知道这段历史，感谢分享。', 'likes': 24, 'time': '2小时前'},
    {'avatar': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=60&q=80', 'name': '历史爱好者', 'text': '项羽确实厉害，破釜沉舟这个策略放到现在也有借鉴意义！', 'likes': 18, 'time': '3小时前'},
    {'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=60&q=80', 'name': '阅读小王子', 'text': '写得很详细，点赞👍', 'likes': 9, 'time': '5小时前'},
  ];

  @override
  void initState() {
    super.initState();
    _likeCount = widget.item.likes;
  }

  String get _content {
    return DETAIL_CONTENT[widget.item.id] ??
        '''这是一篇精彩的内容，涵盖了丰富的知识与有趣的见闻。

无论是历史上那些叱咤风云的人物，还是日常生活中的小智慧，趣知App都为你一一收录。每一个故事背后都有值得深思的道理，每一条知识都能让你在聊天时多一分谈资。

继续浏览，探索更多精彩内容，同时别忘了观看广告赚取积分，用积分换取丰厚礼品！''';
  }

  @override
  Widget build(BuildContext context) {
    final catColor = CATEGORY_COLORS[widget.item.category] ?? CATEGORY_COLORS['all']!;
    final catLabel = CATEGORY_LABELS[widget.item.category] ?? '其他';

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
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.share, size: 20, color: Colors.grey),
                ),
              ],
            ),
          ),

          // Scrollable content
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Cover image
                Image.network(
                  widget.item.image,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
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
                      Text(widget.item.title,
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
                          Text('${widget.item.views} 阅读',
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
                            Text(widget.item.summary,
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
                            onTap: () {
                              setState(() {
                                _liked = !_liked;
                                _likeCount += _liked ? 1 : -1;
                              });
                            },
                          ),
                          _ActionButton(
                            icon: Icons.bookmark,
                            label: _saved ? '已收藏' : '收藏',
                            isActive: _saved,
                            activeColor: Colors.purple,
                            onTap: () =>
                                setState(() => _saved = !_saved),
                          ),
                          _ActionButton(
                            icon: Icons.comment,
                            label:
                                '${_mockComments.length}条评论',
                            isActive: false,
                            activeColor: AppTheme.brand,
                            onTap: () {},
                          ),
                          _ActionButton(
                            icon: Icons.share,
                            label: '分享',
                            isActive: false,
                            activeColor: AppTheme.brand,
                            onTap: () {},
                          ),
                        ],
                      ),
                      const Divider(height: 32),

                      // Comments
                      Text(
                          '评论 (${_mockComments.length})',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 16),
                      ..._mockComments.map((c) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(20),
                                  child: Image.network(
                                    c['avatar'] as String,
                                    width: 36,
                                    height: 36,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        Container(
                                      width: 36,
                                      height: 36,
                                      color: Colors.grey[300],
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
                                          Text(c['name'] as String,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight
                                                          .w600)),
                                          Text(c['time'] as String,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color:
                                                      Colors.grey[500])),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(c['text'] as String,
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
                                          Text('${c['likes']}',
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
                  onTap: () {
                    if (_commentText.trim().isNotEmpty) {
                      setState(() => _commentText = '');
                    }
                  },
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
