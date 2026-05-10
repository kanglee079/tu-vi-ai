import 'package:flutter/foundation.dart';
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import '../../../objectbox.g.dart';
import 'objectbox_entities.dart';

class ObjectBoxService {
  ObjectBoxService._(this._store);

  final Store _store;

  Box<BirthProfileEntity> get birthProfiles => _store.box<BirthProfileEntity>();
  Box<ChartCacheEntity> get chartCaches => _store.box<ChartCacheEntity>();
  Box<UnlockContentEntity> get unlockContents =>
      _store.box<UnlockContentEntity>();
  Box<WalletLedgerEntity> get walletLedger => _store.box<WalletLedgerEntity>();
  Box<WalletSnapshotEntity> get walletSnapshots =>
      _store.box<WalletSnapshotEntity>();
  Box<JournalEntryEntity> get journalEntries =>
      _store.box<JournalEntryEntity>();
  Box<AiConversationEntity> get aiConversations =>
      _store.box<AiConversationEntity>();
  Box<PendingSyncOperationEntity> get pendingSyncOperations =>
      _store.box<PendingSyncOperationEntity>();

  static ObjectBoxService? _instance;

  static Future<ObjectBoxService> create() async {
    final existing = _instance;
    if (existing != null) {
      return existing;
    }
    final directory = await defaultStoreDirectory();
    final store = await openStore(directory: directory.path);
    if (kDebugMode) {
      debugPrint('ObjectBox store opened at ${directory.path}');
    }
    _instance = ObjectBoxService._(store);
    return _instance!;
  }

  static Future<ObjectBoxService> memory() async {
    final store = Store(getObjectBoxModel(), directory: 'memory:minh-menh-ai');
    return ObjectBoxService._(store);
  }

  Future<void> close() async {
    _store.close();
    if (identical(_instance, this)) {
      _instance = null;
    }
  }
}
