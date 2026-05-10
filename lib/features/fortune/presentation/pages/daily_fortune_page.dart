import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/daily_recommendation.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../controllers/fortune_controller.dart';

class DailyFortunePage extends GetView<FortuneController> {
  const DailyFortunePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final days =
          controller.chart.value?.dailyRecommendations ??
          const <DailyRecommendation>[];
      return Scaffold(
        appBar: AppBar(title: const Text('Nhật vận')),
        body: days.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: days.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (BuildContext context, int index) {
                  final day = days[index];
                  return AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                '${day.weekdayLabel} • ${day.dateLabel}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            StatusPill(
                              label: day.level.label,
                              background: day.level == FortuneLevel.favorable
                                  ? AppColors.jadeSoft
                                  : day.level == FortuneLevel.balanced
                                  ? AppColors.ivory
                                  : AppColors.amberSoft,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          day.lunarLabel,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 12),
                        Text(day.summary),
                        const SizedBox(height: 12),
                        Text(
                          'Hợp',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 6),
                        ...day.goodFor.map((String item) => Text('✓ $item')),
                        const SizedBox(height: 12),
                        Text(
                          'Nên tránh',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 6),
                        ...day.avoid.map((String item) => Text('✕ $item')),
                      ],
                    ),
                  );
                },
              ),
      );
    });
  }
}
