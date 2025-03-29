import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taskflow/features/security/domain/use_cases/change_password_use_case.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final ChangePasswordUseCase changePasswordUseCase;
  ChangePasswordBloc(this.changePasswordUseCase) : super(ChangePasswordInitial()) {
    on<ChangeMyPassword>(_changePassword);
  }

  void _changePassword(ChangeMyPassword event, emit) async{
    emit(ChangePasswordLoading());
    try{
      await changePasswordUseCase.changePassword(event.currentPassword, event.newPassword);
      emit(ChangePasswordLoaded());
    }
    catch(e){
      emit(ChangePasswordError('$e'));
    }
  }
}
