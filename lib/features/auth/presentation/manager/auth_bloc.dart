import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:taskflow/features/auth/domain/entities/user.dart';
import 'package:taskflow/features/auth/domain/use_cases/login.dart';
import 'package:taskflow/features/auth/domain/use_cases/signup.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;

  AuthBloc(this.loginUseCase, this.signupUseCase) : super(AuthInitial()) {


    on<SignupRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await signupUseCase.execute(
          event.name,
          event.email,
          event.password
        );
        emit(AuthSignUpSuccess());
      } catch (e) {
        emit(AuthFailure("Failed to SignUp: ${e.toString()}"));
      }
    });

    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await loginUseCase.execute(event.email, event.password);
        await Hive.box('SETTINGS').put('token', user.token);
        emit(AuthLoginSuccess(user));
      } catch (e) {
        emit(AuthFailure("Login failed: ${e.toString()}"));
      }
    });


    on<ResetAuthBloc>((event, emit) {
      emit(AuthInitial());
    });
  }
}
