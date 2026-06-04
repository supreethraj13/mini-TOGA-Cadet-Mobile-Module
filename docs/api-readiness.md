# API Readiness

The Flutter app currently uses mock async services with endpoint-shaped repositories. A real FastAPI integration can replace service internals with Dio/http calls without changing presentation widgets.

JWT auth is represented by a mock token stored in Hive. In production this should move to secure storage, attach `Authorization: Bearer <token>` through an interceptor, and refresh tokens before expiry.

API errors should map to `AppError` codes and Cubit failure states. The UI already renders retry affordances, snackbars, disabled buttons, and empty states.

Offline notes are saved locally first, then pushed through a simulated sync queue. A real Skynet sync worker would drain pending/failed notes, preserve local drafts on failure, and reconcile server IDs.

The included `backend/` folder implements the requested FastAPI routes with mock cadet data and role checking.
