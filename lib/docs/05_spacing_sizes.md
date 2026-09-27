# Spacing, Padding and Sizes

## Purpose
Avoid random spacing values throughout the application.

## Recommended Spacing Scale

```text
4
8
12
16
20
24
32
40
48
64
```

Create semantic constants such as:

```dart
class AppSpacing {
  AppSpacing._();

  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
}
```

## Usage

Prefer:

```dart
padding: const EdgeInsets.all(AppSpacing.md)
```

instead of repeatedly writing:

```dart
padding: const EdgeInsets.all(16)
```

## Sizes
Use `AppSizes` for recurring fixed component dimensions:
- Icon sizes
- Button heights
- Input heights
- Avatar sizes
- Navigation dimensions

## Padding
Padding should communicate hierarchy.

Examples:
- Small internal spacing: `sm`
- Standard content spacing: `md`
- Section spacing: `lg` or `xl`

## Do Not
- Create dozens of nearly identical constants.
- Use a constant merely because it is possible.
- Force every measurement into a global constant if it is truly component-specific.
