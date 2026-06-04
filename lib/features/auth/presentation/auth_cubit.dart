import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/auth_repository.dart';
import '../models/cadet_profile.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(const AuthState());

  final AuthRepository _repository;

  Future<void> restoreSession() async {
    final session = await _repository.restore();
    if (session != null) {
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        token: session.token,
        profile: session.profile,
      ));
    }
  }

  Future<void> login() async {
    emit(state.copyWith(status: AuthStatus.loading, error: null));
    try {
      final session = await _repository.login();
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        token: session.token,
        profile: session.profile,
      ));
    } catch (error) {
      emit(state.copyWith(status: AuthStatus.failure, error: error.toString()));
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    emit(const AuthState());
  }
}
