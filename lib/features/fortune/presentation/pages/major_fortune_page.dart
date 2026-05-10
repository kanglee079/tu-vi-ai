import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/chart_models.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../controllers/fortune_controller.dart';

class MajorFortunePage extends GetView<FortuneController> {
  const MajorFortunePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FortuneTimelinePage(
      title: 'Đại vận',
      subtitle: 'Timeline theo tuổi với marker chính vận.',
      items: () =>
          controller.chart.value?.majorCycles ?? const <FortunePeriod>[],
    );
  }
}

class FortuneTimelinePage extends GetView<FortuneController> {
  const FortuneTimelinePage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.items,
  });

  final String title;
  final String subtitle;
  final List<FortunePeriod> Function() items;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = items();
      return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: data.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: data.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (BuildContext context, int index) {
                  final item = data[index];
                  return AppCard(
                    color: item.isHighlighted ? AppColors.jadeSoft : null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    item.title,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.subtitle,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            StatusPill(
                              label: '${item.score}',
                              background: Colors.white,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Điểm sáng',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        ...item.highlights.map(
                          (String line) => Text('• $line'),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Cần lưu ý',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        ...item.cautions.map((String line) => Text('• $line')),
                        if (!item.unlocked) ...<Widget>[
                          const SizedBox(height: 12),
                          StatusPill(
                            label: 'Mở ${item.unlockCost} xu',
                            background: AppColors.amberSoft,
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
      );
    });
  }
}
