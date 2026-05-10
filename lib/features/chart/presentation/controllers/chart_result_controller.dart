import 'package:get/get.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../data/models/birth_profile.dart';
import '../../../../data/models/chart_models.dart';
import '../../../../data/repositories/chart_repository.dart';
import '../../../../shared/navigation/route_args.dart';

class ChartResultController extends GetxController {
  ChartResultController(this._chartRepository);

  final ChartRepository _chartRepository;

  final Rxn<BirthProfile> profile = Rxn<BirthProfile>();
  final Rxn<ChartSummary> chart = Rxn<ChartSummary>();
  final RxInt selectedYear = DateTime.now().year.obs;
  final RxBool showMajorOverlay = true.obs;
  final RxBool showMinorOverlay = true.obs;
  final RxBool showYearlyOverlay = true.obs;

  String? profileId;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is ChartRouteArgs) {
      profileId = args.profileId;
      selectedYear.value = args.year;
    }
    _load();
  }

  Future<void> _load() async {
    profile.value = profileId == null
        ? await _chartRepository.getMainProfile()
        : await _chartRepository.getProfile(profileId!);
    profileId = profile.value?.id;
    if (profileId == null) {
      return;
    }
    chart.value = await _chartRepository.getChart(
      profileId!,
      selectedYear.value,
    );
  }

  Future<void> changeYear(int year) async {
    selectedYear.value = year;
    if (profileId != null) {
      chart.value = await _chartRepository.getChart(profileId!, year);
    }
  }

  void openEdit() {
    if (profile.value == null) return;
    Get.toNamed(
      AppRoutes.chartForm,
      arguments: ChartFormArgs(profile: profile.value),
    );
  }

  void openPalaces() {
    if (profileId == null) return;
    Get.toNamed(
      AppRoutes.palaceList,
      arguments: ChartRouteArgs(
        profileId: profileId!,
        year: selectedYear.value,
      ),
    );
  }

  void openPalace(ChartPalace palace) {
    if (profileId == null || !palace.isUnlocked) return;
    Get.toNamed(
      AppRoutes.palaceDetail,
      arguments: PalaceRouteArgs(
        profileId: profileId!,
        year: selectedYear.value,
        palaceKey: palace.key,
      ),
    );
  }

  void openMajor() {
    if (profileId == null) return;
    Get.toNamed(
      AppRoutes.majorFortune,
      arguments: FortuneRouteArgs(
        profileId: profileId!,
        year: selectedYear.value,
      ),
    );
  }

  void openMinor() {
    if (profileId == null) return;
    Get.toNamed(
      AppRoutes.minorFortune,
      arguments: FortuneRouteArgs(
        profileId: profileId!,
        year: selectedYear.value,
      ),
    );
  }

  void openMonthly() {
    if (profileId == null) return;
    Get.toNamed(
      AppRoutes.monthlyFortune,
      arguments: FortuneRouteArgs(
        profileId: profileId!,
        year: selectedYear.value,
      ),
    );
  }

  void openDaily() {
    if (profileId == null) return;
    Get.toNamed(
      AppRoutes.dailyFortune,
      arguments: FortuneRouteArgs(
        profileId: profileId!,
        year: selectedYear.value,
      ),
    );
  }

  void openAi({String? seededQuestion}) {
    if (profileId == null) return;
    Get.toNamed(
      AppRoutes.aiAssistant,
      arguments: AiRouteArgs(
        profileId: profileId!,
        year: selectedYear.value,
        seedQuestion: seededQuestion,
      ),
    );
  }

  void openLifeMap() {
    if (profileId == null) return;
    Get.toNamed(
      AppRoutes.lifeMap,
      arguments: ChartRouteArgs(
        profileId: profileId!,
        year: selectedYear.value,
      ),
    );
  }
}
