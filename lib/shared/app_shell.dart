import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/auth/models/cadet_profile.dart';
import '../features/auth/presentation/auth_cubit.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/logbook/presentation/logbook_screen.dart';
import '../features/notifications/presentation/notifications_screen.dart';
import '../features/notes/presentation/notes_screen.dart';
import '../features/study/presentation/study_subjects_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({
    required this.profile,
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final CadetProfile profile;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardScreen(onContinueStudy: () => setState(() => _index = 1)),
      const StudySubjectsScreen(),
      const NotesScreen(),
      const LogbookScreen(),
      const NotificationsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          [
            'TOGA Flight Deck',
            'Study',
            'Notes',
            'Logbook',
            'Notifications',
          ][_index],
        ),
        actions: [
          IconButton(
            tooltip: 'Toggle theme',
            onPressed: () {
              widget.onThemeModeChanged(
                widget.themeMode == ThemeMode.dark
                    ? ThemeMode.light
                    : ThemeMode.dark,
              );
            },
            icon: Icon(
              widget.themeMode == ThemeMode.dark
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
            ),
          ),
          IconButton(
            tooltip: 'Logout',
            onPressed: () => context.read<AuthCubit>().logout(),
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.space_dashboard_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_rounded),
            label: 'Study',
          ),
          NavigationDestination(
            icon: Icon(Icons.edit_note_rounded),
            label: 'Notes',
          ),
          NavigationDestination(
            icon: Icon(Icons.flight_takeoff_rounded),
            label: 'Logbook',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_rounded),
            label: 'Alerts',
          ),
        ],
      ),
    );
  }
}
