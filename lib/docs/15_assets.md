# Asset Management

## Structure

```text
assets/
├── images/
├── icons/
└── fonts/
```

Use meaningful filenames.

## Rules
- Do not duplicate the same asset under multiple names.
- Centralize asset paths in `AppAssets` when the same assets are referenced repeatedly.
- Optimize large images for web.
- Provide appropriate image loading/error states.
- Do not use remote image URLs as hidden hardcoded dependencies without documenting them.

## Example

```dart
Image.asset(AppAssets.logo)
```

## Icons
Prefer a consistent icon family. Avoid mixing unrelated icon styles without a design reason.
