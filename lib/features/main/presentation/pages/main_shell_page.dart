import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../account/presentation/pages/account_tab.dart';
import '../../../chart/presentation/pages/chart_list_tab.dart';
import '../../../day/presentation/pages/good_bad_day_tab.dart';
import '../../../knowledge/presentation/pages/knowledge_tab.dart';
import '../controllers/main_shell_controller.dart';

class MainShellPage extends GetView<MainShellController> {
  const MainShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tabs = <Widget>[
      const ChartListTab(),
      const GoodBadDayTab(),
      const KnowledgeTab(),
      const AccountTab(),
    ];

    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: tabs,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_rounded),
              label: 'Lá số',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'Xem ngày',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined),
              label: 'Kiến thức',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Tài khoản',
            ),
          ],
        ),
      ),
    );
  }
}
