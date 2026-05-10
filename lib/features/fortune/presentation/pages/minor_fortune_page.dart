import 'package:get/get.dart';

import '../controllers/fortune_controller.dart';
import 'major_fortune_page.dart';

class MinorFortunePage extends FortuneTimelinePage {
  MinorFortunePage({super.key})
    : super(
        title: 'Tiểu vận',
        subtitle: 'Danh sách năm với marker năm hiện tại và cảnh báo chính.',
        items: () =>
            Get.find<FortuneController>().chart.value?.minorCycles ?? const [],
      );
}
