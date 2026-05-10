import '../mock/prototype_seed_data.dart';
import '../models/birth_profile.dart';
import '../models/chart_models.dart';
import '../models/engine_snapshot_models.dart';
import 'chart_repository.dart';

class MockChartRepository implements ChartRepository {
  MockChartRepository({List<BirthProfile>? initialProfiles})
    : _profiles = initialProfiles ?? PrototypeSeedData.profiles(),
      _basePalaces = PrototypeSeedData.palaces();

  final List<BirthProfile> _profiles;
  final List<ChartPalace> _basePalaces;

  @override
  Future<void> deleteProfile(String profileId) async {
    _profiles.removeWhere((BirthProfile profile) => profile.id == profileId);
    if (_profiles.isNotEmpty &&
        _profiles.every((BirthProfile e) => !e.isMain)) {
      _profiles[0] = _profiles[0].copyWith(isMain: true);
    }
  }

  @override
  Future<ChartSummary> getChart(String profileId, int year) async {
    final profile = await getProfile(profileId) ?? await getMainProfile();
    final disclaimer = profile?.isLowConfidence == true
        ? 'Giờ sinh của hồ sơ này chưa chắc chắn, nên ưu tiên đọc xu hướng tổng thể thay vì kết luận cứng.'
        : 'Nội dung mang tính tham khảo, phù hợp để chiêm nghiệm và định hướng.';

    final scoreShift = profile?.birthTimeConfidence == BirthTimeConfidence.exact
        ? 0
        : profile?.birthTimeConfidence == BirthTimeConfidence.estimated
        ? -2
        : -4;

    final palaces = _basePalaces
        .map(
          (ChartPalace palace) =>
              palace.copyWith(score: palace.score + scoreShift),
        )
        .toList();

    return ChartSummary(
      profileId: profile?.id ?? profileId,
      year: year,
      school: 'ziwei_vietnamese_v1',
      overallScore: 68 + scoreShift,
      overviewBullets: <String>[
        'Công việc có xu hướng mở rộng khi bạn chủ động chọn việc có tác động rõ.',
        'Tài chính đi lên tốt hơn nếu giữ nguyên tắc tích lũy và tránh quyết định nóng.',
        'Tình cảm cần giao tiếp thẳng nhưng mềm để không hiểu sai kỳ vọng.',
      ],
      disclaimer: disclaimer,
      palaces: palaces,
      focusMetrics: PrototypeSeedData.focusMetrics(),
      evidenceBullets: <String>[
        'Trục Mệnh - Quan Lộc - Tài Bạch tạo thành hướng phát triển mạnh trong năm xem.',
        'Thiên Di sáng giúp vận kết nối và môi trường mới hỗ trợ tiến trình công việc.',
        'Tật Ách nhắc phải giữ nhịp sinh hoạt để không đổi hiệu suất lấy quá tải.',
      ],
      majorCycles: PrototypeSeedData.majorCycles(),
      minorCycles: PrototypeSeedData.minorCycles(year),
      monthlyFortunes: PrototypeSeedData.monthlyFortunes(year),
      dailyRecommendations: PrototypeSeedData.dailyRecommendations(),
    );
  }

  @override
  Future<BirthProfile?> getMainProfile() async {
    return _profiles.firstWhere(
      (BirthProfile profile) => profile.isMain,
      orElse: () => _profiles.first,
    );
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
    return null;
  }

  @override
  Future<BirthProfile?> getProfile(String profileId) async {
    for (final BirthProfile profile in _profiles) {
      if (profile.id == profileId) {
        return profile;
      }
    }
    return null;
  }

  @override
  Future<List<BirthProfile>> listProfiles() async {
    return _profiles.map((BirthProfile profile) => profile.copyWith()).toList()
      ..sort((BirthProfile a, BirthProfile b) {
        if (a.isMain == b.isMain) {
          return a.name.compareTo(b.name);
        }
        return a.isMain ? -1 : 1;
      });
  }

  @override
  Future<void> saveProfile(BirthProfile profile) async {
    final index = _profiles.indexWhere(
      (BirthProfile item) => item.id == profile.id,
    );
    if (profile.isMain) {
      for (var i = 0; i < _profiles.length; i++) {
        _profiles[i] = _profiles[i].copyWith(isMain: false);
      }
    }
    if (index >= 0) {
      _profiles[index] = profile;
    } else {
      _profiles.add(profile);
    }
    if (_profiles.every((BirthProfile item) => !item.isMain) &&
        _profiles.isNotEmpty) {
      _profiles[0] = _profiles[0].copyWith(isMain: true);
    }
  }
}
