import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../shared/navigation/route_args.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../controllers/knowledge_controller.dart';

class KnowledgeTab extends GetView<KnowledgeController> {
  const KnowledgeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kiến thức')),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Tìm bài viết',
              ),
              onChanged: (String value) => controller.query.value = value,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.categories
                  .map(
                    (String category) => ChoiceChip(
                      label: Text(category),
                      selected: controller.category.value == category,
                      onSelected: (_) => controller.category.value = category,
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            ...controller.filteredArticles.map(
              (article) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () => Get.toNamed(
                    AppRoutes.articleDetail,
                    arguments: ArticleRouteArgs(article),
                  ),
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          article.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(article.excerpt),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: <Widget>[
                            StatusPill(
                              label: article.category,
                              background: const Color(0xFFF5EFE4),
                            ),
                            StatusPill(
                              label: '${article.readTimeMinutes} phút',
                              background: const Color(0xFFD7ECE7),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
