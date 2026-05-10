import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../controllers/wallet_controller.dart';

class WalletPage extends GetView<WalletController> {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ví xu & gói')),
      body: Obx(() {
        final wallet = controller.wallet.value;
        if (wallet == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            AppCard(
              color: AppColors.jadeSoft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SectionHeader(
                    title: 'Số dư hiện tại',
                    subtitle:
                        'Prototype paywall cho coin packs, mở lẻ và subscription.',
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${wallet.balance} xu',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(wallet.activePlanLabel),
                  const SizedBox(height: 8),
                  Text(
                    controller.storeAvailable.value
                        ? 'Store khả dụng'
                        : 'Store chưa khả dụng trên thiết bị này',
                  ),
                ],
              ),
            ),
            if (controller.purchaseError.value.isNotEmpty) ...<Widget>[
              const SizedBox(height: 12),
              AppCard(
                color: AppColors.amberSoft,
                child: Text(controller.purchaseError.value),
              ),
            ],
            const SizedBox(height: 16),
            Text(
              'Sản phẩm hiển thị',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            ...controller.offers.map(
              (offer) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppCard(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              offer.title,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(offer.subtitle),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            offer.priceLabel,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 6),
                          StatusPill(
                            label: offer.badge,
                            background: AppColors.ivory,
                          ),
                          const SizedBox(height: 8),
                          FilledButton.tonal(
                            onPressed: controller.storeAvailable.value
                                ? () => controller.buyOffer(offer)
                                : null,
                            child: const Text('Mua'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: controller.restorePurchases,
              child: const Text('Khôi phục giao dịch'),
            ),
            const SizedBox(height: 8),
            Text(
              'Lịch sử gần đây',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            ...wallet.history.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppCard(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              entry.title,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              entry.createdAtLabel,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${entry.amount > 0 ? '+' : ''}${entry.amount}',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: entry.amount > 0
                                  ? AppColors.success
                                  : AppColors.caution,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (controller.storeProducts.isNotEmpty) ...<Widget>[
              const SizedBox(height: 12),
              AppCard(
                child: Text(
                  'Store products đã query: ${controller.storeProducts.keys.join(', ')}',
                ),
              ),
            ],
          ],
        );
      }),
    );
  }
}
