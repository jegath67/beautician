# Folder Structure

## Target Structure

```text
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_spacing.dart
│   │   ├── app_sizes.dart
│   │   ├── app_radius.dart
│   │   ├── app_breakpoints.dart
│   │   ├── app_strings.dart
│   │   └── app_assets.dart
│   │
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── light_theme.dart
│   │   └── dark_theme.dart
│   │
│   ├── widgets/
│   │   ├── app_button.dart
│   │   ├── app_text_field.dart
│   │   ├── app_card.dart
│   │   ├── app_dialog.dart
│   │   ├── app_loader.dart
│   │   └── app_empty_state.dart
│   │
│   ├── responsive/
│   │   ├── responsive_builder.dart
│   │   └── responsive_layout.dart
│   │
│   └── utils/
│       ├── extensions/
│       └── helpers/
│
├── features/
│   ├── auth/
│   ├── user/
│   │   ├── home/
│   │   ├── services/
│   │   ├── bookings/
│   │   └── profile/
│   │
│   └── admin/
│       ├── dashboard/
│       ├── bookings/
│       ├── beauticians/
│       ├── services/
│       └── settings/
│
└── main.dart
```

## Folder Responsibilities

### `core/constants`
Static design and application constants.

### `core/theme`
Light and dark theme definitions.

### `core/widgets`
Only genuinely reusable UI components.

### `core/responsive`
Responsive layout utilities.

### `core/utils`
Small generic helpers and extensions.

### `features`
Business/domain features. Admin and User remain separated.

## Important
Do not create folders only because they look architecturally impressive. Create them when they have a clear responsibility.
