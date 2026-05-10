import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../controllers/life_map_controller.dart';

class LifeMapPage extends GetView<LifeMapController> {
  const LifeMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final profile = controller.profile.value;
      final summary = controller.summary.value;
      return Scaffold(
        appBar: AppBar(title: const Text('Life Map')),
        body: summary == null || profile == null
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
                          '${summary.title} của ${profile.name}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        Text(summary.overview),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: <Widget>[
                            StatusPill(
                              label: 'Peak element: ${summary.peakElement}',
                              background: Colors.white,
                            ),
                            StatusPill(
                              label: 'Hiện tại: ${summary.currentCycleLabel}',
                              background: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SectionHeader(
                    title: 'Nhịp chính của giai đoạn hiện tại',
                    subtitle: summary.currentCycleTheme,
                  ),
                  const SizedBox(height: 16),
                  ...summary.stages.map(
                    (stage) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AppCard(
                        color: stage.isCurrent ? AppColors.ivory : null,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        stage.ageRangeLabel,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        stage.title,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(stage.subtitle),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    StatusPill(
                                      label: '${stage.score}',
                                      background: stage.isCurrent
                                          ? AppColors.jadeSoft
                                          : AppColors.amberSoft,
                                    ),
                                    if (stage.isCurrent) ...<Widget>[
                                      const SizedBox(height: 8),
                                      const StatusPill(
                                        label: 'Hiện tại',
                                        background: AppColors.jadeSoft,
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Điểm sáng',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            ...stage.highlights.map((item) => Text('• $item')),
                            const SizedBox(height: 12),
                            Text(
                              'Cần lưu ý',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            ...stage.cautions.map((item) => Text('• $item')),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      );
    });
  }
}
