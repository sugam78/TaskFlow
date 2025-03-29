part of 'change_password_bloc.dart';

@immutable
sealed class ChangePasswordState {}

final class ChangePasswordInitial extends ChangePasswordState {}
final class ChangePasswordLoading extends ChangePasswordState {}
final class ChangePasswordLoaded extends ChangePasswordState {}
final class ChangePasswordError extends ChangePasswordState {
  final String message;

  ChangePasswordError(this.message);
}
