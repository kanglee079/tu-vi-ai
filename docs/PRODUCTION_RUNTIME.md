# Production Runtime Checklist

## What was automated

The following are **already wired** in this repo and do not require code changes:

- `backend/internal/platform/user_service.go` — User CRUD via PostgreSQL
- `backend/internal/platform/profile_service.go` — Profile CRUD via PostgreSQL
- `backend/internal/platform/wallet_service.go` — Wallet balance + ledger via PostgreSQL
- `backend/internal/platform/article_service.go` — Article listing via PostgreSQL
- `backend/internal/platform/idempotency_service.go` — Idempotency keys via PostgreSQL
- `backend/internal/platform/iap_purchase_service.go` — Purchase recording + coin grant
- `backend/cmd/api/main.go` — Real services auto-wired when `DATABASE_URL` is set; falls back to stubs otherwise
- `lib/core/services/iap_verification_service.dart` — Fixed to send `receiptPayload` (Apple) / `purchaseToken` (Google) with `transactionId`
- `lib/main.dart` — Debug mode (`_kUseDebugDependencies`) bypasses Firebase for local dev

---

## Still requires manual setup (credentials / store accounts)

### Firebase Auth

Project: `minh-menh-ai-prod`

Enable these providers in [Firebase Console](https://console.firebase.google.com/project/minh-menh-ai-prod/authentication/providers):

- [ ] Anonymous
- [ ] Email/Password
- [ ] Google
- [ ] Apple (requires paid Apple Developer account)

> Note: The Identity Platform Admin API returned `BILLING_NOT_ENABLED`. Provider enablement via CLI requires `firebase login --reauth` with a project Owner. You can also enable providers manually in the Firebase Console — no code changes needed.

### Backend Env

Use `backend/.env.example` as the local template. For production, prefer secret files:

- `OPENAI_API_KEY_FILE`
- `APPLE_PRIVATE_KEY_P8_FILE`
- `GOOGLE_SERVICE_ACCOUNT_JSON_FILE`

Required production values:

| Variable | Value |
|---|---|
| `APP_ENV` | `production` |
| `AUTH_ALLOW_DEBUG_BYPASS` | `false` |
| `FIREBASE_PROJECT_ID` | `minh-menh-ai-prod` |
| `APPLE_BUNDLE_ID` | `ai.minhmenh.app` |
| `GOOGLE_PACKAGE_NAME` | `ai.minhmenh.app` |

### PostgreSQL Database

1. Create a PostgreSQL database (e.g., Supabase, Neon, Railway, or self-hosted)
2. Run migrations:

```sh
cd backend
psql $DATABASE_URL -f db/migrations/000001_init.up.sql
```

### Store Product Catalog

These product IDs are wired in the app and backend:

| Product ID | Type | Wallet Delta | Target Price |
|---|---|---:|---|
| `coin_100` | Consumable | 100 | VND 29,000 |
| `coin_300` | Consumable | 300 | VND 79,000 |
| `sub_month` | Subscription | 0 + entitlement `ai_monthly` | VND 199,000/month |

Create the same IDs in App Store Connect and Google Play Console. Then set:

| Variable | Where to get it |
|---|---|
| `APPLE_ISSUER_ID` | App Store Connect → Users and Access → Keys |
| `APPLE_KEY_ID` | App Store Connect → Users and Access → Keys |
| `APPLE_PRIVATE_KEY_P8_FILE` | Download `.p8` key file from App Store Connect |
| `GOOGLE_SERVICE_ACCOUNT_JSON_FILE` | Google Play Console → Setup → API Access |

---

## Local Run

### Backend

```sh
cd backend
go run ./cmd/api
```

With custom env:

```sh
cp backend/.env.example backend/.env
# fill in OPENAI_API_KEY at minimum
go run ./cmd/api
```

### Flutter App

Local (no Firebase):

```sh
# Debug mode bypasses Firebase — uses mock auth + local DB
flutter run -d 13
```

With backend:

```sh
flutter run -d 13 --dart-define=API_BASE_URL=http://127.0.0.1:8080/v1
```

Android emulator:

```sh
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080/v1
```

---

## Production Deployment Checklist

### Backend
- [ ] Set `APP_ENV=production`
- [ ] Set `AUTH_ALLOW_DEBUG_BYPASS=false`
- [ ] Configure `DATABASE_URL` (PostgreSQL with SSL)
- [ ] Configure `REDIS_ADDR` + `REDIS_PASSWORD` (optional, for caching)
- [ ] Configure `OPENAI_API_KEY`
- [ ] Configure Apple IAP credentials
- [ ] Configure Google service account JSON
- [ ] Run `db/migrations/000001_init.up.sql`
- [ ] Deploy to Cloud Run / Railway / Fly.io / etc.

### Flutter / iOS
- [ ] Set `_kUseDebugDependencies = false` in `lib/main.dart`
- [ ] Set real Firebase config in `lib/firebase_options.dart`
- [ ] Enable IAP capabilities in Xcode (In-App Purchase, Push Notifications)
- [ ] Create App Store Connect products (`coin_100`, `coin_300`, `sub_month`)
- [ ] Test sandbox purchase flow

### Flutter / Android
- [ ] Set `_kUseDebugDependencies = false` in `lib/main.dart`
- [ ] Set real Firebase config in `lib/firebase_options.dart`
- [ ] Create Google Play products (`coin_100`, `coin_300`, `sub_month`)
- [ ] Upload AAB to Google Play internal testing track

---

## Build Commands

```sh
# Backend
cd backend && go build ./cmd/api

# Flutter iOS
flutter build ios --simulator --no-codesign

# Flutter Android
flutter build apk --debug

# Run tests
cd backend && go test ./...
flutter test
flutter analyze
```
