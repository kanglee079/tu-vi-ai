import 'package:get/get.dart';

import '../../../../data/models/birth_profile.dart';
import '../../../../data/models/insight_models.dart';
import '../../../../data/repositories/chart_repository.dart';
import '../../../../data/repositories/insight_repository.dart';
import '../../../../shared/navigation/route_args.dart';

class LifeMapController extends GetxController {
  LifeMapController(this._chartRepository, this._insightRepository);

  final ChartRepository _chartRepository;
  final InsightRepository _insightRepository;

  final Rxn<BirthProfile> profile = Rxn<BirthProfile>();
  final Rxn<LifeMapSummary> summary = Rxn<LifeMapSummary>();

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    final args = Get.arguments;
    String? profileId;
    int year = DateTime.now().year;
    if (args is ChartRouteArgs) {
      profileId = args.profileId;
      year = args.year;
    }
    profile.value = profileId == null
        ? await _chartRepository.getMainProfile()
        : await _chartRepository.getProfile(profileId);
    final resolvedProfile = profile.value;
    if (resolvedProfile == null) {
      return;
    }
    summary.value = await _insightRepository.getLifeMap(
      resolvedProfile.id,
      year,
    );
  }
}
