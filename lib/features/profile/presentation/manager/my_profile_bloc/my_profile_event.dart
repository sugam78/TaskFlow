part of 'my_profile_bloc.dart';

@immutable
sealed class MyProfileEvent {}

final class GetMyProfile extends MyProfileEvent{}
