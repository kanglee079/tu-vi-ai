import '../models/insight_models.dart';

abstract class CompatibilityRepository {
  Future<CompatibilityReport> compareProfiles(
    String primaryProfileId,
    String secondaryProfileId,
  );
}
