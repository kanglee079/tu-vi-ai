import 'dart:convert';

import 'birth_profile.dart';
import 'chart_models.dart';

class EngineChartSnapshot {
  const EngineChartSnapshot({
    required this.profileId,
    required this.year,
    required this.generatedAt,
    required this.engineVersion,
    required this.schemaVersion,
    required this.school,
    required this.palaces,
    required this.cycles,
    required this.rawInfo,
  });

  final String profileId;
  final int year;
  final DateTime generatedAt;
  final String engineVersion;
  final String schemaVersion;
  final String school;
  final List<EnginePalaceSnapshot> palaces;
  final EngineCycleSnapshot cycles;
  final Map<String, Object?> rawInfo;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'profileId': profileId,
      'year': year,
      'generatedAt': generatedAt.toIso8601String(),
      'engineVersion': engineVersion,
      'schemaVersion': schemaVersion,
      'school': school,
      'palaces': palaces
          .map((EnginePalaceSnapshot item) => item.toJson())
          .toList(),
      'cycles': cycles.toJson(),
      'rawInfo': rawInfo,
    };
  }

  factory EngineChartSnapshot.fromJson(Map<String, Object?> json) {
    return EngineChartSnapshot(
      profileId: json['profileId']! as String,
      year: json['year']! as int,
      generatedAt: DateTime.parse(json['generatedAt']! as String),
      engineVersion: json['engineVersion']! as String,
      schemaVersion: json['schemaVersion']! as String,
      school: json['school']! as String,
      palaces: (json['palaces'] as List<dynamic>? ?? const <dynamic>[])
          .map(
            (dynamic item) => EnginePalaceSnapshot.fromJson(
              (item as Map<dynamic, dynamic>).cast<String, Object?>(),
            ),
          )
          .toList(),
      cycles: EngineCycleSnapshot.fromJson(
        (json['cycles'] as Map<dynamic, dynamic>).cast<String, Object?>(),
      ),
      rawInfo:
          (json['rawInfo'] as Map<dynamic, dynamic>? ??
                  const <dynamic, dynamic>{})
              .cast<String, Object?>(),
    );
  }
}

class EnginePalaceSnapshot {
  const EnginePalaceSnapshot({
    required this.key,
    required this.index,
    required this.name,
    required this.heavenlyStem,
    required this.earthlyBranch,
    required this.isBodyPalace,
    required this.isOriginalPalace,
    required this.majorStars,
    required this.minorStars,
    required this.adjectiveStars,
    required this.decadalRange,
    required this.ages,
    required this.yearlies,
  });

  final String key;
  final int index;
  final String name;
  final String heavenlyStem;
  final String earthlyBranch;
  final bool isBodyPalace;
  final bool isOriginalPalace;
  final List<String> majorStars;
  final List<String> minorStars;
  final List<String> adjectiveStars;
  final List<int> decadalRange;
  final List<int> ages;
  final List<int> yearlies;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'key': key,
      'index': index,
      'name': name,
      'heavenlyStem': heavenlyStem,
      'earthlyBranch': earthlyBranch,
      'isBodyPalace': isBodyPalace,
      'isOriginalPalace': isOriginalPalace,
      'majorStars': majorStars,
      'minorStars': minorStars,
      'adjectiveStars': adjectiveStars,
      'decadalRange': decadalRange,
      'ages': ages,
      'yearlies': yearlies,
    };
  }

  factory EnginePalaceSnapshot.fromJson(Map<String, Object?> json) {
    return EnginePalaceSnapshot(
      key: json['key']! as String,
      index: json['index']! as int,
      name: json['name']! as String,
      heavenlyStem: json['heavenlyStem']! as String,
      earthlyBranch: json['earthlyBranch']! as String,
      isBodyPalace: json['isBodyPalace']! as bool,
      isOriginalPalace: json['isOriginalPalace']! as bool,
      majorStars: (json['majorStars'] as List<dynamic>? ?? const <dynamic>[])
          .map((dynamic item) => item as String)
          .toList(),
      minorStars: (json['minorStars'] as List<dynamic>? ?? const <dynamic>[])
          .map((dynamic item) => item as String)
          .toList(),
      adjectiveStars:
          (json['adjectiveStars'] as List<dynamic>? ?? const <dynamic>[])
              .map((dynamic item) => item as String)
              .toList(),
      decadalRange:
          (json['decadalRange'] as List<dynamic>? ?? const <dynamic>[])
              .map((dynamic item) => item as int)
              .toList(),
      ages: (json['ages'] as List<dynamic>? ?? const <dynamic>[])
          .map((dynamic item) => item as int)
          .toList(),
      yearlies: (json['yearlies'] as List<dynamic>? ?? const <dynamic>[])
          .map((dynamic item) => item as int)
          .toList(),
    );
  }
}

class EngineHoroscopeNode {
  const EngineHoroscopeNode({
    required this.scope,
    required this.index,
    required this.label,
    required this.heavenlyStem,
    required this.earthlyBranch,
    required this.palaceKeys,
    required this.mutagen,
    this.nominalAge,
  });

  final String scope;
  final int index;
  final String label;
  final String heavenlyStem;
  final String earthlyBranch;
  final List<String> palaceKeys;
  final Map<String, String> mutagen;
  final int? nominalAge;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'scope': scope,
      'index': index,
      'label': label,
      'heavenlyStem': heavenlyStem,
      'earthlyBranch': earthlyBranch,
      'palaceKeys': palaceKeys,
      'mutagen': mutagen,
      'nominalAge': nominalAge,
    };
  }

  factory EngineHoroscopeNode.fromJson(Map<String, Object?> json) {
    return EngineHoroscopeNode(
      scope: json['scope']! as String,
      index: json['index']! as int,
      label: json['label']! as String,
      heavenlyStem: json['heavenlyStem']! as String,
      earthlyBranch: json['earthlyBranch']! as String,
      palaceKeys: (json['palaceKeys'] as List<dynamic>? ?? const <dynamic>[])
          .map((dynamic item) => item as String)
          .toList(),
      mutagen:
          (json['mutagen'] as Map<dynamic, dynamic>? ??
                  const <dynamic, dynamic>{})
              .map(
                (dynamic key, dynamic value) =>
                    MapEntry(key as String, value as String),
              ),
      nominalAge: json['nominalAge'] as int?,
    );
  }
}

class EngineCycleSnapshot {
  const EngineCycleSnapshot({
    required this.decadal,
    required this.yearly,
    required this.monthly,
    required this.daily,
    required this.hourly,
    this.age,
  });

  final EngineHoroscopeNode decadal;
  final EngineHoroscopeNode yearly;
  final EngineHoroscopeNode monthly;
  final EngineHoroscopeNode daily;
  final EngineHoroscopeNode hourly;
  final EngineHoroscopeNode? age;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'decadal': decadal.toJson(),
      'yearly': yearly.toJson(),
      'monthly': monthly.toJson(),
      'daily': daily.toJson(),
      'hourly': hourly.toJson(),
      'age': age?.toJson(),
    };
  }

  factory EngineCycleSnapshot.fromJson(Map<String, Object?> json) {
    return EngineCycleSnapshot(
      decadal: EngineHoroscopeNode.fromJson(
        (json['decadal'] as Map<dynamic, dynamic>).cast<String, Object?>(),
      ),
      yearly: EngineHoroscopeNode.fromJson(
        (json['yearly'] as Map<dynamic, dynamic>).cast<String, Object?>(),
      ),
      monthly: EngineHoroscopeNode.fromJson(
        (json['monthly'] as Map<dynamic, dynamic>).cast<String, Object?>(),
      ),
      daily: EngineHoroscopeNode.fromJson(
        (json['daily'] as Map<dynamic, dynamic>).cast<String, Object?>(),
      ),
      hourly: EngineHoroscopeNode.fromJson(
        (json['hourly'] as Map<dynamic, dynamic>).cast<String, Object?>(),
      ),
      age: json['age'] == null
          ? null
          : EngineHoroscopeNode.fromJson(
              (json['age'] as Map<dynamic, dynamic>).cast<String, Object?>(),
            ),
    );
  }
}

class ChartSnapshotPayload {
  const ChartSnapshotPayload({
    required this.profile,
    required this.summary,
    required this.snapshot,
    required this.snapshotHash,
  });

  final BirthProfile profile;
  final ChartSummary summary;
  final EngineChartSnapshot snapshot;
  final String snapshotHash;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'profile': profile.toJson(),
      'summary': summary.toJson(),
      'snapshot': snapshot.toJson(),
      'snapshotHash': snapshotHash,
    };
  }

  factory ChartSnapshotPayload.fromJson(Map<String, Object?> json) {
    return ChartSnapshotPayload(
      profile: BirthProfile.fromJson(
        (json['profile'] as Map<dynamic, dynamic>).cast<String, Object?>(),
      ),
      summary: ChartSummary.fromJson(
        (json['summary'] as Map<dynamic, dynamic>).cast<String, Object?>(),
      ),
      snapshot: EngineChartSnapshot.fromJson(
        (json['snapshot'] as Map<dynamic, dynamic>).cast<String, Object?>(),
      ),
      snapshotHash: json['snapshotHash']! as String,
    );
  }

  static String buildSnapshotHash({
    required BirthProfile profile,
    required EngineChartSnapshot snapshot,
  }) {
    final encoded = jsonEncode(<String, Object?>{
      'profile': profile.toJson(),
      'snapshot': snapshot.toJson(),
    });
    return encoded.hashCode.toRadixString(16);
  }
}
