import '../local/objectbox/objectbox_entities.dart';
import '../local/objectbox/objectbox_service.dart';
import '../mock/prototype_seed_data.dart';
import '../models/insight_models.dart';
import '../../objectbox.g.dart';
import 'insight_repository.dart';

class PersistentInsightRepository implements InsightRepository {
  PersistentInsightRepository(this._objectBoxService);

  final ObjectBoxService _objectBoxService;

  @override
  Future<void> addJournalEntry(String profileId, JournalEntry entry) async {
    _objectBoxService.journalEntries.put(
      JournalEntryEntity(
        entryId: entry.id,
        profileId: profileId,
        createdAtLabel: entry.createdAtLabel,
        createdAtEpochMs: DateTime.now().millisecondsSinceEpoch,
        mood: entry.mood.name,
        title: entry.title,
        body: entry.body,
        sentimentLabel: entry.sentimentLabel,
      ),
    );
  }

  @override
  Future<LifeMapSummary> getLifeMap(String profileId, int year) async {
    return PrototypeSeedData.lifeMap(profileId, year);
  }

  @override
  Future<JournalReflection> getLatestReflection(String profileId) async {
    return const JournalReflection(
      title: 'Chiêm nghiệm tinh tú',
      body:
          'Trạng thái hôm nay phù hợp với một nhịp chậm để gom lại suy nghĩ. Điều quan trọng không phải làm thêm việc mới, mà là nhìn rõ thứ gì thực sự đáng ưu tiên trong 7 ngày tới.',
      tags: <String>[
        'Tương sinh',
        'Khuyên dùng: tĩnh tâm',
        'Ưu tiên: rà lại kế hoạch',
      ],
    );
  }

  @override
  Future<List<JournalEntry>> listJournalEntries(String profileId) async {
    final entries =
        _objectBoxService.journalEntries
            .query(JournalEntryEntity_.profileId.equals(profileId))
            .build()
            .find()
          ..sort(
            (JournalEntryEntity a, JournalEntryEntity b) =>
                b.createdAtEpochMs.compareTo(a.createdAtEpochMs),
          );
    if (entries.isEmpty) {
      for (final item in PrototypeSeedData.journalEntries(profileId)) {
        await addJournalEntry(profileId, item);
      }
      return listJournalEntries(profileId);
    }
    return entries
        .map(
          (JournalEntryEntity item) => JournalEntry(
            id: item.entryId,
            createdAtLabel: item.createdAtLabel,
            mood: journalMoodFromName(item.mood),
            title: item.title,
            body: item.body,
            sentimentLabel: item.sentimentLabel,
          ),
        )
        .toList();
  }
}
