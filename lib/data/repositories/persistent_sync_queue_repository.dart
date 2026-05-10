import '../local/objectbox/objectbox_entities.dart';
import '../local/objectbox/objectbox_service.dart';
import '../../objectbox.g.dart';
import '../models/sync_models.dart';
import 'sync_queue_repository.dart';

class PersistentSyncQueueRepository implements SyncQueueRepository {
  PersistentSyncQueueRepository(this._objectBoxService);

  final ObjectBoxService _objectBoxService;

  @override
  Future<void> enqueue(PendingSyncOperation operation) async {
    final existing = _objectBoxService.pendingSyncOperations
        .query(PendingSyncOperationEntity_.operationId.equals(operation.id))
        .build()
        .findFirst();
    _objectBoxService.pendingSyncOperations.put(
      PendingSyncOperationEntity(
        dbId: existing?.dbId ?? 0,
        operationId: operation.id,
        entityType: operation.entityType,
        operationType: operation.operationType,
        payloadJson: operation.payloadJson,
        createdAtEpochMs: operation.createdAt.millisecondsSinceEpoch,
        lastAttemptAtEpochMs: operation.lastAttemptAt?.millisecondsSinceEpoch,
        attemptCount: operation.attemptCount,
      ),
    );
  }

  @override
  Future<List<PendingSyncOperation>> listPending() async {
    final items = _objectBoxService.pendingSyncOperations.getAll()
      ..sort(
        (PendingSyncOperationEntity a, PendingSyncOperationEntity b) =>
            a.createdAtEpochMs.compareTo(b.createdAtEpochMs),
      );
    return items
        .map(
          (PendingSyncOperationEntity item) => PendingSyncOperation(
            id: item.operationId,
            entityType: item.entityType,
            operationType: item.operationType,
            payloadJson: item.payloadJson,
            createdAt: DateTime.fromMillisecondsSinceEpoch(
              item.createdAtEpochMs,
            ),
            lastAttemptAt: item.lastAttemptAtEpochMs == null
                ? null
                : DateTime.fromMillisecondsSinceEpoch(
                    item.lastAttemptAtEpochMs!,
                  ),
            attemptCount: item.attemptCount,
          ),
        )
        .toList();
  }

  @override
  Future<void> markAttempt(String operationId, DateTime attemptedAt) async {
    final existing = _objectBoxService.pendingSyncOperations
        .query(PendingSyncOperationEntity_.operationId.equals(operationId))
        .build()
        .findFirst();
    if (existing == null) {
      return;
    }
    existing.lastAttemptAtEpochMs = attemptedAt.millisecondsSinceEpoch;
    existing.attemptCount = existing.attemptCount + 1;
    _objectBoxService.pendingSyncOperations.put(existing);
  }

  @override
  Future<void> remove(String operationId) async {
    final existing = _objectBoxService.pendingSyncOperations
        .query(PendingSyncOperationEntity_.operationId.equals(operationId))
        .build()
        .findFirst();
    if (existing != null) {
      _objectBoxService.pendingSyncOperations.remove(existing.dbId);
    }
  }
}
