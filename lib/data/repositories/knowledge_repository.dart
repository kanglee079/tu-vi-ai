import '../models/knowledge_models.dart';

abstract class KnowledgeRepository {
  Future<KnowledgeBundle> getBundleForScope(String scope);
  Future<List<CombinationRule>> findRulesForPalace(String palaceKey);
}
