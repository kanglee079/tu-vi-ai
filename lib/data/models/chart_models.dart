import 'daily_recommendation.dart';

class ChartSummary {
  const ChartSummary({
    required this.profileId,
    required this.year,
    required this.school,
    required this.overallScore,
    required this.overviewBullets,
    required this.disclaimer,
    required this.palaces,
    required this.focusMetrics,
    required this.evidenceBullets,
    required this.majorCycles,
    required this.minorCycles,
    required this.monthlyFortunes,
    required this.dailyRecommendations,
  });

  final String profileId;
  final int year;
  final String school;
  final int overallScore;
  final List<String> overviewBullets;
  final String disclaimer;
  final List<ChartPalace> palaces;
  final List<FocusMetric> focusMetrics;
  final List<String> evidenceBullets;
  final List<FortunePeriod> majorCycles;
  final List<FortunePeriod> minorCycles;
  final List<MonthlyFortune> monthlyFortunes;
  final List<DailyRecommendation> dailyRecommendations;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'profileId': profileId,
      'year': year,
      'school': school,
      'overallScore': overallScore,
      'overviewBullets': overviewBullets,
      'disclaimer': disclaimer,
      'palaces': palaces.map((ChartPalace item) => item.toJson()).toList(),
      'focusMetrics': focusMetrics
          .map((FocusMetric item) => item.toJson())
          .toList(),
      'evidenceBullets': evidenceBullets,
      'majorCycles': majorCycles
          .map((FortunePeriod item) => item.toJson())
          .toList(),
      'minorCycles': minorCycles
          .map((FortunePeriod item) => item.toJson())
          .toList(),
      'monthlyFortunes': monthlyFortunes
          .map((MonthlyFortune item) => item.toJson())
          .toList(),
      'dailyRecommendations': dailyRecommendations
          .map((DailyRecommendation item) => item.toJson())
          .toList(),
    };
  }

  factory ChartSummary.fromJson(Map<String, Object?> json) {
    return ChartSummary(
      profileId: json['profileId']! as String,
      year: json['year']! as int,
      school: json['school']! as String,
      overallScore: json['overallScore']! as int,
      overviewBullets:
          (json['overviewBullets'] as List<dynamic>? ?? const <dynamic>[])
              .map((dynamic item) => item as String)
              .toList(),
      disclaimer: json['disclaimer']! as String,
      palaces: (json['palaces'] as List<dynamic>? ?? const <dynamic>[])
          .map(
            (dynamic item) => ChartPalace.fromJson(
              (item as Map<dynamic, dynamic>).cast<String, Object?>(),
            ),
          )
          .toList(),
      focusMetrics:
          (json['focusMetrics'] as List<dynamic>? ?? const <dynamic>[])
              .map(
                (dynamic item) => FocusMetric.fromJson(
                  (item as Map<dynamic, dynamic>).cast<String, Object?>(),
                ),
              )
              .toList(),
      evidenceBullets:
          (json['evidenceBullets'] as List<dynamic>? ?? const <dynamic>[])
              .map((dynamic item) => item as String)
              .toList(),
      majorCycles: (json['majorCycles'] as List<dynamic>? ?? const <dynamic>[])
          .map(
            (dynamic item) => FortunePeriod.fromJson(
              (item as Map<dynamic, dynamic>).cast<String, Object?>(),
            ),
          )
          .toList(),
      minorCycles: (json['minorCycles'] as List<dynamic>? ?? const <dynamic>[])
          .map(
            (dynamic item) => FortunePeriod.fromJson(
              (item as Map<dynamic, dynamic>).cast<String, Object?>(),
            ),
          )
          .toList(),
      monthlyFortunes:
          (json['monthlyFortunes'] as List<dynamic>? ?? const <dynamic>[])
              .map(
                (dynamic item) => MonthlyFortune.fromJson(
                  (item as Map<dynamic, dynamic>).cast<String, Object?>(),
                ),
              )
              .toList(),
      dailyRecommendations:
          (json['dailyRecommendations'] as List<dynamic>? ?? const <dynamic>[])
              .map(
                (dynamic item) => DailyRecommendation.fromJson(
                  (item as Map<dynamic, dynamic>).cast<String, Object?>(),
                ),
              )
              .toList(),
    );
  }

  ChartSummary copyWith({
    String? profileId,
    int? year,
    String? school,
    int? overallScore,
    List<String>? overviewBullets,
    String? disclaimer,
    List<ChartPalace>? palaces,
    List<FocusMetric>? focusMetrics,
    List<String>? evidenceBullets,
    List<FortunePeriod>? majorCycles,
    List<FortunePeriod>? minorCycles,
    List<MonthlyFortune>? monthlyFortunes,
    List<DailyRecommendation>? dailyRecommendations,
  }) {
    return ChartSummary(
      profileId: profileId ?? this.profileId,
      year: year ?? this.year,
      school: school ?? this.school,
      overallScore: overallScore ?? this.overallScore,
      overviewBullets: overviewBullets ?? this.overviewBullets,
      disclaimer: disclaimer ?? this.disclaimer,
      palaces: palaces ?? this.palaces,
      focusMetrics: focusMetrics ?? this.focusMetrics,
      evidenceBullets: evidenceBullets ?? this.evidenceBullets,
      majorCycles: majorCycles ?? this.majorCycles,
      minorCycles: minorCycles ?? this.minorCycles,
      monthlyFortunes: monthlyFortunes ?? this.monthlyFortunes,
      dailyRecommendations: dailyRecommendations ?? this.dailyRecommendations,
    );
  }
}

class ChartPalace {
  const ChartPalace({
    required this.key,
    required this.name,
    required this.score,
    required this.shortSummary,
    required this.primaryStars,
    required this.secondaryStars,
    required this.strengths,
    required this.challenges,
    required this.advice,
    required this.evidence,
    required this.relatedPalaces,
    required this.isUnlocked,
    required this.unlockCost,
  });

  final String key;
  final String name;
  final int score;
  final String shortSummary;
  final List<String> primaryStars;
  final List<String> secondaryStars;
  final List<String> strengths;
  final List<String> challenges;
  final List<String> advice;
  final List<String> evidence;
  final List<String> relatedPalaces;
  final bool isUnlocked;
  final int unlockCost;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'key': key,
      'name': name,
      'score': score,
      'shortSummary': shortSummary,
      'primaryStars': primaryStars,
      'secondaryStars': secondaryStars,
      'strengths': strengths,
      'challenges': challenges,
      'advice': advice,
      'evidence': evidence,
      'relatedPalaces': relatedPalaces,
      'isUnlocked': isUnlocked,
      'unlockCost': unlockCost,
    };
  }

  factory ChartPalace.fromJson(Map<String, Object?> json) {
    return ChartPalace(
      key: json['key']! as String,
      name: json['name']! as String,
      score: json['score']! as int,
      shortSummary: json['shortSummary']! as String,
      primaryStars:
          (json['primaryStars'] as List<dynamic>? ?? const <dynamic>[])
              .map((dynamic item) => item as String)
              .toList(),
      secondaryStars:
          (json['secondaryStars'] as List<dynamic>? ?? const <dynamic>[])
              .map((dynamic item) => item as String)
              .toList(),
      strengths: (json['strengths'] as List<dynamic>? ?? const <dynamic>[])
          .map((dynamic item) => item as String)
          .toList(),
      challenges: (json['challenges'] as List<dynamic>? ?? const <dynamic>[])
          .map((dynamic item) => item as String)
          .toList(),
      advice: (json['advice'] as List<dynamic>? ?? const <dynamic>[])
          .map((dynamic item) => item as String)
          .toList(),
      evidence: (json['evidence'] as List<dynamic>? ?? const <dynamic>[])
          .map((dynamic item) => item as String)
          .toList(),
      relatedPalaces:
          (json['relatedPalaces'] as List<dynamic>? ?? const <dynamic>[])
              .map((dynamic item) => item as String)
              .toList(),
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      unlockCost: json['unlockCost'] as int? ?? 0,
    );
  }

  ChartPalace copyWith({
    String? key,
    String? name,
    int? score,
    String? shortSummary,
    List<String>? primaryStars,
    List<String>? secondaryStars,
    List<String>? strengths,
    List<String>? challenges,
    List<String>? advice,
    List<String>? evidence,
    List<String>? relatedPalaces,
    bool? isUnlocked,
    int? unlockCost,
  }) {
    return ChartPalace(
      key: key ?? this.key,
      name: name ?? this.name,
      score: score ?? this.score,
      shortSummary: shortSummary ?? this.shortSummary,
      primaryStars: primaryStars ?? this.primaryStars,
      secondaryStars: secondaryStars ?? this.secondaryStars,
      strengths: strengths ?? this.strengths,
      challenges: challenges ?? this.challenges,
      advice: advice ?? this.advice,
      evidence: evidence ?? this.evidence,
      relatedPalaces: relatedPalaces ?? this.relatedPalaces,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockCost: unlockCost ?? this.unlockCost,
    );
  }
}

class FocusMetric {
  const FocusMetric({
    required this.key,
    required this.label,
    required this.score,
    required this.insight,
  });

  final String key;
  final String label;
  final int score;
  final String insight;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'key': key,
      'label': label,
      'score': score,
      'insight': insight,
    };
  }

  factory FocusMetric.fromJson(Map<String, Object?> json) {
    return FocusMetric(
      key: json['key']! as String,
      label: json['label']! as String,
      score: json['score']! as int,
      insight: json['insight']! as String,
    );
  }
}

class FortunePeriod {
  const FortunePeriod({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.score,
    required this.highlights,
    required this.cautions,
    required this.unlocked,
    required this.unlockCost,
    this.isHighlighted = false,
  });

  final String id;
  final String title;
  final String subtitle;
  final int score;
  final List<String> highlights;
  final List<String> cautions;
  final bool unlocked;
  final int unlockCost;
  final bool isHighlighted;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'score': score,
      'highlights': highlights,
      'cautions': cautions,
      'unlocked': unlocked,
      'unlockCost': unlockCost,
      'isHighlighted': isHighlighted,
    };
  }

  factory FortunePeriod.fromJson(Map<String, Object?> json) {
    return FortunePeriod(
      id: json['id']! as String,
      title: json['title']! as String,
      subtitle: json['subtitle']! as String,
      score: json['score']! as int,
      highlights: (json['highlights'] as List<dynamic>? ?? const <dynamic>[])
          .map((dynamic item) => item as String)
          .toList(),
      cautions: (json['cautions'] as List<dynamic>? ?? const <dynamic>[])
          .map((dynamic item) => item as String)
          .toList(),
      unlocked: json['unlocked'] as bool? ?? false,
      unlockCost: json['unlockCost'] as int? ?? 0,
      isHighlighted: json['isHighlighted'] as bool? ?? false,
    );
  }
}

class MonthlyFortune {
  const MonthlyFortune({
    required this.id,
    required this.monthNumber,
    required this.solarRange,
    required this.title,
    required this.highlight,
    required this.score,
    required this.advice,
    required this.unlocked,
    required this.unlockCost,
  });

  final String id;
  final int monthNumber;
  final String solarRange;
  final String title;
  final String highlight;
  final int score;
  final List<String> advice;
  final bool unlocked;
  final int unlockCost;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'id': id,
      'monthNumber': monthNumber,
      'solarRange': solarRange,
      'title': title,
      'highlight': highlight,
      'score': score,
      'advice': advice,
      'unlocked': unlocked,
      'unlockCost': unlockCost,
    };
  }

  factory MonthlyFortune.fromJson(Map<String, Object?> json) {
    return MonthlyFortune(
      id: json['id']! as String,
      monthNumber: json['monthNumber']! as int,
      solarRange: json['solarRange']! as String,
      title: json['title']! as String,
      highlight: json['highlight']! as String,
      score: json['score']! as int,
      advice: (json['advice'] as List<dynamic>? ?? const <dynamic>[])
          .map((dynamic item) => item as String)
          .toList(),
      unlocked: json['unlocked'] as bool? ?? false,
      unlockCost: json['unlockCost'] as int? ?? 0,
    );
  }
}
