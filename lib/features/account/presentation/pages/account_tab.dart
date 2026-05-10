import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../core/config/feature_flags.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../controllers/account_controller.dart';

class AccountTab extends GetView<AccountController> {
  const AccountTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tài khoản')),
      body: Obx(() {
        final profile = controller.mainProfile.value;
        final wallet = controller.wallet.value;
        final session = controller.session.value;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            AppCard(
              color: AppColors.jadeSoft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SectionHeader(
                    title: 'Chế độ khách',
                    subtitle:
                        'Dữ liệu lá số đang ở local-first. Sync cloud và auth sẽ nối ở phase sau.',
                  ),
                  const SizedBox(height: 12),
                  Text(
                    profile?.name ?? 'Chưa có lá số chính',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (session != null) ...<Widget>[
                    const SizedBox(height: 8),
                    Text(
                      session.isAnonymous
                          ? 'Firebase session: khách'
                          : 'Firebase session: ${session.email ?? session.displayName ?? session.uid}',
                    ),
                  ],
                  if (wallet != null) ...<Widget>[
                    const SizedBox(height: 8),
                    Text('Số dư: ${wallet.balance} xu'),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Quản lý',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  FilledButton.tonal(
                    onPressed: () => Get.toNamed(AppRoutes.wallet),
                    child: const Text('Ví xu & paywall'),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.tonal(
                    onPressed: () => Get.toNamed(AppRoutes.auth),
                    child: Text(
                      session?.isAnonymous == false
                          ? 'Quản lý đăng nhập'
                          : 'Đăng nhập / Đăng ký',
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (session?.isAnonymous == false) ...<Widget>[
                    FilledButton.tonal(
                      onPressed: controller.signOut,
                      child: const Text('Đăng xuất'),
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (FeatureFlags.publicJournalEnabled) ...<Widget>[
                    FilledButton.tonal(
                      onPressed: () => Get.toNamed(AppRoutes.journal),
                      child: const Text('Nhật ký vận trình'),
                    ),
                    const SizedBox(height: 12),
                  ],
                  FilledButton.tonal(
                    onPressed: () => Get.toNamed(AppRoutes.starLookup),
                    child: const Text('Tra cứu sao'),
                  ),
                  const SizedBox(height: 12),
                  if (FeatureFlags.publicCompatibilityEnabled)
                    FilledButton.tonal(
                      onPressed: () => Get.toNamed(AppRoutes.compatibility),
                      child: const Text('So sánh nhân duyên'),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Lưu ý sản phẩm'),
                  SizedBox(height: 8),
                  Text(
                    'Nội dung trong app mang tính tham khảo, chiêm nghiệm và hỗ trợ tự hiểu bản thân.',
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
