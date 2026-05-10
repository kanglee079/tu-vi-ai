import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/wallet_models.dart';
import 'app_card.dart';
import 'section_header.dart';
import 'status_pill.dart';

Future<void> showPrototypePaywallSheet({
  required BuildContext context,
  required UnlockPreview preview,
  required WalletSnapshot wallet,
  required List<WalletOffer> offers,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return SafeArea(
        child: Container(
          key: const ValueKey<String>('paywall_sheet'),
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SectionHeader(
                  title: 'Mở khóa nội dung',
                  subtitle: 'Prototype paywall cho xu, mua lẻ và gói tháng.',
                ),
                const SizedBox(height: 16),
                AppCard(
                  color: AppColors.ivory,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        preview.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(preview.reason),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: <Widget>[
                          StatusPill(
                            label: 'Cần ${preview.cost} xu',
                            background: AppColors.amberSoft,
                          ),
                          StatusPill(
                            label: 'Số dư còn ${preview.remainingBalance} xu',
                            background: AppColors.jadeSoft,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Các gói đang hiển thị',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                ...offers.map(
                  (WalletOffer offer) => Padding(
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
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(offer.subtitle),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
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
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                AppCard(
                  color: AppColors.jadeSoft,
                  child: Text(
                    'Số dư hiện tại: ${wallet.balance} xu. ${preview.alternativeOffer}',
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Đóng'),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
