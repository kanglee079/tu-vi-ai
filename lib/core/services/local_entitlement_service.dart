import '../../data/local/objectbox/objectbox_entities.dart';
import '../../data/local/objectbox/objectbox_service.dart';
import '../../objectbox.g.dart';
import 'entitlement_service.dart';

class LocalEntitlementService implements EntitlementService {
  LocalEntitlementService(this._objectBoxService);

  final ObjectBoxService _objectBoxService;

  @override
  Future<void> grant(String contentKey) async {
    final existing = _objectBoxService.unlockContents
        .query(UnlockContentEntity_.contentKey.equals(contentKey))
        .build()
        .findFirst();
    if (existing != null) {
      return;
    }
    _objectBoxService.unlockContents.put(
      UnlockContentEntity(
        unlockKey: 'unlock::$contentKey',
        profileId: 'global',
        contentType: 'entitlement',
        contentKey: contentKey,
        unlockMethod: 'grant',
        coinSpent: 0,
        createdAtEpochMs: DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  @override
  Future<bool> hasAccess(String contentKey) async {
    return _objectBoxService.unlockContents
            .query(UnlockContentEntity_.contentKey.equals(contentKey))
            .build()
            .count() >
        0;
  }

  @override
  Future<List<String>> listGrantedContentKeys({String? profileId}) async {
    final query = profileId == null
        ? _objectBoxService.unlockContents.query()
        : _objectBoxService.unlockContents.query(
            UnlockContentEntity_.profileId
                .equals(profileId)
                .or(UnlockContentEntity_.profileId.equals('global')),
          );
    return query
        .build()
        .find()
        .map((UnlockContentEntity item) => item.contentKey)
        .toList();
  }
}
