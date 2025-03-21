part of 'create_group_bloc.dart';

@immutable
sealed class CreateGroupEvent {}

class UpdateGroupName extends CreateGroupEvent {
  final String groupName;
  UpdateGroupName(this.groupName);
}

class AddEmail extends CreateGroupEvent {
  final String email;
  AddEmail(this.email);
}

class RemoveEmail extends CreateGroupEvent {
  final int index;
  RemoveEmail(this.index);
}

class CreateGroup extends CreateGroupEvent {
  final String groupName;
  final List<String> memberEmails;

  CreateGroup(this.groupName, this.memberEmails);
}
