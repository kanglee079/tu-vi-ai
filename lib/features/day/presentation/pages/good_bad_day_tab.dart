import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/daily_recommendation.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../controllers/good_bad_day_controller.dart';

class GoodBadDayTab extends GetView<GoodBadDayController> {
  const GoodBadDayTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Xem ngày')),
      body: Obx(() {
        final recommendations = controller.recommendations;
        final today = recommendations.isNotEmpty ? recommendations.first : null;
        return ListView(
          key: const ValueKey<String>('good_day_scroll'),
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            const AppCard(
              child: SectionHeader(
                title: 'Ngày tốt xấu cá nhân hóa',
                subtitle:
                    'Kết hợp lịch chung với nhịp lá số chính trong prototype.',
              ),
            ),
            const SizedBox(height: 16),
            AppCard(
              color: AppColors.ivory,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Việc cần xem',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: controller.activities
                        .map(
                          (String activity) => ChoiceChip(
                            label: Text(activity),
                            selected:
                                controller.selectedActivity.value == activity,
                            onSelected: (_) =>
                                controller.selectedActivity.value = activity,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Tháng 05/2026',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    itemCount: 35,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          mainAxisSpacing: 6,
                          crossAxisSpacing: 6,
                        ),
                    itemBuilder: (BuildContext context, int index) {
                      final day = index + 1;
                      final sample = recommendations.isEmpty
                          ? null
                          : recommendations[index % recommendations.length];
                      final background = sample == null
                          ? Colors.white
                          : sample.level == FortuneLevel.favorable
                          ? AppColors.jadeSoft
                          : sample.level == FortuneLevel.balanced
                          ? AppColors.ivory
                          : AppColors.amberSoft;
                      return Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: background,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.line),
                        ),
                        child: Text('$day'),
                      );
                    },
                  ),
                ],
              ),
            ),
            if (today != null) ...<Widget>[
              const SizedBox(height: 16),
              AppCard(
                color: AppColors.jadeSoft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            '${today.weekdayLabel} • ${today.dateLabel}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        StatusPill(
                          label: today.level.label,
                          background: Colors.white,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(today.summary),
                    const SizedBox(height: 12),
                    Text(
                      'Hôm nay hợp',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    ...today.goodFor.map((String item) => Text('✓ $item')),
                    const SizedBox(height: 12),
                    Text(
                      'Hôm nay nên tránh',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    ...today.avoid.map((String item) => Text('✕ $item')),
                    const SizedBox(height: 12),
                    Text(
                      'Theo lá số chính, ngày này hợp cho chuẩn bị và lên kế hoạch hơn là ký kết lớn.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ],
        );
      }),
    );
  }
}
