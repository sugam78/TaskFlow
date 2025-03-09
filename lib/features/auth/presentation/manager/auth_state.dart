part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSignUpSuccess extends AuthState {

}

class AuthLoginSuccess extends AuthState {
  final User userModel;

  AuthLoginSuccess(this.userModel);

}

class AuthFailure extends AuthState {
  final String errorMessage;

  AuthFailure(this.errorMessage);
}
