# Implementation Plan

## Phase 1 — Foundation
1. Confirm current Flutter project builds.
2. Create `core` structure.
3. Create constants.
4. Create Light/Dark themes.
5. Configure ThemeMode.
6. Create responsive utilities.
7. Establish reusable widget conventions.

## Phase 2 — Application Structure
1. Create Auth area.
2. Separate User and Admin feature areas.
3. Establish navigation.
4. Add role-aware route protection.

## Phase 3 — UI Development
For each screen:
1. Review design.
2. Identify reusable components.
3. Use existing design tokens.
4. Implement responsive layout.
5. Implement Light/Dark behavior.
6. Handle loading/empty/error states.
7. Test multiple viewport sizes.

## Phase 4 — Quality
Run:

```bash
flutter analyze
flutter test
flutter build web
```

Fix issues before moving to the next major feature.

## Change Policy
Before modifying existing code:
- Inspect the current implementation.
- Reuse existing architecture when reasonable.
- Do not delete working business logic without a requirement.
- Do not replace packages or architecture casually.
- Keep each change focused.

## Definition of Done

A feature is considered complete when:
- UI works on supported viewport sizes.
- Light/Dark theme works.
- Shared components are reused.
- No unnecessary hardcoded design values exist.
- Analyzer passes.
- Relevant tests pass.
- No unrelated code was changed.
