# AI Usage Disclosure

## 1. Did you use AI tools? If yes, where?
Yes, AI tools (GitHub Copilot Codex) were used throughout the project, primarily for scaffolding Flutter widgets, Cubits, tests, and the mock FastAPI backend.

## 2. What did AI generate?
AI generated boilerplate code for BLoC/Cubit state management, the initial UI layout for the Dashboard and Login screens, Hive local storage setup, API models with `fromJson`/`toJson`, unit tests, and the Python FastAPI backend scripts.

## 3. What did you manually review or change?
I manually reviewed and adjusted all feature boundaries to strictly follow a feature-first architecture. I also refined the offline note sync logic, ensuring it properly falls back to Hive when the API is unreachable, and updated business logic constraints and checked for bugs.

## 4. Which AI-generated suggestion did you reject and why?
The AI initially suggested using Riverpod and Provider for state management. I rejected this and enforced the use of `flutter_bloc` (Cubit) as i have experiance with it. The AI also suggested SQLite via sqflite, which I rejected in favor of Hive as required.

## 5. Which part of the project did you personally design?
I personally designed the overall project architecture (the separation between UI, Cubits, Repositories, and Services), the API readiness strategy, and the specific telemetry and aviation-themed UI design logic.

## 6. Which part are you least confident about?
I am least confident about the background sync reliability on iOS. Currently, offline notes only sync when the app is active. If the app is killed before a sync completes, there is no background worker (like Workmanager) configured to wake up and push the data.

## 7. Pick one Flutter screen and explain it line by line.
`LoginScreen` (conceptual line-by-line):
- `class LoginScreen extends StatelessWidget`: Declares a stateless widget because state is handled by Cubit.
- `Widget build(BuildContext context)`: The build method that renders the UI.
- `return Scaffold(...)`: Provides the base structure (app bar, body).
- `BlocConsumer<AuthCubit, AuthState>`: Listens to auth state changes to trigger side effects (like navigation) and rebuild the UI.
- `listener: (context, state)`: If `state` is `AuthAuthenticated`, it calls `Navigator.pushReplacementNamed(context, '/dashboard')`.
- `builder: (context, state)`: Renders the UI based on the state.
- `if (state is AuthLoading)`: Returns a `CircularProgressIndicator()`.
- `TextField(controller: _emailController)`: Input for username/email.
- `TextField(controller: _passwordController, obscureText: true)`: Input for password.
- `ElevatedButton(onPressed: () => context.read<AuthCubit>().login(...))`: Triggers the login action in the Cubit when tapped.

## 8. Pick one state management flow and explain it line by line.
`AuthCubit.login(String username, String password)`:
- `emit(AuthLoading());`: Immediately updates the state to show a loading spinner in the UI.
- `try {`: Starts the error handling block.
- `final token = await authRepository.login(username, password);`: Calls the repository layer, which hits the API.
- `await hiveStorage.saveToken(token);`: Persists the received JWT token locally.
- `emit(AuthAuthenticated(token));`: Updates the state to authenticated, triggering the UI to navigate to the dashboard.
- `} catch (e) {`: Catches network or parsing errors.
- `emit(AuthError(e.toString()));`: Updates the state with the error message, triggering a snackbar in the UI.

## 9. Pick one model and explain its `fromJson` / `toJson`.
`StudySubject` model:
- `factory StudySubject.fromJson(Map<String, dynamic> json) {`: Factory constructor taking a JSON map.
- `return StudySubject(`: Instantiates the object.
- `id: json['id'] as String,`: Extracts the ID as a string.
- `title: json['title'] as String,`: Extracts the title as a string.
- `progress: (json['progress'] as num).toDouble(),`: Extracts progress, casting via `num` to handle both int and double JSON types.
- `status: json['status'] as String,`: Extracts the status.
- `); }`
- `Map<String, dynamic> toJson() {`: Method converting the object back to a JSON map for API or Hive storage.
- `return {`: Returns a map literal.
- `'id': id,`: Maps the `id` field.
- `'title': title,`: Maps the `title` field.
- `'progress': progress,`: Maps the `progress` field.
- `'status': status,`: Maps the `status` field.
- `}; }`

## 10. What would break first if this app had 10,000 cadets using it?
If 10,000 cadets used the app concurrently, the JSON-file backed FastAPI mock backend would break first due to concurrent write locks and lack of connection pooling. On the Flutter side, the lack of pagination on lists (like logbook entries or study notes) would cause heavy memory consumption and slow UI rendering. The offline sync mechanism would also cause massive thundering-herd API spikes when a large group regains connectivity simultaneously.
