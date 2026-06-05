part of 'auth_cubit.dart';

enum AuthStatus { unauthenticated, loading, authenticated, failure }

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.unauthenticated,
    this.token,
    this.profile,
    this.availableProfiles = const [],
    this.error,
  });

  final AuthStatus status;
  final String? token;
  final CadetProfile? profile;
  final List<CadetProfile> availableProfiles;
  final String? error;

  AuthState copyWith({
    AuthStatus? status,
    String? token,
    CadetProfile? profile,
    List<CadetProfile>? availableProfiles,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      token: token ?? this.token,
      profile: profile ?? this.profile,
      availableProfiles: availableProfiles ?? this.availableProfiles,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, token, profile, availableProfiles, error];
}
