
import 'package:get_it/get_it.dart';
import 'package:taskflow/core/services/notification_services.dart';
import 'package:taskflow/features/auth/data/data_sources/auth_data_sources.dart';
import 'package:taskflow/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:taskflow/features/auth/domain/repositories/auth_repository.dart';
import 'package:taskflow/features/auth/domain/use_cases/login.dart';
import 'package:taskflow/features/auth/domain/use_cases/signup.dart';
import 'package:http/http.dart' as http;
import 'package:taskflow/features/chat/data/data_sources/chat_group_remote_data_source.dart';
import 'package:taskflow/features/chat/data/data_sources/chat_messages_remote_data_source.dart';
import 'package:taskflow/features/chat/data/data_sources/chat_task_remote_data_source.dart';
import 'package:taskflow/features/chat/data/repositories/chat_group_repository_impl.dart';
import 'package:taskflow/features/chat/data/repositories/chat_messages_repository_impl.dart';
import 'package:taskflow/features/chat/data/repositories/chat_task_repository_impl.dart';
import 'package:taskflow/features/chat/domain/repositories/chat_group_repo.dart';
import 'package:taskflow/features/chat/domain/repositories/chat_messages_repo.dart';
import 'package:taskflow/features/chat/domain/repositories/chat_task_repo.dart';
import 'package:taskflow/features/chat/domain/use_cases/create_group_use_case.dart';
import 'package:taskflow/features/chat/domain/use_cases/create_task_use_case.dart';
import 'package:taskflow/features/chat/domain/use_cases/fetch_messages_use_case.dart';
import 'package:taskflow/features/chat/domain/use_cases/get_chat_group_use_case.dart';
import 'package:taskflow/features/chat/domain/use_cases/get_my_groups_use_case.dart';
import 'package:taskflow/features/chat/domain/use_cases/send_message_use_case.dart';
import 'package:taskflow/features/chat/domain/use_cases/update_task_use_case.dart';


final authLocator = GetIt.instance;
final sharedLocator = GetIt.instance;
final packagesLocator = GetIt.instance;
final chatLocator = GetIt.instance;
final taskLocator = GetIt.instance;
final messageLocator = GetIt.instance;

void setupServiceLocator() {

  //Packages
  packagesLocator.registerLazySingleton<http.Client>(() => http.Client());

  //Auth
  authLocator.registerLazySingleton<AuthRemoteDataSource>(
          () => AuthRemoteDataSourceImpl(packagesLocator<http.Client>()));
  sharedLocator.registerLazySingleton<NotificationServices>(
          () => NotificationServices());

  authLocator.registerLazySingleton<AuthRepository>(
          () => AuthRepositoryImpl(authLocator<AuthRemoteDataSource>()));

  authLocator.registerLazySingleton(() => LoginUseCase(authLocator<AuthRepository>()));
  authLocator.registerLazySingleton(() => SignupUseCase(authLocator<AuthRepository>(),sharedLocator<NotificationServices>()));

  //chat
  chatLocator.registerLazySingleton<ChatGroupRemoteDataSource>(()=> ChatGroupRemoteDataSourceImpl(packagesLocator<http.Client>()));
  chatLocator.registerLazySingleton<ChatGroupRepository>(()=> ChatGroupRepositoryImpl(chatLocator<ChatGroupRemoteDataSource>()));
  chatLocator.registerLazySingleton(()=> GetMyGroupsUseCase(chatLocator<ChatGroupRepository>()));
  chatLocator.registerLazySingleton(()=> GetChatGroupUseCase(chatLocator<ChatGroupRepository>()));
  chatLocator.registerLazySingleton(()=> CreateGroupUseCase(chatLocator<ChatGroupRepository>()));

  //messages
  messageLocator.registerLazySingleton<ChatMessagesRemoteDataSource>(()=>ChatMessagesRemoteDataSourceImpl(packagesLocator<http.Client>()));
  messageLocator.registerLazySingleton<ChatMessagesRepository>(()=>ChatMessagesRepositoryImpl(messageLocator<ChatMessagesRemoteDataSource>()));
  messageLocator.registerLazySingleton(()=>SendMessageUseCase(messageLocator<ChatMessagesRepository>()));
  messageLocator.registerLazySingleton(()=>FetchMessageUseCase(messageLocator<ChatMessagesRepository>()));


  //tasks
  taskLocator.registerLazySingleton<ChatTaskRemoteDataSource>(()=>ChatTaskRemoteDataSourceImpl(packagesLocator<http.Client>()));
  taskLocator.registerLazySingleton<ChatTaskRepository>(()=>ChatTaskRepositoryImpl(taskLocator<ChatTaskRemoteDataSource>()));
  taskLocator.registerLazySingleton(()=>CreateTaskUseCase(taskLocator<ChatTaskRepository>()));
  taskLocator.registerLazySingleton(()=>UpdateTaskUseCase(taskLocator<ChatTaskRepository>()));

}
