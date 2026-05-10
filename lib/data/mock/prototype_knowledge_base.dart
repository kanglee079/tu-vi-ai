import '../models/knowledge_models.dart';

class PrototypeKnowledgeBase {
  static final KnowledgeAttribution _internalV1 = KnowledgeAttribution(
    sourceType: KnowledgeSourceType.internalRewrite,
    sourceRef: 'minh_menh_ai_internal_rewrite_v1',
    copyrightStatus:
        'No verbatim copyrighted text. Authored as structured rules.',
    compiler: 'Minh Menh AI product team',
    version: 'v1',
    updatedAt: DateTime(2026, 5, 10),
    notes:
        'Prototype seed only. Expert review and licensed/public-domain audit required before production.',
  );

  static List<StarMeaning> starMeanings() {
    return <StarMeaning>[
      StarMeaning(
        id: 'star_thai_duong',
        name: 'Thái Dương',
        group: 'chinh_tinh',
        element: 'Hỏa',
        keywords: const <String>[
          'minh bạch',
          'trách nhiệm',
          'danh vọng',
          'chủ động',
        ],
        positive:
            'Chủ về sự rõ ràng, chính trực, tinh thần trách nhiệm và khả năng dẫn dắt.',
        negative:
            'Dễ nóng vội, tự tạo áp lực hoặc đặt nặng thể diện khi kết quả chưa như kỳ vọng.',
        advice:
            'Nên phát triển trong môi trường cần uy tín, tổ chức, giáo dục, quản lý hoặc vai trò dẫn dắt.',
        attribution: _internalV1,
      ),
      StarMeaning(
        id: 'star_thien_phu',
        name: 'Thiên Phủ',
        group: 'chinh_tinh',
        element: 'Thổ',
        keywords: const <String>[
          'tích lũy',
          'quản trị',
          'ổn định',
          'nguồn lực',
        ],
        positive:
            'Thiên về năng lực giữ nhịp, quản lý nguồn lực và tạo cảm giác đáng tin.',
        negative:
            'Dễ thận trọng quá mức hoặc chậm quyết khi cần thử nghiệm có kiểm soát.',
        advice:
            'Nên dùng thế mạnh quản trị để xây nền bền vững trước khi mở rộng nhanh.',
        attribution: _internalV1,
      ),
      StarMeaning(
        id: 'star_vu_khuc',
        name: 'Vũ Khúc',
        group: 'chinh_tinh',
        element: 'Kim',
        keywords: const <String>[
          'tài chính',
          'kỷ luật',
          'thực tế',
          'hiệu suất',
        ],
        positive:
            'Có khuynh hướng thực tế, coi trọng hiệu quả, phù hợp việc cần kỷ luật và đo lường.',
        negative:
            'Dễ cứng trong giao tiếp hoặc đánh giá vấn đề quá thiên về kết quả.',
        advice:
            'Nên cân bằng mục tiêu tài chính với chất lượng quan hệ khi hợp tác.',
        attribution: _internalV1,
      ),
    ];
  }

  static List<PalaceMeaning> palaceMeanings() {
    return <PalaceMeaning>[
      PalaceMeaning(
        id: 'palace_menh',
        name: 'Mệnh',
        keywords: const <String>[
          'khí chất',
          'bản ngã',
          'động lực',
          'cách phản ứng',
        ],
        description:
            'Cung Mệnh phản ánh khí chất nền, cách một người tự định vị và phản ứng với hoàn cảnh.',
        attribution: _internalV1,
      ),
      PalaceMeaning(
        id: 'palace_quan_loc',
        name: 'Quan Lộc',
        keywords: const <String>[
          'sự nghiệp',
          'định hướng nghề nghiệp',
          'vị trí xã hội',
          'thành tựu',
        ],
        description:
            'Cung Quan Lộc phản ánh xu hướng nghề nghiệp, cách phát triển sự nghiệp và cách tạo dựng vị trí xã hội.',
        attribution: _internalV1,
      ),
      PalaceMeaning(
        id: 'palace_tai_bach',
        name: 'Tài Bạch',
        keywords: const <String>[
          'dòng tiền',
          'tích lũy',
          'nguồn thu',
          'quản trị tiền',
        ],
        description:
            'Cung Tài Bạch mô tả cách một người tạo, giữ và sử dụng nguồn lực tài chính.',
        attribution: _internalV1,
      ),
    ];
  }

  static List<CombinationRule> combinationRules() {
    return <CombinationRule>[
      CombinationRule(
        id: 'thai_duong_thien_phu_menh',
        condition: const CombinationCondition(
          palaceKey: 'menh',
          stars: <String>['Thái Dương', 'Thiên Phủ'],
        ),
        meaning:
            'Có xu hướng rõ ràng, chủ động và biết giữ nguồn lực. Hợp vai trò cần uy tín, tổ chức và trách nhiệm.',
        risk:
            'Dễ tự đặt tiêu chuẩn cao, đôi khi chậm chia sẻ áp lực với người khác.',
        advice:
            'Nên chọn mục tiêu dài hạn, chia nhỏ trách nhiệm và giữ lịch hồi phục đều.',
        evidence:
            'Cung Mệnh có nhóm sao thiên về minh bạch, trách nhiệm và quản trị nguồn lực.',
        impact: 'high',
        confidence: 0.78,
        attribution: _internalV1,
      ),
      CombinationRule(
        id: 'vu_khuc_thien_tuong_quan_loc',
        condition: const CombinationCondition(
          palaceKey: 'quan_loc',
          stars: <String>['Vũ Khúc', 'Thiên Tướng'],
          activatedByCycle: 'major_cycle',
        ),
        meaning:
            'Công việc thiên về trách nhiệm, hệ thống và kết quả đo được. Có cơ hội nhận vai trò quan trọng hơn.',
        risk:
            'Áp lực tăng khi kỳ vọng rõ hơn. Không phù hợp quyết định hợp tác khi dữ kiện còn mơ hồ.',
        advice:
            'Nên chuẩn hóa quy trình, chốt cam kết bằng văn bản và ưu tiên việc có tác động lớn.',
        evidence:
            'Quan Lộc có bộ sao thiên về kỷ luật, trách nhiệm và được kích hoạt bởi vận hiện tại.',
        impact: 'high',
        confidence: 0.74,
        attribution: _internalV1,
      ),
      CombinationRule(
        id: 'liem_trinh_hoa_khoa_tai_bach',
        condition: const CombinationCondition(
          palaceKey: 'tai_bach',
          stars: <String>['Liêm Trinh', 'Hóa Khoa'],
        ),
        meaning:
            'Tài chính có lợi khi gắn với chuyên môn, danh tiếng và năng lực giải quyết vấn đề.',
        risk: 'Dễ chi tiền cho cơ hội mới trước khi kiểm chứng đủ dữ kiện.',
        advice:
            'Nên tách quỹ tích lũy, quỹ thử nghiệm và đặt ngưỡng rủi ro rõ trước khi đầu tư thời gian hoặc tiền.',
        evidence:
            'Tài Bạch có yếu tố chuyên môn hóa, nhưng cần kỷ luật để giữ dòng tiền ổn định.',
        impact: 'medium',
        confidence: 0.7,
        attribution: _internalV1,
      ),
    ];
  }

  static List<ReadingTemplate> readingTemplates() {
    return <ReadingTemplate>[
      ReadingTemplate(
        scope: 'career_yearly',
        template:
            'Trong năm {year}, cung Quan Lộc và vận hiện tại cho thấy xu hướng {mainTrend}. Điểm đáng chú ý là {keyFactor}. Bạn nên {advice}.',
        requiredVariables: const <String>[
          'year',
          'mainTrend',
          'keyFactor',
          'advice',
        ],
        attribution: _internalV1,
      ),
      ReadingTemplate(
        scope: 'palace_detail',
        template:
            '{palaceName} cho thấy {meaning}. Thử thách chính là {risk}. Lời khuyên thực tế: {advice}.',
        requiredVariables: const <String>[
          'palaceName',
          'meaning',
          'risk',
          'advice',
        ],
        attribution: _internalV1,
      ),
    ];
  }
}
