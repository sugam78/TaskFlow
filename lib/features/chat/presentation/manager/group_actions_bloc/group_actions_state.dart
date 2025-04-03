part of 'group_actions_bloc.dart';

@immutable
sealed class GroupActionsState {}

final class GroupActionsInitial extends GroupActionsState {}
final class GroupActionsLoading extends GroupActionsState {}
final class GroupLeaveSuccess extends GroupActionsState {}
final class GroupActionsError extends GroupActionsState {
  final String message;

  GroupActionsError(this.message);
}
