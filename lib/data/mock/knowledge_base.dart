/// Tử Vi Minh Mệnh — Knowledge Base
///
/// Nguồn: viết lại nội bộ từ kiến thức tử vi phổ thông Việt Nam.
/// KHÔNG copy nguyên văn từ sách có bản quyền.
/// Mỗi entry có sourceRef nội bộ, không dùng tên sách cụ thể.
/// Phiên bản v1.0 — 2026.

library;

// ============================================================
// PALACE MEANINGS — 12 Cung Tử Vi
// ============================================================

const Map<String, PalaceKnowledge> palaceKnowledgeBase = {
  'menh': PalaceKnowledge(
    key: 'menh',
    name: 'Mệnh',
    fullName: 'Cung Mệnh (Thân)',
    domain: 'Khí chất, cách phản ứng với đời sống, điểm xuất phát cuộc đời',
    coreStrengths: [
      'Tự chủ trong suy nghĩ và hành động',
      'Minh bạch trong giao tiếp',
      'Chủ động dẫn dắt công việc',
      'Có tinh thần trách nhiệm cao',
    ],
    coreChallenges: [
      'Dễ tự áp lực hoặc quá kỳ vọng bản thân',
      'Có xu hướng muốn kiểm soát quá nhiều thứ',
      'Đôi khi nóng vội hoặc thiếu kiên nhẫn',
    ],
    suitableDirections: [
      'Hướng Đông — học hỏi, khởi nghiệp',
      'Hướng Nam — danh vị, công danh',
    ],
    lifeAdvice:
        'Ưu tiên một mục tiêu lớn trong mỗi giai đoạn thay vì ôm nhiều hướng. '
        'Học cách phân bổ năng lượng theo nhịp tự nhiên, không ép bản thân liên tục ở cường độ cao. '
        'Mệnh cung cần vận hành tốt mới phát huy tiềm năng, nên giữ nhịp sinh hoạt đều đặn.',
    relationshipStyle:
        'Thiên hướng rõ ràng trong giao tiếp. Không thích sự mập mờ, '
        'đánh giá cao sự trung thực. Cần đối tác có thể tự lập, không ỷ lại.',
    healthNote:
        'Cần theo dõi huyết áp, stress tích tụ ở vai/gáy. '
        'Ngủ đủ giấc là nền tảng để duy trì năng lượng chủ động.',
  ),

  'phu_mau': PalaceKnowledge(
    key: 'phu_mau',
    name: 'Phụ Mẫu',
    fullName: 'Cung Phụ Mẫu',
    domain: 'Cha mẹ, gia đình gốc, nền tảng giáo dục, nguồn lực ban đầu',
    coreStrengths: [
      'Được hỗ trợ về mặt tinh thần hoặc tài chính từ gia đình',
      'Có kỷ luật bản thân được rèn luyện sớm',
      'Có người định hướng trong giai đoạn đầu đời',
    ],
    coreChallenges: [
      'Kỳ vọng từ gia đình có thể tạo áp lực',
      'Nếu không được hỗ trợ: phải tự tạo nền tảng từ sớm',
      'Dễ mang gánh nặng tâm lý về gia đình gốc',
    ],
    suitableDirections: ['Hướng Tây Bắc — học tập', 'Hướng Đông — khởi nghiệp'],
    lifeAdvice:
        'Gia đình là nền tảng nhưng không phải giới hạn. '
        'Nếu được hỗ trợ, biết ơn và kế thừa giá trị tốt. '
        'Nếu thiếu, học cách tự tạo đường đi riêng — đây chính là sức mạnh dài hạn. '
        'Tránh đổ lỗi hoặc bám víu vào gia đình gốc quá mức.',
    relationshipStyle:
        'Giá trị gia đình cao, biết chăm sóc người thân. '
        'Cần đối tác tôn trọng mối quan hệ với gia đình nhưng có ranh giới rõ.',
    healthNote:
        'Dạ dày, tiêu hóa là điểm cần lưu ý nếu mang nhiều áp lực tâm lý. '
        'Thiền, viết nhật ký giúp giảm gánh nặng tâm trí.',
  ),

  'phuc_duc': PalaceKnowledge(
    key: 'phuc_duc',
    name: 'Phúc Đức',
    fullName: 'Cung Phúc Đức',
    domain: 'May mắn, phúc lộc, tâm linh, cách hưởng thụ cuộc sống',
    coreStrengths: [
      'Có duyên gặp quý nhân đúng lúc',
      'Biết cách tận hưởng cuộc sống',
      'Có trực giác tốt, nhạy cảm với năng lượng xung quanh',
    ],
    coreChallenges: [
      'Dễ an phận thủ thường khi không có động lực rõ ràng',
      'Nhạy cảm quá mức dẫn đến suy nghĩ tiêu cực',
      'Có thể thiếu kỷ luật trong công việc dài hạn',
    ],
    suitableDirections: [
      'Hướng Tây — nghỉ ngơi, hưởng thụ',
      'Hướng Bắc — tâm linh, học hỏi sâu',
    ],
    lifeAdvice:
        'Phúc đức là tài nguyên dự trữ — không dùng phung phí khi chưa cần. '
        'Khi có cơ hội, biết nắm bắt. Khi chưa có, tích lũy nội lực qua học hỏi và rèn luyện. '
        'Tâm linh mạnh giúp vận hành phúc đức tốt hơn.',
    relationshipStyle:
        'Nhẹ nhàng, biết lắng nghe. Thu hút đối tác có cùng tần số. '
        'Cần đối tác khuyến khích phát triển thay vì chỉ an phận.',
    healthNote:
        'Hệ thần kinh, giấc ngủ là điểm yếu khi stress kéo dài. '
        'Yoga, thiền, hoặc các hoạt động nghệ thuật giúp cân bằng năng lượng cung này.',
  ),

  'dien_trach': PalaceKnowledge(
    key: 'dien_trach',
    name: 'Điền Trạch',
    fullName: 'Cung Điền Trạch',
    domain: 'Nhà cửa, đất đai, tài sản gia đình, không gian sống',
    coreStrengths: [
      'Biết quản lý tài chính cá nhân và gia đình',
      'Có óc thực tế trong việc sở hữu tài sản',
      'Tạo được không gian sống ổn định',
    ],
    coreChallenges: [
      'Quá bận tâm vật chất, bất động sản',
      'Khó ra quyết định lớn về tài chính nếu thiếu thông tin',
      'Có thể bám víu vào tài sản thay vì linh hoạt',
    ],
    suitableDirections: [
      'Hướng Tây Nam — tài lộc, gia đình',
      'Hướng Đông Nam — giao dịch, kinh doanh nhỏ',
    ],
    lifeAdvice:
        'Nhà là nơi nghỉ ngơi, không phải gánh nặng. '
        'Ưu tiên không gian chất lượng hơn số lượng. '
        'Khi có dư, đầu tư vào bất động sản là hợp lý. Khi chưa có, '
        'thuê nhà chất lượng tốt còn hơn mua nhà vượt khả năng.',
    relationshipStyle:
        'Giá trị sự ổn định gia đình. Muốn xây dựng tổ ấm vững chắc. '
        'Cần đối tác cùng chia sẻ trách nhiệm gia đình.',
    healthNote:
        'Hệ tiêu hóa, dạ dày cần lưu ý. '
        'Không gian sống bừa bộn ảnh hưởng tâm lý tiêu cực — giữ nhà gọn gàng giúp cân bằng cung này.',
  ),

  'quan_loc': PalaceKnowledge(
    key: 'quan_loc',
    name: 'Quan Lộc',
    fullName: 'Cung Quan Lộc',
    domain: 'Công việc, sự nghiệp, danh vị, vị trí xã hội',
    coreStrengths: [
      'Có ambição và khát vọng thành công',
      'Biết nắm bắt cơ hội thăng tiến',
      'Có uy tín trong môi trường chuyên môn',
    ],
    coreChallenges: [
      'Áp lực thành tích có thể gây kiệt sức',
      'Cạnh tranh trong công việc tạo căng thẳng',
      'Dễ nhầm lẫn giữa giá trị bản thân và vị trí công việc',
    ],
    suitableDirections: [
      'Hướng Bắc — thăng tiến, quyền lực',
      'Hướng Đông — khởi nghiệp, sáng tạo',
      'Hướng Nam — danh vị, công khai',
    ],
    lifeAdvice:
        'Công danh là con đường dài, không phải sprint. '
        'Mỗi giai đoạn có mục tiêu rõ — không so sánh với người khác. '
        'Khi vận công việc mạnh: dồn lực tập trung. Khi yếu: học hỏi, chuẩn bị, không vội thay đổi lớn. '
        'Giá trị của bạn không chỉ nằm ở chức danh.',
    relationshipStyle:
        'Có thể hy sinh thời gian cho công việc quá mức. '
        'Cần đối tác độc lập, không quá phụ thuộc thời gian bên nhau. '
        'Khi thành công, biết chia sẻ thành quả với người thân.',
    healthNote:
        'Huyết áp, tim mạch, vai/gáy là các điểm cần theo dõi khi áp lực công việc cao. '
        'Nghỉ ngơi có kế hoạch, không đợi kiệt sức mới dừng.',
  ),

  'no_boc': PalaceKnowledge(
    key: 'no_boc',
    name: 'Nô Bộc',
    fullName: 'Cung Nô Bộc',
    domain: 'Quan hệ cộng sự, đồng nghiệp, thuộc hạ, môi trường làm việc',
    coreStrengths: [
      'Biết xây dựng mạng lưới quan hệ',
      'Được tin tưởng trong nhóm',
      'Hiểu cách vận hành của tổ chức',
    ],
    coreChallenges: [
      'Dễ bị ảnh hưởng bởi đối thủ cạnh tranh hoặc xung đột',
      'Có thể bị lợi dụng nếu quá tin người',
      'Khó thoát khỏi môi trường độc hại nếu đã quen thuộc',
    ],
    suitableDirections: [
      'Hướng Đông Bắc — hợp tác',
      'Hướng Tây Bắc — xây dựng mạng lưới',
    ],
    lifeAdvice:
        'Chọn môi trường phù hợp là quyết định quan trọng. '
        'Gần người tốt giúp phát triển, gần người xấu dù có năng lực vẫn bị kéo tụt. '
        'Khi vận Nô Bộc mạnh: mở rộng quan hệ. Khi yếu: thu hẹp, chọn lọc, giữ khoảng cách.',
    relationshipStyle:
        'Biết lắng nghe, hỗ trợ người khác. '
        'Cần đối tác có khả năng bảo vệ lợi ích chung, không chỉ phục vụ một chiều.',
    healthNote:
        'Hệ thần kinh, stress từ xung đột quan hệ ảnh hưởng nhiều. '
        'Tập phân biệt giữa quan hệ lành mạnh và quan hệ độc hại.',
  ),

  'thien_di': PalaceKnowledge(
    key: 'thien_di',
    name: 'Thiên Di',
    fullName: 'Cung Thiên Di',
    domain: 'Di chuyển, giao tiếp, học hỏi, mở rộng tầm nhìn, du lịch',
    coreStrengths: [
      'Nhạy bén trong giao tiếp và ngoại giao',
      'Thích nghi nhanh với môi trường mới',
      'Có tầm nhìn rộng, không bó hẹp trong một lĩnh vực',
    ],
    coreChallenges: [
      'Dễ phân tán vì quá nhiều hướng để khám phá',
      'Khó cam kết dài hạn với một địa điểm hoặc mối quan hệ',
      'Có thể nói nhiều hơn nghe',
    ],
    suitableDirections: [
      'Hướng Đông — mở rộng, khám phá',
      'Hướng Tây — giao tiếp, đàm phán',
    ],
    lifeAdvice:
        'Di chuyển, học hỏi là năng lượng tự nhiên của cung này. '
        'Nếu bị giới hạn quá mức, sẽ bức bối. Hãy tạo cơ hội cho bản thân trải nghiệm, '
        'nhưng có chủ đích — chọn một hướng chính thay vì ôm tất cả. '
        'Khi vận Thiên Di mạnh: đây là thời điểm tốt để thử nghiệm, du lịch, học hỏi.',
    relationshipStyle:
        'Cần đối tác có thể đồng hành trong hành trình thay đổi. '
        'Không thích sự tĩnh tại quá mức. '
        'Giao tiếp cởi mở nhưng cần học cách lắng nghe sâu.',
    healthNote:
        'Hệ thần kinh, tay chân dễ bị căng thẳng khi di chuyển nhiều. '
        'Ngủ đủ giấc dù ở môi trường xa lạ.',
  ),

  'tat_ach': PalaceKnowledge(
    key: 'tat_ach',
    name: 'Tật Ách',
    fullName: 'Cung Tật Ách',
    domain: 'Sức khỏe, bệnh tật, tai nạn, thử thách bất ngờ',
    coreStrengths: [
      'Có ý chí vượt qua nghịch cảnh',
      'Nếu vượt qua thử thách: trở nên mạnh mẽ hơn',
      'Nhạy cảm với tín hiệu cơ thể — biết khi nào cần nghỉ ngơi',
    ],
    coreChallenges: [
      'Sức khỏe dễ bị ảnh hưởng khi stress kéo dài',
      'Có thể gặp tai nạn hoặc bệnh bất ngờ trong giai đoạn xấu',
      'Tâm lý bất ổn khi đối mặt với bệnh tật',
    ],
    suitableDirections: [
      'Hướng Đông — phục hồi, khởi động lại',
      'Hướng Bắc — chữa lành, tĩnh tâm',
    ],
    lifeAdvice:
        'Phòng bệnh hơn chữa bệnh. Ăn uống, ngủ nghỉ, vận động là nền tảng. '
        'Khi vận Tật Ách mạnh: cẩn trọng hơn bình thường, tránh hành động liều lĩnh. '
        'Khi gặp thử thách: đây là giai đoạn rèn luyện, không phải hình phạt — '
        'cơ thể đang báo hiệu cần thay đổi thói quen.',
    relationshipStyle:
        'Khi khỏe mạnh: nhiệt tình, tích cực. '
        'Khi đau yếu: có thể thu mình, cần đối tác biết chăm sóc mà không kiểm soát.',
    healthNote:
        'Cung này phản ánh sức khỏe tổng quát. '
        'Đi khám định kỳ, không bỏ qua triệu chứng kéo dài. '
        'Tập thể dục nhẹ nhàng, yoga, thiền giúp cân bằng năng lượng cung này.',
  ),

  'tai_bach': PalaceKnowledge(
    key: 'tai_bach',
    name: 'Tài Bạch',
    fullName: 'Cung Tài Bạch',
    domain: 'Tiền bạc, tài lộc, nguồn thu, đầu tư, tài chính',
    coreStrengths: [
      'Có năng lực kiếm tiền, biết cách tạo thu nhập',
      'Hiểu giá trị của đồng tiền',
      'Có duyên với các nguồn thu bất ngờ',
    ],
    coreChallenges: [
      'Tiêu xài có thể theo cảm xúc, thiếu kế hoạch',
      'Quá tập trung vào tiền bạc dẫn đến bỏ qua giá trị khác',
      'Rủi ro tài chính nếu đầu tư thiếu nghiên cứu',
    ],
    suitableDirections: [
      'Hướng Đông — kinh doanh, tạo thu nhập',
      'Hướng Tây Nam — tài lộc gia đình',
      'Hướng Đông Nam — đầu tư, tích lũy',
    ],
    lifeAdvice:
        'Tài lộc đến từ nhiều nguồn — lương, đầu tư, quà tặng, bất ngờ. '
        'Quan trọng là phân bổ hợp lý: tích lũy dài hạn, quỹ khẩn cấp, đầu tư. '
        'Khi vận Tài Bạch mạnh: có cơ hội tăng thu nhập — nắm bắt nhưng có kiểm soát. '
        'Khi yếu: cẩn thận chi tiêu, tránh đầu tư mạo hiểm.',
    relationshipStyle:
        'Có thể mang thói quen chi tiêu vào quan hệ. '
        'Cần đối tác có tài quản lý tài chính hoặc cùng xây dựng kế hoạch tài chính chung.',
    healthNote:
        'Hệ tiêu hóa, gan thường bị ảnh hưởng khi lo âu về tiền bạc. '
        'Tập buông bỏ lo lắng tài chính, có kế hoạch rõ ràng giúp giảm stress cung này.',
  ),

  'tu_tuc': PalaceKnowledge(
    key: 'tu_tuc',
    name: 'Tử Tức',
    fullName: 'Cung Tử Tức',
    domain: 'Con cái, sáng tạo, dự án dài hạn, di sản',
    coreStrengths: [
      'Có ý tưởng sáng tạo, biết nuôi dưỡng dự án từ nhỏ',
      'Nếu có con: biết cách giáo dục và truyền cảm hứng',
      'Có tầm nhìn dài hạn',
    ],
    coreChallenges: [
      'Kết quả đến chậm — dễ mất kiên nhẫn khi chưa thấy thành quả',
      'Có thể kỳ vọng quá cao vào con cái hoặc dự án',
      'Nếu không có con: cảm thấy thiếu ý nghĩa trong cung này',
    ],
    suitableDirections: [
      'Hướng Tây — sáng tạo, giáo dục',
      'Hướng Đông — khởi nghiệp dài hạn',
    ],
    lifeAdvice:
        'Tử Tức là cung của sự sinh sôi — không chỉ về con cái, '
        'mà còn về việc gieo trồng và chờ đợi thu hoạch. '
        'Chọn một dự án hoặc mục tiêu có ý nghĩa, kiên nhẫn xây dựng. '
        'Khi vận Tử Tức mạnh: gieo hạt giống. Khi yếu: chờ thời, không vội thu hoạch sớm.',
    relationshipStyle:
        'Nuôi dưỡng, kiên nhẫn. '
        'Cần đối tác có thể cùng xây dựng tương lai dài hạn, không chỉ tận hưởng hiện tại.',
    healthNote:
        'Hệ sinh sản cần lưu ý. '
        'Stress khi chưa có con cái hoặc dự án thành công ảnh hưởng tâm lý — '
        'tập trung vào quá trình thay vì áp lực kết quả.',
  ),

  'phu_the': PalaceKnowledge(
    key: 'phu_the',
    name: 'Phu Thê',
    fullName: 'Cung Phu Thê',
    domain: 'Hôn nhân, tình cảm, quan hệ đối tác, vợ/chồng',
    coreStrengths: [
      'Biết cách thu hút đối tượng quan tâm',
      'Có duyên tình cảm, được yêu thương',
      'Hiểu nhu cầu cảm xúc của người bên cạnh',
    ],
    coreChallenges: [
      'Dễ xung đột nếu kỳ vọng khác biệt rõ rệt',
      'Có thể bị ảnh hưởng tiêu cực bởi đối tác không phù hợp',
      'Khó buông bỏ quan hệ đã hết duyên',
    ],
    suitableDirections: [
      'Hướng Tây — hợp nhất',
      'Hướng Đông Nam — quan hệ, giao tiếp',
    ],
    lifeAdvice:
        'Hôn nhân là đối tác dài hạn, không phải sự lãng mạn ban đầu. '
        'Chọn người cùng tầm价值观 và mục tiêu. '
        'Khi vận Phu Thê mạnh: có cơ hội gặp đối tác tốt. Khi yếu: '
        'tập trung vào bản thân trước, đừng vội kết hôn vì áp lực bên ngoài.',
    relationshipStyle:
        'Dịu dàng, quan tâm. '
        'Cần đối tác tôn trọng không gian riêng tư, '
        'biết giao tiếp trực tiếp thay vì giấu cảm xúc.',
    healthNote:
        'Hệ tim mạch, cảm xúc ảnh hưởng đến sức khỏe nhiều hơn bình thường. '
        'Khi xung đột tình cảm kéo dài: tìm người tư vấn hoặc viết nhật ký để giải tỏa.',
  ),

  'huynh_de': PalaceKnowledge(
    key: 'huynh_de',
    name: 'Huynh Đệ',
    fullName: 'Cung Huynh Đệ',
    domain: 'Anh chị em, bạn bè, đồng nghiệp thân thiết, quý nhân',
    coreStrengths: [
      'Có mạng lưới bạn bè và anh chị em hỗ trợ',
      'Biết cách tạo dựng uy tín trong nhóm',
      'Được người khác tin tưởng',
    ],
    coreChallenges: [
      'Quá phụ thuộc vào bạn bè khi đưa ra quyết định',
      'Xung đột anh chị em có thể gây tổn thương sâu sắc',
      'Bạn bè xấu có thể kéo vào đường sai',
    ],
    suitableDirections: [
      'Hướng Đông Bắc — quan hệ',
      'Hướng Tây Bắc — xây dựng uy tín',
    ],
    lifeAdvice:
        'Bạn bè tốt là tài sản quý. Chọn người đồng hành cẩn thận — '
        'không phải ai tốt với bạn đều tốt CHO bạn. '
        'Khi vận Huynh Đệ mạnh: mở rộng quan hệ, gặp quý nhân. '
        'Khi yếu: thu hẹp vòng tròn, giữ những người thực sự đáng tin.',
    relationshipStyle:
        'Hào phóng, hay giúp đỡ. '
        'Cần đối tác hiểu và tôn trọng tình bạn, '
        'không ghen tuông với bạn bè thân.',
    healthNote:
        'Hệ thần kinh, giấc ngủ bị ảnh hưởng khi lo lắng về xung đột quan hệ. '
        'Thiết lập ranh giới rõ ràng với bạn bè giúp giảm căng thẳng không cần thiết.',
  ),
};

// ============================================================
// STAR MEANINGS — 14 Chính tinh + Phụ tinh quan trọng
// ============================================================

const Map<String, StarKnowledge> starKnowledgeBase = {
  // ---- 14 Chính tinh ----
  'Thái Dương': StarKnowledge(
    key: 'Thái Dương',
    type: StarType.major,
    element: 'Dương Hỏa',
    keywords: ['danh vị', 'công danh', 'minh bạch', 'chủ động', 'nam tính', 'uy tín'],
    positive:
        'Có tinh thần tự lập cao, không ỷ lại người khác. '
        'Minh bạch trong suy nghĩ và hành động. '
        'Có khả năng dẫn dắt và tạo ảnh hưởng tích cực. '
        'Dám nghĩ, dám làm, dám chịu trách nhiệm.',
    negative:
        'Có thể quá tự tin, muốn kiểm soát mọi thứ. '
        'Dễ nóng vội, thiếu kiên nhẫn. '
        'Khi gặp thất bại: dễ tự áp lực hoặc đổ lỗi bên ngoài. '
        'Bảo thủ khi bị chất vấn quan điểm.',
    advice:
        'Học cách lắng nghe trước khi phát ngôn. '
        'Tính công danh mạnh: cần môi trường cho phép tỏa sáng, '
        'nhưng biết nhường nhịn đúng lúc. '
        'Khi mất năng lượng: nghỉ ngơi, không cố trung thành với nhịp làm việc quá sức.',
  ),

  'Thiên Phủ': StarKnowledge(
    key: 'Thiên Phủ',
    type: StarType.major,
    element: 'Dương Thổ',
    keywords: ['che chở', 'hỗ trợ', 'cát lợi', 'bạo phước', 'người trên'],
    positive:
        'Được quý nhân phù trợ đúng lúc. '
        'Có khả năng thu hút nguồn lực từ người khác. '
        'Biết cách bảo vệ bản thân và người thân. '
        'Có duyên gặp người giúp đỡ khi khó khăn.',
    negative:
        'Có thể quá phụ thuộc vào người khác. '
        'Khi vận cung mạnh: có thể bạo phước, lạm dụng ơn huệ. '
        'Khi mất duyên: cảm thấy cô đơn, không ai giúp đỡ.',
    advice:
        'Biết ơn nhưng không ỷ lại. '
        'Khi được giúp: ghi nhận và trả ơn. '
        'Khi gặp khó khăn: chủ động tìm cách thay vì đợi người khác giải quyết.',
  ),

  'Vũ Khúc': StarKnowledge(
    key: 'Vũ Khúc',
    type: StarType.major,
    element: 'Dương Thủy',
    keywords: ['linh hoạt', 'thương trường', 'ngoại giao', 'thích nghi', 'giàu có'],
    positive:
        'Khéo léo trong giao tiếp, thương lượng. '
        'Thích nghi nhanh với hoàn cảnh mới. '
        'Có trực giác tốt về cơ hội tài chính. '
        'Biết cách xoay chuyển tình thế.',
    negative:
        'Có thể thiếu kiên định, đổi hướng quá nhanh. '
        'Tính toán nhiều khiến người khác khó tin tưởng. '
        'Khi thất bại: dễ đổ lỗi hoàn cảnh.',
    advice:
        'Học cách cam kết với mục tiêu đã chọn. '
        'Thương trường là chiến trường: chuẩn bị kỹ trước khi ra quyết định lớn. '
        'Đừng chạy theo mọi cơ hội — chọn một hướng đi chính.',
  ),

  'Thiên Tướng': StarKnowledge(
    key: 'Thiên Tướng',
    type: StarType.major,
    element: 'Dương Thổ',
    keywords: ['quyền lực', 'chính trị', 'tổ chức', 'lãnh đạo', 'uy tín'],
    positive:
        'Có tài tổ chức, biết sắp xếp công việc hợp lý. '
        'Có tầm nhìn vĩ mô, không chỉ nhìn vào chi tiết nhỏ. '
        'Được người khác tôn trọng vì sự nghiêm túc. '
        'Biết cách điều phối con người.',
    negative:
        'Có thể trở nên độc đoán nếu quyền lực tập trung quá mức. '
        'Khó thay đổi khi đã có kế hoạch. '
        'Bị áp lực từ trách nhiệm lớn khiến mệt mỏi.',
    advice:
        'Quyền lực đi kèm trách nhiệm. '
        'Học cách phân quyền, tin tưởng người khác làm đúng vai trò của họ. '
        'Khi mệt: nghỉ ngơi có kế hoạch thay vì gắng gượng.',
  ),

  'Liêm Trinh': StarKnowledge(
    key: 'Liêm Trinh',
    type: StarType.major,
    element: 'Dương Hỏa',
    keywords: ['liêm', 'chính', 'trinh', 'ngay thẳng', 'đối đầu', 'thẳng thắn'],
    positive:
        'Ngay thẳng, trung thực, không giả dối. '
        'Dám đối đầu với cái sai. '
        'Có nguyên tắc rõ ràng trong cuộc sống. '
        'Được người khác tin tưởng vì sự nhất quán.',
    negative:
        'Thẳng thắn quá mức có thể gây tổn thương. '
        'Khó uốn nắn khi đã có ý kiến cố hữu. '
        'Dễ xung đột với người có cách làm khác mình.',
    advice:
        'Ngay thẳng là điểm mạnh nhưng cần khéo léo trong cách diễn đạt. '
        'Chọn trận đánh quan trọng — không phải cuộc đối đầu nào cũng cần tham gia. '
        'Lắng nghe trước khi phán xét.',
  ),

  'Thiên Đồng': StarKnowledge(
    key: 'Thiên Đồng',
    type: StarType.major,
    element: 'Dương Thủy',
    keywords: ['học hỏi', 'giao tiếp', 'di chuyển', 'trẻ trung', 'đa tài'],
    positive:
        'Nhạy bén trong học hỏi và tiếp thu kiến thức mới. '
        'Giao tiếp tốt, biết diễn đạt ý tưởng. '
        'Thích nghi nhanh, linh hoạt với thay đổi. '
        'Có sự trẻ trung, nhiệt huyết.',
    negative:
        'Dễ phân tán, học nhiều nhưng không chuyên sâu. '
        'Thiếu kiên nhẫn với những gì chậm tiến bộ. '
        'Có thể nông cạn trong suy nghĩ.',
    advice:
        'Chọn một lĩnh vực chuyên sâu thay vì học tất cả nửa vời. '
        'Di chuyển, học hỏi là thế mạnh — tận dụng nhưng có mục tiêu. '
        'Học đi đôi với thực hành.',
  ),

  'Thái Âm': StarKnowledge(
    key: 'Thái Âm',
    type: StarType.major,
    element: 'Âm Thủy',
    keywords: ['nuông chiều', 'nghệ thuật', 'cảm xúc', 'bảo trợ', 'yếu đuối'],
    positive:
        'Nhạy cảm với cảm xúc bản thân và người khác. '
        'Có năng khiếu nghệ thuật, sáng tạo. '
        'Biết chăm sóc, nuông chiều người thân. '
        'Có trực giác tốt về nhu cầu ngầm của người khác.',
    negative:
        'Cảm xúc quá mức dẫn đến dao động tâm trạng. '
        'Có thể yếu đuối trước áp lực, thiếu quyết đoán. '
        'Dễ tổn thương khi bị phê phán.',
    advice:
        'Cảm xúc là thế mạnh nhưng cần kiểm soát, không để nó điều khiển quyết định. '
        'Nuông chiều là điểm tốt nhưng biết đặt ranh giới. '
        'Tập trung phát triển sự độc lập tinh thần.',
  ),

  'Thiên Lương': StarKnowledge(
    key: 'Thiên Lương',
    type: StarType.major,
    element: 'Âm Thổ',
    keywords: ['công bằng', 'lương tâm', 'chính trực', 'liêm chính', 'nghiêm túc'],
    positive:
        'Có lương tâm rõ ràng, sống ngay thẳng. '
        'Công bằng trong đánh giá người khác. '
        'Được tin tưởng vì sự chính trực. '
        'Có khả năng cân bằng cảm xúc trong quyết định quan trọng.',
    negative:
        'Quá nguyên tắc khiến người khác e ngại. '
        'Khó linh hoạt khi hoàn cảnh đòi hỏi thay đổi. '
        'Áp lực phải "đúng" có thể gây căng thẳng nội tâm.',
    advice:
        'Nguyên tắc là nền tảng, nhưng cần linh hoạt trong cách áp dụng. '
        'Công bằng không có nghĩa là cứng nhắc. '
        'Biết khi nào cần nhượng bộ vì lợi ích lớn hơn.',
  ),

  'Thất Sát': StarKnowledge(
    key: 'Thất Sát',
    type: StarType.major,
    element: 'Dương Hỏa',
    keywords: ['sát phạt', 'quyết đoán', 'dám nghĩ dám làm', 'xung đột', 'bạo dạn'],
    positive:
        'Dám đưa ra quyết định khó khăn. '
        'Không sợ xung đột khi cần thiết. '
        'Có khả năng phá vỡ thế bế tắc. '
        'Mạnh mẽ trong hoàn cảnh khó khăn.',
    negative:
        'Quá bạo dạn, thiếu cân nhắc dẫn đến thất bại. '
        'Dễ gây xung đột không cần thiết. '
        'Có thể bị cô lập vì cách hành xử quá cứng rắn.',
    advice:
        'Sát phạt là con dao — dùng đúng lúc thì cắt gọn, dùng sai thì tự cắt. '
        'Quyết đoán cần đi kèm thông tin đầy đủ. '
        'Học cách nhìn nhận vấn đề từ nhiều góc độ trước khi hành động.',
  ),

  'Tham Lang': StarKnowledge(
    key: 'Tham Lang',
    type: StarType.major,
    element: 'Âm Thủy',
    keywords: ['tham lam', 'ngã', 'nghệ thuật', 'tâm linh', 'sâu sắc'],
    positive:
        'Có chiều sâu tâm linh, suy tư nội tâm mạnh. '
        'Nghệ thuật sắc sảo, có gu thẩm mỹ tinh tế. '
        'Biết tự nhìn nhận bản thân. '
        'Có sức hút bí ẩn, thu hút người khác.',
    negative:
        'Có thể tham lam, muốn chiếm hữu quá mức. '
        'Dễ chìm trong suy nghĩ tiêu cực. '
        'Cô đơn khi không ai hiểu nỗi lòng sâu sắc.',
    advice:
        'Chiều sâu tâm linh là tài sản — dùng để phát triển bản thân, '
        'không để nó trở thành gánh nặng. '
        'Tham lam không chỉ là tiền bạc — cần kiểm soát cả tham vọng về danh vị, tình cảm.',
  ),

  'Phá Quân': StarKnowledge(
    key: 'Phá Quân',
    type: StarType.major,
    element: 'Dương Thủy',
    keywords: ['phá vỡ', 'thay đổi', 'tân trang', 'quật khởi', 'bất ngờ'],
    positive:
        'Dám phá vỡ khuôn mẫu cũ để tạo cái mới. '
        'Mạnh mẽ trong giai đoạn chuyển đổi. '
        'Có sức quật khởi sau thất bại. '
        'Không bám víu vào những gì đã cũ kỹ.',
    negative:
        'Phá vỡ quá mức không xây dựng: tạo hỗn loạn. '
        'Bất ngờ trong thay đổi có thể khiến người khác không theo kịp. '
        'Thiếu kiên nhẫn với những gì không thay đổi được.',
    advice:
        'Phá vỡ nhưng có mục đích — không phải phá để phá. '
        'Khi gặp thay đổi lớn: đây là thời điểm cần dũng cảm, không sợ hãi. '
        'Sau khi phá: phải xây lại. Không để lại đổ nát.',
  ),

  'Cự Môn': StarKnowledge(
    key: 'Cự Môn',
    type: StarType.major,
    element: 'Dương Thủy',
    keywords: ['cực đoan', 'mãnh liệt', 'quyết liệt', 'bộc trực', 'khác biệt'],
    positive:
        'Có cá tính mạnh, không đi theo số đông. '
        'Quyết liệt trong hành động, không do dự. '
        'Dám đi con đường riêng. '
        'Tạo ấn tượng mạnh với người khác.',
    negative:
        'Quá cực đoan dẫn đến sai lầm lớn. '
        'Bộc trực quá mức gây tổn thương người khác. '
        'Khó hòa nhập với môi trường mới.',
    advice:
        'Cá tính mạnh là thế mạnh khi biết kiểm soát. '
        'Bộc trực là tốt nhưng chọn thời điểm và cách diễn đạt phù hợp. '
        'Học cách điều chỉnh cường độ theo hoàn cảnh.',
  ),

  // ---- Phụ tinh quan trọng ----
  'Văn Xương': StarKnowledge(
    key: 'Văn Xương',
    type: StarType.minor,
    element: 'Thổ',
    keywords: ['văn học', 'học vấn', 'công danh', 'trí tuệ', 'nổi tiếng'],
    positive:
        'Có tài học vấn, trí tuệ. '
        'Được công nhận về thành tựu trong lĩnh vực chuyên môn. '
        'Biết diễn đạt ý tưởng bằng ngôn ngữ.',
    negative: 'Đôi khi quá lý thuyết, thiếu thực tế.',
    advice: 'Học đi đôi với làm. Kiến thức cần được áp dụng mới có giá trị.',
  ),

  'Văn Khúc': StarKnowledge(
    key: 'Văn Khúc',
    type: StarType.minor,
    element: 'Thủy',
    keywords: ['nghệ thuật', 'sáng tạo', 'diễn xuất', 'linh hoạt', 'thuyết phục'],
    positive:
        'Có tài năng nghệ thuật, sáng tạo. '
        'Khéo léo trong thuyết phục, diễn đạt. '
        'Biết cách làm cho người khác tin vào điều mình nói.',
    negative:
        'Có thể thiếu thực tế, nói nhiều làm ít. '
        'Đôi khi giả tạo để gây ấn tượng.',
    advice: 'Tài nói là công cụ — dùng để truyền đạt giá trị thật, không chỉ để nổi bật.',
  ),

  'Tả Phù': StarKnowledge(
    key: 'Tả Phù',
    type: StarType.minor,
    element: 'Mộc',
    keywords: ['quý nhân', 'che chở', 'hỗ trợ', 'tốt bụng', 'ân huệ'],
    positive:
        'Được quý nhân giúp đỡ đúng lúc. '
        'Có người hỗ trợ vô điều kiện. '
        'Biết ơn và nhận ra giá trị của sự giúp đỡ.',
    negative: 'Có thể quá phụ thuộc vào quý nhân, thiếu tự lập.',
    advice: 'Quý nhân là phúc — trân trọng. Nhưng đừng quên tự xây năng lực cho mình.',
  ),

  'Hữu Bật': StarKnowledge(
    key: 'Hữu Bật',
    type: StarType.minor,
    element: 'Mộc',
    keywords: ['quý nhân', 'hỗ trợ', 'may mắn', 'duyên', 'gia tăng'],
    positive:
        'Gia tăng may mắn, tài lộc. '
        'Có duyên gặp người tốt. '
        'Công việc và tài chính có chiều hướng tốt lên.',
    negative: 'May mắn có thể làm chủ nhân trở nên chủ quan.',
    advice: 'May mắn là điều kiện thuận — tận dụng để tạo giá trị, đừng lãng phí.',
  ),

  'Lộc Tồn': StarKnowledge(
    key: 'Lộc Tồn',
    type: StarType.minor,
    element: 'Mộc',
    keywords: ['lộc', 'cát', 'tài lộc', 'bảo tồn', 'tích lũy'],
    positive:
        'Tài lộc ổn định, biết giữ được tiền. '
        'Có nguồn thu nhập từ nhiều hướng. '
        'Biết tích lũy cho tương lai.',
    negative:
        'Quá tiết kiệm có thể bỏ qua trải nghiệm đáng giá. '
        'Có thể thiếu đầu tư mạo hiểm dù có tiềm năng.',
    advice: 'Giữ tiền là tốt nhưng cần biết phân bổ: tích lũy + đầu tư + hưởng thụ hợp lý.',
  ),

  'Thiên Mã': StarKnowledge(
    key: 'Thiên Mã',
    type: StarType.minor,
    element: 'Hỏa',
    keywords: ['di chuyển', 'thay đổi', 'phát triển', 'tiến bộ', 'năng động'],
    positive:
        'Có vận di chuyển tốt — du lịch, học tập, thay đổi môi trường đều thuận lợi. '
        'Năng động, không ngại thử nghiệm. '
        'Cơ hội đến từ những hướng bất ngờ.',
    negative: 'Di chuyển quá nhiều có thể gây bất ổn, không có gốc rễ.',
    advice: 'Di chuyển có mục đích — mỗi lần thay đổi cần tạo giá trị rõ ràng.',
  ),

  'Giải Thần': StarKnowledge(
    key: 'Giải Thần',
    type: StarType.minor,
    element: 'Thủy',
    keywords: ['giải trừ', 'xua đuổi', 'thư giãn', 'hòa nhã', 'bình an'],
    positive:
        'Có khả năng giải tỏa xung đột, mâu thuẫn. '
        'Bình an trong tâm trí, ít lo âu. '
        'Được người khác yêu mến vì sự hòa nhã.',
    negative: 'Có thể quá thụ động, né tránh đối đầu khi cần thiết.',
    advice: 'Hòa nhã là điểm tốt nhưng cần biết khi nào cần đối đầu trực tiếp.',
  ),

  'Hóa Khoa': StarKnowledge(
    key: 'Hóa Khoa',
    type: StarType.minor,
    element: 'Hỏa',
    keywords: ['học vấn', 'thi cử', 'trí tuệ', 'kiến thức', 'kỹ năng'],
    positive:
        'Có tài học hành, thi cử. '
        'Tiếp thu kiến thức mới nhanh. '
        'Có khả năng truyền đạt kiến thức cho người khác.',
    negative: 'Học nhiều nhưng áp dụng ít, trở thành người chỉ biết lý thuyết.',
    advice: 'Học để làm — mỗi kiến thức cần ít nhất một ứng dụng thực tế.',
  ),

  'Hóa Lộc': StarKnowledge(
    key: 'Hóa Lộc',
    type: StarType.minor,
    element: 'Mộc',
    keywords: ['lộc', 'sinh sôi', 'phát triển', 'tài lộc', 'cơ hội'],
    positive:
        'Cơ hội tài lộc đến từ nhiều nguồn. '
        'Sức sống dồi dào, có thể đầu tư vào sức khỏe và sự phát triển. '
        'Có duyên kinh doanh.',
    negative: 'Cơ hội nhiều nhưng có thể phân tán, khó chọn.',
    advice: 'Nắm bắt cơ hội tốt nhất thay vì theo đuổi tất cả. Chọn một hướng đi chính.',
  ),

  'Thiên Cơ': StarKnowledge(
    key: 'Thiên Cơ',
    type: StarType.minor,
    element: 'Mộc',
    keywords: ['cơ trí', 'xảo quyệt', 'thông minh', 'thay đổi', 'bất ngờ'],
    positive:
        'Rất thông minh, có trực giác. '
        'Biết nắm bắt cơ hội trước người khác. '
        'Có tài ứng biến trong tình huống khó.',
    negative:
        'Có thể xảo quyệt, dùng trí tuệ để lừa dối. '
        'Hay thay đổi khiến người khác khó tin tưởng.',
    advice: 'Trí tuệ là công cụ — dùng để giải quyết vấn đề, không phải để lợi dụng người khác.',
  ),

  'Thiên Khôi': StarKnowledge(
    key: 'Thiên Khôi',
    type: StarType.minor,
    element: 'Kim',
    keywords: ['kiêu ngạo', 'danh vị', 'nổi bật', 'khoe khoang', 'tài năng'],
    positive:
        'Tài năng nổi bật, được nhiều người biết đến. '
        'Có khí chất thu hút sự chú ý. '
        'Có thể đạt danh vị cao trong lĩnh vực chuyên môn.',
    negative:
        'Kiêu ngạo khiến người khác không muốn hợp tác. '
        'Khoe khoang có thể gây phản tác dụng.',
    advice: 'Nổi bật là tốt — nhưng để thành công thực sự, cần khiêm nhường và biết hợp tác.',
  ),

  'Thiên Việt': StarKnowledge(
    key: 'Thiên Việt',
    type: StarType.minor,
    element: 'Kim',
    keywords: ['nghĩa vụ', 'công danh', 'quan chức', 'chính quyền', 'trách nhiệm'],
    positive:
        'Có khả năng giao tiếp với quan chức, chính quyền. '
        'Được tin tưởng trong môi trường chính thức. '
        'Có ý thức trách nhiệm cao.',
    negative: 'Quá coi trọng hình thức, khuôn phép có thể gây cứng nhắc.',
    advice: 'Giao tiếp chính quyền tốt là lợi thế — dùng để hỗ trợ công việc, không phải để khoe.',
  ),
};

// ============================================================
// STAR STATUS — Trạng thái sao (miếu, vượng, đắc, hãm, bình)
// ============================================================

const Map<String, StarStatus> starStatusDefinitions = {
  'miếu': StarStatus(
    key: 'miếu',
    name: 'Miếu',
    meaning: 'Sao ở vị trí được xem là tốt nhất, mang ý nghĩa cát lợi mạnh mẽ nhất.',
    advice: 'Đây là vị trí thuận lợi nhất — tận dụng thế mạnh của sao này.',
    scoreModifier: 15,
  ),
  'vượng': StarStatus(
    key: 'vượng',
    name: 'Vượng',
    meaning: 'Sao ở vị trí tốt, mang lại năng lượng tích cực.',
    advice: 'Thuận lợi — đây là thời điểm hoặc vị trí tốt để phát huy.',
    scoreModifier: 10,
  ),
  'đắc': StarStatus(
    key: 'đắc',
    name: 'Đắc',
    meaning: 'Sao ở vị trí được hỗ trợ, có thể phát huy tác dụng.',
    advice: 'Có điều kiện thuận — cần nỗ lực để phát huy.',
    scoreModifier: 5,
  ),
  'bình': StarStatus(
    key: 'bình',
    name: 'Bình',
    meaning: 'Sao ở vị trí trung bình, tác dụng bình thường.',
    advice: 'Không tốt không xấu — kết quả phụ thuộc vào cách xử lý.',
    scoreModifier: 0,
  ),
  'hãm': StarStatus(
    key: 'hãm',
    name: 'Hãm',
    meaning: 'Sao ở vị trí bất lợi, tác dụng bị suy giảm hoặc đảo ngược.',
    advice: 'Cần cẩn thận hơn bình thường. Không phải là dấu chấm hết — nhưng cần né tránh rủi ro không cần thiết.',
    scoreModifier: -10,
  ),
};

// ============================================================
// FIVE ELEMENTS — Ngũ hành
// ============================================================

const Map<String, FiveElementKnowledge> fiveElementKnowledgeBase = {
  'Kim': FiveElementKnowledge(
    key: 'Kim',
    element: 'Kim (Thiết)',
    description:
        'Người mang mệnh Kim có tính cách cương nhuận, '
        'quyết đoán, coi trọng công bằng và lẽ phải. '
        'Có ý chí sắt đá, kiên định, nhưng đôi khi cứng rắn quá mức.',
    strengths: ['Quyết đoán', 'Công bằng', 'Kiên trì', 'Có nguyên tắc'],
    challenges: ['Cứng nhắc', 'Khó thay đổi', 'Bảo thủ'],
    suitableProfessions: [
      'Tài chính, ngân hàng',
      'Luật, tư pháp',
      'Kỹ thuật, sản xuất',
      'Quân sự, an ninh',
    ],
    advice:
        'Kim là kim loại — cần rèn luyện mới thành hình. '
        'Học cách linh hoạt trong cách tiếp cận, không đổi nguyên tắc cốt lõi. '
        'Tập lắng nghe ý kiến khác trước khi phát ngôn.',
  ),
  'Mộc': FiveElementKnowledge(
    key: 'Mộc',
    element: 'Mộc (Cây)',
    description:
        'Người mang mệnh Mộc có tính cách sống động, '
        'có khả năng phát triển và mở rộng. '
        'Nhân ái, hay giúp đỡ người khác, nhưng đôi khi thiếu kiên định.',
    strengths: ['Nhân ái', 'Phát triển', 'Sáng tạo', 'Hay giúp đỡ'],
    challenges: ['Thiếu kiên định', 'Do dự', 'Phân tán'],
    suitableProfessions: [
      'Giáo dục, đào tạo',
      'Nông nghiệp, môi trường',
      'Xã hội, từ thiện',
      'Thiết kế, sáng tạo',
    ],
    advice:
        'Cây cần có gốc rễ trước khi vươn cao. '
        'Xây dựng nền tảng vững chắc trước khi mở rộng. '
        'Biết nói "không" với những gì không phù hợp — đừng để người khác quyết định hướng đi.',
  ),
  'Thủy': FiveElementKnowledge(
    key: 'Thủy',
    element: 'Thủy (Nước)',
    description:
        'Người mang mệnh Thủy có tính cách linh hoạt, '
        'thích nghi nhanh, có trí tuệ và khả năng giao tiếp. '
        'Biết cách "chảy" qua chướng ngại, nhưng đôi khi thiếu cốt lõi.',
    strengths: ['Linh hoạt', 'Thông minh', 'Giao tiếp tốt', 'Thích nghi'],
    challenges: ['Thiếu kiên định', 'Bồn chồn', 'Dễ dao động'],
    suitableProfessions: [
      'Kinh doanh, thương mại',
      'Truyền thông, báo chí',
      'Ngoại giao, du lịch',
      'Công nghệ thông tin',
    ],
    advice:
        'Nước là nguồn sống — có thể chảy bất cứ đâu, '
        'nhưng cần biết hướng đi. '
        'Học cách cam kết với mục tiêu dù hoàn cảnh thay đổi. '
        'Thích nghi là tốt nhưng đừng để mất chính mình trong quá trình thích nghi.',
  ),
  'Hỏa': FiveElementKnowledge(
    key: 'Hỏa',
    element: 'Hỏa (Lửa)',
    description:
        'Người mang mệnh Hỏa có tính cách mãnh liệt, '
        'nhiệt huyết, quyết đoán và có sức ảnh hưởng. '
        'Dám nghĩ dám làm, nhưng đôi khi thiếu kiên nhẫn và nóng vội.',
    strengths: ['Nhiệt huyết', 'Quyết đoán', 'Dẫn dắt', 'Tác động mạnh'],
    challenges: ['Nóng vội', 'Thiếu kiên nhẫn', 'Bốc đồng'],
    suitableProfessions: [
      'Lãnh đạo, quản lý',
      'Marketing, truyền thông',
      'Nghệ thuật, giải trí',
      'Khởi nghiệp, kinh doanh',
    ],
    advice:
        'Lửa có thể sưởi ấm hoặc đốt cháy — tùy cách kiểm soát. '
        'Nhiệt huyết là động lực — nhưng cần đốt có kiểm soát. '
        'Trước khi hành động: hít thở sâu, đếm đến 10. '
        'Quyết đoán là tốt — nhưng quyết định vội vàng có thể gây hậu quả lớn.',
  ),
  'Thổ': FiveElementKnowledge(
    key: 'Thổ',
    element: 'Thổ (Đất)',
    description:
        'Người mang mệnh Thổ có tính cách ổn định, '
        'đáng tin cậy, kiên nhẫn và có trách nhiệm. '
        'Biết lắng nghe và hỗ trợ người khác, nhưng đôi khi bảo thủ.',
    strengths: ['Ổn định', 'Đáng tin', 'Kiên nhẫn', 'Chịu đựng'],
    challenges: ['Bảo thủ', 'Chậm thay đổi', 'Quá lo lắng'],
    suitableProfessions: [
      'Kế toán, tài chính',
      'Y tế, chăm sóc sức khỏe',
      'Bất động sản, nông nghiệp',
      'Tư vấn, hỗ trợ tâm lý',
    ],
    advice:
        'Đất là nền tảng — vững chắc nhưng cần biết tiếp nhận cái mới. '
        'Kiên nhẫn là thế mạnh — đừng để nó trở thành trì hoãn. '
        'Lo lắng về người khác là tốt — nhưng đừng quên lo cho bản thân. '
        'Học cách chấp nhận thay đổi là cần thiết.',
  ),
};


enum StarType { major, minor, adjective }

class PalaceKnowledge {
  const PalaceKnowledge({
    required this.key,
    required this.name,
    required this.fullName,
    required this.domain,
    required this.coreStrengths,
    required this.coreChallenges,
    required this.suitableDirections,
    required this.lifeAdvice,
    required this.relationshipStyle,
    required this.healthNote,
  });

  final String key;
  final String name;
  final String fullName;
  final String domain;
  final List<String> coreStrengths;
  final List<String> coreChallenges;
  final List<String> suitableDirections;
  final String lifeAdvice;
  final String relationshipStyle;
  final String healthNote;
}

class StarKnowledge {
  const StarKnowledge({
    required this.key,
    required this.type,
    required this.element,
    required this.keywords,
    required this.positive,
    required this.negative,
    required this.advice,
  });

  final String key;
  final StarType type;
  final String element;
  final List<String> keywords;
  final String positive;
  final String negative;
  final String advice;
}

class StarStatus {
  const StarStatus({
    required this.key,
    required this.name,
    required this.meaning,
    required this.advice,
    required this.scoreModifier,
  });

  final String key;
  final String name;
  final String meaning;
  final String advice;
  final int scoreModifier;
}

class FiveElementKnowledge {
  const FiveElementKnowledge({
    required this.key,
    required this.element,
    required this.description,
    required this.strengths,
    required this.challenges,
    required this.suitableProfessions,
    required this.advice,
  });

  final String key;
  final String element;
  final String description;
  final List<String> strengths;
  final List<String> challenges;
  final List<String> suitableProfessions;
  final String advice;
}
