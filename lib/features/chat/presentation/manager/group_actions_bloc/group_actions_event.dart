part of 'group_actions_bloc.dart';

@immutable
sealed class GroupActionsEvent {}

class LeaveGroup extends GroupActionsEvent{
  final String groupId;

  LeaveGroup(this.groupId);
}
