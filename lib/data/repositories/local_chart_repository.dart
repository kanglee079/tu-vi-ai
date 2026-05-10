import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../mock/prototype_seed_data.dart';
import '../models/birth_profile.dart';
import '../models/chart_models.dart';
import '../models/engine_snapshot_models.dart';
import 'chart_repository.dart';
import 'mock_chart_repository.dart';

class LocalChartRepository implements ChartRepository {
  LocalChartRepository({SharedPreferences? preferences})
    : _preferences = preferences;

  static const String _profilesKey = 'minh_menh_ai.birth_profiles.v1';

  final SharedPreferences? _preferences;
  MockChartRepository? _delegate;

  Future<SharedPreferences> get _prefs async {
    return _preferences ?? SharedPreferences.getInstance();
  }

  Future<MockChartRepository> _repo() async {
    final cached = _delegate;
    if (cached != null) {
      return cached;
    }
    _delegate = MockChartRepository(initialProfiles: await _loadProfiles());
    return _delegate!;
  }

  Future<List<BirthProfile>> _loadProfiles() async {
    final raw = (await _prefs).getString(_profilesKey);
    if (raw == null || raw.isEmpty) {
      return PrototypeSeedData.profiles();
    }
    final decoded = jsonDecode(raw) as List<dynamic>;
    final profiles = decoded
        .map(
          (dynamic item) =>
              BirthProfile.fromJson((item as Map<dynamic, dynamic>).cast()),
        )
        .toList();
    if (profiles.isEmpty) {
      return PrototypeSeedData.profiles();
    }
    if (profiles.every((BirthProfile profile) => !profile.isMain)) {
      profiles[0] = profiles[0].copyWith(isMain: true);
    }
    return profiles;
  }

  Future<void> _persist() async {
    final repo = await _repo();
    final profiles = await repo.listProfiles();
    await (await _prefs).setString(
      _profilesKey,
      jsonEncode(
        profiles.map((BirthProfile profile) => profile.toJson()).toList(),
      ),
    );
  }

  @override
  Future<void> deleteProfile(String profileId) async {
    final repo = await _repo();
    await repo.deleteProfile(profileId);
    await _persist();
  }

  @override
  Future<ChartSummary> getChart(String profileId, int year) async {
    final repo = await _repo();
    return repo.getChart(profileId, year);
  }

  @override
  Future<BirthProfile?> getMainProfile() async {
    final repo = await _repo();
    return repo.getMainProfile();
  }

  @override
  Future<ChartPalace> getPalaceReading(
    String profileId,
    String palaceKey,
  ) async {
    final repo = await _repo();
    return repo.getPalaceReading(profileId, palaceKey);
  }

  @override
  Future<ChartSnapshotPayload?> getChartSnapshot(
    String profileId,
    int year,
  ) async {
    return null;
  }

  @override
  Future<BirthProfile?> getProfile(String profileId) async {
    final repo = await _repo();
    return repo.getProfile(profileId);
  }

  @override
  Future<List<BirthProfile>> listProfiles() async {
    final repo = await _repo();
    return repo.listProfiles();
  }

  @override
  Future<void> saveProfile(BirthProfile profile) async {
    final repo = await _repo();
    await repo.saveProfile(profile);
    await _persist();
  }
}
