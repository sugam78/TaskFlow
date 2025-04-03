part of 'make_admin_bloc.dart';

@immutable
sealed class MakeAdminState {}

final class MakeAdminInitial extends MakeAdminState {}
final class MakeAdminLoading extends MakeAdminState {}
final class MakeAdminLoaded extends MakeAdminState {}
final class MakeAdminError extends MakeAdminState {
  final String message;

  MakeAdminError(this.message);
}
