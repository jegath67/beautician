# Responsive Design

## Goal
The website must work across:
- Mobile
- Large mobile
- Tablet
- Large tablet
- Laptop
- Desktop
- Large desktop

## Breakpoint Strategy

Use a small number of meaningful breakpoints instead of many arbitrary values.

Suggested starting points:

```text
< 600   Mobile
600-899 Tablet
900-1199 Small desktop / laptop
1200-1439 Desktop
>= 1440 Large desktop
```

These values can be adjusted based on the actual UI.

## Rules
- Responsive behavior should be layout-driven, not device-name-driven.
- Avoid hardcoding one layout for a specific phone model.
- Prefer constraints, Flexible, Expanded, Wrap, GridView and LayoutBuilder where appropriate.
- Tables should have a deliberate mobile strategy.
- Navigation should adapt to available width.

## Testing
Every major screen must be tested at multiple widths, not only one desktop and one mobile size.
