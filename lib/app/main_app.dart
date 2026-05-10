import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/theme/app_theme.dart';
import '../data/mock/prototype_dependencies.dart';
import 'bindings/app_binding.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

class MinhMenhAiApp extends StatelessWidget {
  const MinhMenhAiApp({
    super.key,
    this.dependencies,
    this.initialRoute = AppRoutes.splash,
  });

  final AppDependencies? dependencies;
  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    final resolvedDependencies = dependencies ?? AppDependencies.prototype();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Minh Mệnh AI',
      theme: AppTheme.light(),
      initialRoute: initialRoute,
      initialBinding: AppBinding(resolvedDependencies),
      getPages: AppPages.pages,
    );
  }
}
