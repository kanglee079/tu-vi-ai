import 'package:get/get.dart';

import '../../../../data/models/chart_models.dart';
import '../../../../data/repositories/chart_repository.dart';
import '../../../../shared/navigation/route_args.dart';

class FortuneController extends GetxController {
  FortuneController(this._chartRepository);

  final ChartRepository _chartRepository;

  final Rxn<ChartSummary> chart = Rxn<ChartSummary>();
  late final FortuneRouteArgs routeArgs;

  @override
  void onInit() {
    super.onInit();
    routeArgs = Get.arguments as FortuneRouteArgs;
    _load();
  }

  Future<void> _load() async {
    chart.value = await _chartRepository.getChart(
      routeArgs.profileId,
      routeArgs.year,
    );
  }
}
