enum KnowledgeSourceType {
  internalRewrite,
  openSourceReference,
  publicDomainReference,
  licensedContent,
  expertAuthored,
}

extension KnowledgeSourceTypeLabel on KnowledgeSourceType {
  String get label {
    switch (this) {
      case KnowledgeSourceType.internalRewrite:
        return 'internal_rewrite';
      case KnowledgeSourceType.openSourceReference:
        return 'open_source_reference';
      case KnowledgeSourceType.publicDomainReference:
        return 'public_domain_reference';
      case KnowledgeSourceType.licensedContent:
        return 'licensed_content';
      case KnowledgeSourceType.expertAuthored:
        return 'expert_authored';
    }
  }
}

class KnowledgeAttribution {
  const KnowledgeAttribution({
    required this.sourceType,
    required this.sourceRef,
    required this.copyrightStatus,
    required this.compiler,
    required this.version,
    required this.updatedAt,
    this.license,
    this.notes,
  });

  final KnowledgeSourceType sourceType;
  final String sourceRef;
  final String copyrightStatus;
  final String compiler;
  final String version;
  final DateTime updatedAt;
  final String? license;
  final String? notes;
}

class StarMeaning {
  const StarMeaning({
    required this.id,
    required this.name,
    required this.group,
    required this.element,
    required this.keywords,
    required this.positive,
    required this.negative,
    required this.advice,
    required this.attribution,
  });

  final String id;
  final String name;
  final String group;
  final String element;
  final List<String> keywords;
  final String positive;
  final String negative;
  final String advice;
  final KnowledgeAttribution attribution;
}

class PalaceMeaning {
  const PalaceMeaning({
    required this.id,
    required this.name,
    required this.keywords,
    required this.description,
    required this.attribution,
  });

  final String id;
  final String name;
  final List<String> keywords;
  final String description;
  final KnowledgeAttribution attribution;
}

class CombinationCondition {
  const CombinationCondition({
    required this.palaceKey,
    required this.stars,
    this.activatedByCycle,
  });

  final String palaceKey;
  final List<String> stars;
  final String? activatedByCycle;
}

class CombinationRule {
  const CombinationRule({
    required this.id,
    required this.condition,
    required this.meaning,
    required this.risk,
    required this.advice,
    required this.evidence,
    required this.impact,
    required this.confidence,
    required this.attribution,
  });

  final String id;
  final CombinationCondition condition;
  final String meaning;
  final String risk;
  final String advice;
  final String evidence;
  final String impact;
  final double confidence;
  final KnowledgeAttribution attribution;
}

class ReadingTemplate {
  const ReadingTemplate({
    required this.scope,
    required this.template,
    required this.requiredVariables,
    required this.attribution,
  });

  final String scope;
  final String template;
  final List<String> requiredVariables;
  final KnowledgeAttribution attribution;
}

class KnowledgeBundle {
  const KnowledgeBundle({
    required this.starMeanings,
    required this.palaceMeanings,
    required this.combinationRules,
    required this.readingTemplates,
  });

  final List<StarMeaning> starMeanings;
  final List<PalaceMeaning> palaceMeanings;
  final List<CombinationRule> combinationRules;
  final List<ReadingTemplate> readingTemplates;
}
