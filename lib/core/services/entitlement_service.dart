abstract class EntitlementService {
  Future<bool> hasAccess(String contentKey);
  Future<void> grant(String contentKey);
  Future<List<String>> listGrantedContentKeys({String? profileId});
}

class PrototypeEntitlementService implements EntitlementService {
  final Set<String> _unlocked = <String>{};

  @override
  Future<void> grant(String contentKey) async {
    _unlocked.add(contentKey);
  }

  @override
  Future<bool> hasAccess(String contentKey) async {
    return _unlocked.contains(contentKey);
  }

  @override
  Future<List<String>> listGrantedContentKeys({String? profileId}) async {
    return _unlocked.toList();
  }
}
