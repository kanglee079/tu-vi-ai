import '../models/sync_models.dart';
import 'sync_queue_repository.dart';

class InMemorySyncQueueRepository implements SyncQueueRepository {
  final List<PendingSyncOperation> _queue = <PendingSyncOperation>[];

  @override
  Future<void> enqueue(PendingSyncOperation operation) async {
    _queue.add(operation);
  }

  @override
  Future<List<PendingSyncOperation>> listPending() async {
    return List<PendingSyncOperation>.from(_queue);
  }

  @override
  Future<void> markAttempt(String operationId, DateTime attemptedAt) async {
    final index = _queue.indexWhere(
      (PendingSyncOperation item) => item.id == operationId,
    );
    if (index < 0) {
      return;
    }
    final current = _queue[index];
    _queue[index] = PendingSyncOperation(
      id: current.id,
      entityType: current.entityType,
      operationType: current.operationType,
      payloadJson: current.payloadJson,
      createdAt: current.createdAt,
      lastAttemptAt: attemptedAt,
      attemptCount: current.attemptCount + 1,
    );
  }

  @override
  Future<void> remove(String operationId) async {
    _queue.removeWhere((PendingSyncOperation item) => item.id == operationId);
  }
}
