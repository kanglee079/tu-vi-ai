import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/wallet_models.dart';
import 'app_card.dart';
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
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.line,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                Row(
                  children: [
                    const Icon(Icons.lock_outline, color: AppColors.amber),
                    const SizedBox(width: 8),
                    Text(
                      'Mở khóa: ${preview.title}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  preview.reason,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.ink.withValues(alpha: 0.7),
                      ),
                ),
                const SizedBox(height: 16),

                // Cost summary
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.amberSoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Chi phí mở khóa',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${preview.cost} xu',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: AppColors.amber,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: AppColors.line.withValues(alpha: 0.4),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Số dư hiện có',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${wallet.balance} xu',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      color: wallet.balance >= preview.cost
                                          ? AppColors.jade
                                          : AppColors.caution,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Can afford badge
                if (wallet.balance >= preview.cost)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.jadeSoft,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle, color: AppColors.jade, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'Bạn đủ xu để mở khóa',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.jade,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.caution.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.info_outline, color: AppColors.caution, size: 16),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            preview.alternativeOffer,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.caution,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),

                // Offers
                Text(
                  'Chọn cách nạp xu',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 12),

                ...offers.map((WalletOffer offer) {
                  final isBestValue = offer.badge.contains('Phổ biến') ||
                      offer.badge.contains('best') ||
                      offer.badge.contains('tiết kiệm');
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AppCard(
                      color: isBestValue ? AppColors.jadeSoft : null,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: [
                                    if (isBestValue) ...[
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.jade,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          'Best value',
                                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                    Expanded(
                                      child: Text(
                                        offer.title,
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  offer.subtitle,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppColors.ink.withValues(alpha: 0.7),
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                offer.priceLabel,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: AppColors.jade,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              if (offer.badge.isNotEmpty)
                                StatusPill(
                                  label: offer.badge,
                                  background: AppColors.amberSoft,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 16),

                // CTA buttons
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Đóng'),
                ),
                const SizedBox(height: 8),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Xem thêm cách kiếm xu miễn phí',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.ink.withValues(alpha: 0.6),
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
