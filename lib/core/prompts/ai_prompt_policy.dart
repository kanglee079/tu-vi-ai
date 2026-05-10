import '../../data/models/knowledge_models.dart';

class AiPromptPolicy {
  static const String systemPrompt = '''
Bạn là Trợ lý AI Tử Vi của app Minh Mệnh AI.

Nhiệm vụ:
- Giải thích lá số tử vi, vận hạn, ngày tốt xấu bằng tiếng Việt dễ hiểu.
- Chỉ luận dựa trên dữ liệu JSON do hệ thống cung cấp.
- Không tự thêm sao, cung, vận, ngày, giờ hoặc sự kiện không có trong dữ liệu.
- Không khẳng định tuyệt đối tương lai.
- Không đưa ra chẩn đoán y tế, tư vấn pháp lý hoặc khuyến nghị đầu tư chắc chắn.
- Luôn dùng ngôn ngữ tham khảo: "có xu hướng", "nên lưu ý", "phù hợp để", "cần cân nhắc".
- Nếu dữ liệu giờ sinh không chắc chắn, phải nói rõ độ tin cậy thấp hơn.
- Mỗi kết luận quan trọng phải có phần "dựa trên yếu tố nào".
- Không sử dụng hoặc tái tạo nguyên văn sách/tài liệu có bản quyền.
''';

  static const Map<String, Object> responseSchema = <String, Object>{
    'type': 'object',
    'additionalProperties': false,
    'required': <String>[
      'title',
      'shortAnswer',
      'summaryBullets',
      'detailedReading',
      'evidence',
      'practicalAdvice',
      'avoid',
      'nextSuggestions',
      'disclaimer',
    ],
    'properties': <String, Object>{
      'title': <String, Object>{'type': 'string'},
      'shortAnswer': <String, Object>{'type': 'string'},
      'summaryBullets': <String, Object>{
        'type': 'array',
        'items': <String, Object>{'type': 'string'},
      },
      'detailedReading': <String, Object>{'type': 'string'},
      'evidence': <String, Object>{
        'type': 'array',
        'items': <String, Object>{
          'type': 'object',
          'additionalProperties': false,
          'required': <String>['factor', 'meaning', 'impact'],
          'properties': <String, Object>{
            'factor': <String, Object>{'type': 'string'},
            'meaning': <String, Object>{'type': 'string'},
            'impact': <String, Object>{
              'type': 'string',
              'enum': <String>['low', 'medium', 'high'],
            },
          },
        },
      },
      'practicalAdvice': <String, Object>{
        'type': 'array',
        'items': <String, Object>{'type': 'string'},
      },
      'avoid': <String, Object>{
        'type': 'array',
        'items': <String, Object>{'type': 'string'},
      },
      'nextSuggestions': <String, Object>{
        'type': 'array',
        'items': <String, Object>{'type': 'string'},
      },
      'disclaimer': <String, Object>{'type': 'string'},
    },
  };

  static Map<String, Object> buildRequestPayload({
    required String userQuestion,
    required Map<String, Object?> profile,
    required Map<String, Object?> chartFacts,
    required KnowledgeBundle knowledgeBundle,
    String language = 'vi',
    String tone = 'easy_to_understand',
  }) {
    return <String, Object>{
      'systemPrompt': systemPrompt,
      'developerRules': const <String>[
        'Output must match responseSchema exactly.',
        'Do not return markdown.',
        'Do not add facts outside chartFacts or knowledgeBase.',
        'Use knowledgeBase as internal rewritten rules, not as quoted source text.',
        'Always include a non-deterministic disclaimer.',
      ],
      'responseSchema': responseSchema,
      'userContext': <String, Object?>{
        'userQuestion': userQuestion,
        'language': language,
        'tone': tone,
        'profile': profile,
        'chartFacts': chartFacts,
        'knowledgeBase': _serializeKnowledgeBundle(knowledgeBundle),
        'safetyRules': const <String>[
          'No absolute prediction',
          'No medical/legal/financial deterministic advice',
          'No copyrighted text reproduction',
          'Explain evidence',
          'Respect birth-time confidence',
        ],
      },
    };
  }

  static Map<String, Object> _serializeKnowledgeBundle(KnowledgeBundle bundle) {
    return <String, Object>{
      'stars': bundle.starMeanings
          .map(
            (StarMeaning item) => <String, Object>{
              'id': item.id,
              'name': item.name,
              'group': item.group,
              'element': item.element,
              'keywords': item.keywords,
              'positive': item.positive,
              'negative': item.negative,
              'advice': item.advice,
              'sourceType': item.attribution.sourceType.label,
              'version': item.attribution.version,
            },
          )
          .toList(),
      'palaces': bundle.palaceMeanings
          .map(
            (PalaceMeaning item) => <String, Object>{
              'id': item.id,
              'name': item.name,
              'keywords': item.keywords,
              'description': item.description,
              'sourceType': item.attribution.sourceType.label,
              'version': item.attribution.version,
            },
          )
          .toList(),
      'rules': bundle.combinationRules
          .map(
            (CombinationRule item) => <String, Object?>{
              'id': item.id,
              'condition': <String, Object?>{
                'palaceKey': item.condition.palaceKey,
                'stars': item.condition.stars,
                'activatedByCycle': item.condition.activatedByCycle,
              },
              'meaning': item.meaning,
              'risk': item.risk,
              'advice': item.advice,
              'evidence': item.evidence,
              'impact': item.impact,
              'confidence': item.confidence,
              'sourceType': item.attribution.sourceType.label,
              'version': item.attribution.version,
            },
          )
          .toList(),
      'templates': bundle.readingTemplates
          .map(
            (ReadingTemplate item) => <String, Object>{
              'scope': item.scope,
              'template': item.template,
              'requiredVariables': item.requiredVariables,
              'sourceType': item.attribution.sourceType.label,
              'version': item.attribution.version,
            },
          )
          .toList(),
    };
  }
}
