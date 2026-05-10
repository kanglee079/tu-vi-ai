import '../../core/utils/app_formatters.dart';

enum FortuneLevel { favorable, balanced, caution }

FortuneLevel fortuneLevelFromName(String value) {
  return FortuneLevel.values.firstWhere(
    (FortuneLevel item) => item.name == value,
    orElse: () => FortuneLevel.balanced,
  );
}

extension FortuneLevelLabel on FortuneLevel {
  String get label {
    switch (this) {
      case FortuneLevel.favorable:
        return 'Thuận';
      case FortuneLevel.balanced:
        return 'Cân bằng';
      case FortuneLevel.caution:
        return 'Cần lưu ý';
    }
  }
}

class DailyRecommendation {
  const DailyRecommendation({
    required this.date,
    required this.lunarLabel,
    required this.level,
    required this.summary,
    required this.goodFor,
    required this.avoid,
    required this.canChi,
    required this.nguHanh,
    required this.goodHours,
  });

  final DateTime date;
  final String lunarLabel;
  final FortuneLevel level;
  final String summary;
  final List<String> goodFor;
  final List<String> avoid;
  final String canChi;
  final String nguHanh;
  final List<String> goodHours;

  String get dateLabel => AppFormatters.fullDate(date);
  String get weekdayLabel => AppFormatters.weekday(date);

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'date': date.toIso8601String(),
      'lunarLabel': lunarLabel,
      'level': level.name,
      'summary': summary,
      'goodFor': goodFor,
      'avoid': avoid,
      'canChi': canChi,
      'nguHanh': nguHanh,
      'goodHours': goodHours,
    };
  }

  factory DailyRecommendation.fromJson(Map<String, Object?> json) {
    return DailyRecommendation(
      date: DateTime.parse(json['date']! as String),
      lunarLabel: json['lunarLabel']! as String,
      level: fortuneLevelFromName(json['level'] as String? ?? ''),
      summary: json['summary']! as String,
      goodFor: (json['goodFor'] as List<dynamic>? ?? const <dynamic>[])
          .map((dynamic item) => item as String)
          .toList(),
      avoid: (json['avoid'] as List<dynamic>? ?? const <dynamic>[])
          .map((dynamic item) => item as String)
          .toList(),
      canChi: json['canChi']! as String,
      nguHanh: json['nguHanh']! as String,
      goodHours: (json['goodHours'] as List<dynamic>? ?? const <dynamic>[])
          .map((dynamic item) => item as String)
          .toList(),
    );
  }
}
