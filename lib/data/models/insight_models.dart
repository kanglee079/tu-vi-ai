class LifeMapSummary {
  const LifeMapSummary({
    required this.profileId,
    required this.year,
    required this.title,
    required this.overview,
    required this.peakElement,
    required this.currentCycleLabel,
    required this.currentCycleTheme,
    required this.stages,
  });

  final String profileId;
  final int year;
  final String title;
  final String overview;
  final String peakElement;
  final String currentCycleLabel;
  final String currentCycleTheme;
  final List<LifeMapStage> stages;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'profileId': profileId,
      'year': year,
      'title': title,
      'overview': overview,
      'peakElement': peakElement,
      'currentCycleLabel': currentCycleLabel,
      'currentCycleTheme': currentCycleTheme,
      'stages': stages.map((LifeMapStage item) => item.toJson()).toList(),
    };
  }

  factory LifeMapSummary.fromJson(Map<String, Object?> json) {
    return LifeMapSummary(
      profileId: json['profileId']! as String,
      year: json['year']! as int,
      title: json['title']! as String,
      overview: json['overview']! as String,
      peakElement: json['peakElement']! as String,
      currentCycleLabel: json['currentCycleLabel']! as String,
      currentCycleTheme: json['currentCycleTheme']! as String,
      stages: (json['stages'] as List<dynamic>? ?? const <dynamic>[])
          .map(
            (dynamic item) => LifeMapStage.fromJson(
              (item as Map<dynamic, dynamic>).cast<String, Object?>(),
            ),
          )
          .toList(),
    );
  }
}

class LifeMapStage {
  const LifeMapStage({
    required this.id,
    required this.ageRangeLabel,
    required this.title,
    required this.subtitle,
    required this.score,
    required this.highlights,
    required this.cautions,
    this.isCurrent = false,
  });

  final String id;
  final String ageRangeLabel;
  final String title;
  final String subtitle;
  final int score;
  final List<String> highlights;
  final List<String> cautions;
  final bool isCurrent;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'id': id,
      'ageRangeLabel': ageRangeLabel,
      'title': title,
      'subtitle': subtitle,
      'score': score,
      'highlights': highlights,
      'cautions': cautions,
      'isCurrent': isCurrent,
    };
  }

  factory LifeMapStage.fromJson(Map<String, Object?> json) {
    return LifeMapStage(
      id: json['id']! as String,
      ageRangeLabel: json['ageRangeLabel']! as String,
      title: json['title']! as String,
      subtitle: json['subtitle']! as String,
      score: json['score']! as int,
      highlights: (json['highlights'] as List<dynamic>? ?? const <dynamic>[])
          .map((dynamic item) => item as String)
          .toList(),
      cautions: (json['cautions'] as List<dynamic>? ?? const <dynamic>[])
          .map((dynamic item) => item as String)
          .toList(),
      isCurrent: json['isCurrent'] as bool? ?? false,
    );
  }
}

enum JournalMood { bright, deep, mist }

JournalMood journalMoodFromName(String value) {
  return JournalMood.values.firstWhere(
    (JournalMood item) => item.name == value,
    orElse: () => JournalMood.deep,
  );
}

extension JournalMoodLabel on JournalMood {
  String get label {
    switch (this) {
      case JournalMood.bright:
        return 'Dương tích';
      case JournalMood.deep:
        return 'Âm trầm';
      case JournalMood.mist:
        return 'Hỗn mang';
    }
  }
}

class JournalEntry {
  const JournalEntry({
    required this.id,
    required this.createdAtLabel,
    required this.mood,
    required this.title,
    required this.body,
    required this.sentimentLabel,
  });

  final String id;
  final String createdAtLabel;
  final JournalMood mood;
  final String title;
  final String body;
  final String sentimentLabel;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'id': id,
      'createdAtLabel': createdAtLabel,
      'mood': mood.name,
      'title': title,
      'body': body,
      'sentimentLabel': sentimentLabel,
    };
  }

  factory JournalEntry.fromJson(Map<String, Object?> json) {
    return JournalEntry(
      id: json['id']! as String,
      createdAtLabel: json['createdAtLabel']! as String,
      mood: journalMoodFromName(json['mood'] as String? ?? ''),
      title: json['title']! as String,
      body: json['body']! as String,
      sentimentLabel: json['sentimentLabel']! as String,
    );
  }
}

class JournalReflection {
  const JournalReflection({
    required this.title,
    required this.body,
    required this.tags,
  });

  final String title;
  final String body;
  final List<String> tags;

  Map<String, Object?> toJson() {
    return <String, Object?>{'title': title, 'body': body, 'tags': tags};
  }

  factory JournalReflection.fromJson(Map<String, Object?> json) {
    return JournalReflection(
      title: json['title']! as String,
      body: json['body']! as String,
      tags: (json['tags'] as List<dynamic>? ?? const <dynamic>[])
          .map((dynamic item) => item as String)
          .toList(),
    );
  }
}

class CompatibilityReport {
  const CompatibilityReport({
    required this.primaryProfileId,
    required this.secondaryProfileId,
    required this.overallScore,
    required this.verdict,
    required this.summary,
    required this.strengths,
    required this.challenges,
    required this.guidance,
    required this.categories,
  });

  final String primaryProfileId;
  final String secondaryProfileId;
  final int overallScore;
  final String verdict;
  final String summary;
  final List<String> strengths;
  final List<String> challenges;
  final List<String> guidance;
  final List<CompatibilityCategoryScore> categories;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'primaryProfileId': primaryProfileId,
      'secondaryProfileId': secondaryProfileId,
      'overallScore': overallScore,
      'verdict': verdict,
      'summary': summary,
      'strengths': strengths,
      'challenges': challenges,
      'guidance': guidance,
      'categories': categories
          .map((CompatibilityCategoryScore item) => item.toJson())
          .toList(),
    };
  }

  factory CompatibilityReport.fromJson(Map<String, Object?> json) {
    return CompatibilityReport(
      primaryProfileId: json['primaryProfileId']! as String,
      secondaryProfileId: json['secondaryProfileId']! as String,
      overallScore: json['overallScore']! as int,
      verdict: json['verdict']! as String,
      summary: json['summary']! as String,
      strengths: (json['strengths'] as List<dynamic>? ?? const <dynamic>[])
          .map((dynamic item) => item as String)
          .toList(),
      challenges: (json['challenges'] as List<dynamic>? ?? const <dynamic>[])
          .map((dynamic item) => item as String)
          .toList(),
      guidance: (json['guidance'] as List<dynamic>? ?? const <dynamic>[])
          .map((dynamic item) => item as String)
          .toList(),
      categories: (json['categories'] as List<dynamic>? ?? const <dynamic>[])
          .map(
            (dynamic item) => CompatibilityCategoryScore.fromJson(
              (item as Map<dynamic, dynamic>).cast<String, Object?>(),
            ),
          )
          .toList(),
    );
  }
}

class CompatibilityCategoryScore {
  const CompatibilityCategoryScore({
    required this.label,
    required this.score,
    required this.insight,
  });

  final String label;
  final int score;
  final String insight;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'label': label,
      'score': score,
      'insight': insight,
    };
  }

  factory CompatibilityCategoryScore.fromJson(Map<String, Object?> json) {
    return CompatibilityCategoryScore(
      label: json['label']! as String,
      score: json['score']! as int,
      insight: json['insight']! as String,
    );
  }
}
