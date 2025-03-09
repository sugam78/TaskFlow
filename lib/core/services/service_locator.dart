
import 'package:get_it/get_it.dart';
import 'package:taskflow/core/services/notification_services.dart';
import 'package:taskflow/features/auth/data/data_sources/auth_data_sources.dart';
import 'package:taskflow/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:taskflow/features/auth/domain/repositories/auth_repository.dart';
import 'package:taskflow/features/auth/domain/use_cases/login.dart';
import 'package:taskflow/features/auth/domain/use_cases/signup.dart';

final authLocator = GetIt.instance;
final sharedLocator = GetIt.instance;

void setupServiceLocator() {



  //Auth

  authLocator.registerLazySingleton<AuthRemoteDataSource>(
          () => AuthRemoteDataSourceImpl());
  sharedLocator.registerLazySingleton<NotificationServices>(
          () => NotificationServices());

  authLocator.registerLazySingleton<AuthRepository>(
          () => AuthRepositoryImpl(authLocator<AuthRemoteDataSource>()));

  authLocator.registerLazySingleton(() => LoginUseCase(authLocator<AuthRepository>()));
  authLocator.registerLazySingleton(() => SignupUseCase(authLocator<AuthRepository>(),sharedLocator<NotificationServices>()));

}
