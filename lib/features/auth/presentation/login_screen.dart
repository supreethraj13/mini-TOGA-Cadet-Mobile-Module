import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/widgets/app_button.dart';
import 'auth_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.status == AuthStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error ?? 'Authentication failed')),
              );
            }
          },
          builder: (context, state) {
            final loading = state.status == AuthStatus.loading;
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Icon(Icons.flight_rounded, size: 56, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 18),
                  Text('TOGA Mobile App', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Text(
                    'Cadet flight deck for study progress, offline notes, logbook metrics, and Skynet-ready sync.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 28),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Mock Cadet Profile', style: TextStyle(fontWeight: FontWeight.w800)),
                          SizedBox(height: 12),
                          Text('Name: Arjun Menon'),
                          Text('Role: Cadet'),
                          Text('Course: PPL'),
                          Text('FTO: AIRMAN Flight Academy'),
                          Text('Instructor: Capt. R. Sharma'),
                          Text('Base: Chennai'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    label: 'Continue as Cadet',
                    icon: Icons.login_rounded,
                    loading: loading,
                    onPressed: () => context.read<AuthCubit>().login(),
                  ),
                  const Spacer(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
