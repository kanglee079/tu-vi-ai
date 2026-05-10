import '../mock/prototype_seed_data.dart';
import '../models/birth_profile.dart';
import '../models/chart_models.dart';
import '../models/daily_recommendation.dart';
import '../models/engine_snapshot_models.dart';

class ChartSummaryAssembler {
  const ChartSummaryAssembler();

  ChartSummary assemble({
    required BirthProfile profile,
    required int year,
    required EngineChartSnapshot snapshot,
    required Set<String> unlockedKeys,
  }) {
    final basePalaces = {
      for (final ChartPalace palace in PrototypeSeedData.palaces())
        palace.key: palace,
    };

    final palaces = snapshot.palaces
        .where(
          (EnginePalaceSnapshot palace) => basePalaces.containsKey(palace.key),
        )
        .map((EnginePalaceSnapshot palace) {
          final template = basePalaces[palace.key]!;
          final score = _scorePalace(palace, profile);
          final isUnlocked =
              unlockedKeys.contains(palace.key) || template.isUnlocked;
          return template.copyWith(
            name: _displayName(palace.key, template.name, palace.isBodyPalace),
            score: score,
            primaryStars: palace.majorStars.take(3).toList(),
            secondaryStars: <String>[
              ...palace.minorStars.take(3),
              ...palace.adjectiveStars.take(2),
            ].take(4).toList(),
            shortSummary: _palaceSummary(palace, score),
            evidence: _evidenceForPalace(palace),
            relatedPalaces: _relatedPalaces(palace.key),
            isUnlocked: isUnlocked,
          );
        })
        .toList();

    final focusMetrics = <FocusMetric>[
      _focusMetric('career', 'Công việc', _scoreForKey(palaces, 'quan_loc')),
      _focusMetric('wealth', 'Tài chính', _scoreForKey(palaces, 'tai_bach')),
      _focusMetric(
        'relationship',
        'Tình cảm',
        _scoreForKey(palaces, 'phu_the'),
      ),
      _focusMetric('health', 'Sức khỏe', _scoreForKey(palaces, 'tat_ach')),
    ];

    return ChartSummary(
      profileId: profile.id,
      year: year,
      school: snapshot.school,
      overallScore:
          (focusMetrics.fold<int>(
                    0,
                    (int total, FocusMetric item) => total + item.score,
                  ) /
                  focusMetrics.length)
              .round(),
      overviewBullets: <String>[
        'Công việc được dẫn bởi ${palaces.firstWhere((ChartPalace item) => item.key == 'quan_loc').primaryStars.join(', ')} và có xu hướng tăng trách nhiệm.',
        'Tài chính chịu ảnh hưởng bởi ${palaces.firstWhere((ChartPalace item) => item.key == 'tai_bach').primaryStars.join(', ')} nên hợp hướng tích lũy kỷ luật.',
        profile.isLowConfidence
            ? 'Giờ sinh chưa chắc chắn, nên ưu tiên đọc xu hướng tổng thể và kiểm chứng theo trải nghiệm thực tế.'
            : 'Các kết luận nên được dùng như gợi ý định hướng, không phải phán đoán tuyệt đối.',
      ],
      disclaimer: profile.isLowConfidence
          ? 'Giờ sinh của hồ sơ này chưa chắc chắn, nên ưu tiên đọc xu hướng tổng thể thay vì kết luận cứng.'
          : 'Nội dung mang tính tham khảo, chiêm nghiệm và định hướng.',
      palaces: palaces,
      focusMetrics: focusMetrics,
      evidenceBullets: <String>[
        'Snapshot được chuẩn hóa từ engine cục bộ với schema ${snapshot.schemaVersion}.',
        'Các cung được map trực tiếp từ `dart_iztro` vào khóa nội bộ của app.',
        'Điểm và lời khuyên được sinh bởi assembler trên facts đã chuẩn hóa.',
      ],
      majorCycles: _majorCycles(snapshot),
      minorCycles: _minorCycles(snapshot, year),
      monthlyFortunes: _monthlyFortunes(snapshot, year),
      dailyRecommendations: _dailyRecommendations(snapshot, year),
    );
  }

  FocusMetric _focusMetric(String key, String label, int score) {
    return FocusMetric(
      key: key,
      label: label,
      score: score,
      insight: score >= 68
          ? 'Nhịp thuận hơn, hợp dồn lực có chọn lọc.'
          : score >= 55
          ? 'Có dư địa tăng nếu giữ kỷ luật và ưu tiên rõ.'
          : 'Cần thận trọng hơn, tránh quyết định nóng.',
    );
  }

  List<FortunePeriod> _majorCycles(EngineChartSnapshot snapshot) {
    return snapshot.palaces
        .take(4)
        .map(
          (EnginePalaceSnapshot palace) => FortunePeriod(
            id: 'major_${palace.key}',
            title:
                '${palace.decadalRange.first} - ${palace.decadalRange.last} tuổi',
            subtitle: 'Đại vận đi qua ${palace.name}.',
            score: _scoreFromStars(palace.majorStars, palace.minorStars),
            highlights: <String>[
              'Chủ đề nổi bật xoay quanh ${palace.name.toLowerCase()}.',
              'Chính tinh: ${palace.majorStars.take(2).join(', ')}.',
            ],
            cautions: <String>[
              'Nên đọc cùng vận thực tế thay vì kết luận tách rời.',
            ],
            unlocked: palace.key == 'menh' || palace.key == 'phuc_duc',
            unlockCost: 120,
            isHighlighted: palace.key == 'quan_loc',
          ),
        )
        .toList();
  }

  List<FortunePeriod> _minorCycles(EngineChartSnapshot snapshot, int year) {
    final yearlyKey = snapshot.cycles.yearly.palaceKeys.isEmpty
        ? 'quan_loc'
        : snapshot.cycles.yearly.palaceKeys.first;
    final focusPalace = snapshot.palaces.firstWhere(
      (EnginePalaceSnapshot item) => item.key == yearlyKey,
      orElse: () => snapshot.palaces.first,
    );
    return <FortunePeriod>[
      _minorCycleItem(year - 1, focusPalace, false),
      _minorCycleItem(year, focusPalace, true),
      _minorCycleItem(year + 1, focusPalace, false),
    ];
  }

  FortunePeriod _minorCycleItem(
    int year,
    EnginePalaceSnapshot focusPalace,
    bool highlighted,
  ) {
    return FortunePeriod(
      id: 'minor_$year',
      title: '$year',
      subtitle: 'Tiểu vận nhấn vào ${focusPalace.name}.',
      score:
          _scoreFromStars(focusPalace.majorStars, focusPalace.minorStars) -
          (highlighted ? 0 : 4),
      highlights: <String>[
        'Yếu tố nổi bật: ${focusPalace.majorStars.take(2).join(', ')}.',
      ],
      cautions: <String>['Tránh mở quá nhiều hướng cùng lúc.'],
      unlocked: highlighted,
      unlockCost: 90,
      isHighlighted: highlighted,
    );
  }

  List<MonthlyFortune> _monthlyFortunes(
    EngineChartSnapshot snapshot,
    int year,
  ) {
    return List<MonthlyFortune>.generate(12, (int index) {
      final month = index + 1;
      final palaceKey = snapshot
          .cycles
          .monthly
          .palaceKeys[index % snapshot.cycles.monthly.palaceKeys.length];
      final palace = snapshot.palaces.firstWhere(
        (EnginePalaceSnapshot item) => item.key == palaceKey,
        orElse: () => snapshot.palaces.first,
      );
      return MonthlyFortune(
        id: 'month_$month',
        monthNumber: month,
        solarRange: 'Tháng $month/$year',
        title: 'Nhịp tháng đi qua ${palace.name.toLowerCase()}',
        highlight: 'Nổi bật với ${palace.majorStars.take(2).join(', ')}.',
        score: _scoreFromStars(palace.majorStars, palace.minorStars),
        advice: <String>[
          'Giữ ưu tiên rõ cho ${palace.name.toLowerCase()}.',
          'Không quyết định lớn khi dữ kiện còn mơ hồ.',
        ],
        unlocked: month == 1,
        unlockCost: 40,
      );
    });
  }

  List<DailyRecommendation> _dailyRecommendations(
    EngineChartSnapshot snapshot,
    int year,
  ) {
    final rawItems =
        snapshot.rawInfo['dailyWindow'] as List<dynamic>? ?? const <dynamic>[];
    if (rawItems.isNotEmpty) {
      return rawItems
          .map(
            (dynamic item) => _dailyRecommendationFromRaw(
              (item as Map<dynamic, dynamic>).cast<String, Object?>(),
            ),
          )
          .toList();
    }
    return PrototypeSeedData.dailyRecommendations();
  }

  DailyRecommendation _dailyRecommendationFromRaw(Map<String, Object?> json) {
    final stars = (json['stars'] as List<dynamic>? ?? const <dynamic>[])
        .map((dynamic item) => item as String)
        .toList();
    return DailyRecommendation(
      date: DateTime.parse(json['date']! as String),
      lunarLabel: json['lunarLabel'] as String? ?? '',
      level: stars.length >= 3
          ? FortuneLevel.favorable
          : stars.length == 2
          ? FortuneLevel.balanced
          : FortuneLevel.caution,
      summary:
          'Ngày này nhấn vào ${json['palaceLabel']} với các yếu tố ${stars.take(2).join(', ')}.',
      goodFor: <String>[
        'Lên kế hoạch',
        'Rà soát dữ kiện',
        'Kết nối đúng người',
      ],
      avoid: <String>['Quyết định tài chính vội', 'Cam kết khi thiếu dữ kiện'],
      canChi: json['canChi'] as String? ?? '',
      nguHanh: json['nguHanh'] as String? ?? '',
      goodHours: (json['goodHours'] as List<dynamic>? ?? const <dynamic>[])
          .map((dynamic item) => item as String)
          .toList(),
    );
  }

  int _scoreForKey(List<ChartPalace> palaces, String key) {
    return palaces
        .firstWhere(
          (ChartPalace palace) => palace.key == key,
          orElse: () => palaces.first,
        )
        .score;
  }

  int _scorePalace(EnginePalaceSnapshot palace, BirthProfile profile) {
    final base = _scoreFromStars(palace.majorStars, palace.minorStars);
    final confidenceShift =
        profile.birthTimeConfidence == BirthTimeConfidence.exact
        ? 0
        : profile.birthTimeConfidence == BirthTimeConfidence.estimated
        ? -2
        : -4;
    return (base + confidenceShift).clamp(18, 88);
  }

  int _scoreFromStars(List<String> majorStars, List<String> minorStars) {
    return (24 + majorStars.length * 9 + minorStars.length * 3).clamp(20, 86);
  }

  String _displayName(String key, String fallback, bool isBodyPalace) {
    if (key == 'menh' && isBodyPalace) {
      return 'Mệnh + Thân';
    }
    return fallback;
  }

  String _palaceSummary(EnginePalaceSnapshot palace, int score) {
    if (score >= 70) {
      return '${palace.name} đang có lực tốt, hợp chủ động triển khai và giữ nhịp ổn định.';
    }
    if (score >= 55) {
      return '${palace.name} có nhịp trung tính, hợp đi chậm nhưng rõ và tránh phân tán.';
    }
    return '${palace.name} cần đọc thận trọng hơn, phù hợp rà soát và củng cố nền trước khi mở rộng.';
  }

  List<String> _evidenceForPalace(EnginePalaceSnapshot palace) {
    return <String>[
      'Chính tinh: ${palace.majorStars.isEmpty ? 'chưa nổi bật' : palace.majorStars.join(', ')}.',
      'Phụ tinh: ${palace.minorStars.take(3).join(', ')}.',
      'Đại vận tại cung này trải từ ${palace.decadalRange.first} đến ${palace.decadalRange.last} tuổi.',
    ];
  }

  List<String> _relatedPalaces(String palaceKey) {
    switch (palaceKey) {
      case 'menh':
        return <String>['quan_loc', 'tai_bach', 'thien_di'];
      case 'quan_loc':
        return <String>['menh', 'tai_bach', 'thien_di'];
      case 'tai_bach':
        return <String>['quan_loc', 'menh', 'dien_trach'];
      case 'phu_the':
        return <String>['menh', 'phuc_duc'];
      default:
        return <String>['menh', 'quan_loc'];
    }
  }
}
