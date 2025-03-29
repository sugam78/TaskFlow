part of 'my_profile_bloc.dart';

@immutable
sealed class MyProfileState {}

final class MyProfileInitial extends MyProfileState {}
final class MyProfileLoading extends MyProfileState {}
final class MyProfileLoaded extends MyProfileState {
  final Profile profile;

  MyProfileLoaded(this.profile);
}
final class MyProfileError extends MyProfileState {
  final String message;

  MyProfileError(this.message);
}
