# State Management

## Goal
Keep UI state, application state and business logic clearly separated.

## Rules
- Local UI state can remain local when it does not affect other features.
- Shared/application state should use the project's selected state-management solution.
- Business logic must not be duplicated between screens.
- Repositories handle data access.
- Controllers/ViewModels/Providers coordinate state and business operations.

## Avoid
- Global mutable variables for application state.
- Calling APIs directly from widgets.
- Duplicating the same state logic in Admin and User screens.

## Loading States
Every asynchronous feature should consider:
- Initial
- Loading
- Loaded
- Empty
- Error
