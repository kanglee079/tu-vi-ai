import 'package:get/get.dart';

import '../../../../data/models/chart_models.dart';
import '../../../../data/repositories/chart_repository.dart';
import '../../../../shared/navigation/route_args.dart';

class PalaceReadingController extends GetxController {
  PalaceReadingController(this._chartRepository);

  final ChartRepository _chartRepository;

  final RxList<ChartPalace> palaces = <ChartPalace>[].obs;
  late final ChartRouteArgs routeArgs;

  @override
  void onInit() {
    super.onInit();
    routeArgs = Get.arguments as ChartRouteArgs;
    _load();
  }

  Future<void> _load() async {
    final chart = await _chartRepository.getChart(
      routeArgs.profileId,
      routeArgs.year,
    );
    palaces.assignAll(chart.palaces);
  }
}
