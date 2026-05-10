import '../models/sync_models.dart';

abstract class SyncQueueRepository {
  Future<void> enqueue(PendingSyncOperation operation);
  Future<List<PendingSyncOperation>> listPending();
  Future<void> markAttempt(String operationId, DateTime attemptedAt);
  Future<void> remove(String operationId);
}
