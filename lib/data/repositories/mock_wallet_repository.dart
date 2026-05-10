import '../mock/prototype_seed_data.dart';
import '../models/unlocked_content.dart';
import '../models/wallet_models.dart';
import 'wallet_repository.dart';

class MockWalletRepository implements WalletRepository {
  final WalletSnapshot _wallet = PrototypeSeedData.wallet();
  final List<WalletOffer> _offers = PrototypeSeedData.offers();
  final List<UnlockedContent> _unlocked = <UnlockedContent>[];

  @override
  Future<List<WalletOffer>> listOffers() async {
    return _offers;
  }

  @override
  Future<UnlockPreview> previewUnlock(String contentKey) async {
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
      remainingBalance: _wallet.balance - cost,
      reason:
          'Mở phần luận giải này để xem đủ điểm mạnh, thử thách và khuyến nghị hành động.',
      alternativeOffer:
          'Hoặc mở gói tháng để dùng AI nhiều hơn và đọc nhật vận không giới hạn.',
    );
  }

  @override
  Future<WalletSnapshot> getWallet() async {
    return _wallet;
  }

  @override
  Future<List<UnlockedContent>> listUnlockedContent({String? profileId}) async {
    return List<UnlockedContent>.from(_unlocked);
  }

  @override
  Future<void> recordUnlock(UnlockedContent content) async {
    _unlocked.add(content);
  }

  @override
  Future<void> replaceWalletSnapshot(WalletSnapshot snapshot) async {}
}
