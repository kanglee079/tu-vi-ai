import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../controllers/ai_assistant_controller.dart';

class AiAssistantPage extends GetView<AiAssistantController> {
  const AiAssistantPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trợ lý AI Tử Vi')),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            const AppCard(
              child: SectionHeader(
                title: 'AI chỉ diễn giải từ dữ liệu có cấu trúc',
                subtitle:
                    'Engine sinh facts, knowledge base nội bộ cung cấp rules, AI chỉ rewrite theo JSON schema. Không cào hoặc copy nguyên văn sách.',
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.prompts
                  .map(
                    (prompt) => ActionChip(
                      label: Text(prompt.label),
                      onPressed: () => controller.ask(preset: prompt.prompt),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.questionController,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Hỏi sâu hơn về lá số của bạn',
                hintText:
                    'Ví dụ: Năm nay công việc của tôi nên tập trung điều gì?',
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: controller.isLoading.value ? null : controller.ask,
              child: Text(
                controller.isLoading.value
                    ? 'Đang luận giải...'
                    : 'Gửi câu hỏi',
              ),
            ),
            const SizedBox(height: 16),
            ...controller.messages.map(
              (message) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Align(
                  alignment: message.role == 'user'
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 320),
                    child: AppCard(
                      color: message.role == 'user'
                          ? AppColors.jadeSoft
                          : AppColors.surface,
                      child: Text(message.content),
                    ),
                  ),
                ),
              ),
            ),
            if (controller.latestResponse.value != null) ...<Widget>[
              AppCard(
                color: AppColors.ivory,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      controller.latestResponse.value!.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(controller.latestResponse.value!.detailedReading),
                    const SizedBox(height: 16),
                    Text(
                      'Dựa trên yếu tố nào',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    ...controller.latestResponse.value!.evidence.map(
                      (evidence) =>
                          Text('• ${evidence.factor}: ${evidence.meaning}'),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nên làm',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    ...controller.latestResponse.value!.practicalAdvice.map(
                      (item) => Text('✓ $item'),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nên tránh',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    ...controller.latestResponse.value!.avoid.map(
                      (item) => Text('✕ $item'),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
