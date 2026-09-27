# Beautician — Project Architecture

## Purpose
This document defines the architectural rules for the Flutter Beautician web application.

## Architecture Goals
- Keep Admin and User features separated.
- Keep shared UI and design-system code reusable.
- Keep business logic out of UI widgets.
- Make the project easy to extend when backend/API integration is added.
- Avoid unnecessary abstractions and duplicate implementations.

## High-Level Structure

```text
lib/
├── core/
│   ├── constants/
│   ├── theme/
│   ├── widgets/
│   ├── responsive/
│   └── utils/
│
├── features/
│   ├── auth/
│   ├── user/
│   └── admin/
│
└── main.dart
```

## Dependency Direction

```text
UI
 ↓
State / ViewModel / Controller
 ↓
Repository
 ↓
Data Source / API
```

Core must not depend on feature-specific code.

## Rules
- Do not put business logic inside large build methods.
- Do not create duplicate widgets for the same visual purpose.
- Do not import Admin code into User features or vice versa.
- Shared functionality belongs in `core`.
- Feature-specific functionality belongs inside its feature folder.
- Do not introduce a service/repository layer unless the feature actually needs it.

## Admin and User
Admin and User have separate feature areas but share:
- Theme
- Design tokens
- Reusable widgets
- Responsive utilities
- Common utilities
- Common assets where appropriate

## Future Backend
The UI must not directly depend on Firebase/REST/Dio implementation details. Backend integration should be isolated behind repositories/data sources.
