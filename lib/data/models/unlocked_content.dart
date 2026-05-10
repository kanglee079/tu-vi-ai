class UnlockedContent {
  const UnlockedContent({
    required this.contentType,
    required this.contentKey,
    required this.unlockMethod,
    required this.coinSpent,
  });

  final String contentType;
  final String contentKey;
  final String unlockMethod;
  final int coinSpent;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'contentType': contentType,
      'contentKey': contentKey,
      'unlockMethod': unlockMethod,
      'coinSpent': coinSpent,
    };
  }

  factory UnlockedContent.fromJson(Map<String, Object?> json) {
    return UnlockedContent(
      contentType: json['contentType']! as String,
      contentKey: json['contentKey']! as String,
      unlockMethod: json['unlockMethod']! as String,
      coinSpent: json['coinSpent'] as int? ?? 0,
    );
  }
}
