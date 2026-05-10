import 'package:get/get.dart';

import '../../../../data/models/birth_profile.dart';
import '../../../../data/models/chart_models.dart';
import '../../../../data/models/daily_recommendation.dart';
import '../../../../data/repositories/chart_repository.dart';

class GoodBadDayController extends GetxController {
  GoodBadDayController(this._chartRepository);

  final ChartRepository _chartRepository;

  final Rxn<BirthProfile> mainProfile = Rxn<BirthProfile>();
  final Rxn<ChartSummary> chart = Rxn<ChartSummary>();
  final RxString selectedActivity = 'Khai trương'.obs;

  final List<String> activities = const <String>[
    'Khai trương',
    'Ký hợp đồng',
    'Chuyển nhà',
    'Gặp đối tác',
    'Học tập',
  ];

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    mainProfile.value = await _chartRepository.getMainProfile();
    final profile = mainProfile.value;
    if (profile != null) {
      chart.value = await _chartRepository.getChart(
        profile.id,
        DateTime.now().year,
      );
    }
  }

  List<DailyRecommendation> get recommendations =>
      chart.value?.dailyRecommendations ?? const <DailyRecommendation>[];
}
