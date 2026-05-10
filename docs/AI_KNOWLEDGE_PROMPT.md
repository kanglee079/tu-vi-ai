# Minh Mệnh AI - Controlled Knowledge & AI Prompt Contract

## Principle

Do not crawl, scan, or copy copyrighted tử vi books into the app. The production path is:

```text
Engine tính lá số
→ Precomputed chart facts
→ Internal/expert knowledge rules
→ AI rewrite with strict JSON schema
→ Safety-filtered UI
```

The AI is not a source of truth. It only rewrites structured facts and internal rules into clear Vietnamese.

## Knowledge Layers

1. **Engine**
   - Solar/lunar conversion
   - Can chi
   - Birth-hour branch
   - 12 palaces and stars
   - Major/minor/monthly/daily cycles
   - Good/bad day and auspicious hours

2. **Calendar Reference**
   - Public calendar/solar-term references for validation
   - Edge-case tests around lunar new year, leap months, and solar terms

3. **Internal Knowledge Base**
   - `StarMeaning`
   - `PalaceMeaning`
   - `CombinationRule`
   - `ReadingTemplate`
   - Attribution metadata: source type, copyright status, compiler, version, updated date

## Source Policy

Allowed:
- Internal rewrite
- Expert-authored content
- Licensed content with contract
- Public-domain references after verification
- Open-source references under compatible license

Not allowed:
- Verbatim copyrighted book passages
- Scraped paid ebooks
- Scraped competitor/app content
- AI-generated “truth” without expert/rule validation
- Hidden derivative text that is too close to a protected source

## Prompt Contract

The canonical runtime prompt lives in:

```text
lib/core/prompts/ai_prompt_policy.dart
```

It enforces:
- Vietnamese output
- No absolute future claims
- No medical/legal/financial deterministic advice
- No invented stars, palaces, cycles, dates, hours, or events
- Evidence for every important conclusion
- Lower confidence when birth time is uncertain
- JSON schema response only

## Current Prototype Status

The current app includes a small mock knowledge base in:

```text
lib/data/mock/prototype_knowledge_base.dart
```

This is prototype seed data only. Before release, each batch must be audited for copyright, reviewed by a qualified tử vi expert, and covered by golden chart/reading tests.
