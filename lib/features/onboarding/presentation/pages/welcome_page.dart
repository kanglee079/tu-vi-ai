import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/navigation/route_args.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/status_pill.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.jade,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.grid_view_rounded,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Minh Mệnh AI',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Hiểu lá số, nắm vận trình và chọn ngày phù hợp.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const AppCard(
                color: AppColors.jadeSoft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SectionHeader(
                      title: 'Prototype milestone',
                      subtitle:
                          'Flow chính đã dựng bằng mock data và contract nội bộ.',
                    ),
                    SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: <Widget>[
                        StatusPill(
                          label: 'Local-first',
                          background: Colors.white,
                        ),
                        StatusPill(label: '12 cung', background: Colors.white),
                        StatusPill(
                          label: 'AI giải thích',
                          background: Colors.white,
                        ),
                        StatusPill(
                          label: 'Ngày tốt xấu',
                          background: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: const <Widget>[
                    _FeatureTile(
                      icon: Icons.account_tree_outlined,
                      title: 'Lập lá số và xem 12 cung',
                      subtitle:
                          'Tạo nhiều hồ sơ, chọn lá số chính và xem bàn lá số theo năm.',
                    ),
                    SizedBox(height: 12),
                    _FeatureTile(
                      icon: Icons.insights_outlined,
                      title: 'Đại vận, tiểu vận, nguyệt vận, nhật vận',
                      subtitle:
                          'Các màn hình timeline và luận giải đã có đầy đủ state mẫu.',
                    ),
                    SizedBox(height: 12),
                    _FeatureTile(
                      icon: Icons.smart_toy_outlined,
                      title: 'AI chỉ diễn giải từ dữ liệu cấu trúc',
                      subtitle:
                          'Quick prompts, evidence và gợi ý câu hỏi tiếp theo.',
                    ),
                  ],
                ),
              ),
              FilledButton(
                key: const ValueKey<String>('guest_start_button'),
                onPressed: () => Get.offAllNamed(AppRoutes.main),
                child: const Text('Trải nghiệm ngay'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Get.toNamed(AppRoutes.auth),
                child: const Text('Đăng nhập / Đăng ký'),
              ),
              const SizedBox(height: 12),
              TextButton(
                key: const ValueKey<String>('demo_chart_button'),
                onPressed: () {
                  Get.toNamed(
                    AppRoutes.chartResult,
                    arguments: const ChartRouteArgs(
                      profileId: 'profile_001',
                      year: 2026,
                    ),
                  );
                },
                child: const Text('Xem lá số minh họa'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.ivory,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.jade),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
