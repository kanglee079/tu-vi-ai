import 'package:dio/dio.dart';

import '../../../core/services/api_client_service.dart';
import '../../models/ai_models.dart';
import '../../repositories/ai_assistant_repository.dart';
import '../../repositories/chart_repository.dart';

class RemoteAiAssistantRepository implements AiAssistantRepository {
  RemoteAiAssistantRepository({
    required ApiClientService apiClientService,
    required ChartRepository chartRepository,
    required AiAssistantRepository fallbackRepository,
  }) : _apiClientService = apiClientService,
       _chartRepository = chartRepository,
       _fallbackRepository = fallbackRepository;

  final ApiClientService _apiClientService;
  final ChartRepository _chartRepository;
  final AiAssistantRepository _fallbackRepository;

  @override
  Future<AiChatResponse> askQuestion(AiChatRequest request) async {
    try {
      final snapshot = await _chartRepository.getChartSnapshot(
        request.profileId,
        request.year,
      );
      final response = await _apiClientService.post(
        '/ai/chat',
        data: <String, Object?>{
          'profileId': request.profileId,
          'scope': request.scope,
          'question': request.question,
          'chartSnapshotHash': snapshot?.snapshotHash,
          'chartSummary': snapshot?.summary.toJson(),
        },
      );
      return AiChatResponse.fromJson(
        (response.data as Map<dynamic, dynamic>).cast<String, Object?>(),
      );
    } on DioException {
      return _fallbackRepository.askQuestion(request);
    } catch (_) {
      return _fallbackRepository.askQuestion(request);
    }
  }

  @override
  Future<List<AiPromptSuggestion>> getQuickPrompts(String scope) {
    return _fallbackRepository.getQuickPrompts(scope);
  }
}
