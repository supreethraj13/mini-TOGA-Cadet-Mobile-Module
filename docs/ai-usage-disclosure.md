# AI Usage Disclosure

AI tools were used to scaffold and review this assessment module, including Flutter architecture, Cubit flows, mock FastAPI routes, docs, and tests.

All generated code was reviewed for the stated constraints: BLoC/Cubit-only state, feature-first folders, aviation-specific data, Hive persistence, sync retry behavior, and business validation boundaries.

Rejected suggestion: using Provider or Riverpod. The user explicitly required BLoC/Cubit exclusively, so the app uses `flutter_bloc` only.

Personally designed areas: feature boundaries, repository/service seams, telemetry UI tone, and offline note sync behavior.

Least confident area: final platform build output, because Android/iOS build verification depends on local Flutter tooling and SDK availability.

Example screen: `DashboardScreen` requests dashboard data in `initState`, listens to `DashboardCubit`, renders shimmer while loading, error retry on failure, and aviation cards on success.

Example state flow: `NotesCubit.syncNote` optimistically marks a note `Syncing`, calls the repository, then replaces it with `Synced` or `Failed` without deleting the local note.

Example model: `StudySubject.fromJson` parses progress, lesson counts, quiz score, status, and chapters. Its constructor validates progress and quiz score ranges and enforces the required status/progress mapping.

At 10,000 cadets, the first pressure point would be sync conflict handling and backend pagination, followed by notification fan-out and local queue reconciliation.
