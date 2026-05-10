import 'package:dart_iztro/dart_iztro.dart';
import 'package:get/get.dart';

import '../../data/mappers/iztro_chart_mapper.dart';
import '../../data/models/birth_profile.dart';
import '../../data/models/engine_snapshot_models.dart';

abstract class ChartEngineService {
  Future<EngineChartSnapshot> calculateChart({
    required BirthProfile profile,
    required int year,
  });
}

class PrototypeChartEngineService implements ChartEngineService {
  PrototypeChartEngineService({IztroChartMapper? mapper})
    : _mapper = mapper ?? const IztroChartMapper();

  final IztroChartMapper _mapper;

  @override
  Future<EngineChartSnapshot> calculateChart({
    required BirthProfile profile,
    required int year,
  }) async {
    _ensureIztroTranslations();
    final astrolabe = _buildAstrolabe(profile);
    final horoscope = astrolabe.horoscope(date: '$year-06-15');
    final snapshot = _mapper.mapAstrolabe(
      profileId: profile.id,
      year: year,
      astrolabe: astrolabe,
      horoscope: horoscope,
      engineVersion: 'prototype_iztro_0',
      schemaVersion: 'chart_snapshot_v1',
      rawInfo: _rawInfo(profile: profile, year: year, astrolabe: astrolabe),
    );
    return snapshot;
  }

  FunctionalAstrolabe _buildAstrolabe(BirthProfile profile) {
    final birthDate =
        '${profile.birthDate.year}-'
        '${profile.birthDate.month.toString().padLeft(2, '0')}-'
        '${profile.birthDate.day.toString().padLeft(2, '0')}';
    final timeIndex = _timeIndex(profile.birthHourLabel);
    final gender = profile.gender == Gender.female
        ? GenderName.female
        : GenderName.male;
    return profile.calendarType == CalendarType.lunar
        ? byLunar(birthDate, timeIndex, gender, false)
        : bySolar(birthDate, timeIndex, gender);
  }

  void _ensureIztroTranslations() {
    IztroTranslationService.init(initialLocale: 'zh_CN');
    try {
      Get.addTranslations(IztroTranslationService().keys);
    } catch (_) {
      // Tests and non-Get contexts can call the engine before a Get app exists.
    }
  }

  int _timeIndex(String birthHourLabel) {
    if (birthHourLabel.contains('Tý')) return 0;
    if (birthHourLabel.contains('Sửu')) return 1;
    if (birthHourLabel.contains('Dần')) return 2;
    if (birthHourLabel.contains('Mão')) return 3;
    if (birthHourLabel.contains('Thìn')) return 4;
    if (birthHourLabel.contains('Tỵ')) return 5;
    if (birthHourLabel.contains('Ngọ')) return 6;
    if (birthHourLabel.contains('Mùi')) return 7;
    if (birthHourLabel.contains('Thân')) return 8;
    if (birthHourLabel.contains('Dậu')) return 9;
    if (birthHourLabel.contains('Tuất')) return 10;
    if (birthHourLabel.contains('Hợi')) return 11;
    return 6;
  }

  Map<String, Object?> _rawInfo({
    required BirthProfile profile,
    required int year,
    required FunctionalAstrolabe astrolabe,
  }) {
    final dailyWindow = <Map<String, Object?>>[];
    final startDate = year == DateTime.now().year
        ? DateTime.now()
        : DateTime(year, 1, 1);
    for (var i = 0; i < 7; i++) {
      final date = startDate.add(Duration(days: i));
      final label =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final horoscope = astrolabe.horoscope(date: label);
      final palaceIndex = horoscope.daily.index;
      final palace = astrolabe.palaces[palaceIndex];
      dailyWindow.add(<String, Object?>{
        'date': date.toIso8601String(),
        'palaceLabel': palace.name.title,
        'stars': palace.majorStars
            .take(3)
            .map((FunctionalStar star) => star.name.title)
            .toList(),
        'lunarLabel': horoscope.lunarDate,
        'canChi': horoscope.daily.heavenlyStem.title,
        'nguHanh': astrolabe.fiveElementClass.name,
        'goodHours': <String>[astrolabe.timeRage],
      });
    }
    return <String, Object?>{
      'profileId': profile.id,
      'birthSolarDate': astrolabe.solarDate,
      'birthLunarDate': astrolabe.lunarDate,
      'timeRange': astrolabe.timeRage,
      'fiveElementClass': astrolabe.fiveElementClass.name,
      'zodiac': astrolabe.zodiac,
      'sign': astrolabe.sign,
      'dailyWindow': dailyWindow,
    };
  }
}

class IztroChartEngineService extends PrototypeChartEngineService {
  IztroChartEngineService({super.mapper});
}
