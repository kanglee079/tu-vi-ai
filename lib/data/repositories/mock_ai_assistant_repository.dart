import '../../core/prompts/ai_prompt_policy.dart';
import '../mock/prototype_seed_data.dart';
import '../models/ai_models.dart';
import '../models/knowledge_models.dart';
import 'ai_assistant_repository.dart';
import 'knowledge_repository.dart';

class MockAiAssistantRepository implements AiAssistantRepository {
  MockAiAssistantRepository(this._knowledgeRepository);

  final KnowledgeRepository _knowledgeRepository;

  @override
  Future<AiChatResponse> askQuestion(AiChatRequest request) async {
    final knowledgeBundle = await _knowledgeRepository.getBundleForScope(
      request.scope,
    );
    final promptPayload = AiPromptPolicy.buildRequestPayload(
      userQuestion: request.question,
      profile: <String, Object?>{
        'profileId': request.profileId,
        'birthTimeConfidence': 'exact_or_repository_value',
      },
      chartFacts: <String, Object?>{
        'year': request.year,
        'scope': request.scope,
        'factsArePrecomputed': true,
      },
      knowledgeBundle: knowledgeBundle,
    );
    final topRule = _bestRuleForQuestion(
      request.question,
      knowledgeBundle.combinationRules,
    );
    final lowerQuestion = request.question.toLowerCase();
    final title = lowerQuestion.contains('công việc')
        ? 'Nhịp công việc năm ${request.year}'
        : lowerQuestion.contains('tình cảm')
        ? 'Tín hiệu tình cảm hiện tại'
        : 'Tóm tắt theo câu hỏi của bạn';

    final shortAnswer = lowerQuestion.contains('công việc')
        ? 'Năm ${request.year}, công việc của bạn có xu hướng mở rộng vai trò và tăng trách nhiệm. ${topRule.meaning}'
        : lowerQuestion.contains('tình cảm')
        ? 'Tình cảm thiên về cần giao tiếp rõ ràng và thực tế hơn. Nếu né xung đột nhỏ, áp lực dễ dồn lại thành hiểu sai.'
        : 'Lá số đang cho thấy giai đoạn cần ưu tiên hướng phát triển rõ, giao tiếp minh bạch và giữ nhịp sinh hoạt đều.';

    return AiChatResponse(
      title: title,
      shortAnswer: shortAnswer,
      summaryBullets: <String>[
        'Ưu tiên ít mục tiêu nhưng tác động lớn.',
        'Mạng lưới và môi trường mới có lợi cho tiến trình của bạn.',
        'Nên cân nhắc trước các cam kết lớn về tiền hoặc hợp tác.',
      ],
      detailedReading:
          'Mock response này mô phỏng pipeline chuẩn: engine sinh facts, knowledge base nội bộ cung cấp rule, AI chỉ viết lại thành ngôn ngữ dễ hiểu. Rule đang dùng: ${topRule.evidence} Vì vậy, hướng phù hợp nhất là ${topRule.advice}',
      evidence: <AiEvidence>[
        AiEvidence(
          factor: 'Prompt policy',
          meaning:
              'Payload ép AI chỉ dùng chartFacts + knowledgeBase và trả về JSON schema ổn định (${promptPayload['responseSchema'] is Map ? 'schema_ready' : 'schema_missing'}).',
          impact: 'high',
        ),
        AiEvidence(
          factor: 'Rule ${topRule.id}',
          meaning: topRule.evidence,
          impact: topRule.impact,
        ),
        const AiEvidence(
          factor: 'Cung Thiên Di',
          meaning: 'Môi trường mới và kết nối mới đang hỗ trợ vận phát triển.',
          impact: 'medium',
        ),
        const AiEvidence(
          factor: 'Cung Tật Ách',
          meaning:
              'Cần giữ nhịp sinh hoạt để tránh giảm phong độ khi áp lực tăng.',
          impact: 'medium',
        ),
      ],
      practicalAdvice: <String>[
        topRule.advice,
        'Rà soát điều khoản trước khi ký hoặc cam kết tiền lớn.',
        'Giữ lịch nghỉ ngắn đều để không hụt năng lượng.',
      ],
      avoid: <String>[topRule.risk, 'Ôm việc thay cả nhóm.'],
      nextSuggestions: const <String>[
        'Giải thích thêm về Cung Quan Lộc',
        'Chọn ngày phù hợp cho ký kết',
        'Phân tích tháng nổi bật trong năm',
      ],
      disclaimer: 'Nội dung mang tính tham khảo, chiêm nghiệm và định hướng.',
    );
  }

  @override
  Future<List<AiPromptSuggestion>> getQuickPrompts(String scope) async {
    return PrototypeSeedData.prompts();
  }

  CombinationRule _bestRuleForQuestion(
    String question,
    List<CombinationRule> rules,
  ) {
    final normalizedQuestion = question.toLowerCase();
    if (normalizedQuestion.contains('công việc')) {
      return rules.firstWhere(
        (CombinationRule rule) => rule.condition.palaceKey == 'quan_loc',
        orElse: () => rules.first,
      );
    }
    if (normalizedQuestion.contains('tài')) {
      return rules.firstWhere(
        (CombinationRule rule) => rule.condition.palaceKey == 'tai_bach',
        orElse: () => rules.first,
      );
    }
    return rules.first;
  }
}
