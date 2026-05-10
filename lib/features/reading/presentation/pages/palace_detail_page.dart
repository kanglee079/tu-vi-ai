import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/mock/knowledge_base.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/star_detail_sheet.dart';
import '../controllers/palace_detail_controller.dart';

class PalaceDetailPage extends GetView<PalaceDetailController> {
  const PalaceDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final palace = controller.palace.value;
      final knowledge = palace != null ? palaceKnowledgeBase[palace.key] : null;
      return Scaffold(
        appBar: AppBar(
          title: Text(palace?.name ?? 'Chi tiết cung'),
          actions: [
            if (palace != null)
              IconButton(
                icon: const Icon(Icons.star_outline),
                onPressed: () => _showStarDetail(context, palace),
                tooltip: 'Tra cứu sao',
              ),
          ],
        ),
        body: palace == null
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(16),
                children: <Widget>[
                  // Score + stars header card
                  AppCard(
                    color: _scoreCardColor(palace.score),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    palace.name,
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                  if (knowledge != null)
                                    Text(
                                      knowledge.domain,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: AppColors.muted,
                                          ),
                                    ),
                                ],
                              ),
                            ),
                            _ScoreBadge(score: palace.score),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          palace.shortSummary,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: <Widget>[
                            ...palace.primaryStars.map(
                              (String star) => _StarChip(
                                name: star,
                                type: _StarChipType.major,
                                onTap: () => _showStarDetailByName(context, star),
                              ),
                            ),
                            ...palace.secondaryStars.map(
                              (String star) => _StarChip(
                                name: star,
                                type: _StarChipType.minor,
                                onTap: () => _showStarDetailByName(context, star),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Life advice from knowledge base
                  if (knowledge != null) ...<Widget>[
                    _InfoListCard(
                      title: 'Đặc điểm cung này',
                      icon: Icons.psychology_outlined,
                      items: [
                        if (knowledge.coreStrengths.isNotEmpty)
                          'Điểm mạnh: ${knowledge.coreStrengths.join(', ')}.',
                        if (knowledge.coreChallenges.isNotEmpty)
                          'Thách thức: ${knowledge.coreChallenges.join(', ')}.',
                        if (knowledge.suitableDirections.isNotEmpty)
                          'Hướng phù hợp: ${knowledge.suitableDirections.join(', ')}.',
                      ],
                    ),
                    const SizedBox(height: 12),

                    _AdviceCard(
                      title: 'Lời khuyên tổng quát',
                      icon: Icons.lightbulb_outline,
                      text: knowledge.lifeAdvice,
                    ),
                    const SizedBox(height: 12),

                    _AdviceCard(
                      title: 'Tình cảm & quan hệ',
                      icon: Icons.favorite_outline,
                      text: knowledge.relationshipStyle,
                    ),
                    const SizedBox(height: 12),

                    _AdviceCard(
                      title: 'Sức khỏe cần lưu ý',
                      icon: Icons.health_and_safety_outlined,
                      text: knowledge.healthNote,
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Computed strengths/challenges/advice from engine
                  if (palace.strengths.isNotEmpty) ...<Widget>[
                    _InfoListCard(
                      title: 'Điểm mạnh theo lá số',
                      icon: Icons.thumb_up_outlined,
                      items: palace.strengths,
                    ),
                    const SizedBox(height: 12),
                  ],

                  if (palace.challenges.isNotEmpty) ...<Widget>[
                    _InfoListCard(
                      title: 'Thử thách theo lá số',
                      icon: Icons.warning_outlined,
                      items: palace.challenges,
                    ),
                    const SizedBox(height: 12),
                  ],

                  if (palace.advice.isNotEmpty) ...<Widget>[
                    _InfoListCard(
                      title: 'Lời khuyên cá nhân hóa',
                      icon: Icons.tips_and_updates_outlined,
                      items: palace.advice,
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Evidence
                  if (palace.evidence.isNotEmpty) ...<Widget>[
                    const SectionHeader(
                      title: 'Dựa trên yếu tố nào',
                      subtitle: 'Căn cứ từ lá số thực tế, không phải AI tự bịa.',
                    ),
                    const SizedBox(height: 12),
                    AppCard(
                      color: AppColors.ivory,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: palace.evidence
                            .map(
                              (String e) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.check_circle_outline,
                                      size: 16,
                                      color: AppColors.jade,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(e)),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Related palaces
                  const SectionHeader(
                    title: 'Cung liên quan',
                    subtitle: 'Tam phương tứ chính — ảnh hưởng qua lại với cung này.',
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: palace.relatedPalaces.map((String key) {
                      final relatedKb = palaceKnowledgeBase[key];
                      return ActionChip(
                        avatar: Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: AppColors.jade,
                        ),
                        label: Text(
                          relatedKb?.name ?? _formatKey(key),
                          style: const TextStyle(fontSize: 12),
                        ),
                        onPressed: () => _navigateToRelated(context, key),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
      );
    });
  }

  Color _scoreCardColor(int score) {
    if (score >= 68) return AppColors.jadeSoft;
    if (score >= 52) return AppColors.amberSoft;
    return AppColors.ivory;
  }

  String _formatKey(String key) =>
      key.split('_').map((s) => s[0].toUpperCase() + s.substring(1)).join(' ');

  void _showStarDetail(BuildContext context, dynamic palace) {
    _showStarSheet(context, palace.primaryStars, palace.secondaryStars);
  }

  void _showStarDetailByName(BuildContext context, String starName) {
    showStarDetailSheet(context, starName);
  }

  void _showStarSheet(
      BuildContext context, List<String> primary, List<String> secondary) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sao trong cung này',
                  style: Theme.of(ctx).textTheme.titleLarge),
              const SizedBox(height: 16),
              if (primary.isNotEmpty) ...[
                Text('Chính tinh', style: Theme.of(ctx).textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: primary.map((s) => ActionChip(
                    label: Text(s),
                    onPressed: () {
                      Navigator.pop(ctx);
                      showStarDetailSheet(context, s);
                    },
                  )).toList(),
                ),
                const SizedBox(height: 16),
              ],
              if (secondary.isNotEmpty) ...[
                Text('Phụ tinh', style: Theme.of(ctx).textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: secondary.map((s) => ActionChip(
                    label: Text(s),
                    onPressed: () {
                      Navigator.pop(ctx);
                      showStarDetailSheet(context, s);
                    },
                  )).toList(),
                ),
              ],
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Đóng'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToRelated(BuildContext context, String palaceKey) {
    final args = controller.routeArgs;
    Get.toNamed(
      '/palace-detail',
      arguments: args.copyWith(palaceKey: palaceKey),
    );
  }
}

class _ScoreBadge extends StatelessWidget {
  const _ScoreBadge({required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          Text(
            '$score',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: _color,
            ),
          ),
          Text(
            'điểm',
            style: TextStyle(fontSize: 10, color: _color),
          ),
        ],
      ),
    );
  }

  Color get _color {
    if (score >= 68) return AppColors.jade;
    if (score >= 52) return AppColors.amber;
    return AppColors.caution;
  }
}

enum _StarChipType { major, minor }

class _StarChip extends StatelessWidget {
  const _StarChip({
    required this.name,
    required this.type,
    required this.onTap,
  });

  final String name;
  final _StarChipType type;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = type == _StarChipType.major ? AppColors.jade : AppColors.amber;
    return ActionChip(
      avatar: Icon(
        type == _StarChipType.major ? Icons.star : Icons.star_border,
        size: 14,
        color: color,
      ),
      label: Text(
        name,
        style: TextStyle(fontSize: 12, color: color),
      ),
      backgroundColor: color.withValues(alpha: 0.1),
      side: BorderSide(color: color.withValues(alpha: 0.3)),
      onPressed: onTap,
    );
  }
}

class _InfoListCard extends StatelessWidget {
  const _InfoListCard({
    required this.title,
    required this.icon,
    required this.items,
  });

  final String title;
  final IconData icon;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.jade),
              const SizedBox(width: 8),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map(
            (String item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Icon(Icons.circle, size: 6, color: AppColors.jade),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(item)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdviceCard extends StatelessWidget {
  const _AdviceCard({
    required this.title,
    required this.icon,
    required this.text,
  });

  final String title;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.jadeSoft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.jade),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.jade,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
