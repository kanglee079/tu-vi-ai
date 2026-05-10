import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/chart_models.dart';
import '../../../../data/models/wallet_models.dart';
import '../../../../data/repositories/wallet_repository.dart';
import '../../../../shared/navigation/route_args.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/paywall_sheet.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../controllers/palace_reading_controller.dart';

class PalaceReadingPage extends GetView<PalaceReadingController> {
  const PalaceReadingPage({super.key});

  Future<void> _showPaywall(BuildContext context, ChartPalace palace) async {
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
    return Scaffold(
      appBar: AppBar(title: const Text('Luận 12 cung')),
      body: Obx(
        () => ListView.separated(
          key: const ValueKey<String>('palace_list_scroll'),
          padding: const EdgeInsets.all(16),
          itemCount: controller.palaces.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (BuildContext context, int index) {
            final palace = controller.palaces[index];
            return AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          palace.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      StatusPill(
                        label: '${palace.score}',
                        background: palace.score >= 35
                            ? AppColors.jadeSoft
                            : AppColors.amberSoft,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(palace.shortSummary),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: <Widget>[
                      if (palace.isUnlocked)
                        const StatusPill(
                          label: 'Đã mở',
                          background: AppColors.jadeSoft,
                        )
                      else
                        StatusPill(
                          label: 'Mở ${palace.unlockCost} xu',
                          background: AppColors.amberSoft,
                        ),
                      ...palace.primaryStars.map(
                        (String star) => StatusPill(
                          label: star,
                          background: AppColors.ivory,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: <Widget>[
                      FilledButton.tonal(
                        onPressed: palace.isUnlocked
                            ? () => Get.toNamed(
                                AppRoutes.palaceDetail,
                                arguments: PalaceRouteArgs(
                                  profileId: controller.routeArgs.profileId,
                                  year: controller.routeArgs.year,
                                  palaceKey: palace.key,
                                ),
                              )
                            : () => _showPaywall(context, palace),
                        child: Text(
                          palace.isUnlocked ? 'Xem chi tiết' : 'Mở khóa',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
