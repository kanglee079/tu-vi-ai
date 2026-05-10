import 'package:objectbox/objectbox.dart';

@Entity()
class BirthProfileEntity {
  BirthProfileEntity({
    this.dbId = 0,
    required this.profileId,
    required this.name,
    required this.gender,
    required this.calendarType,
    required this.birthDateEpochMs,
    required this.birthHourLabel,
    required this.timezone,
    required this.birthTimeConfidence,
    required this.mainFocusJson,
    required this.isMain,
    this.birthMinute,
    this.birthPlace,
  });

  @Id()
  int dbId;

  @Unique()
  String profileId;
  String name;
  String gender;
  String calendarType;
  int birthDateEpochMs;
  String birthHourLabel;
  int? birthMinute;
  String? birthPlace;
  String timezone;
  String birthTimeConfidence;
  String mainFocusJson;
  bool isMain;
}

@Entity()
class ChartCacheEntity {
  ChartCacheEntity({
    this.dbId = 0,
    required this.cacheKey,
    required this.profileId,
    required this.year,
    required this.engineVersion,
    required this.schemaVersion,
    required this.snapshotHash,
    required this.snapshotJson,
    required this.summaryJson,
    required this.updatedAtEpochMs,
  });

  @Id()
  int dbId;

  @Unique()
  String cacheKey;
  String profileId;
  int year;
  String engineVersion;
  String schemaVersion;
  String snapshotHash;
  String snapshotJson;
  String summaryJson;
  int updatedAtEpochMs;
}

@Entity()
class UnlockContentEntity {
  UnlockContentEntity({
    this.dbId = 0,
    required this.unlockKey,
    required this.profileId,
    required this.contentType,
    required this.contentKey,
    required this.unlockMethod,
    required this.coinSpent,
    required this.createdAtEpochMs,
  });

  @Id()
  int dbId;

  @Unique()
  String unlockKey;
  String profileId;
  String contentType;
  String contentKey;
  String unlockMethod;
  int coinSpent;
  int createdAtEpochMs;
}

@Entity()
class WalletLedgerEntity {
  WalletLedgerEntity({
    this.dbId = 0,
    required this.entryId,
    required this.title,
    required this.amount,
    required this.createdAtLabel,
    required this.createdAtEpochMs,
    required this.source,
  });

  @Id()
  int dbId;

  @Unique()
  String entryId;
  String title;
  int amount;
  String createdAtLabel;
  int createdAtEpochMs;
  String source;
}

@Entity()
class WalletSnapshotEntity {
  WalletSnapshotEntity({
    this.dbId = 0,
    required this.snapshotKey,
    required this.balance,
    required this.activePlanLabel,
    required this.historyJson,
    required this.updatedAtEpochMs,
  });

  @Id()
  int dbId;

  @Unique()
  String snapshotKey;
  int balance;
  String activePlanLabel;
  String historyJson;
  int updatedAtEpochMs;
}

@Entity()
class JournalEntryEntity {
  JournalEntryEntity({
    this.dbId = 0,
    required this.entryId,
    required this.profileId,
    required this.createdAtLabel,
    required this.createdAtEpochMs,
    required this.mood,
    required this.title,
    required this.body,
    required this.sentimentLabel,
  });

  @Id()
  int dbId;

  @Unique()
  String entryId;
  String profileId;
  String createdAtLabel;
  int createdAtEpochMs;
  String mood;
  String title;
  String body;
  String sentimentLabel;
}

@Entity()
class AiConversationEntity {
  AiConversationEntity({
    this.dbId = 0,
    required this.conversationId,
    required this.profileId,
    required this.scope,
    required this.messagesJson,
    required this.updatedAtEpochMs,
  });

  @Id()
  int dbId;

  @Unique()
  String conversationId;
  String profileId;
  String scope;
  String messagesJson;
  int updatedAtEpochMs;
}

@Entity()
class PendingSyncOperationEntity {
  PendingSyncOperationEntity({
    this.dbId = 0,
    required this.operationId,
    required this.entityType,
    required this.operationType,
    required this.payloadJson,
    required this.createdAtEpochMs,
    this.lastAttemptAtEpochMs,
    required this.attemptCount,
  });

  @Id()
  int dbId;

  @Unique()
  String operationId;
  String entityType;
  String operationType;
  String payloadJson;
  int createdAtEpochMs;
  int? lastAttemptAtEpochMs;
  int attemptCount;
}
