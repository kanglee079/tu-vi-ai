import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/insight_models.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../controllers/journal_controller.dart';

class JournalPage extends GetView<JournalController> {
  const JournalPage({super.key});

  IconData _iconForMood(JournalMood mood) {
    switch (mood) {
      case JournalMood.bright:
        return Icons.wb_sunny_outlined;
      case JournalMood.deep:
        return Icons.dark_mode_outlined;
      case JournalMood.mist:
        return Icons.cloud_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final reflection = controller.reflection.value;
      return Scaffold(
        appBar: AppBar(title: const Text('Nhật ký vận trình')),
        body: ListView(
          key: const ValueKey<String>('journal_scroll'),
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            const AppCard(
              child: SectionHeader(
                title: 'Khí sắc hôm nay',
                subtitle:
                    'Prototype journal lưu local qua mock repository để chuẩn bị cho phase đồng bộ sau.',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: JournalMood.values
                  .map(
                    (mood) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: mood == JournalMood.mist ? 0 : 8,
                        ),
                        child: InkWell(
                          onTap: () => controller.selectedMood.value = mood,
                          child: AppCard(
                            color: controller.selectedMood.value == mood
                                ? AppColors.jadeSoft
                                : null,
                            child: Column(
                              children: <Widget>[
                                Icon(_iconForMood(mood), color: AppColors.ink),
                                const SizedBox(height: 8),
                                Text(
                                  mood.label,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    controller: controller.noteController,
                    minLines: 5,
                    maxLines: 8,
                    decoration: const InputDecoration(
                      hintText:
                          'Ghi lại điều gì đang khuấy động tâm trí bạn hôm nay...',
                      border: InputBorder.none,
                      filled: false,
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    key: const ValueKey<String>('journal_save_button'),
                    onPressed: controller.saveEntry,
                    child: const Text('Lưu lại'),
                  ),
                ],
              ),
            ),
            if (reflection != null) ...<Widget>[
              const SizedBox(height: 16),
              AppCard(
                color: AppColors.ivory,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      reflection.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Text(reflection.body),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: reflection.tags
                          .map(
                            (tag) => StatusPill(
                              label: tag,
                              background: Colors.white,
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            const SectionHeader(
              title: 'Lịch sử vận trình',
              subtitle:
                  'Các entry gần đây đang dùng mock data và lưu in-memory trong phiên chạy.',
            ),
            const SizedBox(height: 12),
            ...controller.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.ivory,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(_iconForMood(entry.mood)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    entry.title,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                ),
                                StatusPill(
                                  label: entry.sentimentLabel,
                                  background: AppColors.amberSoft,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              entry.createdAtLabel,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 8),
                            Text(entry.body),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
