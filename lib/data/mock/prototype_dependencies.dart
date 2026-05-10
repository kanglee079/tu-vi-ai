import 'package:firebase_auth/firebase_auth.dart';

import '../../core/services/api_client_service.dart';
import '../../core/services/ai_client_service.dart';
import '../../core/services/app_auth_service.dart';
import '../../core/services/chart_snapshot_sync_service.dart';
import '../../core/services/chart_engine_service.dart';
import '../../core/services/entitlement_service.dart';
import '../../core/services/local_entitlement_service.dart';
import '../../core/services/local_storage_service.dart';
import '../local/objectbox/objectbox_service.dart';
import '../local/objectbox/legacy_profile_migration.dart';
import '../repositories/ai_assistant_repository.dart';
import '../repositories/chart_repository.dart';
import '../repositories/compatibility_repository.dart';
import '../repositories/insight_repository.dart';
import '../repositories/local_chart_repository.dart';
import '../repositories/mock_ai_assistant_repository.dart';
import '../repositories/mock_compatibility_repository.dart';
import '../repositories/mock_insight_repository.dart';
import '../repositories/mock_knowledge_repository.dart';
import '../repositories/mock_wallet_repository.dart';
import '../repositories/in_memory_sync_queue_repository.dart';
import '../repositories/persistent_chart_repository.dart';
import '../repositories/persistent_insight_repository.dart';
import '../repositories/persistent_sync_queue_repository.dart';
import '../repositories/persistent_wallet_repository.dart';
import '../repositories/remote/remote_ai_assistant_repository.dart';
import '../repositories/sync_queue_repository.dart';
import '../repositories/wallet_repository.dart';

class AppDependencies {
  AppDependencies({
    required this.chartRepository,
    required this.aiAssistantRepository,
    required this.walletRepository,
    required this.insightRepository,
    required this.compatibilityRepository,
    required this.localStorageService,
    required this.chartEngineService,
    required this.aiClientService,
    required this.entitlementService,
    required this.apiClientService,
    required this.chartSnapshotSyncService,
    required this.authService,
    required this.syncQueueRepository,
  });

  final ChartRepository chartRepository;
  final AiAssistantRepository aiAssistantRepository;
  final WalletRepository walletRepository;
  final InsightRepository insightRepository;
  final CompatibilityRepository compatibilityRepository;
  final LocalStorageService localStorageService;
  final ChartEngineService chartEngineService;
  final AiClientService aiClientService;
  final EntitlementService entitlementService;
  final ApiClientService apiClientService;
  final ChartSnapshotSyncService chartSnapshotSyncService;
  final AppAuthService authService;
  final SyncQueueRepository syncQueueRepository;

  factory AppDependencies.prototype() {
    final chartRepository = LocalChartRepository();
    final knowledgeRepository = MockKnowledgeRepository();
    return AppDependencies(
      chartRepository: chartRepository,
      aiAssistantRepository: MockAiAssistantRepository(knowledgeRepository),
      walletRepository: MockWalletRepository(),
      insightRepository: MockInsightRepository(),
      compatibilityRepository: MockCompatibilityRepository(),
      localStorageService: PrototypeLocalStorageService(),
      chartEngineService: IztroChartEngineService(),
      aiClientService: PrototypeAiClientService(),
      entitlementService: PrototypeEntitlementService(),
      apiClientService: DioApiClientService(),
      chartSnapshotSyncService: ChartSnapshotSyncService(DioApiClientService()),
      authService: PrototypeAuthService(),
      syncQueueRepository: InMemorySyncQueueRepository(),
    );
  }

  static Future<AppDependencies> production() async {
    final objectBoxService = await ObjectBoxService.create();
    await LegacyProfileMigration(objectBoxService).runIfNeeded();
    final authService = FirebaseAppAuthService(
      firebaseAuth: FirebaseAuth.instance,
    );
    await authService.ensureGuestSession();
    final apiClientService = DioApiClientService(
      idTokenProvider: authService.currentIdToken,
    );
    final localStorageService = PrototypeLocalStorageService();
    final chartEngineService = IztroChartEngineService();
    final entitlementService = LocalEntitlementService(objectBoxService);
    final syncQueueRepository = PersistentSyncQueueRepository(objectBoxService);
    final chartSnapshotSyncService = ChartSnapshotSyncService(apiClientService);
    final chartRepository = PersistentChartRepository(
      objectBoxService: objectBoxService,
      chartEngineService: chartEngineService,
      entitlementService: entitlementService,
      chartSnapshotSyncService: chartSnapshotSyncService,
      syncQueueRepository: syncQueueRepository,
    );
    final fallbackKnowledgeRepository = MockKnowledgeRepository();
    final fallbackAiRepository = MockAiAssistantRepository(
      fallbackKnowledgeRepository,
    );
    return AppDependencies(
      chartRepository: chartRepository,
      aiAssistantRepository: RemoteAiAssistantRepository(
        apiClientService: apiClientService,
        chartRepository: chartRepository,
        fallbackRepository: fallbackAiRepository,
      ),
      walletRepository: PersistentWalletRepository(objectBoxService),
      insightRepository: PersistentInsightRepository(objectBoxService),
      compatibilityRepository: MockCompatibilityRepository(),
      localStorageService: localStorageService,
      chartEngineService: chartEngineService,
      aiClientService: PrototypeAiClientService(),
      entitlementService: entitlementService,
      apiClientService: apiClientService,
      chartSnapshotSyncService: chartSnapshotSyncService,
      authService: authService,
      syncQueueRepository: syncQueueRepository,
    );
  }
}
