import 'dart:convert';

import '../local/objectbox/objectbox_entities.dart';
import '../local/objectbox/objectbox_service.dart';
import '../mock/prototype_seed_data.dart';
import '../models/unlocked_content.dart';
import '../models/wallet_models.dart';
import '../../objectbox.g.dart';
import 'wallet_repository.dart';

class PersistentWalletRepository implements WalletRepository {
  PersistentWalletRepository(this._objectBoxService);

  final ObjectBoxService _objectBoxService;

  static const String _walletSnapshotKey = 'primary';

  @override
  Future<WalletSnapshot> getWallet() async {
    final snapshotEntity = _objectBoxService.walletSnapshots
        .query(WalletSnapshotEntity_.snapshotKey.equals(_walletSnapshotKey))
        .build()
        .findFirst();
    if (snapshotEntity == null) {
      final seed = PrototypeSeedData.wallet();
      await replaceWalletSnapshot(seed);
      return seed;
    }
    final history = (jsonDecode(snapshotEntity.historyJson) as List<dynamic>)
        .map(
          (dynamic item) => WalletLedgerEntry.fromJson(
            (item as Map<dynamic, dynamic>).cast<String, Object?>(),
          ),
        )
        .toList();
    final ledgerBalance = _objectBoxService.walletLedger.getAll().fold<int>(
      0,
      (int total, WalletLedgerEntity item) => total + item.amount,
    );
    return WalletSnapshot(
      balance: history.isEmpty ? snapshotEntity.balance : ledgerBalance,
      history: history,
      activePlanLabel: snapshotEntity.activePlanLabel,
    );
  }

  @override
  Future<List<WalletOffer>> listOffers() async {
    return PrototypeSeedData.offers();
  }

  @override
  Future<List<UnlockedContent>> listUnlockedContent({String? profileId}) async {
    final query = profileId == null
        ? _objectBoxService.unlockContents.query()
        : _objectBoxService.unlockContents.query(
            UnlockContentEntity_.profileId.equals(profileId),
          );
    return query
        .build()
        .find()
        .map(
          (UnlockContentEntity item) => UnlockedContent(
            contentType: item.contentType,
            contentKey: item.contentKey,
            unlockMethod: item.unlockMethod,
            coinSpent: item.coinSpent,
          ),
        )
        .toList();
  }

  @override
  Future<UnlockPreview> previewUnlock(String contentKey) async {
    final wallet = await getWallet();
    final costMap = <String, int>{
      'quan_loc': 100,
      'tai_bach': 100,
      'phu_mau': 80,
      'month_2': 40,
      'major_25_34': 120,
    };
    final cost = costMap[contentKey] ?? 90;
    return UnlockPreview(
      contentKey: contentKey,
      title: 'Mở nội dung chuyên sâu',
      cost: cost,
      remainingBalance: wallet.balance - cost,
      reason:
          'Mở phần luận giải này để xem đủ điểm mạnh, thử thách và khuyến nghị hành động.',
      alternativeOffer:
          'Hoặc mở gói tháng để dùng AI nhiều hơn và đọc nhật vận không giới hạn.',
    );
  }

  @override
  Future<void> recordUnlock(UnlockedContent content) async {
    final key = '${content.contentType}::${content.contentKey}';
    final existing = _objectBoxService.unlockContents
        .query(UnlockContentEntity_.unlockKey.equals(key))
        .build()
        .findFirst();
    if (existing == null) {
      _objectBoxService.unlockContents.put(
        UnlockContentEntity(
          unlockKey: key,
          profileId: 'profile_001',
          contentType: content.contentType,
          contentKey: content.contentKey,
          unlockMethod: content.unlockMethod,
          coinSpent: content.coinSpent,
          createdAtEpochMs: DateTime.now().millisecondsSinceEpoch,
        ),
      );
    }
    await _appendLedgerEntry(
      WalletLedgerEntry(
        title: 'Mở ${content.contentKey}',
        amount: -content.coinSpent,
        createdAtLabel: _nowLabel(),
      ),
      source: 'unlock',
    );
  }

  @override
  Future<void> replaceWalletSnapshot(WalletSnapshot snapshot) async {
    final existing = _objectBoxService.walletSnapshots
        .query(WalletSnapshotEntity_.snapshotKey.equals(_walletSnapshotKey))
        .build()
        .findFirst();
    _objectBoxService.walletSnapshots.put(
      WalletSnapshotEntity(
        dbId: existing?.dbId ?? 0,
        snapshotKey: _walletSnapshotKey,
        balance: snapshot.balance,
        activePlanLabel: snapshot.activePlanLabel,
        historyJson: jsonEncode(
          snapshot.history
              .map((WalletLedgerEntry item) => item.toJson())
              .toList(),
        ),
        updatedAtEpochMs: DateTime.now().millisecondsSinceEpoch,
      ),
    );
    if (_objectBoxService.walletLedger.isEmpty()) {
      for (final entry in snapshot.history) {
        await _appendLedgerEntry(entry, source: 'seed');
      }
    }
  }

  Future<void> _appendLedgerEntry(
    WalletLedgerEntry entry, {
    required String source,
  }) async {
    _objectBoxService.walletLedger.put(
      WalletLedgerEntity(
        entryId:
            '${source}_${DateTime.now().millisecondsSinceEpoch}_${entry.amount}',
        title: entry.title,
        amount: entry.amount,
        createdAtLabel: entry.createdAtLabel,
        createdAtEpochMs: DateTime.now().millisecondsSinceEpoch,
        source: source,
      ),
    );
    final wallet = await getWallet();
    final currentHistory = List<WalletLedgerEntry>.from(wallet.history)
      ..insert(0, entry);
    final balance = _objectBoxService.walletLedger.getAll().fold<int>(
      0,
      (int total, WalletLedgerEntity item) => total + item.amount,
    );
    await replaceWalletSnapshot(
      WalletSnapshot(
        balance: balance,
        history: currentHistory,
        activePlanLabel: wallet.activePlanLabel,
      ),
    );
  }

  String _nowLabel() {
    final now = DateTime.now();
    final day = now.day.toString().padLeft(2, '0');
    final month = now.month.toString().padLeft(2, '0');
    return '$day/$month/${now.year}';
  }
}
