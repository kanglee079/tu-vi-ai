import 'dart:convert';

import '../../core/services/chart_engine_service.dart';
import '../../core/services/chart_snapshot_sync_service.dart';
import '../../core/services/entitlement_service.dart';
import '../local/objectbox/objectbox_entities.dart';
import '../local/objectbox/objectbox_service.dart';
import '../mappers/chart_summary_assembler.dart';
import '../models/birth_profile.dart';
import '../models/chart_models.dart';
import '../models/engine_snapshot_models.dart';
import '../models/sync_models.dart';
import '../../objectbox.g.dart';
import 'chart_repository.dart';
import 'sync_queue_repository.dart';

class PersistentChartRepository implements ChartRepository {
  PersistentChartRepository({
    required ObjectBoxService objectBoxService,
    required ChartEngineService chartEngineService,
    required EntitlementService entitlementService,
    required ChartSnapshotSyncService chartSnapshotSyncService,
    required SyncQueueRepository syncQueueRepository,
    ChartSummaryAssembler? chartSummaryAssembler,
  }) : _objectBoxService = objectBoxService,
       _chartEngineService = chartEngineService,
       _entitlementService = entitlementService,
       _chartSnapshotSyncService = chartSnapshotSyncService,
       _syncQueueRepository = syncQueueRepository,
       _chartSummaryAssembler =
           chartSummaryAssembler ?? const ChartSummaryAssembler();

  final ObjectBoxService _objectBoxService;
  final ChartEngineService _chartEngineService;
  final EntitlementService _entitlementService;
  final ChartSnapshotSyncService _chartSnapshotSyncService;
  final SyncQueueRepository _syncQueueRepository;
  final ChartSummaryAssembler _chartSummaryAssembler;

  @override
  Future<void> deleteProfile(String profileId) async {
    final profile = _findProfileEntity(profileId);
    if (profile != null) {
      _objectBoxService.birthProfiles.remove(profile.dbId);
    }
    final caches = _objectBoxService.chartCaches
        .query(ChartCacheEntity_.profileId.equals(profileId))
        .build()
        .find();
    _objectBoxService.chartCaches.removeMany(
      caches.map((ChartCacheEntity item) => item.dbId).toList(),
    );
    final profiles = await listProfiles();
    if (profiles.isNotEmpty &&
        profiles.every((BirthProfile item) => !item.isMain)) {
      final first = profiles.first.copyWith(isMain: true);
      await saveProfile(first);
    }
  }

  @override
  Future<ChartSummary> getChart(String profileId, int year) async {
    final payload = await _resolveChartPayload(profileId, year);
    return payload.summary;
  }

  @override
  Future<ChartPalace> getPalaceReading(
    String profileId,
    String palaceKey,
  ) async {
    final chart = await getChart(profileId, DateTime.now().year);
    return chart.palaces.firstWhere(
      (ChartPalace palace) => palace.key == palaceKey,
    );
  }

  @override
  Future<ChartSnapshotPayload?> getChartSnapshot(
    String profileId,
    int year,
  ) async {
    return _resolveChartPayload(profileId, year);
  }

  @override
  Future<BirthProfile?> getMainProfile() async {
    final profiles = await listProfiles();
    if (profiles.isEmpty) {
      return null;
    }
    return profiles.firstWhere(
      (BirthProfile item) => item.isMain,
      orElse: () => profiles.first,
    );
  }

  @override
  Future<BirthProfile?> getProfile(String profileId) async {
    final entity = _findProfileEntity(profileId);
    return entity == null ? null : _mapProfileEntity(entity);
  }

  @override
  Future<List<BirthProfile>> listProfiles() async {
    final profiles =
        _objectBoxService.birthProfiles.getAll().map(_mapProfileEntity).toList()
          ..sort((BirthProfile a, BirthProfile b) {
            if (a.isMain == b.isMain) {
              return a.name.compareTo(b.name);
            }
            return a.isMain ? -1 : 1;
          });
    return profiles;
  }

  @override
  Future<void> saveProfile(BirthProfile profile) async {
    if (profile.isMain) {
      final current = _objectBoxService.birthProfiles.getAll();
      for (final entity in current) {
        if (entity.profileId != profile.id && entity.isMain) {
          entity.isMain = false;
          _objectBoxService.birthProfiles.put(entity);
        }
      }
    }
    final existing = _findProfileEntity(profile.id);
    final entity = _toProfileEntity(profile, existing?.dbId ?? 0);
    _objectBoxService.birthProfiles.put(entity);
  }

  Future<ChartSnapshotPayload> _resolveChartPayload(
    String profileId,
    int year,
  ) async {
    final cacheKey = _cacheKey(profileId, year);
    final cachedEntity = _objectBoxService.chartCaches
        .query(ChartCacheEntity_.cacheKey.equals(cacheKey))
        .build()
        .findFirst();
    if (cachedEntity != null) {
      final payload = ChartSnapshotPayload(
        profile: (await getProfile(profileId))!,
        summary: ChartSummary.fromJson(
          (jsonDecode(cachedEntity.summaryJson) as Map<dynamic, dynamic>)
              .cast(),
        ),
        snapshot: EngineChartSnapshot.fromJson(
          (jsonDecode(cachedEntity.snapshotJson) as Map<dynamic, dynamic>)
              .cast(),
        ),
        snapshotHash: cachedEntity.snapshotHash,
      );
      final unlockedKeys = await _entitlementService.listGrantedContentKeys(
        profileId: profileId,
      );
      final refreshedSummary = _chartSummaryAssembler.assemble(
        profile: payload.profile,
        year: year,
        snapshot: payload.snapshot,
        unlockedKeys: unlockedKeys.toSet(),
      );
      return ChartSnapshotPayload(
        profile: payload.profile,
        summary: refreshedSummary,
        snapshot: payload.snapshot,
        snapshotHash: payload.snapshotHash,
      );
    }

    final profile = await getProfile(profileId) ?? await getMainProfile();
    if (profile == null) {
      throw StateError('No birth profile available for chart generation.');
    }
    final snapshot = await _chartEngineService.calculateChart(
      profile: profile,
      year: year,
    );
    final unlockedKeys = await _entitlementService.listGrantedContentKeys(
      profileId: profile.id,
    );
    final summary = _chartSummaryAssembler.assemble(
      profile: profile,
      year: year,
      snapshot: snapshot,
      unlockedKeys: unlockedKeys.toSet(),
    );
    final payload = ChartSnapshotPayload(
      profile: profile,
      summary: summary,
      snapshot: snapshot,
      snapshotHash: ChartSnapshotPayload.buildSnapshotHash(
        profile: profile,
        snapshot: snapshot,
      ),
    );
    _objectBoxService.chartCaches.put(
      ChartCacheEntity(
        cacheKey: cacheKey,
        profileId: profile.id,
        year: year,
        engineVersion: snapshot.engineVersion,
        schemaVersion: snapshot.schemaVersion,
        snapshotHash: payload.snapshotHash,
        snapshotJson: jsonEncode(snapshot.toJson()),
        summaryJson: jsonEncode(summary.toJson()),
        updatedAtEpochMs: DateTime.now().millisecondsSinceEpoch,
      ),
    );
    await _syncSnapshot(payload);
    return payload;
  }

  BirthProfileEntity? _findProfileEntity(String profileId) {
    return _objectBoxService.birthProfiles
        .query(BirthProfileEntity_.profileId.equals(profileId))
        .build()
        .findFirst();
  }

  BirthProfile _mapProfileEntity(BirthProfileEntity entity) {
    return BirthProfile(
      id: entity.profileId,
      name: entity.name,
      gender: genderFromName(entity.gender),
      calendarType: calendarTypeFromName(entity.calendarType),
      birthDate: DateTime.fromMillisecondsSinceEpoch(entity.birthDateEpochMs),
      birthHourLabel: entity.birthHourLabel,
      birthMinute: entity.birthMinute,
      birthPlace: entity.birthPlace,
      timezone: entity.timezone,
      birthTimeConfidence: birthTimeConfidenceFromName(
        entity.birthTimeConfidence,
      ),
      mainFocus: (jsonDecode(entity.mainFocusJson) as List<dynamic>)
          .map((dynamic item) => mainFocusFromName(item as String))
          .toList(),
      isMain: entity.isMain,
    );
  }

  BirthProfileEntity _toProfileEntity(BirthProfile profile, int dbId) {
    return BirthProfileEntity(
      dbId: dbId,
      profileId: profile.id,
      name: profile.name,
      gender: profile.gender.name,
      calendarType: profile.calendarType.name,
      birthDateEpochMs: profile.birthDate.millisecondsSinceEpoch,
      birthHourLabel: profile.birthHourLabel,
      birthMinute: profile.birthMinute,
      birthPlace: profile.birthPlace,
      timezone: profile.timezone,
      birthTimeConfidence: profile.birthTimeConfidence.name,
      mainFocusJson: jsonEncode(
        profile.mainFocus.map((MainFocus focus) => focus.name).toList(),
      ),
      isMain: profile.isMain,
    );
  }

  String _cacheKey(String profileId, int year) => '$profileId::$year';

  Future<void> _syncSnapshot(ChartSnapshotPayload payload) async {
    try {
      await _chartSnapshotSyncService.uploadSnapshot(payload);
    } catch (_) {
      await _syncQueueRepository.enqueue(
        PendingSyncOperation(
          id: 'snapshot_${payload.profile.id}_${payload.summary.year}',
          entityType: 'chart_snapshot',
          operationType: 'upsert',
          payloadJson: jsonEncode(payload.toJson()),
          createdAt: DateTime.now(),
        ),
      );
    }
  }
}
