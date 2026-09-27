# Navigation

## Goal
Navigation should remain predictable as Admin and User features grow.

## Rules
- Keep route definitions centralized.
- Do not scatter raw route strings throughout widgets.
- Role-based routes should be protected centrally.
- Deep links should be considered for web.
- Browser back/forward behavior must remain functional.

## Route Areas

```text
/auth/*
/user/*
/admin/*
```

The exact routing package may be chosen according to the project's existing architecture.

## Access
Unauthenticated users should not access protected areas.

Admin routes must require appropriate authorization.
