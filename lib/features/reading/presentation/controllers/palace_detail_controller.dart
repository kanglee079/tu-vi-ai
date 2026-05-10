import 'package:get/get.dart';

import '../../../../data/models/chart_models.dart';
import '../../../../data/repositories/chart_repository.dart';
import '../../../../shared/navigation/route_args.dart';

class PalaceDetailController extends GetxController {
  PalaceDetailController(this._chartRepository);

  final ChartRepository _chartRepository;

  final Rxn<ChartPalace> palace = Rxn<ChartPalace>();
  late final PalaceRouteArgs routeArgs;

  @override
  void onInit() {
    super.onInit();
    routeArgs = Get.arguments as PalaceRouteArgs;
    _load();
  }

  Future<void> _load() async {
    palace.value = await _chartRepository.getPalaceReading(
      routeArgs.profileId,
      routeArgs.palaceKey,
    );
  }
}
