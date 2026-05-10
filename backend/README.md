# Minh Mệnh AI Backend

Go backend foundation for the store-ready MVP.

## Stack

- `chi` HTTP router
- `pgx` / Postgres
- `go-redis` / Redis
- Cloud Run deployment target
- OpenAI Responses API for structured AI output
- Firebase token verification boundary
- Native IAP verification boundary for Apple and Google

## Environment

- `APP_ENV`
- `PORT`
- `DATABASE_URL`
- `REDIS_ADDR`
- `REDIS_PASSWORD`
- `OPENAI_API_KEY`
- `OPENAI_API_KEY_FILE`
- `OPENAI_MODEL`
- `FIREBASE_PROJECT_ID`
- `AUTH_ALLOW_DEBUG_BYPASS`
- `APPLE_BUNDLE_ID`
- `APPLE_ENVIRONMENT`
- `APPLE_ISSUER_ID`
- `APPLE_KEY_ID`
- `APPLE_PRIVATE_KEY_P8`
- `APPLE_PRIVATE_KEY_P8_FILE`
- `GOOGLE_PACKAGE_NAME`
- `GOOGLE_SERVICE_ACCOUNT_JSON`
- `GOOGLE_SERVICE_ACCOUNT_JSON_FILE`
- `IAP_PRODUCT_CATALOG_JSON`

The API loads `.env` from the current directory and `backend/.env` without overriding shell variables. Keep `AUTH_ALLOW_DEBUG_BYPASS=false` in production.

## Notes

- `GET /v1/products` exposes the configured store catalog.
- `/v1/iap/apple/verify` and `/v1/iap/google/verify` require Firebase bearer auth.
- Store webhooks remain public ingress endpoints and should be protected with platform signature validation before production traffic.
