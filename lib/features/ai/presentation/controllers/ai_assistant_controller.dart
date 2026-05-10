import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/ai_models.dart';
import '../../../../data/repositories/ai_assistant_repository.dart';
import '../../../../shared/navigation/route_args.dart';

class AiAssistantController extends GetxController {
  AiAssistantController(this._aiAssistantRepository);

  final AiAssistantRepository _aiAssistantRepository;

  final TextEditingController questionController = TextEditingController();
  final RxList<AiPromptSuggestion> prompts = <AiPromptSuggestion>[].obs;
  final RxList<AiMessage> messages = <AiMessage>[].obs;
  final Rxn<AiChatResponse> latestResponse = Rxn<AiChatResponse>();
  final RxBool isLoading = false.obs;
  late final AiRouteArgs routeArgs;

  @override
  void onInit() {
    super.onInit();
    routeArgs = Get.arguments as AiRouteArgs;
    _load();
  }

  Future<void> _load() async {
    prompts.assignAll(
      await _aiAssistantRepository.getQuickPrompts('chart_general'),
    );
    if (routeArgs.seedQuestion != null) {
      questionController.text = routeArgs.seedQuestion!;
      await ask();
    }
  }

  Future<void> ask({String? preset}) async {
    final question = (preset ?? questionController.text).trim();
    if (question.isEmpty) {
      return;
    }
    isLoading.value = true;
    messages.add(AiMessage(role: 'user', content: question));
    latestResponse.value = await _aiAssistantRepository.askQuestion(
      AiChatRequest(
        profileId: routeArgs.profileId,
        scope: 'chart_general',
        question: question,
        year: routeArgs.year,
      ),
    );
    messages.add(
      AiMessage(role: 'assistant', content: latestResponse.value!.shortAnswer),
    );
    isLoading.value = false;
    if (preset == null) {
      questionController.clear();
    }
  }

  @override
  void onClose() {
    questionController.dispose();
    super.onClose();
  }
}
