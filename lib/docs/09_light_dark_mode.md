# Light and Dark Mode

## Objective
The entire application must support Light and Dark themes without duplicating UI code.

## Architecture

```text
ThemeMode
   ↓
AppTheme
   ├── LightTheme
   └── DarkTheme
```

## Use Theme Context

```dart
final theme = Theme.of(context);

theme.colorScheme.surface
theme.colorScheme.onSurface
theme.textTheme.bodyMedium
```

## Do Not
Do not create separate LightScreen and DarkScreen widgets for normal theme changes.

Do not write manual conditions for every text/icon color.

Avoid:

```dart
color: isDark ? Colors.white : Colors.black
```

Prefer semantic theme values.

## Exceptions
A component may need a specific conditional treatment only when the design genuinely requires different assets or behavior. Keep such cases local and documented.

## Testing
Verify:
- Text contrast
- Cards
- Inputs
- Buttons
- Dialogs
- Navigation
- Icons
- Tables
- Hover states
- Disabled states
in both themes.
