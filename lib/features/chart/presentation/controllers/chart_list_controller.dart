import 'package:get/get.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../data/models/birth_profile.dart';
import '../../../../data/repositories/chart_repository.dart';
import '../../../../shared/navigation/route_args.dart';

class ChartListController extends GetxController {
  ChartListController(this._chartRepository);

  final ChartRepository _chartRepository;

  final RxBool isLoading = true.obs;
  final RxList<BirthProfile> profiles = <BirthProfile>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadProfiles();
  }

  Future<void> loadProfiles() async {
    isLoading.value = true;
    profiles.assignAll(await _chartRepository.listProfiles());
    isLoading.value = false;
  }

  Future<void> setMainProfile(BirthProfile profile) async {
    await _chartRepository.saveProfile(profile.copyWith(isMain: true));
    await loadProfiles();
  }

  Future<void> deleteProfile(BirthProfile profile) async {
    await _chartRepository.deleteProfile(profile.id);
    await loadProfiles();
  }

  void openCreate() {
    Get.toNamed(AppRoutes.chartForm);
  }

  void openEdit(BirthProfile profile) {
    Get.toNamed(
      AppRoutes.chartForm,
      arguments: ChartFormArgs(profile: profile),
    );
  }

  void openResult(BirthProfile profile, {int? year}) {
    Get.toNamed(
      AppRoutes.chartResult,
      arguments: ChartRouteArgs(
        profileId: profile.id,
        year: year ?? DateTime.now().year,
      ),
    );
  }
}
