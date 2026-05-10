import 'package:get/get.dart';

import '../../data/repositories/ai_assistant_repository.dart';
import '../../data/repositories/chart_repository.dart';
import '../../data/repositories/compatibility_repository.dart';
import '../../data/repositories/insight_repository.dart';
import '../../data/repositories/wallet_repository.dart';
import '../../core/services/iap_verification_service.dart';
import '../../core/services/purchase_client_service.dart';
import '../../features/account/presentation/controllers/account_controller.dart';
import '../../features/account/presentation/pages/account_tab.dart';
import '../../core/services/app_auth_service.dart';
import '../../features/ai/presentation/controllers/ai_assistant_controller.dart';
import '../../features/ai/presentation/pages/ai_assistant_page.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/pages/auth_placeholder_page.dart';
import '../../features/chart/presentation/controllers/chart_form_controller.dart';
import '../../features/chart/presentation/controllers/chart_list_controller.dart';
import '../../features/chart/presentation/controllers/chart_result_controller.dart';
import '../../features/chart/presentation/pages/chart_form_page.dart';
import '../../features/chart/presentation/pages/chart_list_tab.dart';
import '../../features/chart/presentation/pages/chart_result_page.dart';
import '../../features/compatibility/presentation/controllers/compatibility_controller.dart';
import '../../features/compatibility/presentation/pages/compatibility_page.dart';
import '../../features/day/presentation/controllers/good_bad_day_controller.dart';
import '../../features/day/presentation/pages/good_bad_day_tab.dart';
import '../../features/fortune/presentation/controllers/fortune_controller.dart';
import '../../features/fortune/presentation/pages/daily_fortune_page.dart';
import '../../features/fortune/presentation/pages/major_fortune_page.dart';
import '../../features/fortune/presentation/pages/minor_fortune_page.dart';
import '../../features/fortune/presentation/pages/monthly_fortune_page.dart';
import '../../features/insight/presentation/controllers/journal_controller.dart';
import '../../features/insight/presentation/controllers/life_map_controller.dart';
import '../../features/insight/presentation/pages/journal_page.dart';
import '../../features/insight/presentation/pages/life_map_page.dart';
import '../../features/knowledge/presentation/controllers/knowledge_controller.dart';
import '../../features/knowledge/presentation/pages/article_detail_page.dart';
import '../../features/knowledge/presentation/pages/knowledge_tab.dart';
import '../../features/main/presentation/controllers/main_shell_controller.dart';
import '../../features/main/presentation/pages/main_shell_page.dart';
import '../../features/onboarding/presentation/pages/splash_page.dart';
import '../../features/onboarding/presentation/pages/welcome_page.dart';
import '../../features/reading/presentation/controllers/palace_detail_controller.dart';
import '../../features/reading/presentation/controllers/palace_reading_controller.dart';
import '../../features/reading/presentation/pages/palace_detail_page.dart';
import '../../features/reading/presentation/pages/palace_reading_page.dart';
import '../../features/wallet/presentation/controllers/wallet_controller.dart';
import '../../features/wallet/presentation/pages/wallet_page.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = <GetPage<dynamic>>[
    GetPage<dynamic>(name: AppRoutes.splash, page: () => const SplashPage()),
    GetPage<dynamic>(name: AppRoutes.welcome, page: () => const WelcomePage()),
    GetPage<dynamic>(
      name: AppRoutes.auth,
      page: () => const AuthPlaceholderPage(),
      binding: BindingsBuilder(
        () => Get.lazyPut<AuthController>(
          () => AuthController(Get.find<AppAuthService>()),
        ),
      ),
    ),
    GetPage<dynamic>(
      name: AppRoutes.main,
      page: () => const MainShellPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut<MainShellController>(
          () => MainShellController(),
          fenix: true,
        );
        Get.lazyPut<ChartListController>(
          () => ChartListController(Get.find<ChartRepository>()),
          fenix: true,
        );
        Get.lazyPut<GoodBadDayController>(
          () => GoodBadDayController(Get.find<ChartRepository>()),
          fenix: true,
        );
        Get.lazyPut<KnowledgeController>(
          () => KnowledgeController(),
          fenix: true,
        );
        Get.lazyPut<AccountController>(
          () => AccountController(
            Get.find<ChartRepository>(),
            Get.find<WalletRepository>(),
            Get.find<AppAuthService>(),
          ),
          fenix: true,
        );
      }),
    ),
    GetPage<dynamic>(
      name: AppRoutes.chartForm,
      page: () => const ChartFormPage(),
      binding: BindingsBuilder(
        () => Get.lazyPut<ChartFormController>(
          () => ChartFormController(Get.find<ChartRepository>()),
        ),
      ),
    ),
    GetPage<dynamic>(
      name: AppRoutes.chartResult,
      page: () => const ChartResultPage(),
      binding: BindingsBuilder(
        () => Get.lazyPut<ChartResultController>(
          () => ChartResultController(Get.find<ChartRepository>()),
        ),
      ),
    ),
    GetPage<dynamic>(
      name: AppRoutes.palaceList,
      page: () => const PalaceReadingPage(),
      binding: BindingsBuilder(
        () => Get.lazyPut<PalaceReadingController>(
          () => PalaceReadingController(Get.find<ChartRepository>()),
        ),
      ),
    ),
    GetPage<dynamic>(
      name: AppRoutes.palaceDetail,
      page: () => const PalaceDetailPage(),
      binding: BindingsBuilder(
        () => Get.lazyPut<PalaceDetailController>(
          () => PalaceDetailController(Get.find<ChartRepository>()),
        ),
      ),
    ),
    GetPage<dynamic>(
      name: AppRoutes.majorFortune,
      page: () => const MajorFortunePage(),
      binding: BindingsBuilder(
        () => Get.lazyPut<FortuneController>(
          () => FortuneController(Get.find<ChartRepository>()),
        ),
      ),
    ),
    GetPage<dynamic>(
      name: AppRoutes.minorFortune,
      page: () => MinorFortunePage(),
      binding: BindingsBuilder(
        () => Get.lazyPut<FortuneController>(
          () => FortuneController(Get.find<ChartRepository>()),
        ),
      ),
    ),
    GetPage<dynamic>(
      name: AppRoutes.monthlyFortune,
      page: () => const MonthlyFortunePage(),
      binding: BindingsBuilder(
        () => Get.lazyPut<FortuneController>(
          () => FortuneController(Get.find<ChartRepository>()),
        ),
      ),
    ),
    GetPage<dynamic>(
      name: AppRoutes.dailyFortune,
      page: () => const DailyFortunePage(),
      binding: BindingsBuilder(
        () => Get.lazyPut<FortuneController>(
          () => FortuneController(Get.find<ChartRepository>()),
        ),
      ),
    ),
    GetPage<dynamic>(
      name: AppRoutes.aiAssistant,
      page: () => const AiAssistantPage(),
      binding: BindingsBuilder(
        () => Get.lazyPut<AiAssistantController>(
          () => AiAssistantController(Get.find<AiAssistantRepository>()),
        ),
      ),
    ),
    GetPage<dynamic>(
      name: AppRoutes.articleDetail,
      page: () => const ArticleDetailPage(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.wallet,
      page: () => const WalletPage(),
      binding: BindingsBuilder(
        () => Get.lazyPut<WalletController>(
          () => WalletController(
            Get.find<WalletRepository>(),
            Get.find<PurchaseClientService>(),
            IapVerificationService(Get.find()),
          ),
        ),
      ),
    ),
    GetPage<dynamic>(
      name: AppRoutes.lifeMap,
      page: () => const LifeMapPage(),
      binding: BindingsBuilder(
        () => Get.lazyPut<LifeMapController>(
          () => LifeMapController(
            Get.find<ChartRepository>(),
            Get.find<InsightRepository>(),
          ),
        ),
      ),
    ),
    GetPage<dynamic>(
      name: AppRoutes.journal,
      page: () => const JournalPage(),
      binding: BindingsBuilder(
        () => Get.lazyPut<JournalController>(
          () => JournalController(
            Get.find<ChartRepository>(),
            Get.find<InsightRepository>(),
          ),
        ),
      ),
    ),
    GetPage<dynamic>(
      name: AppRoutes.compatibility,
      page: () => const CompatibilityPage(),
      binding: BindingsBuilder(
        () => Get.lazyPut<CompatibilityController>(
          () => CompatibilityController(
            Get.find<ChartRepository>(),
            Get.find<CompatibilityRepository>(),
          ),
        ),
      ),
    ),
    GetPage<dynamic>(
      name: '/debug/chart-tab',
      page: () => const ChartListTab(),
      binding: BindingsBuilder(
        () => Get.lazyPut<ChartListController>(
          () => ChartListController(Get.find<ChartRepository>()),
        ),
      ),
    ),
    GetPage<dynamic>(
      name: '/debug/day-tab',
      page: () => const GoodBadDayTab(),
      binding: BindingsBuilder(
        () => Get.lazyPut<GoodBadDayController>(
          () => GoodBadDayController(Get.find<ChartRepository>()),
        ),
      ),
    ),
    GetPage<dynamic>(
      name: '/debug/knowledge-tab',
      page: () => const KnowledgeTab(),
      binding: BindingsBuilder(
        () => Get.lazyPut<KnowledgeController>(() => KnowledgeController()),
      ),
    ),
    GetPage<dynamic>(
      name: '/debug/account-tab',
      page: () => const AccountTab(),
      binding: BindingsBuilder(
        () => Get.lazyPut<AccountController>(
          () => AccountController(
            Get.find<ChartRepository>(),
            Get.find<WalletRepository>(),
            Get.find<AppAuthService>(),
          ),
        ),
      ),
    ),
  ];
}
