# Minh Mệnh AI

Flutter UI prototype for a local-first tử vi app with mock chart, reading, AI, good-day, wallet, and knowledge flows.

## Current Milestone

- Flutter UI prototype with GetX routing and mock repositories.
- Local-first chart/profile flow with no backend dependency.
- Controlled AI prompt contract and internal knowledge-base seed data.
- No copyrighted book crawling or copied long-form source text.

## Verification

```sh
flutter analyze
flutter test
```

## AI / Knowledge Policy

The app separates chart calculation from interpretation:

```text
engine facts -> internal knowledge rules -> AI rewrite -> UI
```

See `docs/AI_KNOWLEDGE_PROMPT.md` for the prompt and source policy.

## Prototype Coverage

- Onboarding, guest mode, auth placeholder
- Chart list, create/edit chart, chart result, 12-palace reading
- Major/minor/monthly/daily fortune
- Good/bad day
- AI assistant with controlled prompt/schema contract
- Knowledge feed and article detail
- Wallet/paywall
- Life Map
- Journal
- Compatibility
