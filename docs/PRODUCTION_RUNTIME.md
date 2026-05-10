# Production Runtime Checklist

## What was automated

The following are **already wired** in this repo and do not require code changes:

- `backend/internal/platform/user_service.go` — User CRUD via PostgreSQL
- `backend/internal/platform/profile_service.go` — Profile CRUD via PostgreSQL
- `backend/internal/platform/wallet_service.go` — Wallet balance + ledger via PostgreSQL
- `backend/internal/platform/article_service.go` — Article listing via PostgreSQL
- `backend/internal/platform/idempotency_service.go` — Idempotency keys via PostgreSQL
- `backend/internal/platform/iap_purchase_service.go` — Purchase recording + coin grant
- `backend/cmd/api/main.go` — Real services auto-wired when `DATABASE_URL` is set and `FORCE_STUB_SERVICES=false`; falls back to stubs otherwise
- `lib/core/services/iap_verification_service.dart` — Fixed to send `receiptPayload` (Apple) / `purchaseToken` (Google) with `transactionId`
- `lib/main.dart` — Debug mode bypasses Firebase for local dev (uses mock auth + local DB)
- Firebase config (`lib/firebase_options.dart`, `ios/Runner/GoogleService-Info.plist`, `android/app/google-services.json`) — Project `minh-menh-ai-prod` (#202213348151)
- Flutter iOS simulator build — verified working (`flutter build ios --simulator --no-codesign`)
- Flutter analyze — zero issues

---

## Still requires manual setup

### 1. Firebase Auth (Firebase Console — requires browser login)

Project: `minh-menh-ai-prod` (#202213348151)

**Steps:**
1. Open [Firebase Console](https://console.firebase.google.com/project/minh-menh-ai-prod/authentication/providers)
2. Login with the account that owns the project
3. Click "Get started" on the Authentication page
4. Enable these providers:

| Provider | Status |
|---|---|
| Anonymous | ☐ Enable — needed for guest usage |
| Email/Password | ☐ Enable |
| Google | ☐ Enable — needs OAuth consent screen |
| Apple | ☐ Enable (requires paid Apple Developer account) |

For Google Sign-In: you need an **OAuth 2.0 client ID** from Google Cloud Console. The OAuth consent screen must be configured (App name, scopes, test users for development).

### 2. PostgreSQL Database (Supabase)

**Current status:** Database is provisioned (Supabase project `ppdzcrieayhzotwagkjs`) but unreachable from this machine due to IPv6-only DNS. Migrations have NOT been run.

**To run migrations (when DB is reachable):**
```sh
psql "postgresql://postgres:<PASSWORD>@db.ppdzcrieayhzotwagkjs.supabase.co:5432/postgres?sslmode=require" \
  -f backend/db/migrations/000001_init.up.sql
```

**Alternative:** Run in Supabase Dashboard SQL Editor:
```sql
-- Paste contents of backend/db/migrations/000001_init.up.sql here
```

**On deployment server** (where DB is reachable), run:
```sh
cd backend
DATABASE_URL="postgresql://..." go run ./cmd/api
# Or with FORCE_STUB_SERVICES=false and DATABASE_URL set:
go run ./cmd/api
```

### 3. Backend Env for Production

Copy `backend/.env` and set:

| Variable | Value |
|---|---|
| `APP_ENV` | `production` |
| `AUTH_ALLOW_DEBUG_BYPASS` | `false` |
| `FIREBASE_PROJECT_ID` | `minh-menh-ai-prod` |
| `FORCE_STUB_SERVICES` | `false` (or unset) |
| `DATABASE_URL` | PostgreSQL connection string with SSL |
| `OPENAI_API_KEY` | Your OpenAI API key |

For secret files (preferred):
```
OPENAI_API_KEY_FILE=/run/secrets/openai_key
APPLE_PRIVATE_KEY_P8_FILE=/run/secrets/apple_key.p8
GOOGLE_SERVICE_ACCOUNT_JSON_FILE=/run/secrets/gcp_sa.json
```

### 4. App Store Connect Products (IAP — paused for now)

These product IDs are wired in the app and backend:

| Product ID | Type | Wallet Delta | Target Price |
|---|---|---:|---|
| `coin_100` | Consumable | 100 | VND 29,000 |
| `coin_300` | Consumable | 300 | VND 79,000 |
| `sub_month` | Subscription | 0 + entitlement `ai_monthly` | VND 199,000/month |

When ready, create these in App Store Connect and Google Play Console. Then set:
- `APPLE_ISSUER_ID`, `APPLE_KEY_ID`, `APPLE_PRIVATE_KEY_P8_FILE`
- `GOOGLE_SERVICE_ACCOUNT_JSON_FILE`

---

## Local Run

### Backend

```sh
cd backend
go run ./cmd/api
# Currently running: FORCE_STUB_SERVICES=true (DB unreachable)
# When DB is reachable, set FORCE_STUB_SERVICES=false or unset
```

Backend is currently running at `http://127.0.0.1:8080` with stub services.

### Flutter App

```sh
# iOS Simulator (no Firebase — mock auth)
flutter run -d 13 --dart-define=DEBUG_DEPENDENCIES=true

# iOS Simulator with backend (stub services)
flutter run -d 13 --dart-define=API_BASE_URL=http://127.0.0.1:8080/v1

# Android emulator
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080/v1
```

---

## Production Deployment Checklist

### Backend
- [ ] Set `APP_ENV=production`
- [ ] Set `AUTH_ALLOW_DEBUG_BYPASS=false`
- [ ] Set `FORCE_STUB_SERVICES=false` (or unset)
- [ ] Configure `DATABASE_URL` (PostgreSQL with SSL, reachable from deployment server)
- [ ] Run `backend/db/migrations/000001_init.up.sql`
- [ ] Configure `OPENAI_API_KEY`
- [ ] (IAP paused) Configure Apple IAP credentials
- [ ] (IAP paused) Configure Google service account JSON
- [ ] Deploy to Cloud Run / Railway / Fly.io / etc.

### Flutter / iOS
- [ ] Firebase Auth providers enabled (Anonymous, Email/Password, Google)
- [ ] Set `DEBUG_DEPENDENCIES=false` for production build
- [ ] Configure real Firebase in `lib/firebase_options.dart`
- [ ] Enable IAP capabilities in Xcode (In-App Purchase, Push Notifications)
- [ ] (IAP paused) Create App Store Connect products

### Flutter / Android
- [ ] Firebase Auth providers enabled
- [ ] Set `DEBUG_DEPENDENCIES=false` for production build
- [ ] Configure real Firebase in `lib/firebase_options.dart`
- [ ] (IAP paused) Create Google Play products

---

## Build Commands

```sh
# Backend
cd backend && go build ./cmd/api

# Flutter iOS Simulator
flutter build ios --simulator --no-codesign

# Flutter Android
flutter build apk --debug

# Run tests
cd backend && go test ./...
flutter test
flutter analyze
```

---

## Current Environment Status (May 10, 2026)

| Component | Status |
|---|---|
| Backend binary | Running at `http://127.0.0.1:8080` |
| Database | Supabase provisioned but unreachable (IPv6 DNS issue) |
| Database migrations | Not run — tables don't exist |
| Backend services | Stub mode (`FORCE_STUB_SERVICES=true`) |
| OpenAI API | Configured |
| Firebase project | `minh-menh-ai-prod` (#202213348151) |
| Firebase Auth providers | Not enabled (needs Console) |
| Flutter iOS build | Working (`flutter build ios --simulator --no-codesign`) |
| Flutter analyze | 0 issues |
