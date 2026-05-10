# Production Runtime Checklist

## Firebase Auth

Project: `minh-menh-ai-prod`

Enable these providers in Firebase Console:

- Anonymous
- Email/Password
- Google
- Apple

The Firebase CLI account can see the project, but Firebase Auth provider initialization could not be completed from the CLI in this environment. The Identity Platform Admin API returned `BILLING_NOT_ENABLED`, so provider enablement still needs the Firebase Console or a billed Identity Platform setup.

## Backend Env

Use `backend/.env.example` as the local template. For production, prefer secret files:

- `OPENAI_API_KEY_FILE`
- `APPLE_PRIVATE_KEY_P8_FILE`
- `GOOGLE_SERVICE_ACCOUNT_JSON_FILE`

Required production values:

- `APP_ENV=production`
- `AUTH_ALLOW_DEBUG_BYPASS=false`
- `FIREBASE_PROJECT_ID=minh-menh-ai-prod`
- `APPLE_BUNDLE_ID=ai.minhmenh.app`
- `GOOGLE_PACKAGE_NAME=ai.minhmenh.app`

## Store Product Catalog

These product IDs are wired in the app and backend:

| Product ID | Type | Wallet Delta | Target Price |
| --- | --- | ---: | --- |
| `coin_100` | Consumable | 100 | VND 29,000 |
| `coin_300` | Consumable | 300 | VND 79,000 |
| `sub_month` | Subscription | 0 | VND 199,000/month |

Create the same IDs in App Store Connect and Google Play Console. After credentials are available, set:

- `APPLE_ISSUER_ID`
- `APPLE_KEY_ID`
- `APPLE_PRIVATE_KEY_P8_FILE`
- `GOOGLE_SERVICE_ACCOUNT_JSON_FILE`

## Local Run

From `backend/`:

```sh
go run ./cmd/api
```

From the Flutter app, pass the backend URL when needed:

```sh
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8080/v1
```

For Android emulator use:

```sh
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080/v1
```
