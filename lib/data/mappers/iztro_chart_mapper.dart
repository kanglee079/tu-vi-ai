import 'package:dart_iztro/dart_iztro.dart';

import '../models/engine_snapshot_models.dart';

class IztroChartMapper {
  const IztroChartMapper();

  EngineChartSnapshot mapAstrolabe({
    required String profileId,
    required int year,
    required IFunctionalAstrolabe astrolabe,
    required IFunctionalHoroscpoe horoscope,
    required String engineVersion,
    required String schemaVersion,
    required Map<String, Object?> rawInfo,
  }) {
    return EngineChartSnapshot(
      profileId: profileId,
      year: year,
      generatedAt: DateTime.now(),
      engineVersion: engineVersion,
      schemaVersion: schemaVersion,
      school: 'ziwei_vietnamese_v1',
      palaces: astrolabe.palaces
          .map((IFunctionalPalace palace) => _mapPalace(palace))
          .toList(),
      cycles: EngineCycleSnapshot(
        decadal: _mapHoroscopeNode('decadal', horoscope.decadal),
        yearly: _mapHoroscopeNode('yearly', horoscope.yearly),
        monthly: _mapHoroscopeNode('monthly', horoscope.monthly),
        daily: _mapHoroscopeNode('daily', horoscope.daily),
        hourly: _mapHoroscopeNode('hourly', horoscope.hourly),
        age: _mapHoroscopeNode('age', horoscope.age),
      ),
      rawInfo: rawInfo,
    );
  }

  EnginePalaceSnapshot _mapPalace(IFunctionalPalace palace) {
    return EnginePalaceSnapshot(
      key: _canonicalPalaceKey(palace.name.key),
      index: palace.index,
      name: _palaceDisplayName(_canonicalPalaceKey(palace.name.key)),
      heavenlyStem: palace.heavenlySten.title,
      earthlyBranch: palace.earthlyBranch.title,
      isBodyPalace: palace.isBodyPalace,
      isOriginalPalace: palace.isOriginalPalace,
      majorStars: palace.majorStars
          .map(
            (FunctionalStar star) =>
                _starDisplayName(star.name.starKey, star.name.title),
          )
          .toList(),
      minorStars: palace.minorStars
          .map(
            (FunctionalStar star) =>
                _starDisplayName(star.name.starKey, star.name.title),
          )
          .toList(),
      adjectiveStars: palace.adjectiveStars
          .map(
            (FunctionalStar star) =>
                _starDisplayName(star.name.starKey, star.name.title),
          )
          .toList(),
      decadalRange: palace.decadal.range,
      ages: palace.ages,
      yearlies: palace.yearlies,
    );
  }

  EngineHoroscopeNode _mapHoroscopeNode(String scope, HoroscopeItem item) {
    return EngineHoroscopeNode(
      scope: scope,
      index: item.index,
      label: item.name,
      heavenlyStem: item.heavenlyStem.title,
      earthlyBranch: item.earthlyBranch.title,
      palaceKeys: item.palaceNames
          .map((PalaceName palaceName) => _canonicalPalaceKey(palaceName.key))
          .toList(),
      mutagen: <String, String>{
        'hoa_loc': item.mutagen.isNotEmpty ? item.mutagen[0].title : '',
        'hoa_quyen': item.mutagen.length > 1 ? item.mutagen[1].title : '',
        'hoa_khoa': item.mutagen.length > 2 ? item.mutagen[2].title : '',
        'hoa_ky': item.mutagen.length > 3 ? item.mutagen[3].title : '',
      },
      nominalAge: item is AgeHoroscope ? item.nominalAge : null,
    );
  }

  String _canonicalPalaceKey(String iztroKey) {
    switch (iztroKey) {
      case 'soulPalace':
        return 'menh';
      case 'parentsPalace':
        return 'phu_mau';
      case 'spiritPalace':
        return 'phuc_duc';
      case 'propertyPalace':
        return 'dien_trach';
      case 'careerPalace':
        return 'quan_loc';
      case 'friendsPalace':
        return 'no_boc';
      case 'surfacePalace':
        return 'thien_di';
      case 'healthPalace':
        return 'tat_ach';
      case 'wealthPalace':
        return 'tai_bach';
      case 'childrenPalace':
        return 'tu_tuc';
      case 'spousePalace':
        return 'phu_the';
      case 'siblingsPalace':
        return 'huynh_de';
      case 'bodyPalace':
        return 'than';
      case 'originalPalace':
        return 'lai_nhan';
      default:
        return iztroKey;
    }
  }

  String _palaceDisplayName(String key) {
    switch (key) {
      case 'menh':
        return 'Mệnh';
      case 'phu_mau':
        return 'Phụ Mẫu';
      case 'phuc_duc':
        return 'Phúc Đức';
      case 'dien_trach':
        return 'Điền Trạch';
      case 'quan_loc':
        return 'Quan Lộc';
      case 'no_boc':
        return 'Nô Bộc';
      case 'thien_di':
        return 'Thiên Di';
      case 'tat_ach':
        return 'Tật Ách';
      case 'tai_bach':
        return 'Tài Bạch';
      case 'tu_tuc':
        return 'Tử Tức';
      case 'phu_the':
        return 'Phu Thê';
      case 'huynh_de':
        return 'Huynh Đệ';
      case 'than':
        return 'Thân';
      case 'lai_nhan':
        return 'Lai Nhân';
      default:
        return key;
    }
  }

  String _starDisplayName(String key, String fallback) {
    const starMap = <String, String>{
      // Chính tinh — 14 sao chính
      'taiYangMaj': 'Thái Dương',
      'tianFuMaj': 'Thiên Phủ',
      'wuQuMaj': 'Vũ Khúc',
      'tianXiangMaj': 'Thiên Tướng',
      'tianTongMaj': 'Thiên Đồng',
      'taiYinMaj': 'Thái Âm',
      'tianLiangMaj': 'Thiên Lương',
      'qiShaMaj': 'Thất Sát',
      'tanLangMaj': 'Tham Lang',
      'poJunMaj': 'Phá Quân',
      'lianZhenMaj': 'Liêm Trinh',
      'juMenMaj': 'Cự Môn',
      'youXingMaj': 'Diêm Vương',
      'duShaoMaj': 'Đà La',

      // Phụ tinh — Văn minh
      'wenChangMin': 'Văn Xương',
      'wenQuMin': 'Văn Khúc',
      'luCunMin': 'Lộc Tồn',
      'luJiaMin': 'Lộc Giáp',
      'tianJiMin': 'Thiên Cơ',
      'taiYinMin': 'Thái Dương (Phụ)',

      // Phụ tinh — Quý nhân
      'zuoFuMin': 'Tả Phù',
      'youBiMin': 'Hữu Bật',
      'tianKuiMin': 'Thiên Khôi',
      'tianYueMin': 'Thiên Việt',
      'tianMaMin': 'Thiên Mã',
      'tianChaiMin': 'Thiên Trì',
      'tianChengMin': 'Thiên Thành',

      // Phụ tinh — Tài lộc
      'luQinMin': 'Lục Quý',
      'tianCaiMin': 'Thiên Tài',
      'faLunMin': 'Phá Lý Luân',

      // Phụ tinh — Xấu/chướng
      'huaLuMin': 'Hóa Lộc',
      'huaQuanMin': 'Hóa Quyền',
      'huaKe': 'Hóa Khoa',
      'huaJie': 'Hóa Giải',
      'qingYangMin': 'Thanh Dương',
      'yinEos': 'Âm Nhật',
      'yangRen': 'Dương Nhật',

      // Phụ tinh — Xung/phá
      'poYangMin': 'Bạch Đường',
      'jieShen': 'Giải Thần',
      'tiQianMin': 'Thiên Can',
      'huaGangMin': 'Hóa Cương',

      // Phụ tinh — Hỗ trợ/cát
      'yingFengMin': 'Âm Phong',
      'tianXinMin': 'Thiên Tâm',
      'tianXiuMin': 'Thiên Thứ',
      'tianGuanMin': 'Thiên Quan',
      'tianYuanMin': 'Thiên Nguyên',
      'tianZhongMin': 'Thiên Trung',
      'tianLaMin': 'Thiên La',
      'tianDeMin': 'Thiên Đức',
      'tianXingMin': 'Thiên Hình',
      'tianShaMin': 'Thiên Sát',
      'tianYaoMin': 'Thiên Y',
      'tianFuMin': 'Thiên Phủ (Phụ)',
      'tianKongMin': 'Thiên Không',
      'tianTongMin': 'Thiên Thông',
      'tianJieMin': 'Thiên Giới',
      'tianZhenMin': 'Thiên Chấn',
      'tianYuanKai': 'Thiên Nguyệt',
    };
    return starMap[key] ?? fallback;
  }
}
