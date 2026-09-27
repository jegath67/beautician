# Reusable Widgets

## Goal
Create reusable components for repeated UI patterns.

## Recommended Shared Widgets

```text
AppButton
AppTextField
AppCard
AppDialog
AppLoader
AppEmptyState
AppSectionHeader
AppDropdown
```

## When to Create a Reusable Widget
Create one when:
- The pattern appears in multiple places.
- The component has meaningful behavior.
- Centralizing it improves consistency.
- Its API can remain reasonably simple.

## When Not to Create One
Do not create a widget only to wrap one line of UI unless it has a clear semantic or future reuse purpose.

## API Rules
Reusable widgets should:
- Accept only necessary parameters.
- Avoid feature-specific business logic.
- Support theme values.
- Support responsive constraints where needed.
- Have sensible defaults.

## Example

```dart
AppButton(
  text: 'Book Now',
  onPressed: onBook,
)
```

The shared button owns visual styling; the feature owns the action.

## Do Not
- Put API calls inside generic UI widgets.
- Put Admin business logic inside `AppButton`.
- Duplicate nearly identical buttons.
