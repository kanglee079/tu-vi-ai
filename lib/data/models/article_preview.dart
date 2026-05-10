class ArticlePreview {
  const ArticlePreview({
    required this.id,
    required this.title,
    required this.category,
    required this.excerpt,
    required this.readTimeMinutes,
    required this.tags,
    required this.bodySections,
    this.isPremium = false,
  });

  final String id;
  final String title;
  final String category;
  final String excerpt;
  final int readTimeMinutes;
  final List<String> tags;
  final List<String> bodySections;
  final bool isPremium;
}
