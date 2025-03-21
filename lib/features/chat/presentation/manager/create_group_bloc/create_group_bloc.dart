import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taskflow/features/chat/domain/use_cases/create_group_use_case.dart';

part 'create_group_event.dart';
part 'create_group_state.dart';

class CreateGroupBloc extends Bloc<CreateGroupEvent, CreateGroupState> {
  final CreateGroupUseCase createGroupUseCase;

  CreateGroupBloc(this.createGroupUseCase) : super(CreateGroupInitial()) {
    on<UpdateGroupName>(_updateGroupName);
    on<AddEmail>(_addEmail);
    on<RemoveEmail>(_removeEmail);
    on<CreateGroup>(_createGroup);
  }

  void _updateGroupName(UpdateGroupName event, Emitter<CreateGroupState> emit) {
    if (state is CreateGroupData) {
      final currentState = state as CreateGroupData;
      emit(currentState.copyWith(groupName: event.groupName));
    } else {
      emit(CreateGroupData(groupName: event.groupName, emails: []));
    }
  }

  void _addEmail(AddEmail event, Emitter<CreateGroupState> emit) {
    if (state is CreateGroupData) {
      final currentState = state as CreateGroupData;
      final updatedEmails = List<String>.from(currentState.emails)..add(event.email);
      emit(currentState.copyWith(emails: updatedEmails));
    } else {
      emit(CreateGroupData(groupName: '', emails: [event.email]));
    }
  }

  void _removeEmail(RemoveEmail event, Emitter<CreateGroupState> emit) {
    if (state is CreateGroupData) {
      final currentState = state as CreateGroupData;
      final updatedEmails = List<String>.from(currentState.emails)..removeAt(event.index);
      emit(currentState.copyWith(emails: updatedEmails));
    }
  }

  void _createGroup(CreateGroup event, Emitter<CreateGroupState> emit) async {
    emit(CreateGroupLoading());
    try {
      final bool isCreated = await createGroupUseCase.createGroup(event.groupName, event.memberEmails);
      if (isCreated) {
        emit(CreateGroupLoaded());
      } else {
        emit(CreateGroupError('Error creating group'));
      }
    } catch (e) {
      emit(CreateGroupError('$e'));
    }
  }
}
