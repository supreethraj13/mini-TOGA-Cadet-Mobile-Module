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

On this machine, `python` may resolve to MSYS2 Python. If `python -m venv .venv`
hangs during `ensurepip`, install a normal Windows CPython distribution or run the
backend without a venv using `python -m pip install -r backend/requirements.txt`
and `python -m uvicorn backend.main:app --reload --port 8000`.

Use `POST /auth/login`, then pass `Authorization: Bearer mock.jwt.cadet-arjun-menon`.

The Flutter app now calls the FastAPI server directly. Start the backend before logging in. For desktop/web runs the default base URL is `http://127.0.0.1:8000`. For Android emulator use:

```bash
flutter run --dart-define=TOGA_API_BASE_URL=http://10.0.2.2:8000
```

For a physical device, replace the host with your computer LAN IP.

## Structure

`lib/core` contains theme, error handling, mock data, and storage. `lib/features/*` owns feature models, data repositories/services, Cubits, and screens. `lib/shared` contains reusable aviation UI components.

## API Data

Cadet data comes from the FastAPI mock backend: Arjun Menon, PPL, AIRMAN Flight Academy, Capt. R. Sharma, Chennai, study subjects, logbook summary, and TOGA notifications. If the API is offline the Flutter app shows error states instead of falling back to local mock data.

## Local Storage

Hive persists mock session, study notes, notification read state, and chapter completion overrides.

## API Readiness

Repositories are endpoint-shaped and can swap mock services for real REST clients. Docs in `docs/api-readiness.md` describe JWT, refresh tokens, error display, offline note sync, and Skynet sync.

## Improvements

Add Dio interceptors, secure token storage, typed Hive adapters, background sync, richer widget tests, CI, and generated screenshots/APK.
# mini-TOGA-Cadet-Mobile-Module
# mini-TOGA-Cadet-Mobile-Module
