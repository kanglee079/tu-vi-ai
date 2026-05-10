import '../models/insight_models.dart';
import 'compatibility_repository.dart';

class MockCompatibilityRepository implements CompatibilityRepository {
  @override
  Future<CompatibilityReport> compareProfiles(
    String primaryProfileId,
    String secondaryProfileId,
  ) async {
    return CompatibilityReport(
      primaryProfileId: primaryProfileId,
      secondaryProfileId: secondaryProfileId,
      overallScore: secondaryProfileId == 'profile_002' ? 78 : 66,
      verdict: secondaryProfileId == 'profile_002' ? 'Khá hợp' : 'Cần dung hòa',
      summary: secondaryProfileId == 'profile_002'
          ? 'Hai lá số hỗ trợ nhau tốt ở nhịp cảm xúc và cách xây nền. Điểm cần giữ là cách ra quyết định khi áp lực tăng.'
          : 'Nhịp phát triển và cách phản ứng trước áp lực khác nhau rõ hơn. Cần quy ước giao tiếp sớm để tránh hiểu sai.',
      strengths: secondaryProfileId == 'profile_002'
          ? const <String>[
              'Tình cảm có độ đồng điệu tốt.',
              'Cả hai đều hợp nhịp khi mục tiêu chung đã rõ.',
              'Một người giữ nhịp, một người mở hướng.',
            ]
          : const <String>[
              'Có thể học từ góc nhìn rất khác nhau.',
              'Hợp cho việc bổ sung tư duy trong ngắn hạn.',
            ],
      challenges: secondaryProfileId == 'profile_002'
          ? const <String>[
              'Không hợp né xung đột quá lâu.',
              'Việc tiền bạc cần nguyên tắc rõ hơn cảm xúc.',
            ]
          : const <String>[
              'Khác kỳ vọng về nhịp tiến lên.',
              'Dễ mệt nếu cả hai cùng giữ quan điểm quá cứng.',
            ],
      guidance: secondaryProfileId == 'profile_002'
          ? const <String>[
              'Chốt rõ kỳ vọng về công việc và thời gian dành cho nhau.',
              'Tách quyết định tiền và quyết định cảm xúc.',
              'Khi áp lực tăng, ưu tiên nói thẳng hơn là đoán ý.',
            ]
          : const <String>[
              'Giữ vai trò rõ khi hợp tác hoặc gắn bó sâu hơn.',
              'Dùng check-in định kỳ thay vì chờ mâu thuẫn lớn.',
            ],
      categories: secondaryProfileId == 'profile_002'
          ? const <CompatibilityCategoryScore>[
              CompatibilityCategoryScore(
                label: 'Tình cảm',
                score: 85,
                insight: 'Đồng điệu tốt về cảm xúc và khả năng lắng nghe.',
              ),
              CompatibilityCategoryScore(
                label: 'Công việc',
                score: 60,
                insight:
                    'Hợp khi chia vai trò rõ, không hợp ôm quyết định mơ hồ.',
              ),
              CompatibilityCategoryScore(
                label: 'Quan điểm sống',
                score: 90,
                insight: 'Cùng trọng sự phát triển dài hạn và nền tảng bền.',
              ),
            ]
          : const <CompatibilityCategoryScore>[
              CompatibilityCategoryScore(
                label: 'Tình cảm',
                score: 68,
                insight: 'Có thu hút nhưng cần đi chậm để hiểu nhịp nhau.',
              ),
              CompatibilityCategoryScore(
                label: 'Công việc',
                score: 72,
                insight: 'Hợp trong vai trò bổ trợ hơn là đồng quyết mọi thứ.',
              ),
              CompatibilityCategoryScore(
                label: 'Quan điểm sống',
                score: 58,
                insight: 'Khác cách ưu tiên và cần quy ước giao tiếp sớm.',
              ),
            ],
    );
  }
}
