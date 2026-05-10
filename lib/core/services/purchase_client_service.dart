import 'package:in_app_purchase/in_app_purchase.dart';

abstract class PurchaseClientService {
  Future<bool> isAvailable();
  Future<ProductDetailsResponse> queryProducts(Set<String> productIds);
  Stream<List<PurchaseDetails>> get purchases;
  Future<void> buy(ProductDetails productDetails);
  Future<void> restore();
  Future<void> complete(PurchaseDetails purchaseDetails);
}

class StoreKitPlayPurchaseClientService implements PurchaseClientService {
  StoreKitPlayPurchaseClientService({InAppPurchase? inAppPurchase})
    : _inAppPurchase = inAppPurchase ?? InAppPurchase.instance;

  final InAppPurchase _inAppPurchase;

  @override
  Future<bool> isAvailable() {
    return _inAppPurchase.isAvailable();
  }

  @override
  Stream<List<PurchaseDetails>> get purchases => _inAppPurchase.purchaseStream;

  @override
  Future<ProductDetailsResponse> queryProducts(Set<String> productIds) {
    return _inAppPurchase.queryProductDetails(productIds);
  }

  @override
  Future<void> buy(ProductDetails productDetails) async {
    final param = PurchaseParam(productDetails: productDetails);
    if (productDetails.id.startsWith('coin_')) {
      await _inAppPurchase.buyConsumable(
        purchaseParam: param,
        autoConsume: true,
      );
      return;
    }
    await _inAppPurchase.buyNonConsumable(purchaseParam: param);
  }

  @override
  Future<void> restore() {
    return _inAppPurchase.restorePurchases();
  }

  @override
  Future<void> complete(PurchaseDetails purchaseDetails) {
    return _inAppPurchase.completePurchase(purchaseDetails);
  }
}
