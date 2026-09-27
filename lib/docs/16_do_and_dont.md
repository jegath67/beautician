# Do and Don't

## Do

- Use the design system.
- Reuse shared widgets.
- Use semantic ThemeData colors.
- Support Light and Dark themes.
- Test responsive layouts.
- Keep Admin and User features separated.
- Keep business logic outside presentation widgets.
- Use meaningful names.
- Run analyzer/tests after significant changes.

## Don't

- Hardcode repeated colors.
- Hardcode repeated spacing.
- Create duplicate widgets.
- Put API calls directly in UI widgets.
- Create separate Light/Dark screens unnecessarily.
- Add packages without a real requirement.
- Perform unrelated refactors.
- Leave dead code and unused imports.
- Assume desktop-only layouts are responsive.

## Golden Rule

Before creating a new constant, widget, helper or abstraction, check whether an existing project component already solves the same problem.
