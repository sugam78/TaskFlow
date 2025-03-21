part of 'my_groups_bloc.dart';

@immutable
sealed class MyGroupsState {}

final class MyGroupsInitial extends MyGroupsState {}
final class MyGroupsLoading extends MyGroupsState {}
final class MyGroupsLoaded extends MyGroupsState {
  final MyChatGroups myChatGroups;

  MyGroupsLoaded(this.myChatGroups);
}
final class MyGroupsError extends MyGroupsState {
  final String message;

  MyGroupsError(this.message);
}
