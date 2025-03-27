import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taskflow/features/my_tasks/domain/entities/my_tasks.dart';
import 'package:taskflow/features/my_tasks/domain/use_cases/fetch_my_tasks_use_case.dart';

part 'my_tasks_event.dart';
part 'my_tasks_state.dart';

class MyTasksBloc extends Bloc<MyTasksEvent, MyTasksState> {
  final FetchMyTasksUseCase fetchMyTasksUseCase;
  MyTasksBloc(this.fetchMyTasksUseCase) : super(MyTasksInitial()) {
    on<FetchMyTasks>(_fetchMyTasks);
  }

  void _fetchMyTasks(event, emit) async{
    emit(MyTasksLoading());
    try{
      final tasks = await fetchMyTasksUseCase.fetchMyTasks();
      emit(MyTasksLoaded(tasks));
    }
    catch(e){
      emit(MyTasksError(e.toString()));
    }
  }
}
