# Architecture

TOGA Mobile App uses a feature-first clean structure. Each feature owns its models, data services/repositories, Cubit state, and presentation screens.

State management is exclusively BLoC/Cubit through `flutter_bloc`. UI widgets depend on Cubits to reflect state changes. Cubits depend on repositories to fetch data. Repositories abstract the data sources, coordinating between local Hive storage and remote API services. Services handle the raw HTTP communication and return DTOs or Models to the repositories. This separation ensures UI doesn't know about network calls, and network calls don't know about UI state.

Hive stores session, offline study notes, notification read state, and chapter completion overrides. The repository layer is the boundary between local storage, mock services, and future FastAPI clients.

Global errors are routed through `runZonedGuarded`, `FlutterError.reportError`, and `AppBlocObserver`. Feature Cubits also expose loading, success, and failure states for UI feedback.

Instructor workflows can scale by adding `features/instructor/` with its own repositories and role-scoped models while keeping shared widgets and core network/storage layers unchanged.
