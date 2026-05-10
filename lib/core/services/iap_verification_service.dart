import 'package:flutter/foundation.dart';

import 'api_client_service.dart';

class PurchaseVerifyResult {
  const PurchaseVerifyResult({
    required this.verified,
    required this.entitlements,
    required this.walletDelta,
  });

  final bool verified;
  final List<String> entitlements;
  final int walletDelta;

  factory PurchaseVerifyResult.fromJson(Map<String, Object?> json) {
    return PurchaseVerifyResult(
      verified: json['verified'] as bool? ?? false,
      entitlements:
          (json['entitlements'] as List<dynamic>? ?? const <dynamic>[])
              .map((dynamic item) => item as String)
              .toList(),
      walletDelta: json['walletDelta'] as int? ?? 0,
    );
  }
}

class IapVerificationService {
  IapVerificationService(this._apiClientService);

  final ApiClientService _apiClientService;

  Future<PurchaseVerifyResult> verify({
    required String productId,
    required String transactionId,
    required String serverVerificationData,
  }) async {
    final isApple =
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS;
    final path = isApple ? '/iap/apple/verify' : '/iap/google/verify';
    final response = await _apiClientService.post(
      path,
      data: <String, Object?>{
        'productId': productId,
        'transactionId': transactionId,
        if (isApple)
          'receiptPayload': serverVerificationData
        else
          'purchaseToken': serverVerificationData,
      },
    );
    return PurchaseVerifyResult.fromJson(
      (response.data as Map<dynamic, dynamic>).cast<String, Object?>(),
    );
  }
}
