import 'package:get/get.dart';

import '../../../../data/models/birth_profile.dart';
import '../../../../data/models/insight_models.dart';
import '../../../../data/repositories/chart_repository.dart';
import '../../../../data/repositories/compatibility_repository.dart';

class CompatibilityController extends GetxController {
  CompatibilityController(this._chartRepository, this._compatibilityRepository);

  final ChartRepository _chartRepository;
  final CompatibilityRepository _compatibilityRepository;

  final Rxn<BirthProfile> primaryProfile = Rxn<BirthProfile>();
  final RxList<BirthProfile> otherProfiles = <BirthProfile>[].obs;
  final Rxn<BirthProfile> secondaryProfile = Rxn<BirthProfile>();
  final Rxn<CompatibilityReport> report = Rxn<CompatibilityReport>();

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    final profiles = await _chartRepository.listProfiles();
    final main = await _chartRepository.getMainProfile();
    primaryProfile.value = main;
    otherProfiles.assignAll(
      profiles.where((BirthProfile item) => item.id != main?.id).toList(),
    );
    if (otherProfiles.isNotEmpty) {
      secondaryProfile.value = otherProfiles.first;
      await refreshReport();
    }
  }

  Future<void> changeSecondary(BirthProfile profile) async {
    secondaryProfile.value = profile;
    await refreshReport();
  }

  Future<void> refreshReport() async {
    if (primaryProfile.value == null || secondaryProfile.value == null) {
      return;
    }
    report.value = await _compatibilityRepository.compareProfiles(
      primaryProfile.value!.id,
      secondaryProfile.value!.id,
    );
  }
}
