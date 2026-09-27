# Colors and Theme

## Core Rule

Separate static brand colors from theme-dependent colors.

## AppColors
Use `AppColors` for static brand colors only.

Example:

```dart
class AppColors {
  AppColors._();

  static const primary = Color(0xFF...);
  static const accent = Color(0xFF...);
}
```

Do not store theme-dependent text/background colors as permanent black/white constants.

## Theme-Dependent Colors

Prefer:

```dart
Theme.of(context).colorScheme.primary
Theme.of(context).colorScheme.surface
Theme.of(context).colorScheme.onSurface
Theme.of(context).colorScheme.outline
Theme.of(context).colorScheme.error
```

## Text
Prefer:

```dart
Theme.of(context).textTheme.titleLarge
Theme.of(context).textTheme.bodyMedium
Theme.of(context).textTheme.labelLarge
```

## Avoid

```dart
Colors.black
Colors.white
Color(0xFF000000)
```

when the value is intended to adapt to Light/Dark mode.

## Theme Structure

```text
light_theme.dart
dark_theme.dart
app_theme.dart
```

`AppTheme` should expose the application's theme configuration without scattering ThemeData creation throughout screens.

## Dark Mode
Dark mode must not be implemented by manually checking brightness in every widget.

Avoid:

```dart
if (isDark) {
  ...
}
```

for ordinary color selection.

Use semantic `ColorScheme` and `TextTheme`.

## ThemeMode

The application should support:

```dart
ThemeMode.light
ThemeMode.dark
ThemeMode.system
```

The selected mode should be controlled centrally.
