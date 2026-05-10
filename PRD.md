Dưới đây là bản **PRD/SRS hoàn chỉnh** cho app Flutter xem tử vi thế hệ mới, dựa trên toàn bộ ảnh bạn gửi và định hướng làm tốt hơn app mẫu.

Mình đặt tên tạm là **Minh Mệnh AI**. Tên này có cảm giác phương Đông, dễ nhớ, không copy brand “Altuvi”, và có thể định vị là app **tử vi + vận hạn + chọn ngày + AI cá nhân hóa**.

---

# 1. Tầm nhìn sản phẩm

## Tên app tạm thời

**Minh Mệnh AI**

## Slogan

> Hiểu lá số, nắm vận trình, chọn ngày phù hợp và nhận luận giải cá nhân hóa bằng AI.

## Định vị

Đây không chỉ là app “xem tử vi cho vui”, mà là một app **mệnh lý cá nhân hóa** gồm:

- Lập lá số tử vi.
- Xem 12 cung.
- Xem đại vận, tiểu vận, nguyệt vận, nhật vận.
- Xem ngày tốt xấu.
- AI giải thích lá số bằng ngôn ngữ dễ hiểu.
- Theo dõi vận trình cá nhân theo ngày/tháng/năm.
- Mở khóa luận giải bằng xu/gói mua/gói subscription.
- Có hệ thống kiến thức để người dùng học và hiểu tử vi.

Điểm quan trọng: app nên dùng chữ **“tham khảo, chiêm nghiệm, định hướng”**, không khẳng định kiểu “chắc chắn xảy ra”. Điều này giúp sản phẩm chuyên nghiệp hơn, tránh rủi ro khi lên App Store/Google Play. Apple chia App Review Guidelines thành các nhóm Safety, Performance, Business, Design và Legal, còn Google Play có các mục chính sách về nội dung AI, quyền riêng tư, lừa đảo, sở hữu trí tuệ và nội dung sức khỏe/tài chính, nên app cần thiết kế an toàn ngay từ đầu. ([Apple Developer][1])

---

# 2. Nguyên tắc “chính xác” của app

Với app tử vi, mình không nên hứa “dự đoán cuộc đời chính xác 100%”. Ta nên định nghĩa “chính xác” theo 3 lớp:

## Lớp 1: Chính xác về dữ liệu đầu vào

- Ngày sinh.
- Giờ sinh.
- Giới tính.
- Lịch dương/lịch âm.
- Múi giờ.
- Nơi sinh nếu có tính giờ mặt trời thật.

## Lớp 2: Chính xác về thuật toán lập lá số

- Chuyển dương lịch ↔ âm lịch.
- Can chi.
- Tiết khí.
- 12 cung.
- An sao.
- Đại vận.
- Tiểu vận.
- Nguyệt vận.
- Nhật vận.

## Lớp 3: Nhất quán về luận giải

AI chỉ được luận dựa trên dữ liệu lá số đã tính ra. Không để AI tự bịa sao, tự bịa cung, tự thêm vận hạn.

Nên ghi trong app:

> Nội dung trong app mang tính tham khảo, chiêm nghiệm và hỗ trợ tự hiểu bản thân. Không thay thế tư vấn y tế, tài chính, pháp lý hoặc quyết định quan trọng trong đời sống.

---

# 3. Nguồn dữ liệu và công nghệ nên dùng

## 3.1. Engine lập lá số

Có 3 hướng:

### Hướng A — Dùng thư viện có sẵn để tăng tốc MVP

Có thể nghiên cứu **dart_iztro** vì đây là thư viện Flutter/Dart cho Purple Star Astrology/Zi Wei Dou Shu, hỗ trợ tính lá số, BaZi, chuyển lịch âm/dương, 12 cung, vận hạn lớn/nhỏ/năm/tháng/ngày/giờ, đa ngôn ngữ và cross-platform. ([GitHub][2])

Ưu điểm:

- Nhanh có MVP.
- Chạy được trực tiếp trong Flutter.
- Có dữ liệu 12 cung, sao, vận hạn.
- Có hỗ trợ tiếng Việt.

Nhược điểm:

- Cần kiểm tra kỹ xem có khớp với hệ phái tử vi Việt Nam mình muốn dùng không.
- Không nên phụ thuộc 100% vào lib ngoài nếu muốn làm app lâu dài.

### Hướng B — Dùng iztro làm chuẩn tham khảo

**iztro** là thư viện JavaScript open-source tạo astrolabe Zi Wei Dou Shu, hỗ trợ input ngày sinh dương/âm, giờ sinh, giới tính; có 12 cung, zodiac, horoscope decadal/yearly/monthly/daily, kiểm tra sao/cung, độ sáng sao, tam phương tứ chính, và hỗ trợ nhiều ngôn ngữ gồm tiếng Việt. ([GitHub][3])

iztro dùng giấy phép MIT, nên có thể tham khảo hoặc tích hợp nếu tuân thủ license. ([GitHub][3])

### Hướng C — Tự viết engine nội bộ

Đây là hướng tốt nhất cho sản phẩm lâu dài.

Ban đầu dùng thư viện để đối chiếu, sau đó viết package riêng:

```text
packages/
 └── destiny_engine/
     ├── calendar/
     ├── can_chi/
     ├── ziwei/
     ├── fortune_cycles/
     ├── good_bad_day/
     └── scoring/
```

Nguồn đối chiếu có thể dùng thêm `lasotuvi`, một project Python mã nguồn mở về an sao tử vi, MIT license. ([GitHub][4])

## 3.2. Lịch âm, tiết khí, can chi

Phần lịch âm và tiết khí phải làm cẩn thận. Hong Kong Observatory có bảng chuyển đổi Gregorian–Lunar và lưu ý rằng nếu thời điểm sóc/tiết khí gần nửa đêm thì có thể lệch một ngày ở một số trường hợp xa tương lai. ([hko.gov.hk][5])

24 tiết khí dựa trên kinh độ Mặt Trời, mỗi tiết cách nhau 15 độ trên hoàng đạo; lịch âm có tháng nhuận khi tháng âm lịch không chứa trung khí lớn. ([hko.gov.hk][6])

=> App nên có `CalendarEngine` riêng, có test case mạnh cho các năm 1900–2100, đặc biệt các ngày gần giao thừa âm lịch, tiết khí và tháng nhuận.

## 3.3. Dữ liệu luận giải

Không nên copy nguyên văn sách có bản quyền. Nên làm theo cách:

- Tạo **knowledge base nội bộ** bằng văn bản do mình viết lại.
- Mỗi mục có `sourceRef`, `school`, `version`, `confidence`.
- Dữ liệu sao/cung dùng dạng ngắn, có cấu trúc.
- AI chỉ dùng knowledge base này để viết lại thành văn tự nhiên.

Ví dụ:

```json
{
  "id": "star_thai_duong_menh",
  "type": "star_meaning",
  "star": "Thái Dương",
  "palace": "Mệnh",
  "keywords": ["công danh", "sáng rõ", "chủ động", "nam tính", "danh vọng"],
  "positive": "Có khuynh hướng chủ động, thích rõ ràng, có tinh thần trách nhiệm.",
  "negative": "Dễ tự áp lực, đôi khi nóng vội hoặc quá đặt nặng danh dự.",
  "advice": "Nên dùng sự minh bạch và năng lực tổ chức để phát triển sự nghiệp.",
  "sourceRef": "internal_rewrite_v1"
}
```

---

# 4. Kiến trúc tổng thể

## Đề xuất tốt nhất: Local-first + Cloud optional

Ý kiến của bạn là đúng: thông tin lá số có thể lưu local, nhập xong là bốc lá số ra ngay. Mình đề xuất kiến trúc như sau:

```text
Flutter App
 ├── Local Destiny Engine
 ├── Local Database
 ├── Local Chart Cache
 ├── AI Client
 ├── Payment Client
 └── Sync Client optional

Backend
 ├── Auth / User sync
 ├── Payment validation
 ├── AI orchestration
 ├── Content CMS
 ├── Coin wallet
 ├── Entitlement
 └── Analytics / Remote Config
```

## Vì sao local-first?

- App mở nhanh.
- Người dùng có thể lập lá số không cần mạng.
- Dữ liệu ngày sinh/giờ sinh riêng tư hơn.
- Server chỉ cần dùng cho đăng nhập, đồng bộ, thanh toán, AI và content.

## Database local

Nên dùng:

- `ObjectBox` nếu muốn local database nhanh và sau này có vector search/RAG local. ObjectBox có định hướng cho Flutter, mobile/IoT và có vector search phục vụ AI/RAG on-device. ([Dart packages][7])
- `flutter_secure_storage` để lưu token, refresh token, key mã hóa, thông tin nhạy cảm; package này dùng Keychain trên iOS/macOS và cơ chế mã hóa/secure storage theo nền tảng trên Android/Linux/Windows. ([Dart packages][8])

## Backend

Dùng stack bạn quen:

- Node.js + NestJS hoặc Express.
- MongoDB hoặc PostgreSQL.
- Redis cache.
- Firebase Auth.
- Firebase Cloud Messaging.
- Firebase Crashlytics.
- Firebase Remote Config.
- Firebase Analytics.

Firebase cho Flutter có Firestore realtime/offline sync, Cloud Functions, Cloud Messaging, Crashlytics, Performance Monitoring và Remote Config. ([Firebase][9])

---

# 5. Công nghệ Flutter đề xuất

## Core

```yaml
flutter:
  sdk: flutter

dependencies:
  get: latest
  dio: latest
  objectbox: latest
  flutter_secure_storage: latest
  firebase_core: latest
  firebase_auth: latest
  cloud_firestore: latest
  firebase_crashlytics: latest
  firebase_analytics: latest
  firebase_messaging: latest
  firebase_remote_config: latest
  cached_network_image: latest
  flutter_animate: latest
  fl_chart: latest
  in_app_purchase: latest
  purchases_flutter: optional
```

## State management

Với bạn, dùng **GetX** là nhanh nhất vì bạn đã quen. Nhưng cần quy định rõ:

- Controller chỉ giữ state màn hình.
- Repository xử lý data.
- Service xử lý engine/API.
- Không nhồi logic tử vi vào UI.

## Performance

Ưu tiên:

- Dùng `CustomScrollView`, `SliverList`, `ListView.builder`.
- Tránh render toàn bộ feed bài viết/lá số dài cùng lúc.
- Cache kết quả lá số.
- Chạy engine nặng trong isolate.
- Không rebuild cả màn hình khi chỉ đổi 1 tab.
- Ảnh bài viết phải resize/cached.
- Bảng lá số 12 cung nên custom paint hoặc render widget tối ưu.

Flutter khuyến nghị với list/grid lớn nên dùng lazy builder để chỉ build phần đang thấy trên màn hình, và tránh layout pass thừa vì có thể làm chậm app. ([Tài liệu Flutter][10])

---

# 6. Module sản phẩm

## Module 1 — Onboarding

### Màn hình

1. Splash.
2. Welcome.
3. Trải nghiệm ngay.
4. Đăng nhập/Đăng ký.
5. Tạo lá số nhanh.
6. Xem lá số minh họa.

### Chức năng

- Người dùng có thể dùng thử không cần đăng nhập.
- Đăng nhập để lưu cloud, mua xu, đồng bộ.
- Có CTA rõ:
  - “Trải nghiệm ngay”
  - “Đăng nhập/Đăng ký”
  - “Xem lá số minh họa”

---

## Module 2 — Auth

### Màn hình

- Đăng nhập email/password.
- Đăng ký.
- Quên mật khẩu.
- Tiếp tục với Google.
- Tiếp tục với Apple.
- Xóa tài khoản.

### Yêu cầu

- Firebase Auth.
- Apple Sign In bắt buộc nếu có social login trên iOS.
- Không bắt đăng nhập trước khi xem demo.
- Cho phép guest mode.

---

## Module 3 — Quản lý lá số

### Màn hình

- Danh sách lá số.
- Lá số chính.
- Lá số khác.
- Lập lá số mới.
- Sửa lá số.
- Xóa lá số.
- Đặt làm lá số chính.

### Field tạo lá số

```text
Họ tên
Giới tính
Ngày sinh
Loại lịch: Dương lịch / Âm lịch
Giờ sinh
Phút sinh optional
Năm xem
Nơi sinh optional
Múi giờ
Độ chắc chắn giờ sinh: chắc chắn / ước lượng / không rõ
Mối quan tâm chính: công việc / tình cảm / tài chính / sức khỏe / học tập / gia đình
```

### Tính năng hơn app mẫu

- Có “độ tin cậy giờ sinh”.
- Có “mục tiêu xem”.
- Có “nơi sinh” để sau này hỗ trợ giờ mặt trời thật.
- Có chế độ “không biết giờ sinh” nhưng kết quả bị đánh dấu độ tin cậy thấp.

---

## Module 4 — Lá số tử vi

### Màn hình

- Bàn lá số 12 cung.
- Zoom/pinch lá số.
- Năm xem.
- Toggle an lưu đại vận.
- Toggle an lưu tiểu vận.
- Toggle lưu niên.
- Tra cứu sao.
- Chỉnh sửa.
- Tải PDF.
- Chia sẻ hình ảnh.

### Nội dung

- Cung Mệnh.
- Cung Phụ Mẫu.
- Cung Phúc Đức.
- Cung Điền Trạch.
- Cung Quan Lộc.
- Cung Nô Bộc.
- Cung Thiên Di.
- Cung Tật Ách.
- Cung Tài Bạch.
- Cung Tử Tức.
- Cung Phu Thê.
- Cung Huynh Đệ.
- Chính tinh.
- Phụ tinh.
- Tứ hóa.
- Vòng Tràng Sinh.
- Đại vận.
- Tiểu vận.
- Lưu niên.

### Tính năng đột phá

- Chạm vào từng cung để mở panel giải thích.
- Highlight tam phương tứ chính.
- Highlight sao tốt/xấu.
- Có “vì sao app luận như vậy”.
- Có thang điểm từng cung nhưng phải giải thích rõ điểm không phải “phán số”, mà là điểm tương quan theo bộ quy tắc.

---

## Module 5 — Luận cung

### Màn hình

Danh sách 12 cung, mỗi cung có:

- Điểm số.
- Tên cung.
- Mô tả ngắn.
- Trạng thái mở khóa.
- Giá xu.
- Nút “Mở”.

Ví dụ:

```text
45 — Cung Mệnh + Thân — Mở 150 xu
39 — Cung Phúc Đức — Mở 100 xu
23 — Cung Điền Trạch — Mở 60 xu
37 — Cung Quan Lộc — Mở 100 xu
```

### Nội dung sau mở khóa

Mỗi cung nên có cấu trúc:

1. Tóm tắt 3 ý chính.
2. Điểm mạnh.
3. Thử thách.
4. Cung/sao liên quan.
5. Lời khuyên thực tế.
6. Câu hỏi AI gợi ý.

---

## Module 6 — Đại vận

### Màn hình

- Biểu đồ đại vận theo tuổi.
- Checkbox:
  - Tài lộc.
  - Thách thức.

- Marker “Chính vận”.
- Box “Biểu đồ của bạn nói gì”.
- Danh sách đại vận:
  - 5–14 tuổi.
  - 15–24 tuổi.
  - 25–34 tuổi.
  - 35–44 tuổi.
  - ...

- Mở khóa từng đại vận bằng xu.

### Tính năng hơn app mẫu

- Timeline ngang 0–100 tuổi.
- Người dùng có thể lọc theo:
  - Công việc.
  - Tài chính.
  - Tình cảm.
  - Gia đình.
  - Sức khỏe.

- Có chế độ “kế hoạch 10 năm”.

---

## Module 7 — Tiểu vận

### Màn hình

- Biểu đồ đường theo từng tuổi/năm.
- Marker “Năm nay”.
- Tài lộc/thách thức.
- Danh sách từng năm.
- Nút mở khóa.

### Nội dung

- Tổng quan năm.
- Cơ hội.
- Rủi ro.
- Tháng đáng chú ý.
- Việc nên làm.
- Việc nên tránh.
- Câu hỏi AI theo năm.

---

## Module 8 — Nguyệt vận

### Màn hình

- Năm xem.
- Danh sách tháng âm.
- Khoảng ngày dương lịch.
- Giá xu từng tháng.
- Icon quẻ/cung/sao.

### Nội dung

- Chủ đề chính của tháng.
- Công việc.
- Tài chính.
- Tình cảm.
- Sức khỏe.
- Ngày nên chú ý.
- Gợi ý hành động.

---

## Module 9 — Nhật vận

### Màn hình

- Lịch tháng.
- Chấm xanh ngày tốt.
- Chấm đỏ ngày xấu.
- Ngày âm dưới ngày dương.
- Thẻ ngày chi tiết.
- Giờ hoàng đạo/hắc đạo.
- Can chi.
- Ngũ hành.
- Ngày kỵ.
- AI luận ngày.

### Tính năng hơn app mẫu

Thêm phần:

```text
Hôm nay hợp:
✓ Học tập
✓ Gặp người quan trọng
✓ Lên kế hoạch

Hôm nay nên tránh:
✕ Quyết định tài chính lớn
✕ Tranh luận cảm xúc
✕ Ký kết vội vàng
```

---

## Module 10 — Xem ngày tốt xấu

Khác với Nhật vận trong lá số, tab này là công cụ chung.

### Màn hình

- Calendar month.
- Date converter.
- Chọn việc cần xem:
  - Khai trương.
  - Cưới hỏi.
  - Ký hợp đồng.
  - Chuyển nhà.
  - Xuất hành.
  - Mua xe.
  - Cắt tóc.
  - Gặp đối tác.

- Kết quả ngày phù hợp.
- Lý do phù hợp/không phù hợp.

### Điểm đột phá

Kết hợp ngày tốt xấu chung với lá số cá nhân:

```text
Ngày này theo lịch chung là tốt, nhưng với lá số của bạn có yếu tố xung nhẹ ở cung Quan Lộc, nên phù hợp cho chuẩn bị/kế hoạch hơn là ký kết lớn.
```

---

## Module 11 — Trợ lý AI Tử Vi

### 2 dạng AI

#### AI trong từng bài luận giải

- Tóm tắt.
- Giải thích đoạn khó hiểu.
- Gợi ý xem tiếp.
- Hỏi sâu về cung/vận.

#### AI toàn app

Người dùng hỏi tự do:

- Hôm nay của tôi thế nào?
- Năm nay công việc có tốt không?
- Tôi và người yêu có hợp không?
- Tôi nên chọn ngày nào để khai trương?
- Tôi nên tập trung điều gì trong tháng này?

### Nguyên tắc AI

AI không được tự bịa dữ liệu tử vi. Backend gửi cho AI một JSON đã tính sẵn, AI chỉ diễn giải lại.

OpenAI API hỗ trợ Structured Outputs bằng JSON Schema, giúp ép model trả về đúng cấu trúc JSON; phần này rất hợp cho app vì mình cần output ổn định để render UI, lưu cache và kiểm duyệt. ([Nền tảng OpenAI][11])

---

## Module 12 — Kiến thức

### Màn hình

- Feed bài viết.
- Chi tiết bài viết.
- Mục lục.
- Tìm kiếm.
- Lưu bài.
- Chia sẻ.
- Bài liên quan.

### Danh mục

- Nhập môn tử vi.
- Ý nghĩa 12 cung.
- Ý nghĩa chính tinh.
- Ý nghĩa phụ tinh.
- Đại vận.
- Tiểu vận.
- Nguyệt vận.
- Ngày tốt xấu.
- 12 con giáp hằng ngày.
- Chuyên đề tình cảm.
- Chuyên đề công danh.
- Chuyên đề tài lộc.
- Chuyên đề sức khỏe.

---

## Module 13 — Ví xu và thanh toán

### Màn hình

- Số xu hiện tại.
- Nạp thêm.
- Lịch sử sử dụng.
- Lịch sử mua.
- Gói xu.
- Gói subscription.
- Khôi phục giao dịch.
- Quản lý subscription.

### Sản phẩm bán

#### Consumable

- Gói 100 xu.
- Gói 300 xu.
- Gói 500 xu.
- Gói 1000 xu.

#### Non-consumable

- Mở trọn bộ một lá số.
- Xuất PDF cao cấp.

#### Subscription

- Gói tuần.
- Gói tháng.
- Gói năm.

Google Play Billing flow chuẩn là: hiển thị sản phẩm, mở purchase flow, verify purchase trên server, cấp quyền nội dung, rồi acknowledge/consume; subscription còn có các trạng thái active, cancelled, grace period, on hold, paused, expired. ([Android Developers][12])

Với Flutter, có thể dùng plugin `in_app_purchase` chính thức để hỗ trợ App Store và Google Play, nhưng vẫn cần cấu hình từng store và validate giao dịch. ([GitHub][13])

Nếu muốn tăng tốc, dùng **RevenueCat** cho MVP vì SDK Flutter của RevenueCat bọc StoreKit, Google Play Billing và backend RevenueCat, có receipt validation và entitlement tracking sẵn. ([GitHub][14])

---

# 7. Database design

## 7.1. Local database

### `LocalUserProfile`

```json
{
  "localId": "local_user_001",
  "cloudUserId": null,
  "displayName": "Vương Hỷ Khang",
  "email": null,
  "isGuest": true,
  "createdAt": "2026-05-07T13:19:00+07:00",
  "updatedAt": "2026-05-07T13:19:00+07:00"
}
```

### `BirthProfile`

```json
{
  "id": "profile_001",
  "userId": "local_user_001",
  "name": "VƯƠNG HỶ KHANG",
  "gender": "male",
  "calendarType": "solar",
  "birthDate": "2002-10-12",
  "birthHourBranch": "Suu",
  "birthHourText": "01:00-02:59",
  "birthMinute": null,
  "birthPlace": "Ca Mau, Vietnam",
  "timezone": "Asia/Ho_Chi_Minh",
  "birthTimeConfidence": "exact",
  "mainFocus": ["career", "wealth", "relationship"],
  "isMain": true,
  "createdAt": "...",
  "updatedAt": "..."
}
```

### `ChartCache`

```json
{
  "id": "chart_001_2026",
  "profileId": "profile_001",
  "year": 2026,
  "engineVersion": "destiny_engine_1.0.0",
  "school": "ziwei_vietnamese_v1",
  "inputHash": "sha256...",
  "chartJson": {},
  "createdAt": "...",
  "updatedAt": "..."
}
```

### `UnlockedContent`

```json
{
  "id": "unlock_001",
  "profileId": "profile_001",
  "contentType": "palace_reading",
  "contentKey": "career_palace",
  "unlockMethod": "coin",
  "coinSpent": 100,
  "createdAt": "..."
}
```

### `AIConversation`

```json
{
  "id": "chat_001",
  "profileId": "profile_001",
  "scope": "chart_general",
  "messages": [
    {
      "role": "user",
      "content": "Năm nay công việc của tôi thế nào?",
      "createdAt": "..."
    },
    {
      "role": "assistant",
      "content": "Năm nay bạn nên tập trung...",
      "createdAt": "..."
    }
  ]
}
```

---

## 7.2. Cloud database

Nếu dùng MongoDB:

### `users`

```json
{
  "_id": "user_id",
  "provider": "firebase",
  "firebaseUid": "abc",
  "name": "Khang Vuong Hy",
  "email": "khang@example.com",
  "avatarUrl": "",
  "coinBalance": 0,
  "premium": {
    "active": false,
    "plan": null,
    "expiresAt": null,
    "platform": null
  },
  "createdAt": "...",
  "updatedAt": "..."
}
```

### `birth_profiles`

```json
{
  "_id": "profile_id",
  "userId": "user_id",
  "name": "VƯƠNG HỶ KHANG",
  "gender": "male",
  "calendarType": "solar",
  "birthDate": "2002-10-12",
  "birthHourBranch": "Suu",
  "birthMinute": null,
  "birthPlace": "Ca Mau, Vietnam",
  "timezone": "Asia/Ho_Chi_Minh",
  "isMain": true,
  "createdAt": "...",
  "updatedAt": "..."
}
```

### `entitlements`

```json
{
  "_id": "entitlement_id",
  "userId": "user_id",
  "profileId": "profile_id",
  "type": "full_chart",
  "contentKey": "chart_2026_full",
  "source": "iap",
  "active": true,
  "expiresAt": null,
  "createdAt": "..."
}
```

### `coin_ledger`

```json
{
  "_id": "ledger_id",
  "userId": "user_id",
  "type": "spend",
  "amount": -100,
  "balanceAfter": 200,
  "reason": "unlock_palace_career",
  "profileId": "profile_id",
  "createdAt": "..."
}
```

### `purchases`

```json
{
  "_id": "purchase_id",
  "userId": "user_id",
  "platform": "ios",
  "productId": "full_chart_229k",
  "transactionId": "xxx",
  "originalTransactionId": "xxx",
  "purchaseToken": "xxx",
  "status": "verified",
  "amount": 229000,
  "currency": "VND",
  "createdAt": "..."
}
```

### `articles`

```json
{
  "_id": "article_id",
  "title": "Sao Giải Thần cung Phúc Đức...",
  "slug": "sao-giai-than-cung-phuc-duc",
  "summary": "Sao Giải Thần...",
  "coverImageUrl": "",
  "contentHtml": "",
  "category": "star_meaning",
  "tags": ["phuc-duc", "giai-than"],
  "published": true,
  "createdAt": "...",
  "updatedAt": "..."
}
```

---

# 8. API design

## Auth

```http
POST /v1/auth/session
GET /v1/me
PATCH /v1/me
DELETE /v1/me
```

## Birth profiles

```http
GET /v1/profiles
POST /v1/profiles
GET /v1/profiles/:id
PATCH /v1/profiles/:id
DELETE /v1/profiles/:id
POST /v1/profiles/:id/set-main
```

## Chart

Vì app local-first, API chart là optional.

```http
POST /v1/charts/validate
POST /v1/charts/sync
GET /v1/charts/:profileId/:year
POST /v1/charts/:profileId/:year/export-pdf
```

## AI

```http
POST /v1/ai/chat
POST /v1/ai/summarize-reading
POST /v1/ai/explain-palace
POST /v1/ai/daily-advice
POST /v1/ai/compatibility
```

Request mẫu:

```json
{
  "profileId": "profile_001",
  "scope": "yearly_fortune",
  "question": "Năm 2026 công việc của tôi thế nào?",
  "chartContext": {
    "year": 2026,
    "lifePalace": {},
    "careerPalace": {},
    "majorCycle": {},
    "yearlyCycle": {}
  },
  "style": "easy_to_understand"
}
```

Response mẫu:

```json
{
  "answer": "Năm 2026 là năm bạn nên tập trung...",
  "summaryBullets": [
    "Công việc có xu hướng mở rộng.",
    "Nên tránh quyết định vội.",
    "Quan hệ xã hội đóng vai trò quan trọng."
  ],
  "evidence": [
    {
      "type": "palace",
      "name": "Quan Lộc",
      "reason": "Cung Quan Lộc có nhóm sao liên quan đến..."
    }
  ],
  "riskLevel": "medium",
  "disclaimer": "Nội dung mang tính tham khảo."
}
```

## Wallet

```http
GET /v1/wallet
GET /v1/wallet/ledger
POST /v1/wallet/spend
POST /v1/wallet/grant
```

## Purchase

```http
GET /v1/products
POST /v1/purchases/verify/apple
POST /v1/purchases/verify/google
POST /v1/purchases/restore
GET /v1/entitlements
```

## Content

```http
GET /v1/articles
GET /v1/articles/:slug
GET /v1/articles/categories
POST /v1/articles/:id/bookmark
DELETE /v1/articles/:id/bookmark
```

## Daily tracking

```http
POST /v1/daily-journal
GET /v1/daily-journal
GET /v1/insights/monthly
```

---

# 9. User flow chính

## Flow 1 — Người dùng mới xem thử

```text
Welcome
→ Trải nghiệm ngay
→ Lập lá số tử vi
→ Nhập họ tên, giới tính, ngày sinh, giờ sinh, năm xem
→ Xem kết quả
→ Xem tổng quan miễn phí
→ Gợi ý mở khóa luận giải đầy đủ
```

## Flow 2 — Đăng nhập

```text
Welcome
→ Đăng nhập/Đăng ký
→ Email/Google/Apple
→ Vào tab Lá số
→ Đồng bộ lá số local nếu có
```

## Flow 3 — Mở khóa bằng xu

```text
Luận cung
→ Chọn Cung Quan Lộc
→ Bấm Mở - 100 xu
→ Kiểm tra số dư
→ Trừ xu
→ Lưu entitlement
→ Hiển thị nội dung
```

## Flow 4 — Mua luận giải trọn bộ

```text
Kết quả lá số
→ Luận giải toàn bộ 229.000đ
→ Paywall
→ IAP
→ Server verify
→ Cấp full_chart entitlement
→ Mở toàn bộ nội dung
```

## Flow 5 — Hỏi AI

```text
Kết quả lá số
→ Bấm floating AI
→ Chọn gợi ý nhanh hoặc nhập câu hỏi
→ App gửi chartContext + question
→ Backend gọi AI
→ Trả về answer + evidence + gợi ý xem tiếp
```

## Flow 6 — Xem ngày tốt cá nhân hóa

```text
Xem ngày
→ Chọn ngày
→ App tính lịch âm/can chi/tiết khí
→ Nếu có lá số chính, ghép với chartContext
→ Hiển thị ngày tốt/xấu chung + lời khuyên cá nhân
```

---

# 10. Prompt AI chuẩn

## 10.1. System prompt

```text
Bạn là Trợ lý AI Tử Vi của app Minh Mệnh AI.

Nhiệm vụ:
- Giải thích lá số tử vi, vận hạn, ngày tốt xấu bằng tiếng Việt dễ hiểu.
- Chỉ luận dựa trên dữ liệu JSON do hệ thống cung cấp.
- Không tự thêm sao, cung, vận, ngày, giờ hoặc sự kiện không có trong dữ liệu.
- Không khẳng định tuyệt đối tương lai.
- Không đưa ra chẩn đoán y tế, tư vấn pháp lý hoặc khuyến nghị đầu tư chắc chắn.
- Luôn dùng ngôn ngữ tham khảo: "có xu hướng", "nên lưu ý", "phù hợp để", "cần cân nhắc".
- Nếu dữ liệu giờ sinh không chắc chắn, phải nói rõ độ tin cậy thấp hơn.
- Mỗi kết luận quan trọng phải có phần "dựa trên yếu tố nào".
```

## 10.2. Developer prompt

```text
Output phải theo JSON schema:
{
  "title": string,
  "shortAnswer": string,
  "summaryBullets": string[],
  "detailedReading": string,
  "evidence": [
    {
      "factor": string,
      "meaning": string,
      "impact": "low" | "medium" | "high"
    }
  ],
  "practicalAdvice": string[],
  "avoid": string[],
  "nextSuggestions": string[],
  "disclaimer": string
}

Không trả markdown. Không trả dữ liệu ngoài schema.
```

## 10.3. User context gửi vào AI

```json
{
  "userQuestion": "Năm nay công việc của tôi thế nào?",
  "language": "vi",
  "tone": "easy_to_understand",
  "profile": {
    "gender": "male",
    "birthDate": "2002-10-12",
    "birthHour": "Suu",
    "birthTimeConfidence": "exact"
  },
  "chart": {
    "year": 2026,
    "palaces": [],
    "majorCycle": {},
    "yearlyCycle": {},
    "monthlyCycle": null,
    "dailyCycle": null
  },
  "unlockedScopes": ["general", "career"],
  "safetyRules": [
    "No absolute prediction",
    "No medical/legal/financial deterministic advice",
    "Explain evidence"
  ]
}
```

---

# 11. Luận giải không nên để AI làm hết

Cấu trúc tốt nhất:

```text
Rule Engine
→ Sinh ra facts
→ Scoring Engine
→ Sinh ra điểm/cảnh báo
→ Template Engine
→ Sinh ra luận giải thô
→ AI Rewrite
→ Safety Filter
→ UI Render
```

Ví dụ `facts`:

```json
{
  "career": {
    "score": 72,
    "mainFactors": [
      "Quan Lộc có sao A",
      "Đại vận kích hoạt cung B",
      "Tiểu vận năm 2026 liên quan Thiên Di"
    ],
    "warnings": ["Dễ áp lực khi hợp tác", "Không nên nóng vội khi ký kết"]
  }
}
```

AI chỉ viết lại:

```text
Năm 2026 công việc của bạn có xu hướng mở rộng nhờ...
```

Không để AI tự tính.

---

# 12. SRS — Functional requirements

## FR-01: Lập lá số

- User nhập thông tin sinh.
- App chuyển đổi lịch nếu cần.
- App tạo chart JSON.
- App lưu chart local.
- App hiển thị bàn lá số 12 cung.
- App cho phép đổi năm xem.

## FR-02: Quản lý nhiều lá số

- User tạo nhiều profile.
- User đặt một profile là lá số chính.
- User sửa/xóa profile.
- User xem lịch sử lá số đã tạo.

## FR-03: Xem ngày tốt xấu

- User xem lịch tháng.
- App hiển thị ngày âm.
- App đánh dấu ngày tốt/xấu.
- App hiển thị giờ hoàng đạo/hắc đạo.
- App gợi ý việc nên làm/nên tránh.

## FR-04: Luận giải tổng quan

- App hiển thị miễn phí một đoạn tổng quan.
- Nội dung cao cấp bị khóa.
- User mở khóa bằng xu, full purchase hoặc subscription.

## FR-05: Luận cung

- App hiển thị 12 cung.
- Mỗi cung có điểm, mô tả ngắn, giá xu.
- User mở khóa từng cung.
- App lưu quyền mở khóa.

## FR-06: Đại vận/Tiểu vận/Nguyệt vận/Nhật vận

- App hiển thị biểu đồ.
- App hiển thị danh sách vận.
- User mở khóa từng mục.
- AI giải thích biểu đồ.

## FR-07: AI Assistant

- User hỏi câu hỏi.
- Backend nhận chartContext.
- AI trả lời theo JSON schema.
- UI render answer/evidence/suggestion.
- Có giới hạn số câu hỏi theo gói.

## FR-08: Ví xu

- User xem số xu.
- User nạp xu.
- User chi xu.
- App lưu lịch sử.
- Server chống double-spend.

## FR-09: In-app purchase

- App hiển thị sản phẩm.
- App thực hiện purchase.
- Backend verify.
- App cấp entitlement.
- App restore purchase.

## FR-10: Kiến thức

- User xem feed bài viết.
- User đọc bài chi tiết.
- User mở mục lục.
- User tìm kiếm.
- User lưu bài.

---

# 13. Non-functional requirements

## Performance

- App mở màn chính dưới 2 giây trên iPhone/Android tầm trung.
- Lá số cache sau lần tính đầu.
- Bảng lá số zoom mượt.
- Feed bài viết lazy load.
- AI trả lời streaming nếu có thể.
- Không block UI khi tính chart.

## Privacy

- Dữ liệu ngày giờ sinh lưu local mặc định.
- Chỉ sync khi người dùng đăng nhập.
- Có nút xóa tài khoản và xóa dữ liệu.
- Token lưu secure storage.
- Không gửi toàn bộ dữ liệu nhạy cảm lên AI nếu không cần.

## Security

- Payment verify server-side.
- Không tin entitlement từ client.
- Coin ledger ghi dạng append-only.
- API có rate limit.
- AI endpoint có quota.

## Compliance

- Không copy brand/icon/UI y hệt app mẫu.
- Không dùng ảnh/sách có bản quyền khi chưa có quyền.
- Có privacy policy.
- Có terms of use.
- Có disclaimer tử vi tham khảo.
- Có nút restore purchase.

Google Play cấm impersonation và cảnh báo về việc copy/lừa người dùng/sở hữu trí tuệ, nên app nên có brand, icon, nội dung và UI riêng. ([play.google][15])

---

# 14. Monetization strategy

## Free

- Tạo 1–2 lá số.
- Xem bàn lá số.
- Xem tổng quan ngắn.
- Xem ngày tốt xấu cơ bản.
- Đọc một số bài kiến thức.
- Hỏi AI giới hạn 3 câu/ngày.

## Coin

- Mở từng cung.
- Mở từng đại vận.
- Mở từng tiểu vận.
- Mở từng nguyệt vận.
- Hỏi AI chuyên sâu.
- Xuất PDF.

## One-time purchase

- Mở trọn bộ lá số: 229.000đ hoặc test nhiều mức giá.
- PDF cao cấp.
- So sánh hai lá số.

## Subscription

Gợi ý:

- Tuần: 69.000đ.
- Tháng: 199.000đ hoặc 249.000đ.
- Năm: 999.000đ–1.499.000đ.

Quyền lợi:

- AI nhiều câu hơn.
- Xem ngày cá nhân hóa.
- Nhật vận không giới hạn.
- Lưu nhiều lá số.
- Đọc bài premium.
- Giảm giá mở full lá số.

---

# 15. Roadmap build app Flutter

## Phase 0 — Chuẩn bị

Thời gian: 3–5 ngày.

Checklist:

- Chốt tên app.
- Chốt logo.
- Chốt màu.
- Chốt module MVP.
- Tạo Figma hoặc wireframe.
- Tạo Flutter project.
- Setup GetX architecture.
- Setup Firebase project.
- Setup GitHub repo.

---

## Phase 1 — UI Prototype

Thời gian: 7–10 ngày.

Build trước giao diện với mock data:

- Welcome screen.
- Login screen.
- Create chart screen.
- Main bottom navigation.
- Lá số list.
- Xem ngày.
- Kiến thức feed.
- Tài khoản.
- Kết quả lá số.
- Luận cung.
- Đại vận.
- Tiểu vận.
- Nguyệt vận.
- Nhật vận.
- Chuyên đề.
- AI assistant UI.
- Paywall.

Mục tiêu: app demo nhìn đẹp, mượt, giống sản phẩm thật.

---

## Phase 2 — Local data + engine MVP

Thời gian: 10–14 ngày.

Checklist:

- Tích hợp local database.
- Tạo model BirthProfile.
- Tạo ChartCache.
- Tích hợp `dart_iztro` hoặc engine thử nghiệm.
- Tính được 12 cung.
- Tính được đại vận/năm/tháng/ngày cơ bản.
- Cache chart.
- Viết unit test cho engine.
- So sánh output với ít nhất 20 lá số mẫu.

---

## Phase 3 — Result screen thật

Thời gian: 10–14 ngày.

Checklist:

- Render bàn lá số 12 cung.
- Zoom/pinch.
- Chạm cung để xem chi tiết.
- Render radar chart.
- Render biểu đồ đại vận.
- Render biểu đồ tiểu vận.
- Render lịch nguyệt vận.
- Render nhật vận.
- Render giải thích từ template.

---

## Phase 4 — Backend + Auth + Sync

Thời gian: 7–10 ngày.

Checklist:

- Firebase Auth.
- API user.
- API profile sync.
- API entitlement.
- API coin ledger.
- Cloud sync optional.
- Guest → registered migration.
- Xóa tài khoản.
- Crashlytics/Analytics.

---

## Phase 5 — AI thật

Thời gian: 10–14 ngày.

Checklist:

- Backend AI endpoint.
- Prompt system/developer.
- JSON schema response.
- Safety filter.
- Chart context builder.
- Streaming response nếu có.
- Gợi ý câu hỏi.
- AI trong từng tab.
- Quota theo user/gói.
- Log chất lượng câu trả lời.

---

## Phase 6 — Payment

Thời gian: 10–14 ngày.

Checklist:

- Tạo sản phẩm App Store Connect.
- Tạo sản phẩm Google Play Console.
- Tích hợp RevenueCat hoặc `in_app_purchase`.
- Verify purchase server-side.
- Cấp xu.
- Cấp entitlement.
- Restore purchase.
- Test sandbox iOS.
- Test license tester Android.
- Test pending/refund/cancel subscription.

---

## Phase 7 — Content CMS

Thời gian: 7–10 ngày.

Checklist:

- Admin tạo bài viết.
- Upload ảnh.
- Category/tag.
- Feed bài viết.
- Article detail.
- Mục lục.
- Related articles.
- Push bài mới.

---

## Phase 8 — Polish + Release

Thời gian: 10–14 ngày.

Checklist:

- Optimize performance.
- Test iPhone nhỏ/lớn.
- Test Android thấp.
- Fix crash.
- Add privacy policy.
- Add terms.
- Add disclaimer.
- Add App Store screenshots.
- Add Google Play listing.
- TestFlight.
- Internal testing Google Play.
- Release MVP.

---

# 16. Checklist build chi tiết theo thư mục Flutter

```text
lib/
 ├── app/
 │   ├── routes/
 │   ├── bindings/
 │   ├── modules/
 │   │   ├── onboarding/
 │   │   ├── auth/
 │   │   ├── main/
 │   │   ├── chart_list/
 │   │   ├── create_chart/
 │   │   ├── chart_result/
 │   │   ├── palace_reading/
 │   │   ├── major_fortune/
 │   │   ├── minor_fortune/
 │   │   ├── monthly_fortune/
 │   │   ├── daily_fortune/
 │   │   ├── good_bad_day/
 │   │   ├── ai_assistant/
 │   │   ├── knowledge/
 │   │   ├── wallet/
 │   │   ├── purchase/
 │   │   └── account/
 │   ├── data/
 │   │   ├── models/
 │   │   ├── local/
 │   │   ├── remote/
 │   │   └── repositories/
 │   ├── engine/
 │   │   ├── calendar/
 │   │   ├── can_chi/
 │   │   ├── ziwei/
 │   │   ├── scoring/
 │   │   └── reading/
 │   ├── core/
 │   │   ├── theme/
 │   │   ├── constants/
 │   │   ├── widgets/
 │   │   ├── utils/
 │   │   └── services/
 │   └── main_app.dart
 └── main.dart
```

---

# 17. MVP nên làm trước

Bản đầu tiên không nên ôm hết. MVP tốt nhất là:

## MVP 1

- Welcome.
- Login optional.
- Tạo lá số.
- Danh sách lá số.
- Bàn lá số.
- Tổng quan miễn phí.
- Luận 12 cung dạng khóa/mở.
- Xem ngày tốt xấu.
- AI assistant mock hoặc AI thật giới hạn.
- Paywall UI.
- Local-first.

## MVP 2

- Engine hoàn thiện hơn.
- Đại vận.
- Tiểu vận.
- Nguyệt vận.
- Nhật vận.
- Coin wallet.
- IAP thật.
- AI thật.

## MVP 3

- So sánh hai lá số.
- Nhật ký vận trình.
- PDF cao cấp.
- Push notification cá nhân hóa.
- Content CMS.
- Subscription.

---

# 18. Tính năng đột phá nên thêm để hơn app mẫu

## 1. Life Map

Timeline cuộc đời từ 0–100 tuổi:

- Giai đoạn mạnh về học tập.
- Giai đoạn mạnh về công việc.
- Giai đoạn mạnh về tài chính.
- Giai đoạn cần cẩn trọng.
- Giai đoạn tình cảm nổi bật.

## 2. Nhật ký vận trình

Người dùng ghi lại mỗi ngày:

- Tâm trạng.
- Công việc.
- Tình cảm.
- Tài chính.
- Sự kiện nổi bật.
- Dự báo hôm nay đúng không.

Sau 30 ngày, app tạo insight:

```text
Trong 30 ngày qua, dự báo về cảm xúc của bạn có xu hướng khớp 68%.
Những ngày hành Mộc/Hỏa bạn thường ghi nhận năng lượng tốt hơn.
```

## 3. AI giải thích “vì sao”

Không chỉ nói kết quả, mà nói:

```text
Kết luận này dựa trên:
- Cung Quan Lộc có nhóm sao...
- Đại vận hiện tại đi vào...
- Tiểu vận năm nay kích hoạt...
```

## 4. So sánh hai lá số

Rất dễ viral:

- Hợp yêu đương.
- Hợp kết hôn.
- Hợp làm ăn.
- Điểm dễ xung đột.
- Cách dung hòa.

## 5. Chọn ngày theo mục tiêu cá nhân

Không chỉ “ngày tốt chung”, mà:

- Ngày tốt cho công việc của bạn.
- Ngày tốt cho gặp đối tác.
- Ngày tốt cho học tập.
- Ngày nên nghỉ ngơi.
- Ngày nên tránh tranh luận.

---

# 19. Kế hoạch làm ngay từ hôm nay

Thứ tự mình khuyên bạn làm:

1. **Chốt tên app + màu + logo**
   Không dùng Altuvi, không dùng icon quá giống.

2. **Build UI trước với mock data**
   Đây là cách nhanh nhất để thấy sản phẩm.

3. **Tích hợp local engine**
   Trước mắt dùng `dart_iztro` để tăng tốc, sau đó fork/tự viết lại engine nội bộ.

4. **Làm local-first database**
   Người dùng nhập xong xem ngay, không cần mạng.

5. **Thêm AI sau khi chart JSON ổn định**
   AI phải nhận dữ liệu có cấu trúc.

6. **Payment làm sau khi nội dung đủ giá trị**
   Đừng gắn thanh toán quá sớm khi luận giải chưa hay.

7. **Test App Store/Google Play từ sớm**
   Tử vi/fortune telling là nhóm dễ bị soi nếu app quá giống app khác hoặc hứa hẹn quá mức.

---

# 20. Checklist tổng cuối cùng

## Product

- [ ] Tên app.
- [ ] Logo.
- [ ] Theme.
- [ ] Slogan.
- [ ] USP.
- [ ] Pricing.
- [ ] Disclaimer.

## Flutter

- [ ] Project structure.
- [ ] GetX routing.
- [ ] Theme.
- [ ] Common widgets.
- [ ] Bottom nav.
- [ ] Onboarding.
- [ ] Create chart.
- [ ] Chart result.
- [ ] Calendar.
- [ ] AI UI.
- [ ] Paywall.

## Engine

- [ ] Solar/lunar conversion.
- [ ] Can chi.
- [ ] Tiết khí.
- [ ] 12 cung.
- [ ] An sao.
- [ ] Đại vận.
- [ ] Tiểu vận.
- [ ] Nguyệt vận.
- [ ] Nhật vận.
- [ ] Test cases.

## AI

- [ ] Prompt system.
- [ ] Prompt developer.
- [ ] JSON schema.
- [ ] Chart context builder.
- [ ] Safety filter.
- [ ] AI quota.
- [ ] AI logs.
- [ ] Feedback like/dislike/comment.

## Backend

- [ ] Auth.
- [ ] User.
- [ ] Profiles.
- [ ] Entitlement.
- [ ] Wallet.
- [ ] Purchase verification.
- [ ] AI endpoint.
- [ ] CMS.
- [ ] Push notification.

## Payment

- [ ] Product IDs.
- [ ] Coin packs.
- [ ] Full chart purchase.
- [ ] Subscription.
- [ ] Restore purchase.
- [ ] Server validation.
- [ ] Refund/cancel handling.

## Release

- [ ] Privacy policy.
- [ ] Terms.
- [ ] App Store screenshots.
- [ ] Google Play screenshots.
- [ ] TestFlight.
- [ ] Internal test Android.
- [ ] Crashlytics.
- [ ] Analytics.
- [ ] Performance test.

---

Chốt lại: hướng đúng nhất cho app này là **Flutter local-first + engine tử vi nội bộ + AI luận giải dựa trên JSON + ví xu/IAP + content kiến thức + nhật ký vận trình**. Bản MVP nên tập trung vào trải nghiệm “nhập ngày sinh → ra lá số đẹp → đọc luận dễ hiểu → hỏi AI → mở khóa nội dung sâu”.

[1]: https://developer.apple.com/app-store/review/guidelines/ "App Review Guidelines - Apple Developer"
[2]: https://github.com/EdwinXiang/dart_iztro "GitHub - EdwinXiang/dart_iztro: ⭐A lightweight open-source dart library for obtaining The Purple Star Astrology (Zi Wei Dou Shu) astrolabe information.. 支持多语言轻量级获取紫微斗数排盘信息的flutter开源库。 · GitHub"
[3]: https://github.com/SylarLong/iztro/blob/master/README-en_US.md "iztro/README-en_US.md at main · SylarLong/iztro · GitHub"
[4]: https://github.com/doanguyen/lasotuvi "GitHub - doanguyen/lasotuvi: Phần mềm an sao tử vi mã nguồn mở · GitHub"
[5]: https://www.hko.gov.hk/en/gts/time/conversion.htm "Gregorian-Lunar Calendar Conversion Table｜Hong Kong Observatory(HKO)｜Calendar"
[6]: https://www.hko.gov.hk/en/gts/time/24solarterms.htm "The 24 Solar Terms｜Hong Kong Observatory(HKO)｜Calendar"
[7]: https://pub.dev/packages/objectbox "objectbox | Dart package"
[8]: https://pub.dev/packages/flutter_secure_storage "flutter_secure_storage | Flutter package"
[9]: https://firebase.google.com/docs/flutter "Welcome to Firebase for Flutter!  |  Firebase Documentation"
[10]: https://docs.flutter.dev/perf/best-practices "Performance best practices"
[11]: https://platform.openai.com/docs/api-reference/evals?adobe_mc=MCORGID%3DA8833BC75245AF9E0A490D4D%2540AdobeOrg%7CTS%3D1769472000 "Evals | OpenAI API Reference"
[12]: https://developer.android.com/google/play/billing/integrate "Integrate the Google Play Billing Library into your app  |  Android Developers"
[13]: https://github.com/flutter/packages/blob/main/packages/in_app_purchase/in_app_purchase/README.md "packages/packages/in_app_purchase/in_app_purchase/README.md at main · flutter/packages · GitHub"
[14]: https://github.com/RevenueCat/purchases-flutter "GitHub - RevenueCat/purchases-flutter: Flutter plugin for in-app purchases and subscriptions. Supports iOS, macOS and Android. · GitHub"
[15]: https://play.google/developer-content-policy/ "Developer Policy Center"
