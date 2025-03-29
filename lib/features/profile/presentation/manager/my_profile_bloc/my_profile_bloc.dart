import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taskflow/features/profile/domain/entities/profile.dart';
import 'package:taskflow/features/profile/domain/use_cases/get_my_profile_use_case.dart';

part 'my_profile_event.dart';
part 'my_profile_state.dart';

class MyProfileBloc extends Bloc<MyProfileEvent, MyProfileState> {
  final GetMyProfileUseCase getMyProfileUseCase;
  MyProfileBloc(this.getMyProfileUseCase) : super(MyProfileInitial()) {
    on<GetMyProfile>(_getMyProfile);
  }

  void _getMyProfile(event, emit) async{
    emit(MyProfileLoading());
    try{
      final profile = await getMyProfileUseCase.getMyProfile();
      emit(MyProfileLoaded(profile));
    }
    catch(e){
      emit(MyProfileError(e.toString()));
    }
  }
}
