import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/birth_profile.dart';
import 'objectbox_entities.dart';
import 'objectbox_service.dart';

class LegacyProfileMigration {
  LegacyProfileMigration(this._objectBoxService);

  final ObjectBoxService _objectBoxService;

  static const String _legacyProfilesKey = 'minh_menh_ai.birth_profiles.v1';
  static const String _migrationMarkerKey =
      'minh_menh_ai.objectbox.profile_migration.v1';

  Future<void> runIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_migrationMarkerKey) == true) {
      return;
    }
    if (_objectBoxService.birthProfiles.count() > 0) {
      await prefs.setBool(_migrationMarkerKey, true);
      return;
    }
    final raw = prefs.getString(_legacyProfilesKey);
    if (raw == null || raw.isEmpty) {
      await prefs.setBool(_migrationMarkerKey, true);
      return;
    }
    final decoded = jsonDecode(raw) as List<dynamic>;
    for (final item in decoded) {
      final profile = BirthProfile.fromJson(
        (item as Map<dynamic, dynamic>).cast<String, Object?>(),
      );
      _objectBoxService.birthProfiles.put(
        BirthProfileEntity(
          profileId: profile.id,
          name: profile.name,
          gender: profile.gender.name,
          calendarType: profile.calendarType.name,
          birthDateEpochMs: profile.birthDate.millisecondsSinceEpoch,
          birthHourLabel: profile.birthHourLabel,
          birthMinute: profile.birthMinute,
          birthPlace: profile.birthPlace,
          timezone: profile.timezone,
          birthTimeConfidence: profile.birthTimeConfidence.name,
          mainFocusJson: jsonEncode(
            profile.mainFocus.map((MainFocus focus) => focus.name).toList(),
          ),
          isMain: profile.isMain,
        ),
      );
    }
    await prefs.setBool(_migrationMarkerKey, true);
  }
}
