import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taskflow/features/chat/domain/use_cases/chat/add_member_use_case.dart';
import 'package:taskflow/features/chat/domain/use_cases/chat/remove_member_use_case.dart';

part 'add_member_event.dart';
part 'add_member_state.dart';

class GroupMemberBloc extends Bloc<GroupMemberEvent, GroupMemberState> {
  final AddMemberUseCase addMemberUseCase;
  final RemoveMemberUseCase removeMemberUseCase;
  GroupMemberBloc(this.addMemberUseCase, this.removeMemberUseCase) : super(GroupMemberInitial()) {
    on<AddMember>(_addMember);
    on<RemoveMember>(_removeMember);
  }
  void _addMember(AddMember event, emit) async{
    emit(GroupMemberLoading());
    try{
      await addMemberUseCase.addMember(event.groupId, event.email);
      emit(MemberAdded());
    }
    catch(e){
      emit(GroupMemberError(e.toString()));
    }
  }
  void _removeMember(RemoveMember event, emit) async{
    emit(GroupMemberLoading());
    try{
      await removeMemberUseCase.removeMember(event.groupId, event.email);
      emit(MemberRemoved());
    }
    catch(e){
      emit(GroupMemberError(e.toString()));
    }
  }
}
