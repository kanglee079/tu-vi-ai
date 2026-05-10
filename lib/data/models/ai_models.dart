class AiPromptSuggestion {
  const AiPromptSuggestion({
    required this.scope,
    required this.label,
    required this.prompt,
    this.isPremium = false,
  });

  final String scope;
  final String label;
  final String prompt;
  final bool isPremium;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'scope': scope,
      'label': label,
      'prompt': prompt,
      'isPremium': isPremium,
    };
  }

  factory AiPromptSuggestion.fromJson(Map<String, Object?> json) {
    return AiPromptSuggestion(
      scope: json['scope']! as String,
      label: json['label']! as String,
      prompt: json['prompt']! as String,
      isPremium: json['isPremium'] as bool? ?? false,
    );
  }
}

class AiChatRequest {
  const AiChatRequest({
    required this.profileId,
    required this.scope,
    required this.question,
    required this.year,
  });

  final String profileId;
  final String scope;
  final String question;
  final int year;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'profileId': profileId,
      'scope': scope,
      'question': question,
      'year': year,
    };
  }
}

class AiEvidence {
  const AiEvidence({
    required this.factor,
    required this.meaning,
    required this.impact,
  });

  final String factor;
  final String meaning;
  final String impact;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'factor': factor,
      'meaning': meaning,
      'impact': impact,
    };
  }

  factory AiEvidence.fromJson(Map<String, Object?> json) {
    return AiEvidence(
      factor: json['factor']! as String,
      meaning: json['meaning']! as String,
      impact: json['impact']! as String,
    );
  }
}

class AiChatResponse {
  const AiChatResponse({
    required this.title,
    required this.shortAnswer,
    required this.summaryBullets,
    required this.detailedReading,
    required this.evidence,
    required this.practicalAdvice,
    required this.avoid,
    required this.nextSuggestions,
    required this.disclaimer,
  });

  final String title;
  final String shortAnswer;
  final List<String> summaryBullets;
  final String detailedReading;
  final List<AiEvidence> evidence;
  final List<String> practicalAdvice;
  final List<String> avoid;
  final List<String> nextSuggestions;
  final String disclaimer;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'title': title,
      'shortAnswer': shortAnswer,
      'summaryBullets': summaryBullets,
      'detailedReading': detailedReading,
      'evidence': evidence.map((AiEvidence item) => item.toJson()).toList(),
      'practicalAdvice': practicalAdvice,
      'avoid': avoid,
      'nextSuggestions': nextSuggestions,
      'disclaimer': disclaimer,
    };
  }

  factory AiChatResponse.fromJson(Map<String, Object?> json) {
    return AiChatResponse(
      title: json['title']! as String,
      shortAnswer: json['shortAnswer']! as String,
      summaryBullets:
          (json['summaryBullets'] as List<dynamic>? ?? const <dynamic>[])
              .map((dynamic item) => item as String)
              .toList(),
      detailedReading: json['detailedReading']! as String,
      evidence: (json['evidence'] as List<dynamic>? ?? const <dynamic>[])
          .map(
            (dynamic item) => AiEvidence.fromJson(
              (item as Map<dynamic, dynamic>).cast<String, Object?>(),
            ),
          )
          .toList(),
      practicalAdvice:
          (json['practicalAdvice'] as List<dynamic>? ?? const <dynamic>[])
              .map((dynamic item) => item as String)
              .toList(),
      avoid: (json['avoid'] as List<dynamic>? ?? const <dynamic>[])
          .map((dynamic item) => item as String)
          .toList(),
      nextSuggestions:
          (json['nextSuggestions'] as List<dynamic>? ?? const <dynamic>[])
              .map((dynamic item) => item as String)
              .toList(),
      disclaimer: json['disclaimer']! as String,
    );
  }
}

class AiMessage {
  const AiMessage({required this.role, required this.content});

  final String role;
  final String content;

  Map<String, Object?> toJson() {
    return <String, Object?>{'role': role, 'content': content};
  }

  factory AiMessage.fromJson(Map<String, Object?> json) {
    return AiMessage(
      role: json['role']! as String,
      content: json['content']! as String,
    );
  }
}
