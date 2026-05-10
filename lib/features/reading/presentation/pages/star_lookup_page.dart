import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/mock/knowledge_base.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/star_detail_sheet.dart';

/// Tra cứu sao theo tên — searchable star encyclopedia.
class StarLookupPage extends StatefulWidget {
  const StarLookupPage({super.key});

  @override
  State<StarLookupPage> createState() => _StarLookupPageState();
}

class _StarLookupPageState extends State<StarLookupPage> {
  String _query = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MapEntry<String, StarKnowledge>> get _filteredStars {
    final all = starKnowledgeBase.entries.toList();
    if (_query.isEmpty) return all;
    final q = _query.toLowerCase();
    return all
        .where((e) =>
            e.key.toLowerCase().contains(q) ||
            e.value.element.toLowerCase().contains(q) ||
            e.value.keywords.any((k) => k.toLowerCase().contains(q)))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tra cứu sao'),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm sao theo tên, ngũ hành...',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),

          // Filter chips
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _FilterChip(
                  label: 'Tất cả (${starKnowledgeBase.length})',
                  selected: _query.isEmpty,
                  onTap: () => setState(() {
                    _query = '';
                    _searchController.clear();
                  }),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Chính tinh (${starKnowledgeBase.entries.where((e) => e.value.type == StarType.major).length})',
                  selected: false,
                  onTap: () => setState(() {
                    _query = 'chinh';
                    _searchController.text = 'Chính tinh';
                  }),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Phụ tinh (${starKnowledgeBase.entries.where((e) => e.value.type == StarType.minor).length})',
                  selected: false,
                  onTap: () => setState(() {
                    _query = 'phu';
                    _searchController.text = 'Phụ tinh';
                  }),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Kim',
                  selected: false,
                  onTap: () => setState(() {
                    _query = 'kim';
                    _searchController.text = 'Kim';
                  }),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Mộc',
                  selected: false,
                  onTap: () => setState(() {
                    _query = 'mộc';
                    _searchController.text = 'Mộc';
                  }),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Thủy',
                  selected: false,
                  onTap: () => setState(() {
                    _query = 'thủy';
                    _searchController.text = 'Thủy';
                  }),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Hỏa',
                  selected: false,
                  onTap: () => setState(() {
                    _query = 'hỏa';
                    _searchController.text = 'Hỏa';
                  }),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Thổ',
                  selected: false,
                  onTap: () => setState(() {
                    _query = 'thổ';
                    _searchController.text = 'Thổ';
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Results
          Expanded(
            child: _filteredStars.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off, size: 48, color: AppColors.muted),
                        const SizedBox(height: 12),
                        Text(
                          'Không tìm thấy sao phù hợp',
                          style: TextStyle(color: AppColors.muted),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredStars.length,
                    itemBuilder: (context, i) {
                      final entry = _filteredStars[i];
                      return _StarListItem(
                        name: entry.key,
                        knowledge: entry.value,
                        onTap: () => _showDetail(context, entry.key),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showDetail(BuildContext context, String starName) {
    showStarDetailSheet(context, starName);
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.jade : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.jade : AppColors.line,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.ink,
          ),
        ),
      ),
    );
  }
}

class _StarListItem extends StatelessWidget {
  const _StarListItem({
    required this.name,
    required this.knowledge,
    required this.onTap,
  });

  final String name;
  final StarKnowledge knowledge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isMajor = knowledge.type == StarType.major;
    final color = isMajor ? AppColors.jade : AppColors.amber;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: AppCard(
          child: Row(
            children: <Widget>[
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  isMajor ? Icons.star : Icons.star_border,
                  color: color,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          isMajor ? 'Chính tinh' : 'Phụ tinh',
                          style: TextStyle(fontSize: 10, color: color),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    knowledge.element.isNotEmpty
                        ? 'Ngũ hành: ${knowledge.element}'
                        : knowledge.keywords.take(3).join(' • '),
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _truncate(knowledge.positive, 80),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.ink.withValues(alpha: 0.6),
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.muted, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  String _truncate(String text, int max) {
    if (text.length <= max) return text;
    return '${text.substring(0, max)}...';
  }
}
