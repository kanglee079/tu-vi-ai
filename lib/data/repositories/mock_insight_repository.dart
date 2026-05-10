import '../models/insight_models.dart';
import '../mock/prototype_seed_data.dart';
import 'insight_repository.dart';

class MockInsightRepository implements InsightRepository {
  final Map<String, List<JournalEntry>> _entries = <String, List<JournalEntry>>{
    'profile_001': List<JournalEntry>.from(
      PrototypeSeedData.journalEntries('profile_001'),
    ),
  };

  @override
  Future<void> addJournalEntry(String profileId, JournalEntry entry) async {
    final current = _entries.putIfAbsent(profileId, () => <JournalEntry>[]);
    current.insert(0, entry);
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
    return List<JournalEntry>.from(
      _entries[profileId] ?? const <JournalEntry>[],
    );
  }
}
