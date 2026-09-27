# Design System

## Goal
All Admin and User screens must follow one consistent visual language.

## Design Tokens
Centralize:
- Brand colors
- Semantic colors
- Spacing
- Sizes
- Border radius
- Typography
- Breakpoints
- Elevation/shadows where appropriate

## Rules
- Never introduce random spacing values repeatedly.
- Never create a new color for one widget without a design reason.
- Reuse existing components before creating new ones.
- Keep visual hierarchy consistent.
- Prefer semantic theme colors over raw color values.

## Component Hierarchy

```text
Design Tokens
    ↓
Theme
    ↓
Reusable Components
    ↓
Feature Screens
```

## Consistency
Admin and User may have different layouts, but common controls should look and behave consistently unless a documented product requirement says otherwise.
