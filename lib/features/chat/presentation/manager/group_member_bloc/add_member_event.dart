part of 'group_member_bloc.dart';

@immutable
sealed class GroupMemberEvent {}

final class AddMember extends GroupMemberEvent{
  final String groupId,email;

  AddMember(this.groupId, this.email);
}
final class RemoveMember extends GroupMemberEvent{
  final String groupId,email;

  RemoveMember(this.groupId, this.email);
}
