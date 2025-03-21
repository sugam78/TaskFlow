part of 'group_details_bloc.dart';

@immutable
sealed class GroupDetailsState {}

final class GroupDetailsInitial extends GroupDetailsState {}
final class GroupDetailsLoading extends GroupDetailsState {}
final class GroupDetailsLoaded extends GroupDetailsState {
  final ChatGroup chatGroup;

  GroupDetailsLoaded(this.chatGroup);
}
final class GroupDetailsError extends GroupDetailsState {
  final String message;

  GroupDetailsError(this.message);
}
