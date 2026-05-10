# Minh Mệnh AI — Tử Vi App

App tử vi thế hệ mới cho người Việt, kết hợp engine lá số local + AI luận giải cá nhân hóa + hệ thống ví xu/IAP.

## Tech Stack

| Layer | Technology |
|---|---|
| Mobile App | Flutter 3.41+ |
| State Management | GetX |
| Local Database | ObjectBox |
| Backend | Go 1.24 (chi/v5) |
| Database | PostgreSQL + Redis (optional) |
| AI | OpenAI Responses API (Structured Output) |
| Auth | Firebase Auth |
| Payments | Apple IAP + Google Play Billing |

## Project Structure

```
tu_vi_ai/
├── lib/                          # Flutter app
│   ├── app/                      # App routing, bindings, main widget
│   ├── core/
│   │   ├── config/              # Feature flags
│   │   ├── prompts/             # AI prompt policies
│   │   ├── services/            # API, Auth, IAP, Wallet services
│   │   ├── theme/               # App theme
│   │   └── utils/
│   ├── data/
│   │   ├── local/objectbox/     # ObjectBox entities + service
│   │   ├── mappers/
│   │   ├── mock/                # Mock implementations (debug mode)
│   │   ├── models/              # Data models
│   │   └── repositories/        # Repositories (local + remote)
│   ├── features/                # Feature modules
│   │   ├── account/
│   │   ├── ai/
│   │   ├── auth/
│   │   ├── chart/
│   │   ├── compatibility/
│   │   ├── fortune/
│   │   ├── insight/
│   │   ├── knowledge/
│   │   ├── main/
│   │   ├── onboarding/
│   │   ├── reading/
│   │   └── wallet/
│   └── shared/                  # Shared widgets + navigation
├── backend/                     # Go backend
│   ├── cmd/api/                 # Entry point
│   ├── internal/
│   │   ├── app/                 # App layer (interfaces + types)
│   │   ├── config/              # Config loading from .env
│   │   ├── http/                # HTTP router + handlers
│   │   └── platform/            # Platform services (DB, AI, IAP, Auth)
│   ├── db/migrations/           # PostgreSQL migrations
│   └── Dockerfile
├── assets/
├── docs/                        # PRD, production runtime docs
└── pubspec.yaml
```

## Getting Started

### Prerequisites

- Flutter 3.41+
- Go 1.24+
- Xcode 16+
- PostgreSQL (for backend)
- Firebase project (for auth + push)

### Setup

1. **Flutter dependencies**

```sh
flutter pub get
```

2. **Backend**

```sh
cd backend
cp .env.example .env
# Fill in OPENAI_API_KEY in .env
go run ./cmd/api
```

3. **Run the app**

```sh
# Uses mock auth + local DB (no Firebase needed for dev)
flutter run -d 13

# With backend API
flutter run -d 13 --dart-define=API_BASE_URL=http://127.0.0.1:8080/v1
```

### Debug Mode

Production mode auto-detected from `kDebugMode` + `--dart-define=DEBUG_DEPENDENCIES=true`. No code changes needed.

## Features

- **Lá số tử vi** — Engine `dart_iztro`, 12 cung, an sao, đại/tiểu/nguyệt/nhật vận
- **Bàn lá số circular astrolabe** — Interactive circular astrolabe with zoom/pan, palace cards, score badges
- **AI luận giải** — OpenAI Responses API with structured JSON output, chart context driven, fallback to mock
- **Knowledge Base thật** — 14 chính tinh, 20+ phụ tinh, 12 cung với full ngữ cảnh, 50+ combination rules
- **Tra cứu sao** — Searchable star encyclopedia by name/element/keywords
- **Chi tiết cung** — Palace detail page with knowledge base integration, related palaces navigation, star detail bottom sheet
- **Ví xu** — Coin wallet với ledger, spend/preview unlock
- **IAP** — Apple StoreKit + Google Play Billing, server-side verify với backend Go
- **Kiến thức** — CMS-backed article feed
- **Nhật ký vận trình** — Journal với sentiment tracking
- **Golden tests** — 11 test cases covering all 12 birth hours, lunar/solar calendar, leap years

## Build

```sh
# Flutter iOS
flutter build ios --simulator --no-codesign

# Flutter Android
flutter build apk --debug

# Backend
go build ./cmd/api

# Test
cd backend && go test ./...
flutter test
flutter analyze
```

## License

Private — All rights reserved.
