import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../controllers/compatibility_controller.dart';

class CompatibilityPage extends GetView<CompatibilityController> {
  const CompatibilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final primary = controller.primaryProfile.value;
      final secondary = controller.secondaryProfile.value;
      final report = controller.report.value;
      return Scaffold(
        appBar: AppBar(title: const Text('So sánh lá số')),
        body: primary == null
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(16),
                children: <Widget>[
                  AppCard(
                    color: AppColors.jadeSoft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SectionHeader(
                          title: 'So sánh nhân duyên',
                          subtitle:
                              'Prototype dùng hồ sơ chính và các hồ sơ còn lại để mô phỏng phân tích độ hợp.',
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${primary.name} với ${secondary?.name ?? 'chưa chọn đối tượng'}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (controller.otherProfiles.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: controller.otherProfiles
                          .map(
                            (profile) => ChoiceChip(
                              label: Text(profile.name),
                              selected: secondary?.id == profile.id,
                              onSelected: (_) =>
                                  controller.changeSecondary(profile),
                            ),
                          )
                          .toList(),
                    ),
                  if (report != null) ...<Widget>[
                    const SizedBox(height: 16),
                    AppCard(
                      color: AppColors.ivory,
                      child: Column(
                        children: <Widget>[
                          Text(
                            '${report.overallScore}%',
                            style: Theme.of(context).textTheme.displaySmall
                                ?.copyWith(color: AppColors.jade),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            report.verdict,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(report.summary, textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...report.categories.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      item.label,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                  ),
                                  StatusPill(
                                    label: '${item.score}%',
                                    background: item.score >= 75
                                        ? AppColors.jadeSoft
                                        : AppColors.amberSoft,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              LinearProgressIndicator(
                                value: item.score / 100,
                                minHeight: 8,
                                borderRadius: BorderRadius.circular(999),
                                backgroundColor: AppColors.line,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.jade,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(item.insight),
                            ],
                          ),
                        ),
                      ),
                    ),
                    _BulletCard(title: 'Điểm hợp', items: report.strengths),
                    const SizedBox(height: 12),
                    _BulletCard(
                      title: 'Điểm dễ xung',
                      items: report.challenges,
                    ),
                    const SizedBox(height: 12),
                    _BulletCard(title: 'Cách dung hòa', items: report.guidance),
                  ],
                ],
              ),
      );
    });
  }
}

class _BulletCard extends StatelessWidget {
  const _BulletCard({required this.title, required this.items});

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
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text('• $item'),
            ),
          ),
        ],
      ),
    );
  }
}
