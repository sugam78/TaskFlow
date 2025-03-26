import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taskflow/features/chat/domain/entities/my_chat_groups.dart';
import 'package:taskflow/features/chat/domain/use_cases/chat/get_my_groups_use_case.dart';

part 'my_groups_event.dart';
part 'my_groups_state.dart';

class MyGroupsBloc extends Bloc<MyGroupsEvent, MyGroupsState> {
  final GetMyGroupsUseCase getMyGroupsUseCase;
  MyGroupsBloc(this.getMyGroupsUseCase) : super(MyGroupsInitial()) {
    on<GetMyGroups>(_getMyGroups);
  }
  void _getMyGroups(event, emit) async{
    emit(MyGroupsLoading());
    try{
      final myGroups = await getMyGroupsUseCase.getMyGroups();
      emit(MyGroupsLoaded(myGroups));
    }
    catch(e){
      emit(MyGroupsError(e.toString()));
    }
  }
}
