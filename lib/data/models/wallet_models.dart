class WalletSnapshot {
  const WalletSnapshot({
    required this.balance,
    required this.history,
    required this.activePlanLabel,
  });

  final int balance;
  final List<WalletLedgerEntry> history;
  final String activePlanLabel;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'balance': balance,
      'history': history
          .map((WalletLedgerEntry item) => item.toJson())
          .toList(),
      'activePlanLabel': activePlanLabel,
    };
  }

  factory WalletSnapshot.fromJson(Map<String, Object?> json) {
    return WalletSnapshot(
      balance: json['balance'] as int? ?? 0,
      history: (json['history'] as List<dynamic>? ?? const <dynamic>[])
          .map(
            (dynamic item) => WalletLedgerEntry.fromJson(
              (item as Map<dynamic, dynamic>).cast<String, Object?>(),
            ),
          )
          .toList(),
      activePlanLabel: json['activePlanLabel'] as String? ?? '',
    );
  }
}

class WalletLedgerEntry {
  const WalletLedgerEntry({
    required this.title,
    required this.amount,
    required this.createdAtLabel,
  });

  final String title;
  final int amount;
  final String createdAtLabel;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'title': title,
      'amount': amount,
      'createdAtLabel': createdAtLabel,
    };
  }

  factory WalletLedgerEntry.fromJson(Map<String, Object?> json) {
    return WalletLedgerEntry(
      title: json['title']! as String,
      amount: json['amount'] as int? ?? 0,
      createdAtLabel: json['createdAtLabel']! as String,
    );
  }
}

class WalletOffer {
  const WalletOffer({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.priceLabel,
    required this.badge,
  });

  final String id;
  final String title;
  final String subtitle;
  final String priceLabel;
  final String badge;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'priceLabel': priceLabel,
      'badge': badge,
    };
  }

  factory WalletOffer.fromJson(Map<String, Object?> json) {
    return WalletOffer(
      id: json['id']! as String,
      title: json['title']! as String,
      subtitle: json['subtitle']! as String,
      priceLabel: json['priceLabel']! as String,
      badge: json['badge']! as String,
    );
  }
}

class UnlockPreview {
  const UnlockPreview({
    required this.contentKey,
    required this.title,
    required this.cost,
    required this.remainingBalance,
    required this.reason,
    required this.alternativeOffer,
  });

  final String contentKey;
  final String title;
  final int cost;
  final int remainingBalance;
  final String reason;
  final String alternativeOffer;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'contentKey': contentKey,
      'title': title,
      'cost': cost,
      'remainingBalance': remainingBalance,
      'reason': reason,
      'alternativeOffer': alternativeOffer,
    };
  }

  factory UnlockPreview.fromJson(Map<String, Object?> json) {
    return UnlockPreview(
      contentKey: json['contentKey']! as String,
      title: json['title']! as String,
      cost: json['cost'] as int? ?? 0,
      remainingBalance: json['remainingBalance'] as int? ?? 0,
      reason: json['reason']! as String,
      alternativeOffer: json['alternativeOffer']! as String,
    );
  }
}
