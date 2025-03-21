part of 'group_details_bloc.dart';

@immutable
sealed class GroupDetailsEvent {}

final class GetChatGroup extends GroupDetailsEvent{
  final String groupId;

  GetChatGroup(this.groupId);
}
