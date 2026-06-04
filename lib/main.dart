import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/errors/app_bloc_observer.dart';
import 'core/storage/local_storage.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/data/auth_service.dart';
import 'features/auth/presentation/auth_cubit.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/dashboard/data/dashboard_repository.dart';
import 'features/dashboard/data/dashboard_service.dart';
import 'features/dashboard/presentation/dashboard_cubit.dart';
import 'features/logbook/data/logbook_repository.dart';
import 'features/logbook/data/logbook_service.dart';
import 'features/logbook/presentation/logbook_cubit.dart';
import 'features/notifications/data/notification_repository.dart';
import 'features/notifications/data/notification_service.dart';
import 'features/notifications/presentation/notifications_cubit.dart';
import 'features/notes/data/notes_repository.dart';
import 'features/notes/data/notes_service.dart';
import 'features/notes/presentation/notes_cubit.dart';
import 'features/study/data/study_repository.dart';
import 'features/study/data/study_service.dart';
import 'features/study/presentation/study_cubit.dart';
import 'shared/app_shell.dart';

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    Bloc.observer = AppBlocObserver();
    await Hive.initFlutter();
    await LocalStorage.init();
    runApp(const TogaMobileApp());
  }, (error, stackTrace) {
    FlutterError.reportError(
      FlutterErrorDetails(exception: error, stack: stackTrace),
    );
  });
}

class TogaMobileApp extends StatefulWidget {
  const TogaMobileApp({super.key});

  @override
  State<TogaMobileApp> createState() => _TogaMobileAppState();
}

class _TogaMobileAppState extends State<TogaMobileApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository(AuthService());
    final dashboardRepository = DashboardRepository(DashboardService());
    final studyRepository = StudyRepository(StudyService());
    final notesRepository = NotesRepository(NotesService());
    final logbookRepository = LogbookRepository(LogbookService());
    final notificationRepository = NotificationRepository(NotificationService());

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: dashboardRepository),
        RepositoryProvider.value(value: studyRepository),
        RepositoryProvider.value(value: notesRepository),
        RepositoryProvider.value(value: logbookRepository),
        RepositoryProvider.value(value: notificationRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthCubit(authRepository)..restoreSession()),
          BlocProvider(create: (_) => DashboardCubit(dashboardRepository)),
          BlocProvider(create: (_) => StudyCubit(studyRepository)),
          BlocProvider(create: (_) => NotesCubit(notesRepository)..loadNotes()),
          BlocProvider(create: (_) => LogbookCubit(logbookRepository)),
          BlocProvider(
            create: (_) => NotificationsCubit(notificationRepository)
              ..loadNotifications(),
          ),
        ],
        child: MaterialApp(
          title: 'TOGA Mobile App',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: _themeMode,
          home: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state.status == AuthStatus.authenticated) {
                return AppShell(
                  profile: state.profile!,
                  themeMode: _themeMode,
                  onThemeModeChanged: (mode) => setState(() => _themeMode = mode),
                );
              }
              return const LoginScreen();
            },
          ),
        ),
      ),
    );
  }
}
