part of 'make_admin_bloc.dart';

@immutable
sealed class MakeAdminEvent {}

final class MakeGroupAdmin extends MakeAdminEvent{
  final String groupId,email;

  MakeGroupAdmin(this.groupId, this.email);
}
