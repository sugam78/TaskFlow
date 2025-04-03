import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taskflow/features/chat/domain/use_cases/chat/make_group_admin_use_case.dart';

part 'make_admin_event.dart';
part 'make_admin_state.dart';

class MakeAdminBloc extends Bloc<MakeAdminEvent, MakeAdminState> {
  final MakeGroupAdminUseCase makeGroupAdminUseCase;
  MakeAdminBloc(this.makeGroupAdminUseCase) : super(MakeAdminInitial()) {
    on<MakeGroupAdmin>(_makeGroupAdmin);
  }
  void _makeGroupAdmin(MakeGroupAdmin event, emit) async{
    emit(MakeAdminLoading());
    try{
      await makeGroupAdminUseCase.makeAdmin(event.groupId, event.email);
      emit(MakeAdminLoaded());
    }
    catch(e){
      emit(MakeAdminError(e.toString()));
    }
  }
}
