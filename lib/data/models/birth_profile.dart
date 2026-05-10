import '../../core/utils/app_formatters.dart';

enum Gender { male, female, other }

Gender genderFromName(String value) {
  return Gender.values.firstWhere(
    (Gender item) => item.name == value,
    orElse: () => Gender.other,
  );
}

extension GenderLabel on Gender {
  String get label {
    switch (this) {
      case Gender.male:
        return 'Nam';
      case Gender.female:
        return 'Nữ';
      case Gender.other:
        return 'Khác';
    }
  }
}

enum CalendarType { solar, lunar }

CalendarType calendarTypeFromName(String value) {
  return CalendarType.values.firstWhere(
    (CalendarType item) => item.name == value,
    orElse: () => CalendarType.solar,
  );
}

extension CalendarTypeLabel on CalendarType {
  String get label => this == CalendarType.solar ? 'Dương lịch' : 'Âm lịch';
}

enum BirthTimeConfidence { exact, estimated, unknown }

BirthTimeConfidence birthTimeConfidenceFromName(String value) {
  return BirthTimeConfidence.values.firstWhere(
    (BirthTimeConfidence item) => item.name == value,
    orElse: () => BirthTimeConfidence.unknown,
  );
}

extension BirthTimeConfidenceLabel on BirthTimeConfidence {
  String get label {
    switch (this) {
      case BirthTimeConfidence.exact:
        return 'Chắc chắn';
      case BirthTimeConfidence.estimated:
        return 'Ước lượng';
      case BirthTimeConfidence.unknown:
        return 'Không rõ';
    }
  }
}

enum MainFocus { career, relationship, wealth, health, study, family }

MainFocus mainFocusFromName(String value) {
  return MainFocus.values.firstWhere(
    (MainFocus item) => item.name == value,
    orElse: () => MainFocus.career,
  );
}

extension MainFocusLabel on MainFocus {
  String get label {
    switch (this) {
      case MainFocus.career:
        return 'Công việc';
      case MainFocus.relationship:
        return 'Tình cảm';
      case MainFocus.wealth:
        return 'Tài chính';
      case MainFocus.health:
        return 'Sức khỏe';
      case MainFocus.study:
        return 'Học tập';
      case MainFocus.family:
        return 'Gia đình';
    }
  }
}

class BirthProfile {
  const BirthProfile({
    required this.id,
    required this.name,
    required this.gender,
    required this.calendarType,
    required this.birthDate,
    required this.birthHourLabel,
    required this.timezone,
    required this.birthTimeConfidence,
    required this.mainFocus,
    required this.isMain,
    this.birthMinute,
    this.birthPlace,
  });

  final String id;
  final String name;
  final Gender gender;
  final CalendarType calendarType;
  final DateTime birthDate;
  final String birthHourLabel;
  final int? birthMinute;
  final String? birthPlace;
  final String timezone;
  final BirthTimeConfidence birthTimeConfidence;
  final List<MainFocus> mainFocus;
  final bool isMain;

  String get birthDateLabel => AppFormatters.fullDate(birthDate);
  String get confidenceLabel => birthTimeConfidence.label;
  bool get isLowConfidence => birthTimeConfidence != BirthTimeConfidence.exact;
  String get focusSummary =>
      mainFocus.map((MainFocus e) => e.label).join(' • ');

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'id': id,
      'name': name,
      'gender': gender.name,
      'calendarType': calendarType.name,
      'birthDate': birthDate.toIso8601String(),
      'birthHourLabel': birthHourLabel,
      'birthMinute': birthMinute,
      'birthPlace': birthPlace,
      'timezone': timezone,
      'birthTimeConfidence': birthTimeConfidence.name,
      'mainFocus': mainFocus.map((MainFocus focus) => focus.name).toList(),
      'isMain': isMain,
    };
  }

  factory BirthProfile.fromJson(Map<String, Object?> json) {
    return BirthProfile(
      id: json['id']! as String,
      name: json['name']! as String,
      gender: genderFromName(json['gender'] as String? ?? ''),
      calendarType: calendarTypeFromName(json['calendarType'] as String? ?? ''),
      birthDate: DateTime.parse(json['birthDate']! as String),
      birthHourLabel: json['birthHourLabel']! as String,
      birthMinute: json['birthMinute'] as int?,
      birthPlace: json['birthPlace'] as String?,
      timezone: json['timezone'] as String? ?? 'Asia/Ho_Chi_Minh',
      birthTimeConfidence: birthTimeConfidenceFromName(
        json['birthTimeConfidence'] as String? ?? '',
      ),
      mainFocus: (json['mainFocus'] as List<dynamic>? ?? const <dynamic>[])
          .map((dynamic item) => mainFocusFromName(item as String? ?? ''))
          .toList(),
      isMain: json['isMain'] as bool? ?? false,
    );
  }

  BirthProfile copyWith({
    String? id,
    String? name,
    Gender? gender,
    CalendarType? calendarType,
    DateTime? birthDate,
    String? birthHourLabel,
    int? birthMinute,
    String? birthPlace,
    String? timezone,
    BirthTimeConfidence? birthTimeConfidence,
    List<MainFocus>? mainFocus,
    bool? isMain,
  }) {
    return BirthProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      calendarType: calendarType ?? this.calendarType,
      birthDate: birthDate ?? this.birthDate,
      birthHourLabel: birthHourLabel ?? this.birthHourLabel,
      birthMinute: birthMinute ?? this.birthMinute,
      birthPlace: birthPlace ?? this.birthPlace,
      timezone: timezone ?? this.timezone,
      birthTimeConfidence: birthTimeConfidence ?? this.birthTimeConfidence,
      mainFocus: mainFocus ?? this.mainFocus,
      isMain: isMain ?? this.isMain,
    );
  }
}
