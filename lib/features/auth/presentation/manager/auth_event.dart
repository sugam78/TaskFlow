part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}


class SignupRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;

  SignupRequested({
    required this.name,
    required this.email,
    required this.password,
  });
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested(this.email, this.password);
}

class ResetAuthBloc extends AuthEvent {}