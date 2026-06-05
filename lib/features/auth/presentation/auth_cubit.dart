import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/auth_repository.dart';
import '../models/cadet_profile.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(const AuthState());

  final AuthRepository _repository;

  Future<void> loadMockProfiles() async {
    try {
      final profiles = await _repository.fetchMockProfiles();
      emit(state.copyWith(availableProfiles: profiles, error: null));
    } catch (error) {
      emit(state.copyWith(status: AuthStatus.failure, error: error.toString()));
    }
  }

  Future<void> restoreSession() async {
    final session = await _repository.restore();
    if (session != null) {
      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          token: session.token,
          profile: session.profile,
        ),
      );
    }
  }

  Future<void> login() async {
    final profileId = state.availableProfiles.isNotEmpty
        ? state.availableProfiles.first.id
        : 'cadet-arjun-menon';
    await authenticate(
      profileId: profileId,
      mode: 'login',
      username: 'mock.cadet',
      password: 'mock-password',
    );
  }

  Future<void> authenticate({
    required String profileId,
    required String mode,
    required String username,
    required String password,
    Map<String, dynamic>? profileDetails,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading, error: null));
    try {
      final session = await _repository.login(
        profileId: profileId,
        mode: mode,
        username: username,
        password: password,
        profileDetails: profileDetails,
      );
      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          token: session.token,
          profile: session.profile,
        ),
      );
    } catch (error) {
      emit(state.copyWith(status: AuthStatus.failure, error: error.toString()));
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    emit(const AuthState());
  }
}
