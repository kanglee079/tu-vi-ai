import 'package:get/get.dart';

import '../../../../data/mock/prototype_seed_data.dart';
import '../../../../data/models/article_preview.dart';

class KnowledgeController extends GetxController {
  final RxString query = ''.obs;
  final RxString category = 'Tất cả'.obs;

  List<ArticlePreview> get allArticles => PrototypeSeedData.articles();

  List<String> get categories => <String>[
    'Tất cả',
    ...allArticles.map((ArticlePreview article) => article.category).toSet(),
  ];

  List<ArticlePreview> get filteredArticles {
    final lowercaseQuery = query.value.toLowerCase();
    return allArticles.where((ArticlePreview article) {
      final categoryMatch =
          category.value == 'Tất cả' || article.category == category.value;
      final queryMatch =
          lowercaseQuery.isEmpty ||
          article.title.toLowerCase().contains(lowercaseQuery);
      return categoryMatch && queryMatch;
    }).toList();
  }
}
