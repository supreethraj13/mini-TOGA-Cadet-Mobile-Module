# API Readiness

The Flutter app uses endpoint-shaped repositories and an `http` API client pointed at FastAPI. Services call the backend directly and surface Cubit failure states when the API is offline.

JWT auth is represented by a mock token stored in Hive. In production this should move to secure storage, attach `Authorization: Bearer <token>` through an interceptor, and refresh tokens before expiry.

API errors should map to `AppError` codes and Cubit failure states. The UI already renders retry affordances, snackbars, disabled buttons, and empty states.

Offline notes are saved locally first, then pushed through `POST /toga/study/notes`. Failed API calls leave the note local with a retryable failed state.

The included `backend/` folder implements the requested FastAPI routes with mock cadet data and role checking.

How TOGA would sync with Skynet:
TOGA serves as the cadet interface, while Skynet is the overarching fleet and operations management system.
1. Aircraft scheduling and maintenance status from Skynet would be fetched via FastAPI endpoints (e.g., `/skynet/aircraft/{id}/status`).
2. Flight log telemetry captured in TOGA would be pushed to FastAPI, which then translates and forwards it to Skynet's external webhooks.
3. Sync would be mostly asynchronous: TOGA queues logbook updates locally, FastAPI acknowledges them, and a background celery worker on the backend syncs the data to Skynet, returning eventual consistency to the app on subsequent polls.