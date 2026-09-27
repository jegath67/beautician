# Typography

## Goal
Typography must be consistent across the application.

## Theme
Define the application's text hierarchy through `ThemeData.textTheme`.

Common roles:
- Display
- Headline
- Title
- Body
- Label

## Usage

Prefer:

```dart
Theme.of(context).textTheme.titleLarge
```

instead of repeatedly defining:

```dart
TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
)
```

## Rules
- Do not randomly change font sizes between similar screens.
- Use semantic text roles.
- Override only the property that genuinely needs changing.
- Keep typography readable on mobile and desktop.
