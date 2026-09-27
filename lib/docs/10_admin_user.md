# Admin and User Architecture

## Goal
Admin and User are separate product areas sharing the same design system.

## Structure

```text
features/
├── auth/
├── user/
└── admin/
```

## Shared
Both roles can use:
- Core widgets
- Theme
- Constants
- Responsive utilities
- Generic helpers
- Common authentication components where appropriate

## User
User-specific pages and business logic belong under:

```text
features/user/
```

## Admin
Admin-specific pages and business logic belong under:

```text
features/admin/
```

## Role Access
Role-based navigation/access should be handled centrally, not by hiding arbitrary widgets throughout the application.

## Security
UI visibility is not security. Actual authorization must be enforced by the backend when backend integration is added.
