import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/article_preview.dart';
import '../../../../shared/navigation/route_args.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/status_pill.dart';

class ArticleDetailPage extends StatelessWidget {
  const ArticleDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as ArticleRouteArgs;
    final ArticlePreview article = args.article;
    return Scaffold(
      appBar: AppBar(title: const Text('Bài viết')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Text(article.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              StatusPill(
                label: article.category,
                background: const Color(0xFFF5EFE4),
              ),
              ...article.tags.map(
                (String tag) =>
                    StatusPill(label: tag, background: const Color(0xFFD7ECE7)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...article.bodySections.map(
            (String section) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AppCard(child: Text(section)),
            ),
          ),
        ],
      ),
    );
  }
}
