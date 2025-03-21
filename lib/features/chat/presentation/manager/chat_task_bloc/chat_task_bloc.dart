import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taskflow/features/chat/domain/use_cases/create_task_use_case.dart';
import 'package:taskflow/features/chat/domain/use_cases/update_task_use_case.dart';

part 'chat_task_event.dart';
part 'chat_task_state.dart';

class ChatTaskBloc extends Bloc<ChatTaskEvent, ChatTaskState> {
  final CreateTaskUseCase createTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  ChatTaskBloc(this.createTaskUseCase, this.updateTaskUseCase) : super(ChatTaskInitial()) {
    on<CreateTask>(_createTask);
    on<UpdateTask>(_updateTask);
  }
  void _createTask(CreateTask event, emit) async{
    emit(ChatTaskLoading());
    try{
      final taskId = await createTaskUseCase.createTask(event.title, event.description, event.assignedToEmail, event.groupId);
      emit(ChatTaskCreated(taskId));
    }
    catch(e){
      emit(ChatTaskError(e.toString()));
    }
  }
  void _updateTask(UpdateTask event, emit) async{
    emit(ChatTaskLoading());
    try{
      await updateTaskUseCase.updateTask(event.taskId, event.status);
      emit(ChatTaskUpdated());
    }
    catch(e){
      emit(ChatTaskError(e.toString()));
    }
  }
}
