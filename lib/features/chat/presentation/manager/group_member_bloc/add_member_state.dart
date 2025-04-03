part of 'group_member_bloc.dart';

@immutable
sealed class GroupMemberState {}

final class GroupMemberInitial extends GroupMemberState {}
final class GroupMemberLoading extends GroupMemberState {}
final class MemberAdded extends GroupMemberState {}
final class MemberRemoved extends GroupMemberState {}
final class GroupMemberError extends GroupMemberState {
  final String message;

  GroupMemberError(this.message);
}
