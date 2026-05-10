import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/chart_models.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../controllers/fortune_controller.dart';

class MonthlyFortunePage extends GetView<FortuneController> {
  const MonthlyFortunePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final months =
          controller.chart.value?.monthlyFortunes ?? const <MonthlyFortune>[];
      return Scaffold(
        appBar: AppBar(title: const Text('Nguyệt vận')),
        body: months.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: months.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (BuildContext context, int index) {
                  final month = months[index];
                  return AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                'Tháng ${month.monthNumber} âm lịch',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            StatusPill(
                              label: '${month.score}',
                              background: month.unlocked
                                  ? AppColors.jadeSoft
                                  : AppColors.amberSoft,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          month.solarRange,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          month.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(month.highlight),
                        const SizedBox(height: 12),
                        ...month.advice.map((String line) => Text('• $line')),
                        if (!month.unlocked) ...<Widget>[
                          const SizedBox(height: 12),
                          Text(
                            'Mở ${month.unlockCost} xu để xem đủ luận giải.',
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
