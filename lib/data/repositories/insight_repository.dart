import '../models/insight_models.dart';

abstract class InsightRepository {
  Future<LifeMapSummary> getLifeMap(String profileId, int year);
  Future<List<JournalEntry>> listJournalEntries(String profileId);
  Future<JournalReflection> getLatestReflection(String profileId);
  Future<void> addJournalEntry(String profileId, JournalEntry entry);
}
