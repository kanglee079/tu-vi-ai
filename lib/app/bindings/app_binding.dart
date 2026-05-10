import 'package:get/get.dart';

import '../../core/services/api_client_service.dart';
import '../../core/services/ai_client_service.dart';
import '../../core/services/app_auth_service.dart';
import '../../core/services/chart_snapshot_sync_service.dart';
import '../../core/services/chart_engine_service.dart';
import '../../core/services/entitlement_service.dart';
import '../../core/services/local_storage_service.dart';
import '../../core/services/purchase_client_service.dart';
import '../../data/mock/prototype_dependencies.dart';
import '../../data/repositories/ai_assistant_repository.dart';
import '../../data/repositories/chart_repository.dart';
import '../../data/repositories/compatibility_repository.dart';
import '../../data/repositories/insight_repository.dart';
import '../../data/repositories/wallet_repository.dart';

class AppBinding extends Bindings {
  AppBinding(this.appDependencies);

  final AppDependencies appDependencies;

  @override
  void dependencies() {
    Get.put<AppDependencies>(appDependencies, permanent: true);
    Get.put<ChartRepository>(appDependencies.chartRepository, permanent: true);
    Get.put<AiAssistantRepository>(
      appDependencies.aiAssistantRepository,
      permanent: true,
    );
    Get.put<WalletRepository>(
      appDependencies.walletRepository,
      permanent: true,
    );
    Get.put<InsightRepository>(
      appDependencies.insightRepository,
      permanent: true,
    );
    Get.put<CompatibilityRepository>(
      appDependencies.compatibilityRepository,
      permanent: true,
    );
    Get.put<LocalStorageService>(
      appDependencies.localStorageService,
      permanent: true,
    );
    Get.put<ChartEngineService>(
      appDependencies.chartEngineService,
      permanent: true,
    );
    Get.put<AiClientService>(appDependencies.aiClientService, permanent: true);
    Get.put<AppAuthService>(appDependencies.authService, permanent: true);
    Get.put<EntitlementService>(
      appDependencies.entitlementService,
      permanent: true,
    );
    Get.put<ApiClientService>(
      appDependencies.apiClientService,
      permanent: true,
    );
    Get.put<ChartSnapshotSyncService>(
      appDependencies.chartSnapshotSyncService,
      permanent: true,
    );
    Get.put<PurchaseClientService>(
      StoreKitPlayPurchaseClientService(),
      permanent: true,
    );
  }
}
