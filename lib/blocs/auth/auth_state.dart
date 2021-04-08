part of 'auth_bloc.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  const AuthState({
    this.user,
    this.status = AuthStatus.unknown,
  });

  final auth.User? user;
  final AuthStatus status;

  factory AuthState.unknown() => const AuthState();

  factory AuthState.authenticated({required auth.User? user}) {
    return AuthState(
      user: user,
      status: AuthStatus.authenticated,
    );
  }

  factory AuthState.unauthenticated() {
    return AuthState(
      status: AuthStatus.unauthenticated,
    );
  }

  @override
  List<Object?> get props => [user, status];
}
