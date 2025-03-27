part of 'my_tasks_bloc.dart';

@immutable
sealed class MyTasksState {}

final class MyTasksInitial extends MyTasksState {}
final class MyTasksLoading extends MyTasksState {}
final class MyTasksLoaded extends MyTasksState {
  final MyTasks myTasks;

  MyTasksLoaded(this.myTasks);
}
final class MyTasksError extends MyTasksState {
  final String message;

  MyTasksError(this.message);
}
