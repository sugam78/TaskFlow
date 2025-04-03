import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taskflow/features/chat/domain/use_cases/chat/leave_group_use_case.dart';

part 'group_actions_event.dart';
part 'group_actions_state.dart';

class GroupActionsBloc extends Bloc<GroupActionsEvent, GroupActionsState> {
  final LeaveGroupUseCase _leaveGroupUseCase;
  GroupActionsBloc(this._leaveGroupUseCase) : super(GroupActionsInitial()) {
    on<LeaveGroup>(_leaveGroup);
  }
  void _leaveGroup(LeaveGroup event, emit) async{
    emit(GroupActionsLoading());
    try{
      await _leaveGroupUseCase.leaveGroup(event.groupId);
      emit(GroupLeaveSuccess());
    }
    catch(e){
      emit(GroupActionsError(e.toString()));
    }
  }
}
