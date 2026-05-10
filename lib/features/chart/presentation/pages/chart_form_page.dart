import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../data/models/birth_profile.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../controllers/chart_form_controller.dart';

class ChartFormPage extends GetView<ChartFormController> {
  const ChartFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.editingProfile == null ? 'Lập lá số mới' : 'Sửa lá số',
        ),
      ),
      body: Obx(
        () => ListView(
          key: const ValueKey<String>('chart_form_scroll'),
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            const AppCard(
              child: SectionHeader(
                title: 'Thông tin đầu vào',
                subtitle:
                    'MVP UI ưu tiên đầy đủ field và state shape cho engine giai đoạn sau.',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.nameController,
              decoration: const InputDecoration(labelText: 'Họ tên'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<Gender>(
              initialValue: controller.gender.value,
              decoration: const InputDecoration(labelText: 'Giới tính'),
              items: Gender.values
                  .map(
                    (Gender gender) => DropdownMenuItem<Gender>(
                      value: gender,
                      child: Text(gender.label),
                    ),
                  )
                  .toList(),
              onChanged: (Gender? value) {
                if (value != null) controller.gender.value = value;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<CalendarType>(
              initialValue: controller.calendarType.value,
              decoration: const InputDecoration(labelText: 'Loại lịch'),
              items: CalendarType.values
                  .map(
                    (CalendarType type) => DropdownMenuItem<CalendarType>(
                      value: type,
                      child: Text(type.label),
                    ),
                  )
                  .toList(),
              onChanged: (CalendarType? value) {
                if (value != null) controller.calendarType.value = value;
              },
            ),
            const SizedBox(height: 12),
            AppCard(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Ngày sinh',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppFormatters.fullDate(controller.birthDate.value),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () => controller.pickDate(context),
                    child: const Text('Chọn ngày'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: controller.birthHourLabel.value,
              decoration: const InputDecoration(labelText: 'Giờ sinh'),
              items: controller.birthHours
                  .map(
                    (String hour) => DropdownMenuItem<String>(
                      value: hour,
                      child: Text(hour),
                    ),
                  )
                  .toList(),
              onChanged: (String? value) {
                if (value != null) controller.birthHourLabel.value = value;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<BirthTimeConfidence>(
              initialValue: controller.confidence.value,
              decoration: const InputDecoration(
                labelText: 'Độ chắc chắn giờ sinh',
              ),
              items: BirthTimeConfidence.values
                  .map(
                    (BirthTimeConfidence confidence) =>
                        DropdownMenuItem<BirthTimeConfidence>(
                          value: confidence,
                          child: Text(confidence.label),
                        ),
                  )
                  .toList(),
              onChanged: (BirthTimeConfidence? value) {
                if (value != null) controller.confidence.value = value;
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller.placeController,
              decoration: const InputDecoration(
                labelText: 'Nơi sinh',
                hintText: 'Ví dụ: Cà Mau, Việt Nam',
              ),
            ),
            const SizedBox(height: 16),
            AppCard(
              color: AppColors.ivory,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Mối quan tâm chính',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: MainFocus.values
                        .map(
                          (MainFocus focus) => FilterChip(
                            selected: controller.selectedFocus.contains(focus),
                            label: Text(focus.label),
                            onSelected: (_) => controller.toggleFocus(focus),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Đặt làm lá số chính'),
              subtitle: const Text(
                'Lá số này sẽ được dùng cho xem ngày cá nhân hóa.',
              ),
              value: controller.isMain.value,
              onChanged: (bool value) => controller.isMain.value = value,
            ),
            if (controller.confidence.value !=
                BirthTimeConfidence.exact) ...<Widget>[
              const SizedBox(height: 12),
              const StatusPill(
                label: 'Độ tin cậy thấp hơn do giờ sinh chưa chắc chắn.',
                background: AppColors.amberSoft,
                icon: Icons.info_outline,
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(
              key: const ValueKey<String>('chart_save_button'),
              onPressed: controller.save,
              child: const Text('Lưu và xem lá số'),
            ),
          ],
        ),
      ),
    );
  }
}
