import '../mock/knowledge_base.dart';
import '../models/birth_profile.dart';
import '../models/chart_models.dart';
import '../models/daily_recommendation.dart';
import '../models/engine_snapshot_models.dart';

/// Assembles a ChartSummary from iztro engine output + knowledge base.
///
/// Rules:
/// - iztro data is the source of truth for palace keys, stars, cycles.
/// - Knowledge base provides human-readable meanings and advice.
/// - Scoring uses actual star composition, not a mock formula.
/// - PrototypeSeedData is NOT used as template — it is only a fallback for
///   display-only fields that iztro doesn't provide (e.g. radar chart sections).
class ChartSummaryAssembler {
  const ChartSummaryAssembler();

  ChartSummary assemble({
    required BirthProfile profile,
    required int year,
    required EngineChartSnapshot snapshot,
    required Set<String> unlockedKeys,
  }) {
    final profilePalaceMap = {for (final p in snapshot.palaces) p.key: p};

    // ---- Assemble palaces using iztro data + knowledge base ----
    final palaces = snapshot.palaces.map((enginePalace) {
      final knowledge = palaceKnowledgeBase[enginePalace.key];
      final majorCount = enginePalace.majorStars.length;
      final minorCount = enginePalace.minorStars.length;
      final adjCount = enginePalace.adjectiveStars.length;
      final isUnlocked = unlockedKeys.contains(enginePalace.key) ||
          _isFreePalace(enginePalace.key);
      final score = _computeScore(majorCount, minorCount, adjCount, enginePalace.key);

      return ChartPalace(
        key: enginePalace.key,
        name: _palaceDisplayName(enginePalace),
        score: score,
        shortSummary: _buildShortSummary(enginePalace, knowledge, score),
        primaryStars: enginePalace.majorStars.take(4).toList(),
        secondaryStars: [
          ...enginePalace.minorStars.take(3),
          ...enginePalace.adjectiveStars.take(2),
        ].take(5).toList(),
        strengths: _buildStrengths(enginePalace, knowledge),
        challenges: _buildChallenges(enginePalace, knowledge),
        advice: _buildAdvice(enginePalace, knowledge, score),
        evidence: _buildEvidence(enginePalace),
        relatedPalaces: _relatedPalaces(enginePalace.key),
        isUnlocked: isUnlocked,
        unlockCost: _unlockCost(enginePalace.key),
      );
    }).toList();

    // ---- Focus metrics derived from iztro palace composition ----
    final focusMetrics = <FocusMetric>[
      _focusMetric(
          'career', 'Công việc', profilePalaceMap['quan_loc']),
      _focusMetric(
          'wealth', 'Tài chính', profilePalaceMap['tai_bach']),
      _focusMetric(
          'relationship', 'Tình cảm', profilePalaceMap['phu_the']),
      _focusMetric(
          'health', 'Sức khỏe', profilePalaceMap['tat_ach']),
    ];

    final overallScore = (focusMetrics.fold<int>(
                0, (int total, FocusMetric f) => total + f.score) /
            focusMetrics.length)
        .round();

    return ChartSummary(
      profileId: profile.id,
      year: year,
      school: snapshot.school,
      overallScore: overallScore,
      overviewBullets: _buildOverviewBullets(
          snapshot, profilePalaceMap, palaces, profile),
      disclaimer: profile.isLowConfidence
          ? 'Giờ sinh của hồ sơ này chưa chắc chắn, nên đọc xu hướng tổng thể '
              'thay vì kết luận cứng. Các luận giải chỉ mang tính tham khảo.'
          : 'Nội dung mang tính tham khảo, chiêm nghiệm và định hướng. '
              'Không thay thế tư vấn y tế, tài chính hoặc pháp lý.',
      palaces: palaces,
      focusMetrics: focusMetrics,
      evidenceBullets: <String>[
        'Lá số được tính bằng engine dựa trên ngày sinh, giờ sinh, giới tính.',
        'Mapper chuẩn hóa 12 cung từ iztro sang khóa nội bộ của app.',
        'Luận giải được xây dựng từ knowledge base nội bộ dựa trên sao thực tế có trong cung.',
      ],
      majorCycles: _buildMajorCycles(snapshot),
      minorCycles: _buildMinorCycles(snapshot, year),
      monthlyFortunes: _buildMonthlyFortunes(snapshot, year),
      dailyRecommendations: _buildDailyRecommendations(snapshot, year),
    );
  }

  // ---- Scoring ----

  int _computeScore(int majorCount, int minorCount, int adjCount, String palaceKey) {
    // Base score from star composition
    var score = 20 + majorCount * 8 + minorCount * 4 + adjCount * 2;

    // Palace-specific bonuses
    score += switch (palaceKey) {
      'menh' => 5,
      'quan_loc' => 4,
      'tai_bach' => 4,
      'phuc_duc' => 3,
      'phu_the' => 3,
      'thien_di' => 2,
      _ => 0,
    };

    // Major star quality bonus
    score += majorCount > 3 ? 5 : 0;
    score += minorCount > 4 ? 3 : 0;

    return score.clamp(15, 92);
  }

  bool _isFreePalace(String key) =>
      key == 'menh' || key == 'thien_di' || key == 'phuc_duc' || key == 'phu_the';

  int _unlockCost(String key) => switch (key) {
        'quan_loc' => 100,
        'tai_bach' => 100,
        'no_boc' => 80,
        'tat_ach' => 80,
        'dien_trach' => 60,
        'tu_tuc' => 60,
        'huynh_de' => 50,
        _ => 90,
      };

  // ---- Palace helpers ----

  String _palaceDisplayName(EnginePalaceSnapshot p) {
    if (p.key == 'menh' && p.isBodyPalace) return 'Mệnh + Thân';
    final kb = palaceKnowledgeBase[p.key];
    return kb?.name ?? p.name;
  }

  String _buildShortSummary(EnginePalaceSnapshot p, PalaceKnowledge? kb, int score) {
    if (kb == null) {
      return score >= 68
          ? 'Cung này có ${p.majorStars.length} chính tinh, vận thuận lợi.'
          : score >= 50
              ? 'Cung này có ${p.majorStars.length} chính tinh, vận ở mức trung bình.'
              : 'Cung này cần được phân tích kỹ hơn để rút ra ý nghĩa.';
    }
    if (score >= 68) {
      return '${kb.name} có ${p.majorStars.length} chính tinh. '
          'Vận thuận lợi, ${kb.coreStrengths.first}.';
    }
    if (score >= 52) {
      return '${kb.name} có ${p.majorStars.length} chính tinh. '
          'Vận ở mức trung bình, ${kb.coreChallenges.first}.';
    }
    return '${kb.name} có ${p.majorStars.length} chính tinh. '
        'Cần cẩn trọng, ${kb.coreChallenges.first}.';
  }

  List<String> _buildStrengths(EnginePalaceSnapshot p, PalaceKnowledge? kb) {
    final stars = p.majorStars;
    final result = <String>[];
    if (stars.isNotEmpty) {
      result.add('Có sao ${stars.first} — mang ${_starKeywords(stars.first)}.');
    }
    if (stars.length >= 2) {
      result.add('Nhóm sao chính tạo đà phát triển cho ${kb?.domain ?? "cung này"}.');
    }
    if (kb != null && kb.coreStrengths.isNotEmpty) {
      result.add(kb.coreStrengths.first);
    }
    return result.take(3).toList();
  }

  List<String> _buildChallenges(EnginePalaceSnapshot p, PalaceKnowledge? kb) {
    final result = <String>[];
    if (kb != null && kb.coreChallenges.isNotEmpty) {
      result.add(kb.coreChallenges.first);
    }
    if (p.minorStars.isEmpty && p.majorStars.length < 2) {
      result.add('Cung này chưa có nhiều sao hỗ trợ, cần thời gian tích lũy.');
    }
    if (result.isEmpty) {
      result.add('Cần xem xét trong bối cảnh tổng thể lá số.');
    }
    return result.take(3).toList();
  }

  List<String> _buildAdvice(
      EnginePalaceSnapshot p, PalaceKnowledge? kb, int score) {
    final result = <String>[];
    if (kb != null) {
      result.addAll(kb.lifeAdvice.split('. ').take(2));
    }
    if (score < 52) {
      result.add('Thời điểm này phù hợp để quan sát và chuẩn bị, hơn là hành động lớn.');
    }
    if (p.majorStars.isNotEmpty) {
      result.add('Chú ý đến yếu tố ${p.majorStars.first} trong cung này.');
    }
    return result.take(3).toList();
  }

  List<String> _buildEvidence(EnginePalaceSnapshot p) => <String>[
        if (p.majorStars.isNotEmpty)
          'Chính tinh: ${p.majorStars.join(', ')}.',
        if (p.minorStars.isNotEmpty)
          'Phụ tinh: ${p.minorStars.take(3).join(', ')}${p.minorStars.length > 3 ? '...' : ''}.',
        if (p.adjectiveStars.isNotEmpty)
          'Tính sao: ${p.adjectiveStars.take(2).join(', ')}.',
        'Can chi: ${p.heavenlyStem} ${p.earthlyBranch}.',
        'Vận đại: ${p.decadalRange.first}–${p.decadalRange.last} tuổi.',
      ];

  List<String> _relatedPalaces(String key) => switch (key) {
        'menh' => ['quan_loc', 'tai_bach', 'thien_di'],
        'quan_loc' => ['menh', 'tai_bach', 'thien_di'],
        'tai_bach' => ['quan_loc', 'dien_trach', 'menh'],
        'thien_di' => ['quan_loc', 'menh', 'no_boc'],
        'phu_the' => ['menh', 'phuc_duc', 'tu_tuc'],
        'phuc_duc' => ['menh', 'phuc_duc', 'tat_ach'],
        _ => ['menh', 'quan_loc'],
      };

  String _starKeywords(String star) {
    final sk = starKnowledgeBase[star];
    return sk != null ? sk.keywords.take(3).join(', ') : 'năng lượng riêng';
  }

  // ---- Focus metrics ----

  FocusMetric _focusMetric(
      String key, String label, EnginePalaceSnapshot? palace) {
    final score = palace != null
        ? _computeScore(palace.majorStars.length, palace.minorStars.length,
            palace.adjectiveStars.length, palace.key)
        : 40;
    final insight = switch (key) {
      'career' => score >= 68
          ? 'Vận công việc thuận lợi. Có cơ hội thể hiện năng lực và được ghi nhận.'
          : score >= 52
              ? 'Công việc có nhịp ổn định. Cần chọn lọc ưu tiên để đạt hiệu quả cao hơn.'
              : 'Vận công việc cần thời gian. Ưu tiên học hỏi và chuẩn bị nền tảng.',
      'wealth' => score >= 68
          ? 'Vận tài chính tốt. Có cơ hội tăng thu nhập — nắm bắt nhưng có kiểm soát.'
          : score >= 52
              ? 'Tài chính ổn định. Cần kế hoạch rõ ràng để tích lũy hiệu quả hơn.'
              : 'Vận tài chính cần cẩn thận. Tránh chi tiêu bốc đồng và quyết định đầu tư thiếu nghiên cứu.',
      'relationship' => score >= 68
          ? 'Vận tình cảm thuận lợi. Có duyên gặp người phù hợp — mở lòng đúng lúc.'
          : score >= 52
              ? 'Tình cảm có nhịp. Giao tiếp cởi mở hơn sẽ giúp cải thiện mối quan hệ.'
              : 'Vận tình cảm cần kiên nhẫn. Tập trung vào bản thân trước khi tìm kiếm đối tác.',
      'health' => score >= 68
          ? 'Sức khỏe tốt. Duy trì nhịp sinh hoạt đều đặn để giữ phong độ.'
          : score >= 52
              ? 'Sức khỏe ổn định. Chú ý ngủ đủ giấc và giảm stress không cần thiết.'
              : 'Sức khỏe cần chú ý hơn. Ăn uống, ngủ nghỉ và vận động nhẹ là ưu tiên.',
      _ => 'Cần thêm thông tin để luận giải chính xác hơn.',
    };
    return FocusMetric(key: key, label: label, score: score, insight: insight);
  }

  // ---- Overview bullets ----

  List<String> _buildOverviewBullets(
    EngineChartSnapshot snapshot,
    Map<String, EnginePalaceSnapshot> profilePalaceMap,
    List<ChartPalace> palaces,
    BirthProfile profile,
  ) {
    final result = <String>[];

    // Derive overview from actual star composition
    final menhPalace = profilePalaceMap['menh'];
    if (menhPalace != null && menhPalace.majorStars.isNotEmpty) {
      result.add(
          'Cung Mệnh có chính tinh nổi bật: ${menhPalace.majorStars.take(2).join(', ')}. '
          '${_fiveElementContext(snapshot.rawInfo)}');
    }

    final quanLoc = profilePalaceMap['quan_loc'];
    if (quanLoc != null && quanLoc.majorStars.isNotEmpty) {
      result.add(
          'Cung Quan Lộc được kích hoạt bởi ${quanLoc.majorStars.take(2).join(', ')}. '
          'Năm nay vận công việc có nhịp mở rộng.');
    }

    final taiBach = profilePalaceMap['tai_bach'];
    if (taiBach != null && taiBach.majorStars.isNotEmpty) {
      result.add(
          'Cung Tài Bạch chịu ảnh hưởng từ ${taiBach.majorStars.first}. '
          'Tài chính cần kế hoạch rõ ràng.');
    }

    if (profile.isLowConfidence) {
      result.add(
          'Giờ sinh chưa chắc chắn — các luận giải dưới đây nên dùng làm '
          'xu hướng tham khảo, không phải kết luận cứng.');
    }

    return result;
  }

  String _fiveElementContext(Map<String, Object?> rawInfo) {
    final element = rawInfo['fiveElementClass'] as String?;
    if (element == null) return '';
    final kb = fiveElementKnowledgeBase[element];
    if (kb == null) return 'Mệnh ngũ hành: $element.';
    return 'Mệnh ngũ hành: ${kb.element}. ${kb.strengths.take(2).join(', ')}.';
  }

  // ---- Fortune cycles ----

  List<FortunePeriod> _buildMajorCycles(EngineChartSnapshot snapshot) {
    return snapshot.palaces.take(4).map((p) {
      final score = _computeScore(
          p.majorStars.length, p.minorStars.length, p.adjectiveStars.length, p.key);
      final isHighlighted = p.key == 'quan_loc';
      return FortunePeriod(
        id: 'major_${p.key}',
        title: '${p.decadalRange.first}–${p.decadalRange.last} tuổi',
        subtitle:
            'Đại vận đi qua ${_palaceDisplayNameFor(p.key)}. '
            'Chính tinh: ${p.majorStars.take(2).join(', ')}.',
        score: score,
        highlights: <String>[
          if (p.majorStars.isNotEmpty)
            'Chính tinh nổi bật: ${p.majorStars.take(2).join(', ')}.',
          if (p.minorStars.isNotEmpty)
            'Phụ tinh: ${p.minorStars.take(2).join(', ')}.',
        ],
        cautions: <String>[
          'Nên xem vận thực tế, không chỉ dựa vào đại vận để kết luận.',
        ],
        unlocked: p.key == 'menh' || p.key == 'thien_di',
        unlockCost: 120,
        isHighlighted: isHighlighted,
      );
    }).toList();
  }

  String _palaceDisplayNameFor(String key) => switch (key) {
        'menh' => 'Cung Mệnh',
        'phu_mau' => 'Cung Phụ Mẫu',
        'phuc_duc' => 'Cung Phúc Đức',
        'dien_trach' => 'Cung Điền Trạch',
        'quan_loc' => 'Cung Quan Lộc',
        'no_boc' => 'Cung Nô Bộc',
        'thien_di' => 'Cung Thiên Di',
        'tat_ach' => 'Cung Tật Ách',
        'tai_bach' => 'Cung Tài Bạch',
        'tu_tuc' => 'Cung Tử Tức',
        'phu_the' => 'Cung Phu Thê',
        'huynh_de' => 'Cung Huynh Đệ',
        _ => 'Cung $key',
      };

  List<FortunePeriod> _buildMinorCycles(EngineChartSnapshot snapshot, int year) {
    final yearlyPalace = snapshot.cycles.yearly;
    final yearlyKey = yearlyPalace.palaceKeys.isNotEmpty
        ? yearlyPalace.palaceKeys.first
        : 'quan_loc';
    final focusPalace = snapshot.palaces.firstWhere(
      (p) => p.key == yearlyKey,
      orElse: () => snapshot.palaces.first,
    );

    return [
      _minorPeriod(year - 1, focusPalace, false),
      _minorPeriod(year, focusPalace, true),
      _minorPeriod(year + 1, snapshot.palaces.length > 1 ? snapshot.palaces[1] : focusPalace, false),
    ];
  }

  FortunePeriod _minorPeriod(int year, EnginePalaceSnapshot focus, bool highlighted) {
    final score = _computeScore(
        focus.majorStars.length, focus.minorStars.length,
        focus.adjectiveStars.length, focus.key);
    return FortunePeriod(
      id: 'minor_$year',
      title: '$year',
      subtitle: 'Tiểu vận nhấn vào ${_palaceDisplayNameFor(focus.key)}.',
      score: (score + (highlighted ? 0 : -4)).clamp(15, 92),
      highlights: <String>[
        if (focus.majorStars.isNotEmpty)
          'Chính tinh: ${focus.majorStars.take(2).join(', ')}.',
      ],
      cautions: <String>[
        if (!highlighted) 'Năm này chưa phải chính vận — ưu tiên chuẩn bị.',
      ],
      unlocked: highlighted,
      unlockCost: 90,
      isHighlighted: highlighted,
    );
  }

  // ---- Monthly fortunes ----

  List<MonthlyFortune> _buildMonthlyFortunes(
      EngineChartSnapshot snapshot, int year) {
    final monthlyPalaceKeys = snapshot.cycles.monthly.palaceKeys;
    return List.generate(12, (int i) {
      final month = i + 1;
      final palaceKey = monthlyPalaceKeys.isNotEmpty
          ? monthlyPalaceKeys[i % monthlyPalaceKeys.length]
          : 'quan_loc';
      final palace = snapshot.palaces.firstWhere(
        (p) => p.key == palaceKey,
        orElse: () => snapshot.palaces.first,
      );
      final score = _computeScore(
          palace.majorStars.length, palace.minorStars.length,
          palace.adjectiveStars.length, palace.key);
      return MonthlyFortune(
        id: 'month_$month',
        monthNumber: month,
        solarRange: 'Tháng $month/$year',
        title: '${_monthlyTitle(score)} ${_palaceDisplayNameFor(palaceKey).toLowerCase()}',
        highlight: palace.majorStars.isNotEmpty
            ? '${palace.majorStars.first} đi qua cung này trong tháng.'
            : 'Tháng này thiên về ${palace.key}.',
        score: score,
        advice: <String>[
          'Giữ nhịp sinh hoạt đều.',
          if (score < 55) 'Hạn chế quyết định tài chính lớn trong tháng này.',
          if (score >= 70) 'Tháng này có đà — nắm bắt cơ hội phù hợp.',
        ],
        unlocked: month == DateTime.now().month,
        unlockCost: 40,
      );
    });
  }

  String _monthlyTitle(int score) {
    if (score >= 70) return 'Vận thuận —';
    if (score >= 55) return 'Nhịp ổn định —';
    return 'Cần cẩn trọng —';
  }

  // ---- Daily recommendations ----

  List<DailyRecommendation> _buildDailyRecommendations(
      EngineChartSnapshot snapshot, int year) {
    final rawItems =
        snapshot.rawInfo['dailyWindow'] as List<dynamic>? ?? <dynamic>[];
    if (rawItems.isEmpty) {
      return _fallbackDailyRecs();
    }
    return rawItems.map((item) {
      final json = (item as Map<dynamic, dynamic>).cast<String, Object?>();
      return _dailyFromRaw(json);
    }).toList();
  }

  DailyRecommendation _dailyFromRaw(Map<String, Object?> json) {
    final stars = (json['stars'] as List<dynamic>? ?? [])
        .map((e) => e as String)
        .toList();
    final level = stars.length >= 3
        ? FortuneLevel.favorable
        : stars.length == 2
            ? FortuneLevel.balanced
            : FortuneLevel.caution;
    final palaceLabel = json['palaceLabel'] as String? ?? '';
    return DailyRecommendation(
      date: DateTime.parse(json['date']! as String),
      lunarLabel: json['lunarLabel'] as String? ?? '',
      level: level,
      summary: _dailySummary(stars, palaceLabel, level),
      goodFor: _goodFor(stars, level),
      avoid: _avoid(stars, level),
      canChi: json['canChi'] as String? ?? '',
      nguHanh: json['nguHanh'] as String? ?? '',
      goodHours: (json['goodHours'] as List<dynamic>? ?? ['08:00–09:59'])
          .map((e) => e.toString())
          .toList(),
    );
  }

  String _dailySummary(List<String> stars, String palace, FortuneLevel level) {
    final starStr = stars.isNotEmpty ? stars.join(', ') : 'năng lượng trung tính';
    return switch (level) {
      FortuneLevel.favorable =>
        'Ngày này nhấn vào $palace với $starStr — vận thuận lợi cho học hỏi và kết nối.',
      FortuneLevel.balanced =>
        'Ngày này đi qua $palace với $starStr — nhịp ổn định, phù hợp cho việc đã có kế hoạch.',
      FortuneLevel.caution =>
        'Ngày này đi qua $palace — cần cẩn trọng hơn, tránh quyết định quan trọng khi thiếu thông tin.',
    };
  }

  List<String> _goodFor(List<String> stars, FortuneLevel level) {
    if (level == FortuneLevel.favorable) {
      return ['Học tập', 'Gặp người quan trọng', 'Lên kế hoạch', 'Giao dịch nhỏ'];
    }
    if (level == FortuneLevel.balanced) {
      return ['Hoàn thành công việc tồn đọng', 'Rà soát kế hoạch'];
    }
    return ['Quan sát, không hành động lớn', 'Nghỉ ngơi'];
  }

  List<String> _avoid(List<String> stars, FortuneLevel level) {
    if (level == FortuneLevel.caution) {
      return [
        'Quyết định tài chính lớn',
        'Ký kết quan trọng',
        'Tranh luận căng thẳng',
      ];
    }
    return [
      'Chi tiêu bốc đồng',
      'Cam kết miệng khi thiếu thông tin',
    ];
  }

  List<DailyRecommendation> _fallbackDailyRecs() {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final date = now.add(Duration(days: i));
      final level = i == 0
          ? FortuneLevel.favorable
          : i == 1
              ? FortuneLevel.balanced
              : FortuneLevel.caution;
      return DailyRecommendation(
        date: date,
        lunarLabel: 'Âm lịch tùy ngày',
        level: level,
        summary: _fallbackSummary(level),
        goodFor: _goodFor([], level),
        avoid: _avoid([], level),
        canChi: 'Tùy ngày',
        nguHanh: 'Tùy ngày',
        goodHours: ['08:00–09:59', '11:00–12:59'],
      );
    });
  }

  String _fallbackSummary(FortuneLevel level) => switch (level) {
        FortuneLevel.favorable =>
          'Ngày thuận lợi cho học hỏi và kết nối mới.',
        FortuneLevel.balanced =>
          'Ngày ổn định, phù hợp cho việc đã có kế hoạch.',
        FortuneLevel.caution =>
          'Ngày cần cẩn trọng, tránh quyết định lớn khi thiếu thông tin.',
      };
}
