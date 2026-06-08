import 'package:flutter/material.dart';
import 'package:quzhi_app/models/app_models.dart';
import 'package:quzhi_app/data/mock_data.dart';
import 'package:quzhi_app/utils/theme.dart';

class ContentCard extends StatelessWidget {
  final ContentItem item;
  final ValueChanged<ContentItem> onClick;

  const ContentCard({
    super.key,
    required this.item,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    final catColor = CATEGORY_COLORS[item.category] ?? CATEGORY_COLORS['all']!;
    final catLabel = CATEGORY_LABELS[item.category] ?? '其他';

    return GestureDetector(
      onTap: () => onClick(item),
      child: Container(
        decoration: AppTheme.cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                item.image,
                height: 130,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 130,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image, color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category tag
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Color(catColor['bg']!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Color(catColor['dot']!),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(catLabel,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(catColor['text']!),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          height: 1.3)),
                  const SizedBox(height: 4),
                  Text(item.summary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                          height: 1.4)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.favorite, size: 14, color: Colors.red[300]),
                      const SizedBox(width: 4),
                      Text(item.likes.toString(),
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey[500])),
                      const SizedBox(width: 12),
                      Icon(Icons.visibility,
                          size: 14, color: Colors.grey[400]),
                      const SizedBox(width: 4),
                      Text(item.views.toString(),
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey[500])),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
