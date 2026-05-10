import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/config/feature_flags.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/birth_profile.dart';
import '../../../../data/models/chart_models.dart';
import '../../../../data/models/wallet_models.dart';
import '../../../../data/repositories/wallet_repository.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/chart_board.dart';
import '../../../../shared/widgets/paywall_sheet.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../controllers/chart_result_controller.dart';

class ChartResultPage extends GetView<ChartResultController> {
  const ChartResultPage({super.key});

  Future<void> _openPaywall(BuildContext context, ChartPalace palace) async {
    final walletRepository = Get.find<WalletRepository>();
    final UnlockPreview preview = await walletRepository.previewUnlock(
      palace.key,
    );
    final wallet = await walletRepository.getWallet();
    final offers = await walletRepository.listOffers();
    if (!context.mounted) return;
    await showPrototypePaywallSheet(
      context: context,
      preview: preview,
      wallet: wallet,
      offers: offers,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final profile = controller.profile.value;
      final chart = controller.chart.value;
      final lockedPalaces =
          chart == null
                ? <ChartPalace>[]
                : chart.palaces
                      .where((ChartPalace palace) => !palace.isUnlocked)
                      .toList()
            ..sort((ChartPalace a, ChartPalace b) {
              if (a.key == 'quan_loc') return -1;
              if (b.key == 'quan_loc') return 1;
              return a.unlockCost.compareTo(b.unlockCost);
            });
      return Scaffold(
        appBar: AppBar(
          title: Text(profile?.name ?? 'Lá số'),
          actions: <Widget>[
            IconButton(
              onPressed: controller.openEdit,
              icon: const Icon(Icons.edit_outlined),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          key: const ValueKey<String>('open_ai_button'),
          onPressed: controller.openAi,
          icon: const Icon(Icons.smart_toy_outlined),
          label: const Text('AI'),
        ),
        body: chart == null || profile == null
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                key: const ValueKey<String>('chart_result_scroll'),
                padding: const EdgeInsets.all(16),
                children: <Widget>[
                  AppCard(
                    color: AppColors.jadeSoft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                '${profile.name} • Năm xem ${controller.selectedYear.value}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            StatusPill(
                              label: profile.confidenceLabel,
                              background: profile.isLowConfidence
                                  ? AppColors.amberSoft
                                  : Colors.white,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${profile.gender.label} • ${profile.birthDateLabel} • ${profile.birthHourLabel}',
                        ),
                        const SizedBox(height: 8),
                        Text(profile.focusSummary),
                        if (profile.isLowConfidence) ...<Widget>[
                          const SizedBox(height: 12),
                          Text(
                            'Độ tin cậy thấp hơn do giờ sinh chưa chắc chắn.',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppColors.caution,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const SectionHeader(
                    title: 'Bàn lá số 12 cung',
                    subtitle: 'Chạm cung đã mở để xem luận giải chi tiết.',
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: <Widget>[
                      ...<int>[2025, 2026, 2027].map(
                        (int year) => ChoiceChip(
                          label: Text('$year'),
                          selected: controller.selectedYear.value == year,
                          onSelected: (_) => controller.changeYear(year),
                        ),
                      ),
                      FilterChip(
                        label: const Text('Đại vận'),
                        selected: controller.showMajorOverlay.value,
                        onSelected: (bool value) =>
                            controller.showMajorOverlay.value = value,
                      ),
                      FilterChip(
                        label: const Text('Tiểu vận'),
                        selected: controller.showMinorOverlay.value,
                        onSelected: (bool value) =>
                            controller.showMinorOverlay.value = value,
                      ),
                      FilterChip(
                        label: const Text('Lưu niên'),
                        selected: controller.showYearlyOverlay.value,
                        onSelected: (bool value) =>
                            controller.showYearlyOverlay.value = value,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AppCard(
                    padding: const EdgeInsets.all(10),
                    child: ChartBoard(
                      palaces: chart.palaces,
                      onTap: (ChartPalace palace) {
                        if (palace.isUnlocked) {
                          controller.openPalace(palace);
                        } else {
                          _openPaywall(context, palace);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Tổng quan ${controller.selectedYear.value}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        ...chart.overviewBullets.map(
                          (String bullet) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Padding(
                                  padding: EdgeInsets.only(top: 4),
                                  child: Icon(
                                    Icons.circle,
                                    size: 8,
                                    color: AppColors.jade,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(child: Text(bullet)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const SectionHeader(
                    title: 'Điểm theo mối quan tâm',
                    subtitle:
                        'Điểm là tương quan theo bộ quy tắc mẫu, không phải phán số tuyệt đối.',
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: chart.focusMetrics
                        .map(
                          (FocusMetric metric) => SizedBox(
                            width: 160,
                            child: AppCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    metric.label,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${metric.score}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(color: AppColors.jade),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    metric.insight,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: <Widget>[
                      FilledButton.tonal(
                        onPressed: controller.openPalaces,
                        child: const Text('Luận 12 cung'),
                      ),
                      FilledButton.tonal(
                        onPressed: controller.openMajor,
                        child: const Text('Đại vận'),
                      ),
                      FilledButton.tonal(
                        onPressed: controller.openMinor,
                        child: const Text('Tiểu vận'),
                      ),
                      FilledButton.tonal(
                        onPressed: controller.openMonthly,
                        child: const Text('Nguyệt vận'),
                      ),
                      FilledButton.tonal(
                        onPressed: controller.openDaily,
                        child: const Text('Nhật vận'),
                      ),
                      if (FeatureFlags.publicLifeMapEnabled)
                        FilledButton.tonal(
                          onPressed: controller.openLifeMap,
                          child: const Text('Life Map'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const SectionHeader(
                    title: 'Gợi ý mở khóa',
                    subtitle: 'Các mục này đang khóa bằng xu trong prototype.',
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 182,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: lockedPalaces.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 12),
                      itemBuilder: (BuildContext context, int index) {
                        final palace = lockedPalaces[index];
                        return SizedBox(
                          width: 240,
                          child: AppCard(
                            color: AppColors.amberSoft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  palace.name,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  palace.shortSummary,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Spacer(),
                                FilledButton.tonal(
                                  key: ValueKey<String>('unlock_${palace.key}'),
                                  onPressed: () =>
                                      _openPaywall(context, palace),
                                  child: Text('Mở ${palace.unlockCost} xu'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Vì sao app luận như vậy',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        ...chart.evidenceBullets.map(
                          (String item) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text('• $item'),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          chart.disclaimer,
                          style: Theme.of(context).textTheme.bodySmall,
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
