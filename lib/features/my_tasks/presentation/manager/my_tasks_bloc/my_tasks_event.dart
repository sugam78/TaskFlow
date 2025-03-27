part of 'my_tasks_bloc.dart';

@immutable
sealed class MyTasksEvent {}

final class FetchMyTasks extends MyTasksEvent{}
