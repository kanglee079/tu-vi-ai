import 'dart:async';

import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../../core/services/iap_verification_service.dart';
import '../../../../core/services/purchase_client_service.dart';
import '../../../../data/models/wallet_models.dart';
import '../../../../data/repositories/wallet_repository.dart';

class WalletController extends GetxController {
  WalletController(
    this._walletRepository,
    this._purchaseClientService,
    this._iapVerificationService,
  );

  final WalletRepository _walletRepository;
  final PurchaseClientService _purchaseClientService;
  final IapVerificationService _iapVerificationService;

  final Rxn<WalletSnapshot> wallet = Rxn<WalletSnapshot>();
  final RxList<WalletOffer> offers = <WalletOffer>[].obs;
  final RxMap<String, ProductDetails> storeProducts =
      <String, ProductDetails>{}.obs;
  final RxBool storeAvailable = false.obs;
  final RxString purchaseError = ''.obs;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  @override
  void onInit() {
    super.onInit();
    _load();
    _purchaseSubscription = _purchaseClientService.purchases.listen(
      _handlePurchases,
    );
  }

  Future<void> _load() async {
    wallet.value = await _walletRepository.getWallet();
    offers.assignAll(await _walletRepository.listOffers());
    storeAvailable.value = await _purchaseClientService.isAvailable();
    if (storeAvailable.value) {
      final response = await _purchaseClientService.queryProducts(
        offers.map((WalletOffer offer) => offer.id).toSet(),
      );
      storeProducts.assignAll(<String, ProductDetails>{
        for (final product in response.productDetails) product.id: product,
      });
    }
  }

  Future<void> buyOffer(WalletOffer offer) async {
    purchaseError.value = '';
    final product = storeProducts[offer.id];
    if (product == null) {
      purchaseError.value = 'Sản phẩm store chưa sẵn sàng cho ${offer.id}.';
      return;
    }
    await _purchaseClientService.buy(product);
  }

  Future<void> restorePurchases() async {
    purchaseError.value = '';
    await _purchaseClientService.restore();
  }

  Future<void> _handlePurchases(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        try {
          final result = await _iapVerificationService.verify(
            productId: purchase.productID,
            transactionId: purchase.purchaseID ?? '',
            serverVerificationData:
                purchase.verificationData.serverVerificationData,
          );
          if (result.verified) {
            final current = await _walletRepository.getWallet();
            await _walletRepository.replaceWalletSnapshot(
              WalletSnapshot(
                balance: current.balance + result.walletDelta,
                history: current.history,
                activePlanLabel: current.activePlanLabel,
              ),
            );
            wallet.value = await _walletRepository.getWallet();
          }
        } catch (error) {
          purchaseError.value = error.toString();
        }
      } else if (purchase.status == PurchaseStatus.error) {
        purchaseError.value =
            purchase.error?.message ?? 'Store purchase failed.';
      }
      if (purchase.pendingCompletePurchase) {
        await _purchaseClientService.complete(purchase);
      }
    }
  }

  @override
  void onClose() {
    _purchaseSubscription?.cancel();
    super.onClose();
  }
}
