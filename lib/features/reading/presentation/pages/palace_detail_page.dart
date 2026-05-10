import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../controllers/palace_detail_controller.dart';

class PalaceDetailPage extends GetView<PalaceDetailController> {
  const PalaceDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final palace = controller.palace.value;
      return Scaffold(
        appBar: AppBar(title: Text(palace?.name ?? 'Chi tiết cung')),
        body: palace == null
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(16),
                children: <Widget>[
                  AppCard(
                    color: AppColors.jadeSoft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          palace.shortSummary,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: <Widget>[
                            StatusPill(
                              label: 'Điểm ${palace.score}',
                              background: Colors.white,
                            ),
                            ...palace.primaryStars.map(
                              (String star) => StatusPill(
                                label: star,
                                background: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _InfoListCard(title: 'Điểm mạnh', items: palace.strengths),
                  const SizedBox(height: 12),
                  _InfoListCard(title: 'Thử thách', items: palace.challenges),
                  const SizedBox(height: 12),
                  _InfoListCard(
                    title: 'Dựa trên yếu tố nào',
                    items: palace.evidence,
                  ),
                  const SizedBox(height: 12),
                  _InfoListCard(
                    title: 'Lời khuyên thực tế',
                    items: palace.advice,
                  ),
                  const SizedBox(height: 12),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SectionHeader(
                          title: 'Tam phương tứ chính liên quan',
                          subtitle:
                              'Highlight theo nhóm cung ảnh hưởng qua lại trong prototype.',
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: palace.relatedPalaces
                              .map(
                                (String key) => StatusPill(
                                  label: key.replaceAll('_', ' ').toUpperCase(),
                                  background: AppColors.ivory,
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      );
    });
  }
}

class _InfoListCard extends StatelessWidget {
  const _InfoListCard({required this.title, required this.items});

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          ...items.map(
            (String item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text('• $item'),
            ),
          ),
        ],
      ),
    );
  }
}
