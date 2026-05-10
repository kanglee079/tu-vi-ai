import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../data/models/birth_profile.dart';
import '../../../../data/repositories/chart_repository.dart';
import '../../../../shared/navigation/route_args.dart';

class ChartFormController extends GetxController {
  ChartFormController(this._chartRepository);

  final ChartRepository _chartRepository;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final Rx<Gender> gender = Gender.male.obs;
  final Rx<CalendarType> calendarType = CalendarType.solar.obs;
  final Rx<BirthTimeConfidence> confidence = BirthTimeConfidence.exact.obs;
  final Rx<DateTime> birthDate = DateTime(2002, 10, 12).obs;
  final RxString birthHourLabel = 'Sửu (01:00 - 02:59)'.obs;
  final RxBool isMain = false.obs;
  final RxList<MainFocus> selectedFocus = <MainFocus>[
    MainFocus.career,
    MainFocus.wealth,
  ].obs;

  BirthProfile? editingProfile;

  final List<String> birthHours = const <String>[
    'Tý (23:00 - 00:59)',
    'Sửu (01:00 - 02:59)',
    'Dần (03:00 - 04:59)',
    'Mão (05:00 - 06:59)',
    'Thìn (07:00 - 08:59)',
    'Tỵ (09:00 - 10:59)',
    'Ngọ (11:00 - 12:59)',
    'Mùi (13:00 - 14:59)',
    'Thân (15:00 - 16:59)',
    'Dậu (17:00 - 18:59)',
    'Tuất (19:00 - 20:59)',
    'Hợi (21:00 - 22:59)',
    'Không rõ giờ sinh',
  ];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is ChartFormArgs && args.profile != null) {
      editingProfile = args.profile;
      final profile = args.profile!;
      nameController.text = profile.name;
      placeController.text = profile.birthPlace ?? '';
      gender.value = profile.gender;
      calendarType.value = profile.calendarType;
      confidence.value = profile.birthTimeConfidence;
      birthDate.value = profile.birthDate;
      birthHourLabel.value = profile.birthHourLabel;
      isMain.value = profile.isMain;
      selectedFocus.assignAll(profile.mainFocus);
    } else {
      isMain.value = true;
    }
  }

  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      initialDate: birthDate.value,
    );
    if (picked != null) {
      birthDate.value = picked;
    }
  }

  void toggleFocus(MainFocus focus) {
    if (selectedFocus.contains(focus)) {
      if (selectedFocus.length > 1) {
        selectedFocus.remove(focus);
      }
      return;
    }
    selectedFocus.add(focus);
  }

  Future<void> save() async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar('Thiếu thông tin', 'Vui lòng nhập họ tên để tạo lá số.');
      return;
    }

    final profile = BirthProfile(
      id:
          editingProfile?.id ??
          'profile_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      gender: gender.value,
      calendarType: calendarType.value,
      birthDate: birthDate.value,
      birthHourLabel: birthHourLabel.value,
      timezone: 'Asia/Ho_Chi_Minh',
      birthTimeConfidence: confidence.value,
      mainFocus: selectedFocus.toList(),
      isMain: isMain.value,
      birthPlace: placeController.text.trim().isEmpty
          ? null
          : placeController.text.trim(),
    );

    await _chartRepository.saveProfile(profile);
    Get.offNamed(
      AppRoutes.chartResult,
      arguments: ChartRouteArgs(
        profileId: profile.id,
        year: DateTime.now().year,
      ),
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    placeController.dispose();
    super.onClose();
  }
}
