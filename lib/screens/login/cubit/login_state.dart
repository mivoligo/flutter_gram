part of 'login_cubit.dart';

enum LoginStatus { initial, submitting, success, error }

class LoginState extends Equatable {
  const LoginState({
    required this.email,
    required this.password,
    required this.status,
    required this.failure,
  });

  final String email;
  final String password;
  final LoginStatus status;
  final Failure failure;

  bool get isFormValid => email.isNotEmpty && password.isNotEmpty;

  factory LoginState.initial() {
    return LoginState(
      email: '',
      password: '',
      status: LoginStatus.initial,
      failure: Failure(),
    );
  }

  LoginState copyWith({
    String? email,
    String? password,
    LoginStatus? status,
    Failure? failure,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [email, password, status, failure];
}
