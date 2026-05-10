import '../models/birth_profile.dart';
import '../models/chart_models.dart';
import '../models/engine_snapshot_models.dart';

abstract class ChartRepository {
  Future<List<BirthProfile>> listProfiles();
  Future<BirthProfile?> getMainProfile();
  Future<BirthProfile?> getProfile(String profileId);
  Future<void> saveProfile(BirthProfile profile);
  Future<void> deleteProfile(String profileId);
  Future<ChartSummary> getChart(String profileId, int year);
  Future<ChartSnapshotPayload?> getChartSnapshot(String profileId, int year);
  Future<ChartPalace> getPalaceReading(String profileId, String palaceKey);
}
