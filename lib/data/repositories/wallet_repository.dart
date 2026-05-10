import '../models/unlocked_content.dart';
import '../models/wallet_models.dart';

abstract class WalletRepository {
  Future<WalletSnapshot> getWallet();
  Future<List<WalletOffer>> listOffers();
  Future<UnlockPreview> previewUnlock(String contentKey);
  Future<List<UnlockedContent>> listUnlockedContent({String? profileId});
  Future<void> recordUnlock(UnlockedContent content);
  Future<void> replaceWalletSnapshot(WalletSnapshot snapshot);
}
