class PendingSyncOperation {
  const PendingSyncOperation({
    required this.id,
    required this.entityType,
    required this.operationType,
    required this.payloadJson,
    required this.createdAt,
    this.lastAttemptAt,
    this.attemptCount = 0,
  });

  final String id;
  final String entityType;
  final String operationType;
  final String payloadJson;
  final DateTime createdAt;
  final DateTime? lastAttemptAt;
  final int attemptCount;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'id': id,
      'entityType': entityType,
      'operationType': operationType,
      'payloadJson': payloadJson,
      'createdAt': createdAt.toIso8601String(),
      'lastAttemptAt': lastAttemptAt?.toIso8601String(),
      'attemptCount': attemptCount,
    };
  }

  factory PendingSyncOperation.fromJson(Map<String, Object?> json) {
    return PendingSyncOperation(
      id: json['id']! as String,
      entityType: json['entityType']! as String,
      operationType: json['operationType']! as String,
      payloadJson: json['payloadJson']! as String,
      createdAt: DateTime.parse(json['createdAt']! as String),
      lastAttemptAt: json['lastAttemptAt'] == null
          ? null
          : DateTime.parse(json['lastAttemptAt']! as String),
      attemptCount: json['attemptCount'] as int? ?? 0,
    );
  }
}
