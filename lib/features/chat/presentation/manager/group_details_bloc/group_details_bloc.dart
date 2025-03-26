import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taskflow/features/chat/domain/entities/chat_group.dart';
import 'package:taskflow/features/chat/domain/use_cases/chat/get_chat_group_use_case.dart';

part 'group_details_event.dart';
part 'group_details_state.dart';

class GroupDetailsBloc extends Bloc<GroupDetailsEvent, GroupDetailsState> {
  final GetChatGroupUseCase getChatGroupUseCase;
  GroupDetailsBloc(this.getChatGroupUseCase) : super(GroupDetailsInitial()) {
    on<GetChatGroup>(_getChatGroup);

  }
  _getChatGroup(GetChatGroup event, emit) async{
    emit(GroupDetailsLoading());
    try{
      final group = await getChatGroupUseCase.getChatGroup(event.groupId);
      emit(GroupDetailsLoaded(group));
    }
    catch(e){
      emit(GroupDetailsError('$e'));
    }
  }
}
