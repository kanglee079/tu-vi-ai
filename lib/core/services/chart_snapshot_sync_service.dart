import '../../data/models/engine_snapshot_models.dart';
import 'api_client_service.dart';

class ChartSnapshotSyncService {
  ChartSnapshotSyncService(this._apiClientService);

  final ApiClientService _apiClientService;

  Future<void> uploadSnapshot(ChartSnapshotPayload payload) async {
    await _apiClientService.post('/chart-snapshots', data: payload.toJson());
  }
}
