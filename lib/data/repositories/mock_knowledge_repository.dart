import '../mock/prototype_knowledge_base.dart';
import '../models/knowledge_models.dart';
import 'knowledge_repository.dart';

class MockKnowledgeRepository implements KnowledgeRepository {
  @override
  Future<List<CombinationRule>> findRulesForPalace(String palaceKey) async {
    return PrototypeKnowledgeBase.combinationRules()
        .where((CombinationRule rule) => rule.condition.palaceKey == palaceKey)
        .toList();
  }

  @override
  Future<KnowledgeBundle> getBundleForScope(String scope) async {
    return KnowledgeBundle(
      starMeanings: PrototypeKnowledgeBase.starMeanings(),
      palaceMeanings: PrototypeKnowledgeBase.palaceMeanings(),
      combinationRules: PrototypeKnowledgeBase.combinationRules(),
      readingTemplates: PrototypeKnowledgeBase.readingTemplates(),
    );
  }
}
