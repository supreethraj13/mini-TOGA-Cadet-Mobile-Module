# TOGA Mobile App

Production-minded Flutter cadet module for AIRMAN TOGA: auth, dashboard, study management, offline notes with Hive persistence, logbook metrics, notifications, theme switching, shimmer loading, and mock FastAPI readiness.

## Tech Stack

- Flutter + Dart
- BLoC/Cubit via `flutter_bloc`
- Hive / Hive Flutter for local persistence
- Feature-first clean directory structure
- FastAPI mock backend in `backend/`

## Run

```bash
flutter pub get
flutter run
```

## Test

```bash
flutter test
```

## Backend Mock

```bash
pip install -r backend/requirements.txt
uvicorn backend.main:app --reload --port 8000
```

Use `POST /auth/login`, then pass `Authorization: Bearer mock.jwt.cadet-arjun-menon`.

## Structure

`lib/core` contains theme, error handling, mock data, and storage. `lib/features/*` owns feature models, data repositories/services, Cubits, and screens. `lib/shared` contains reusable aviation UI components.

## Mock Data

Mock cadet data comes from the assessment PDF: Arjun Menon, PPL, AIRMAN Flight Academy, Capt. R. Sharma, Chennai, study subjects, logbook summary, and TOGA notifications.

## Local Storage

Hive persists mock session, study notes, notification read state, and chapter completion overrides.

## API Readiness

Repositories are endpoint-shaped and can swap mock services for real REST clients. Docs in `docs/api-readiness.md` describe JWT, refresh tokens, error display, offline note sync, and Skynet sync.

## Improvements

Add Dio interceptors, secure token storage, typed Hive adapters, background sync, richer widget tests, CI, and generated screenshots/APK.
# mini-TOGA-Cadet-Mobile-Module
