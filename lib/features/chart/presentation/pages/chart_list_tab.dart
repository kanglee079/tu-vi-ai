import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/birth_profile.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../controllers/chart_list_controller.dart';

class ChartListTab extends GetView<ChartListController> {
  const ChartListTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lá số'),
        actions: <Widget>[
          IconButton(
            key: const ValueKey<String>('create_chart_button'),
            onPressed: controller.openCreate,
            icon: const Icon(Icons.add),
            tooltip: 'Lập lá số mới',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          key: const ValueKey<String>('chart_list_scroll'),
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            AppCard(
              color: AppColors.jadeSoft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SectionHeader(
                    title: 'Local-first prototype',
                    subtitle:
                        'Hồ sơ sinh lưu mock tại app, chưa phụ thuộc login hay backend.',
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Tổng hồ sơ: ${controller.profiles.length}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ...controller.profiles.map(
              (BirthProfile profile) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              profile.name,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          if (profile.isMain)
                            const StatusPill(
                              label: 'Lá số chính',
                              background: AppColors.jadeSoft,
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${profile.gender.label} • ${profile.birthDateLabel} • ${profile.birthHourLabel}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: <Widget>[
                          StatusPill(
                            label: profile.confidenceLabel,
                            background: profile.isLowConfidence
                                ? AppColors.amberSoft
                                : AppColors.jadeSoft,
                          ),
                          ...profile.mainFocus.map(
                            (MainFocus focus) => StatusPill(
                              label: focus.label,
                              background: AppColors.ivory,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: <Widget>[
                          FilledButton.tonal(
                            onPressed: () => controller.openResult(profile),
                            child: const Text('Xem lá số'),
                          ),
                          if (!profile.isMain)
                            OutlinedButton(
                              onPressed: () =>
                                  controller.setMainProfile(profile),
                              child: const Text('Đặt chính'),
                            ),
                          OutlinedButton(
                            onPressed: () => controller.openEdit(profile),
                            child: const Text('Sửa'),
                          ),
                          TextButton(
                            onPressed: () => controller.deleteProfile(profile),
                            child: const Text('Xóa'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
