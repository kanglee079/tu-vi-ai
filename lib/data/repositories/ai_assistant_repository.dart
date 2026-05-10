import '../models/ai_models.dart';

abstract class AiAssistantRepository {
  Future<List<AiPromptSuggestion>> getQuickPrompts(String scope);
  Future<AiChatResponse> askQuestion(AiChatRequest request);
}
