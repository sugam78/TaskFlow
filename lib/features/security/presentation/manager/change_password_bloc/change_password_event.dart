part of 'change_password_bloc.dart';

@immutable
sealed class ChangePasswordEvent {}

final class ChangeMyPassword extends ChangePasswordEvent{
  final String currentPassword,newPassword;

  ChangeMyPassword(this.currentPassword, this.newPassword);
}
