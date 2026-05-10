import '../../core/utils/app_formatters.dart';
import '../models/ai_models.dart';
import '../models/article_preview.dart';
import '../models/birth_profile.dart';
import '../models/chart_models.dart';
import '../models/daily_recommendation.dart';
import '../models/insight_models.dart';
import '../models/wallet_models.dart';

class PrototypeSeedData {
  static List<BirthProfile> profiles() {
    return <BirthProfile>[
      BirthProfile(
        id: 'profile_001',
        name: 'Vương Hỷ Khang',
        gender: Gender.male,
        calendarType: CalendarType.solar,
        birthDate: DateTime(2002, 10, 12),
        birthHourLabel: 'Sửu (01:00 - 02:59)',
        timezone: 'Asia/Ho_Chi_Minh',
        birthTimeConfidence: BirthTimeConfidence.exact,
        mainFocus: const <MainFocus>[
          MainFocus.career,
          MainFocus.wealth,
          MainFocus.relationship,
        ],
        isMain: true,
        birthPlace: 'Cà Mau, Việt Nam',
      ),
      BirthProfile(
        id: 'profile_002',
        name: 'Lê Minh Anh',
        gender: Gender.female,
        calendarType: CalendarType.lunar,
        birthDate: DateTime(1998, 3, 24),
        birthHourLabel: 'Mão (05:00 - 06:59)',
        timezone: 'Asia/Ho_Chi_Minh',
        birthTimeConfidence: BirthTimeConfidence.estimated,
        mainFocus: const <MainFocus>[
          MainFocus.relationship,
          MainFocus.family,
          MainFocus.health,
        ],
        isMain: false,
        birthPlace: 'Huế, Việt Nam',
      ),
      BirthProfile(
        id: 'profile_003',
        name: 'Trần Gia Linh',
        gender: Gender.female,
        calendarType: CalendarType.solar,
        birthDate: DateTime(1995, 8, 18),
        birthHourLabel: 'Không rõ giờ sinh',
        timezone: 'Asia/Ho_Chi_Minh',
        birthTimeConfidence: BirthTimeConfidence.unknown,
        mainFocus: const <MainFocus>[MainFocus.career, MainFocus.study],
        isMain: false,
        birthPlace: 'Đà Nẵng, Việt Nam',
      ),
    ];
  }

  static List<ChartPalace> palaces() {
    return const <ChartPalace>[
      ChartPalace(
        key: 'menh',
        name: 'Mệnh + Thân',
        score: 45,
        shortSummary: 'Khí chất rõ ràng, thiên về chủ động và tự dẫn dắt.',
        primaryStars: <String>['Thái Dương', 'Thiên Phủ'],
        secondaryStars: <String>['Văn Xương', 'Thiên Việt'],
        strengths: <String>[
          'Tinh thần tự chủ cao.',
          'Dễ tạo niềm tin khi làm việc nhóm.',
        ],
        challenges: <String>[
          'Có xu hướng tự ép mình.',
          'Dễ mất cân bằng khi ôm nhiều vai trò.',
        ],
        advice: <String>[
          'Ưu tiên một mục tiêu lớn cho mỗi quý.',
          'Giữ lịch nghỉ rõ ràng để tránh quá tải.',
        ],
        evidence: <String>[
          'Cung Mệnh sáng nhờ chính tinh thiên về danh vị.',
          'Tam hợp với Quan Lộc và Tài Bạch tạo trục phát triển rõ.',
        ],
        relatedPalaces: <String>['quan_loc', 'tai_bach', 'thien_di'],
        isUnlocked: true,
        unlockCost: 0,
      ),
      ChartPalace(
        key: 'phu_mau',
        name: 'Phụ Mẫu',
        score: 31,
        shortSummary:
            'Nguồn lực gia đình có hỗ trợ nhưng cần giao tiếp mềm hơn.',
        primaryStars: <String>['Thiên Cơ'],
        secondaryStars: <String>['Long Đức'],
        strengths: <String>['Được nhắc nhở đúng lúc khi cần chỉnh hướng.'],
        challenges: <String>['Kỳ vọng giữa các thế hệ dễ lệch nhịp.'],
        advice: <String>[
          'Trao đổi rõ kế hoạch dài hạn trước khi quyết định lớn.',
        ],
        evidence: <String>[
          'Phụ Mẫu có cát tinh nhưng đi kèm áp lực tiêu chuẩn.',
        ],
        relatedPalaces: <String>['menh', 'phuc_duc'],
        isUnlocked: false,
        unlockCost: 80,
      ),
      ChartPalace(
        key: 'phuc_duc',
        name: 'Phúc Đức',
        score: 39,
        shortSummary: 'Nội lực tốt khi có không gian học hỏi và tĩnh tâm.',
        primaryStars: <String>['Thiên Lương'],
        secondaryStars: <String>['Giải Thần'],
        strengths: <String>['Phục hồi tốt sau giai đoạn áp lực.'],
        challenges: <String>['Dễ suy nghĩ nhiều khi kết quả chưa rõ.'],
        advice: <String>['Nên có chu kỳ tổng kết tháng để xả áp lực.'],
        evidence: <String>['Phúc Đức có bộ sao thiên về giải ách và giữ nhịp.'],
        relatedPalaces: <String>['menh', 'tat_ach'],
        isUnlocked: true,
        unlockCost: 0,
      ),
      ChartPalace(
        key: 'dien_trach',
        name: 'Điền Trạch',
        score: 23,
        shortSummary:
            'Nhà cửa, không gian sống cần tối giản để hỗ trợ vận học và làm.',
        primaryStars: <String>['Thất Sát'],
        secondaryStars: <String>['Lộc Tồn'],
        strengths: <String>['Phù hợp tối ưu lại không gian làm việc.'],
        challenges: <String>['Không hợp quyết định tài sản quá vội.'],
        advice: <String>['Nên ưu tiên tích lũy và khảo sát nhiều nguồn.'],
        evidence: <String>['Điền Trạch chưa phải cung nổi bật trong năm xem.'],
        relatedPalaces: <String>['tai_bach', 'quan_loc'],
        isUnlocked: false,
        unlockCost: 60,
      ),
      ChartPalace(
        key: 'quan_loc',
        name: 'Quan Lộc',
        score: 37,
        shortSummary:
            'Công việc có nhịp mở rộng, nhưng áp lực trách nhiệm tăng cùng.',
        primaryStars: <String>['Vũ Khúc', 'Thiên Tướng'],
        secondaryStars: <String>['Tả Phù', 'Hữu Bật'],
        strengths: <String>[
          'Dễ được giao phần việc quan trọng.',
          'Hợp xây hệ thống hoặc vai trò quản lý việc.',
        ],
        challenges: <String>[
          'Kỳ vọng cao làm phát sinh áp lực tự thân.',
          'Cần tránh ký kết khi dữ kiện chưa đủ.',
        ],
        advice: <String>[
          'Giữ nguyên tắc ưu tiên theo tác động kinh doanh.',
          'Chốt bằng văn bản khi hợp tác quan trọng.',
        ],
        evidence: <String>[
          'Quan Lộc được kích hoạt bởi đại vận hiện tại.',
          'Cung Thiên Di hỗ trợ cơ hội đến từ mạng lưới mới.',
        ],
        relatedPalaces: <String>['menh', 'tai_bach', 'thien_di'],
        isUnlocked: false,
        unlockCost: 100,
      ),
      ChartPalace(
        key: 'no_boc',
        name: 'Nô Bộc',
        score: 28,
        shortSummary: 'Quan hệ cộng tác mở ra cơ hội, nhưng cần lọc kỳ vọng.',
        primaryStars: <String>['Cự Môn'],
        secondaryStars: <String>['Thiên Khôi'],
        strengths: <String>['Có người hỗ trợ đúng chuyên môn.'],
        challenges: <String>['Dễ mệt vì khác cách làm.'],
        advice: <String>['Giao việc theo outcome thay vì cảm tính.'],
        evidence: <String>['Nô Bộc có lợi khi đi cùng nguyên tắc rõ.'],
        relatedPalaces: <String>['quan_loc', 'thien_di'],
        isUnlocked: false,
        unlockCost: 70,
      ),
      ChartPalace(
        key: 'thien_di',
        name: 'Thiên Di',
        score: 41,
        shortSummary:
            'Ra ngoài dễ gặp vận mở, hợp kết nối và thử môi trường mới.',
        primaryStars: <String>['Thiên Đồng'],
        secondaryStars: <String>['Hóa Lộc'],
        strengths: <String>['Gặp may khi chủ động kết nối.'],
        challenges: <String>['Dễ phân tán vì quá nhiều lời mời.'],
        advice: <String>['Chọn một hướng hợp tác chủ lực trong 90 ngày.'],
        evidence: <String>['Thiên Di sáng hỗ trợ vận công việc và học hỏi.'],
        relatedPalaces: <String>['quan_loc', 'menh'],
        isUnlocked: true,
        unlockCost: 0,
      ),
      ChartPalace(
        key: 'tat_ach',
        name: 'Tật Ách',
        score: 30,
        shortSummary: 'Cần quản trị nhịp sinh hoạt và áp lực tích tụ.',
        primaryStars: <String>['Tham Lang'],
        secondaryStars: <String>['Thiên Y'],
        strengths: <String>['Biết tự điều chỉnh khi đã nhận diện vấn đề.'],
        challenges: <String>['Dễ quá sức khi làm việc cường độ cao liên tục.'],
        advice: <String>['Tách lịch sâu và lịch nghỉ rõ ràng theo tuần.'],
        evidence: <String>['Tật Ách chịu ảnh hưởng từ trục công việc mạnh.'],
        relatedPalaces: <String>['menh', 'phuc_duc'],
        isUnlocked: false,
        unlockCost: 70,
      ),
      ChartPalace(
        key: 'tai_bach',
        name: 'Tài Bạch',
        score: 43,
        shortSummary:
            'Tài chính có đà tăng nếu biết ưu tiên nguồn thu bền vững.',
        primaryStars: <String>['Liêm Trinh'],
        secondaryStars: <String>['Hóa Khoa'],
        strengths: <String>['Có thể tăng giá trị nhờ chuyên môn.'],
        challenges: <String>['Không hợp quyết định tiền lớn theo cảm hứng.'],
        advice: <String>['Tách quỹ tích lũy và quỹ thử nghiệm.'],
        evidence: <String>['Tài Bạch được nâng bởi trục Quan Lộc - Thiên Di.'],
        relatedPalaces: <String>['menh', 'quan_loc', 'dien_trach'],
        isUnlocked: false,
        unlockCost: 100,
      ),
      ChartPalace(
        key: 'tu_tuc',
        name: 'Tử Tức',
        score: 29,
        shortSummary: 'Thiên hướng chăm chút dự án phụ hoặc kết quả dài hạn.',
        primaryStars: <String>['Phá Quân'],
        secondaryStars: <String>['Thiên Hỷ'],
        strengths: <String>['Có ý tưởng mới khi dám thử khung khác.'],
        challenges: <String>['Kết quả đến chậm hơn kỳ vọng.'],
        advice: <String>['Đừng đánh giá dự án phụ quá sớm.'],
        evidence: <String>['Tử Tức phù hợp nuôi ý tưởng hơn là chốt nhanh.'],
        relatedPalaces: <String>['phu_the', 'tai_bach'],
        isUnlocked: false,
        unlockCost: 60,
      ),
      ChartPalace(
        key: 'phu_the',
        name: 'Phu Thê',
        score: 35,
        shortSummary: 'Tình cảm cần nhịp giao tiếp rõ và thực tế hơn kỳ vọng.',
        primaryStars: <String>['Thái Âm'],
        secondaryStars: <String>['Đào Hoa'],
        strengths: <String>['Dễ tạo kết nối cảm xúc sâu.'],
        challenges: <String>['Dễ né xung đột thay vì nói thẳng.'],
        advice: <String>['Hỏi rõ nhu cầu thay vì đoán cảm xúc.'],
        evidence: <String>[
          'Phu Thê có mềm hóa nhưng vẫn cần nguyên tắc giao tiếp.',
        ],
        relatedPalaces: <String>['menh', 'phuc_duc'],
        isUnlocked: true,
        unlockCost: 0,
      ),
      ChartPalace(
        key: 'huynh_de',
        name: 'Huynh Đệ',
        score: 26,
        shortSummary:
            'Quan hệ ngang hàng hỗ trợ tốt nếu mục tiêu chung rõ ràng.',
        primaryStars: <String>['Tử Vi'],
        secondaryStars: <String>['Thiên Quan'],
        strengths: <String>['Có quý nhân kiểu anh chị đi trước.'],
        challenges: <String>['Không hợp vay mượn hoặc hứa miệng.'],
        advice: <String>['Giữ ranh giới và vai trò rõ.'],
        evidence: <String>['Huynh Đệ sáng khi đi với mục tiêu minh bạch.'],
        relatedPalaces: <String>['no_boc', 'quan_loc'],
        isUnlocked: false,
        unlockCost: 50,
      ),
    ];
  }

  static List<FocusMetric> focusMetrics() {
    return const <FocusMetric>[
      FocusMetric(
        key: 'career',
        label: 'Công việc',
        score: 72,
        insight: 'Có cơ hội mở rộng vai trò, nên ưu tiên việc tạo giá trị rõ.',
      ),
      FocusMetric(
        key: 'wealth',
        label: 'Tài chính',
        score: 64,
        insight: 'Thu nhập tăng tốt hơn khi đi cùng kỷ luật và chuyên môn.',
      ),
      FocusMetric(
        key: 'relationship',
        label: 'Tình cảm',
        score: 58,
        insight: 'Nên trao đổi thẳng nhu cầu và nhịp sống thực tế.',
      ),
      FocusMetric(
        key: 'health',
        label: 'Sức khỏe',
        score: 61,
        insight: 'Cần giữ nhịp ngủ và hồi phục để duy trì phong độ dài hơi.',
      ),
    ];
  }

  static List<FortunePeriod> majorCycles() {
    return const <FortunePeriod>[
      FortunePeriod(
        id: 'major_15_24',
        title: '15 - 24 tuổi',
        subtitle: 'Giai đoạn học và định vị nền tảng.',
        score: 62,
        highlights: <String>['Xây tư duy nghề nghiệp.', 'Gặp người mở hướng.'],
        cautions: <String>['Dễ thử quá nhiều hướng.'],
        unlocked: true,
        unlockCost: 0,
      ),
      FortunePeriod(
        id: 'major_25_34',
        title: '25 - 34 tuổi',
        subtitle: 'Chính vận công việc và tích lũy thương hiệu cá nhân.',
        score: 78,
        highlights: <String>[
          'Công việc tăng trách nhiệm.',
          'Hợp xây hệ thống.',
        ],
        cautions: <String>['Áp lực cao nếu ôm việc thay người khác.'],
        unlocked: false,
        unlockCost: 120,
        isHighlighted: true,
      ),
      FortunePeriod(
        id: 'major_35_44',
        title: '35 - 44 tuổi',
        subtitle: 'Chu kỳ bứt phá tài chính và vị thế.',
        score: 74,
        highlights: <String>['Dễ có đòn bẩy tài chính.', 'Mạng lưới mạnh hơn.'],
        cautions: <String>['Cần chọn lọc đối tác.'],
        unlocked: false,
        unlockCost: 120,
      ),
    ];
  }

  static List<FortunePeriod> minorCycles(int year) {
    return <FortunePeriod>[
      FortunePeriod(
        id: 'minor_${year - 1}',
        title: '$year - 1',
        subtitle: 'Năm chuyển nhịp, thiên về dọn nền.',
        score: 54,
        highlights: const <String>['Có điều chỉnh quan trọng.'],
        cautions: const <String>['Không nên nóng trong việc tiền.'],
        unlocked: true,
        unlockCost: 0,
      ),
      FortunePeriod(
        id: 'minor_$year',
        title: '$year',
        subtitle: 'Năm tăng hiện diện và trách nhiệm.',
        score: 71,
        highlights: const <String>[
          'Dễ được trao vai trò lớn hơn.',
          'Quan hệ xã hội hỗ trợ công việc.',
        ],
        cautions: const <String>['Tránh ký kết vội.'],
        unlocked: false,
        unlockCost: 90,
        isHighlighted: true,
      ),
      FortunePeriod(
        id: 'minor_${year + 1}',
        title: '${year + 1}',
        subtitle: 'Năm tối ưu hóa kết quả đã gieo.',
        score: 66,
        highlights: const <String>['Hợp chuẩn hóa quy trình.'],
        cautions: const <String>['Cần kiên nhẫn với kết quả dài hạn.'],
        unlocked: false,
        unlockCost: 90,
      ),
    ];
  }

  static List<MonthlyFortune> monthlyFortunes(int year) {
    return <MonthlyFortune>[
      MonthlyFortune(
        id: 'month_1',
        monthNumber: 1,
        solarRange: AppFormatters.monthRange(
          DateTime(year, 1, 25),
          DateTime(year, 2, 22),
        ),
        title: 'Mở nhịp mới',
        highlight: 'Hợp lên kế hoạch và chốt ưu tiên năm.',
        score: 68,
        advice: const <String>[
          'Chốt 1 mục tiêu chính.',
          'Giữ nhịp sinh hoạt đều.',
        ],
        unlocked: true,
        unlockCost: 0,
      ),
      MonthlyFortune(
        id: 'month_2',
        monthNumber: 2,
        solarRange: AppFormatters.monthRange(
          DateTime(year, 2, 23),
          DateTime(year, 3, 23),
        ),
        title: 'Cơ hội kết nối',
        highlight: 'Mạng lưới mới đem lại tín hiệu tốt cho công việc.',
        score: 72,
        advice: const <String>['Gặp đúng người.', 'Đừng ôm quá nhiều hứa hẹn.'],
        unlocked: false,
        unlockCost: 40,
      ),
      MonthlyFortune(
        id: 'month_3',
        monthNumber: 3,
        solarRange: AppFormatters.monthRange(
          DateTime(year, 3, 24),
          DateTime(year, 4, 21),
        ),
        title: 'Cần ổn định nhịp',
        highlight: 'Áp lực tăng, hợp tối giản việc và tránh phân tán.',
        score: 56,
        advice: const <String>[
          'Giữ nguyên tắc ưu tiên.',
          'Nghỉ ngắn nhưng đều.',
        ],
        unlocked: false,
        unlockCost: 40,
      ),
    ];
  }

  static List<DailyRecommendation> dailyRecommendations() {
    return <DailyRecommendation>[
      DailyRecommendation(
        date: DateTime(2026, 5, 9),
        lunarLabel: '22/03 âm lịch',
        level: FortuneLevel.favorable,
        summary:
            'Hợp học tập, lên kế hoạch và nói chuyện với người quan trọng.',
        goodFor: const <String>[
          'Học tập',
          'Gặp người quan trọng',
          'Lên kế hoạch',
        ],
        avoid: const <String>[
          'Quyết định tài chính lớn',
          'Tranh luận cảm xúc',
          'Ký kết vội vàng',
        ],
        canChi: 'Canh Thìn',
        nguHanh: 'Bạch Lạp Kim',
        goodHours: const <String>['07:00 - 08:59', '11:00 - 12:59'],
      ),
      DailyRecommendation(
        date: DateTime(2026, 5, 10),
        lunarLabel: '23/03 âm lịch',
        level: FortuneLevel.balanced,
        summary: 'Hợp hoàn thiện việc tồn đọng hơn là mở việc hoàn toàn mới.',
        goodFor: const <String>['Tổng kết', 'Dọn backlog'],
        avoid: const <String>['Đốt giai đoạn', 'Cam kết miệng'],
        canChi: 'Tân Tỵ',
        nguHanh: 'Sa Trung Thổ',
        goodHours: const <String>['09:00 - 10:59'],
      ),
      DailyRecommendation(
        date: DateTime(2026, 5, 11),
        lunarLabel: '24/03 âm lịch',
        level: FortuneLevel.caution,
        summary: 'Cần hạ kỳ vọng, kiểm tra kỹ thông tin trước khi quyết định.',
        goodFor: const <String>['Rà soát', 'Nghỉ nhịp', 'Lắng nghe'],
        avoid: const <String>['Mua sắm lớn', 'Tranh luận căng thẳng'],
        canChi: 'Nhâm Ngọ',
        nguHanh: 'Dương Liễu Mộc',
        goodHours: const <String>['13:00 - 14:59'],
      ),
    ];
  }

  static List<AiPromptSuggestion> prompts() {
    return const <AiPromptSuggestion>[
      AiPromptSuggestion(
        scope: 'chart_general',
        label: 'Tóm tắt lá số',
        prompt: 'Tóm tắt lá số của tôi theo cách dễ hiểu.',
      ),
      AiPromptSuggestion(
        scope: 'career',
        label: 'Công việc năm nay',
        prompt: 'Năm nay công việc của tôi có xu hướng gì nổi bật?',
      ),
      AiPromptSuggestion(
        scope: 'relationship',
        label: 'Tình cảm cần lưu ý',
        prompt: 'Tôi nên lưu ý điều gì trong chuyện tình cảm?',
      ),
      AiPromptSuggestion(
        scope: 'good_day',
        label: 'Ngày phù hợp ký kết',
        prompt: 'Ngày nào phù hợp hơn để ký kết hoặc chốt việc quan trọng?',
        isPremium: true,
      ),
    ];
  }

  static List<ArticlePreview> articles() {
    return const <ArticlePreview>[
      ArticlePreview(
        id: 'article_001',
        title: 'Ý nghĩa Cung Mệnh khi đi cùng Thái Dương',
        category: 'Nhập môn tử vi',
        excerpt: 'Cách đọc khí chất, động lực và cách bạn tự dẫn dắt mình.',
        readTimeMinutes: 6,
        tags: <String>['Mệnh', 'Thái Dương'],
        bodySections: <String>[
          'Cung Mệnh cho biết phần cốt lõi trong cách bạn phản ứng với đời sống.',
          'Khi Thái Dương nổi bật, năng lượng chủ đạo thường là minh bạch, muốn tự nắm quyền chủ động.',
          'Điểm cần giữ là đừng biến trách nhiệm thành áp lực tự thân quá mức.',
        ],
      ),
      ArticlePreview(
        id: 'article_002',
        title: 'Đại vận là gì và nên đọc theo cách nào',
        category: 'Đại vận',
        excerpt:
            'Đại vận không phải lời phán cứng, mà là khung bối cảnh theo từng giai đoạn.',
        readTimeMinutes: 8,
        tags: <String>['Đại vận', 'Cách đọc'],
        bodySections: <String>[
          'Đại vận giúp nhìn chu kỳ dài chứ không thay thế quyết định cá nhân.',
          'Nên đọc đại vận cùng cung Mệnh, Quan Lộc, Tài Bạch và Thiên Di.',
          'Đừng dùng đại vận như kết luận tuyệt đối cho mọi lĩnh vực.',
        ],
      ),
      ArticlePreview(
        id: 'article_003',
        title: 'Chọn ngày tốt theo mục tiêu cá nhân',
        category: 'Ngày tốt xấu',
        excerpt:
            'Ngày tốt chung chưa chắc là ngày tối ưu cho đúng mục tiêu của bạn.',
        readTimeMinutes: 5,
        tags: <String>['Ngày tốt', 'Cá nhân hóa'],
        bodySections: <String>[
          'Nên tách ngày thuận cho chuẩn bị, ngày thuận cho gặp gỡ và ngày thuận cho chốt quyết định.',
          'Lá số cá nhân giúp điều chỉnh mức độ phù hợp với từng mục tiêu.',
          'Giữ thái độ tham khảo để tránh lệ thuộc vào một chỉ báo duy nhất.',
        ],
      ),
    ];
  }

  static WalletSnapshot wallet() {
    return const WalletSnapshot(
      balance: 320,
      activePlanLabel: 'Gói trải nghiệm AI: 3 câu/ngày',
      history: <WalletLedgerEntry>[
        WalletLedgerEntry(
          title: 'Mở Cung Mệnh + Thân',
          amount: -150,
          createdAtLabel: '07/05/2026',
        ),
        WalletLedgerEntry(
          title: 'Nạp gói 500 xu',
          amount: 500,
          createdAtLabel: '05/05/2026',
        ),
      ],
    );
  }

  static List<WalletOffer> offers() {
    return const <WalletOffer>[
      WalletOffer(
        id: 'coin_100',
        title: '100 xu',
        subtitle: 'Mở 1 cung hoặc 2 tháng vận',
        priceLabel: '29.000đ',
        badge: 'Consumable',
      ),
      WalletOffer(
        id: 'coin_300',
        title: '300 xu',
        subtitle: 'Phù hợp mở nhiều phần luận giải',
        priceLabel: '79.000đ',
        badge: 'Phổ biến',
      ),
      WalletOffer(
        id: 'sub_month',
        title: 'Gói tháng',
        subtitle: 'AI nhiều câu hơn, nhật vận không giới hạn',
        priceLabel: '199.000đ',
        badge: 'Subscription',
      ),
    ];
  }

  static List<JournalEntry> journalEntries(String profileId) {
    if (profileId != 'profile_001') {
      return const <JournalEntry>[];
    }
    return const <JournalEntry>[
      JournalEntry(
        id: 'journal_001',
        createdAtLabel: '09/05/2026 20:15',
        mood: JournalMood.deep,
        title: 'Cần hạ nhịp để nhìn rõ hơn',
        body:
            'Tâm trí hơi nặng sau một ngày nhiều quyết định. Khi dừng lại để rà lại kế hoạch, mình thấy vấn đề không nằm ở thiếu cơ hội mà ở việc ôm quá nhiều hướng cùng lúc.',
        sentimentLabel: 'Chiêm nghiệm',
      ),
      JournalEntry(
        id: 'journal_002',
        createdAtLabel: '08/05/2026 08:40',
        mood: JournalMood.bright,
        title: 'Năng lượng tốt cho việc mở hướng',
        body:
            'Buổi sáng có nhiều ý tưởng rõ ràng hơn. Hôm nay hợp cho việc gặp người mới và chốt những phần đang treo.',
        sentimentLabel: 'Tăng trưởng',
      ),
    ];
  }

  static LifeMapSummary lifeMap(String profileId, int year) {
    return LifeMapSummary(
      profileId: profileId,
      year: year,
      title: 'Bản đồ cuộc sống',
      overview:
          'Chu kỳ hiện tại thiên về tăng trách nhiệm và mở rộng hiện diện. Giai đoạn mạnh hơn bắt đầu khi bạn dồn lực vào một hướng nghề nghiệp rõ, thay vì giữ quá nhiều nhánh song song.',
      peakElement: 'Hỏa',
      currentCycleLabel: '25 - 34 tuổi',
      currentCycleTheme: 'Tăng trưởng nghề nghiệp',
      stages: const <LifeMapStage>[
        LifeMapStage(
          id: 'stage_0_14',
          ageRangeLabel: '0 - 14',
          title: 'Nền tảng',
          subtitle: 'Học tập và xây nhịp tự thân',
          score: 62,
          highlights: <String>[
            'Hợp học kỹ năng nền và giữ kỷ luật.',
            'Môi trường gia đình ảnh hưởng mạnh đến tự tin ban đầu.',
          ],
          cautions: <String>['Dễ tự so sánh nếu tiêu chuẩn quá cao.'],
        ),
        LifeMapStage(
          id: 'stage_15_24',
          ageRangeLabel: '15 - 24',
          title: 'Khám phá',
          subtitle: 'Tìm hướng đi và thử nhiều ngã rẽ',
          score: 58,
          highlights: <String>[
            'Có lợi cho việc học, thực tập, thay môi trường.',
          ],
          cautions: <String>['Dễ phân tán khi mục tiêu còn mờ.'],
        ),
        LifeMapStage(
          id: 'stage_25_34',
          ageRangeLabel: '25 - 34',
          title: 'Tăng trưởng',
          subtitle: 'Giai đoạn mở rộng vai trò và thương hiệu cá nhân',
          score: 78,
          highlights: <String>[
            'Công việc đi vào pha nhận trách nhiệm lớn hơn.',
            'Mạng lưới mới hỗ trợ mở cơ hội.',
          ],
          cautions: <String>[
            'Không nên đổi hướng liên tục chỉ vì áp lực ngắn hạn.',
          ],
          isCurrent: true,
        ),
        LifeMapStage(
          id: 'stage_35_44',
          ageRangeLabel: '35 - 44',
          title: 'Đỉnh tài chính',
          subtitle: 'Giai đoạn bứt phá từ nền đã xây',
          score: 81,
          highlights: <String>['Hợp chuẩn hóa tài sản và quy trình kiếm tiền.'],
          cautions: <String>['Cần chọn đúng đối tác dài hạn.'],
        ),
      ],
    );
  }
}
