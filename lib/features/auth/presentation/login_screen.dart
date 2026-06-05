import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/widgets/app_button.dart';
import '../models/cadet_profile.dart';
import 'auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController(text: 'mock.cadet');
  final _passwordController = TextEditingController(text: 'mock-password');
  final _nameController = TextEditingController(text: 'Arjun Menon');
  final _courseController = TextEditingController(text: 'PPL');
  final _baseController = TextEditingController(text: 'Chennai');
  final _ftoController = TextEditingController(text: 'AIRMAN Flight Academy');
  final _instructorController = TextEditingController(text: 'Capt. R. Sharma');

  var _mode = 'login';
  String? _selectedProfileId;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthCubit>();
    if (auth.state.availableProfiles.isEmpty) {
      auth.loadMockProfiles();
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _courseController.dispose();
    _baseController.dispose();
    _ftoController.dispose();
    _instructorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.status == AuthStatus.failure && state.error != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error!)));
            }
          },
          builder: (context, state) {
            final profiles = state.availableProfiles;
            final selectedProfile = _selectedProfile(profiles);
            final loading = state.status == AuthStatus.loading;
            return ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const SizedBox(height: 36),
                Icon(
                  Icons.flight_rounded,
                  size: 56,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 18),
                Text(
                  'TOGA Mobile App',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Cadet flight deck for study progress, offline notes, logbook metrics, and Skynet-ready sync.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 28),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: 'login',
                      label: Text('Login'),
                      icon: Icon(Icons.login_rounded),
                    ),
                    ButtonSegment(
                      value: 'signup',
                      label: Text('Sign up'),
                      icon: Icon(Icons.person_add_alt_1_rounded),
                    ),
                  ],
                  selected: {_mode},
                  onSelectionChanged: (value) =>
                      setState(() => _mode = value.first),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person_rounded),
                  ),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_rounded),
                  ),
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),
                Text(
                  'Select Mock Cadet Profile',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                if (profiles.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.error ?? 'Mock profiles are not loaded yet.',
                          ),
                          const SizedBox(height: 12),
                          AppButton(
                            label: 'Load Profiles',
                            icon: Icons.refresh_rounded,
                            onPressed: () =>
                                context.read<AuthCubit>().loadMockProfiles(),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (final profile in profiles)
                        ChoiceChip(
                          label: Text(profile.name),
                          selected: selectedProfile?.id == profile.id,
                          avatar: const Icon(Icons.school_rounded, size: 18),
                          onSelected: (_) => _selectProfile(profile),
                        ),
                    ],
                  ),
                const SizedBox(height: 16),
                _CadetDetailsForm(
                  nameController: _nameController,
                  courseController: _courseController,
                  baseController: _baseController,
                  ftoController: _ftoController,
                  instructorController: _instructorController,
                ),
                const SizedBox(height: 24),
                AppButton(
                  label: _mode == 'login'
                      ? 'Login as Cadet'
                      : 'Create Mock Cadet Account',
                  icon: _mode == 'login'
                      ? Icons.login_rounded
                      : Icons.person_add_alt_1_rounded,
                  loading: loading,
                  onPressed: selectedProfile == null
                      ? null
                      : () => context.read<AuthCubit>().authenticate(
                          profileId: selectedProfile.id,
                          mode: _mode,
                          username: _usernameController.text.trim(),
                          password: _passwordController.text,
                          profileDetails: _profileDetails(),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  CadetProfile? _selectedProfile(List<CadetProfile> profiles) {
    if (profiles.isEmpty) return null;
    if (_selectedProfileId == null) {
      return profiles.first;
    }
    return profiles.firstWhere(
      (profile) => profile.id == _selectedProfileId,
      orElse: () => profiles.first,
    );
  }

  void _selectProfile(CadetProfile profile) {
    setState(() {
      _selectedProfileId = profile.id;
      _usernameController.text = profile.id
          .replaceFirst('cadet-', '')
          .replaceAll('-', '.');
      _nameController.text = profile.name;
      _courseController.text = profile.course;
      _baseController.text = profile.base;
      _ftoController.text = profile.fto.name;
      _instructorController.text = profile.instructor.name;
    });
  }

  Map<String, dynamic> _profileDetails() {
    return {
      'name': _nameController.text.trim(),
      'course': _courseController.text.trim(),
      'base': _baseController.text.trim(),
      'fto_name': _ftoController.text.trim(),
      'instructor_name': _instructorController.text.trim(),
    };
  }
}

class _CadetDetailsForm extends StatelessWidget {
  const _CadetDetailsForm({
    required this.nameController,
    required this.courseController,
    required this.baseController,
    required this.ftoController,
    required this.instructorController,
  });

  final TextEditingController nameController;
  final TextEditingController courseController;
  final TextEditingController baseController;
  final TextEditingController ftoController;
  final TextEditingController instructorController;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cadet Details',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Cadet name',
                prefixIcon: Icon(Icons.badge_rounded),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: courseController,
              decoration: const InputDecoration(
                labelText: 'Course',
                prefixIcon: Icon(Icons.school_rounded),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: baseController,
              decoration: const InputDecoration(
                labelText: 'Base',
                prefixIcon: Icon(Icons.place_rounded),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: ftoController,
              decoration: const InputDecoration(
                labelText: 'FTO',
                prefixIcon: Icon(Icons.business_rounded),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: instructorController,
              decoration: const InputDecoration(
                labelText: 'Instructor',
                prefixIcon: Icon(Icons.person_pin_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
