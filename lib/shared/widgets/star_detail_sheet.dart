import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/mock/knowledge_base.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/status_pill.dart';

/// Shared star detail bottom sheet — used by both palace detail and star lookup.
void showStarDetailSheet(BuildContext context, String starName) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => StarDetailSheet(starName: starName),
  );
}

class StarDetailSheet extends StatelessWidget {
  const StarDetailSheet({super.key, required this.starName});

  final String starName;

  @override
  Widget build(BuildContext context) {
    final knowledge = starKnowledgeBase[starName];
    final isMajor = knowledge?.type == StarType.major;
    final primaryColor = isMajor == true ? AppColors.jade : AppColors.amber;

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Drag handle
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

              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isMajor == true ? Icons.star : Icons.star_border,
                      color: primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          starName,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        Text(
                          isMajor == true ? 'Chính tinh' : 'Phụ tinh',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Element & keywords
              if (knowledge != null) ...<Widget>[
                if (knowledge.element.isNotEmpty)
                  StatusPill(
                    label: 'Ngũ hành: ${knowledge.element}',
                    background: AppColors.ivory,
                  ),
                const SizedBox(height: 12),

                if (knowledge.keywords.isNotEmpty) ...<Widget>[
                  Text('Đặc điểm',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: knowledge.keywords
                        .map((k) => Chip(
                              label: Text(k, style: const TextStyle(fontSize: 11)),
                              backgroundColor: AppColors.ivory,
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                ],

                // Positive
                AppCard(
                  color: AppColors.jadeSoft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.thumb_up_outlined,
                              size: 16, color: AppColors.jade),
                          const SizedBox(width: 6),
                          Text('Tác động tích cực',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: AppColors.jade)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(knowledge.positive),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Negative
                AppCard(
                  color: AppColors.caution.withValues(alpha: 0.08),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.warning_outlined,
                              size: 16, color: AppColors.caution),
                          const SizedBox(width: 6),
                          Text('Lưu ý',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: AppColors.caution)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(knowledge.negative),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Advice
                AppCard(
                  color: AppColors.ivory,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.lightbulb_outline,
                              size: 16, color: AppColors.amber),
                          const SizedBox(width: 6),
                          Text('Lời khuyên',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: AppColors.amber)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(knowledge.advice),
                    ],
                  ),
                ),
              ] else ...<Widget>[
                AppCard(
                  color: AppColors.ivory,
                  child: Text(
                    'Sao này đang trong quá trình bổ sung dữ liệu. '
                    'Thông tin cơ bản: $starName là ${isMajor == true ? 'chính tinh' : 'phụ tinh'} trong lá số Tử Vi.',
                  ),
                ),
              ],
              const SizedBox(height: 16),

              // Close button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Đóng'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
