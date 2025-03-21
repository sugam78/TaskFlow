part of 'create_group_bloc.dart';

@immutable
sealed class CreateGroupState {}

final class CreateGroupInitial extends CreateGroupState {}

final class CreateGroupLoading extends CreateGroupState {}

final class CreateGroupLoaded extends CreateGroupState {}

final class CreateGroupError extends CreateGroupState {
  final String message;
  CreateGroupError(this.message);
}

final class CreateGroupData extends CreateGroupState {
  final String groupName;
  final List<String> emails;

  CreateGroupData({this.groupName = '', this.emails = const []});

  CreateGroupData copyWith({String? groupName, List<String>? emails}) {
    return CreateGroupData(
      groupName: groupName ?? this.groupName,
      emails: emails ?? this.emails,
    );
  }
}
