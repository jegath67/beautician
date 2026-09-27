# Coding Guidelines

## General
- Prefer readable code over clever code.
- Keep widgets focused.
- Keep build methods reasonably small.
- Use `const` wherever Flutter allows it.
- Avoid unnecessary rebuilds.
- Remove unused imports and dead code.

## Constants
Use `const` for compile-time static values.

Do not misuse `const` for values that depend on runtime theme/context.

## UI
- No direct API calls from presentation widgets.
- No business logic hidden inside large UI callbacks.
- Avoid duplicated UI code.

## State
Use the project's chosen state-management approach consistently. Do not introduce multiple state-management libraries without a documented reason.

## Error Handling
Errors should be represented clearly in the UI:
- Loading
- Success
- Empty
- Error

## Refactoring
Do not perform broad refactors while implementing an unrelated feature unless required.
