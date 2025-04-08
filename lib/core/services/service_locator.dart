
import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskflow/core/constants/api_constants.dart';
import 'package:taskflow/core/services/notification_services.dart';
import 'package:taskflow/core/services/web_socket_service.dart';
import 'package:taskflow/features/auth/data/data_sources/auth_data_sources.dart';
import 'package:taskflow/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:taskflow/features/auth/domain/repositories/auth_repository.dart';
import 'package:taskflow/features/auth/domain/use_cases/login.dart';
import 'package:taskflow/features/auth/domain/use_cases/signup.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:taskflow/features/chat/data/data_sources/local/chat_group_local_data_source.dart';
import 'package:taskflow/features/chat/data/data_sources/local/chat_messages_local_data_source.dart';
import 'package:taskflow/features/chat/data/data_sources/remote/chat_member_remote_data_source.dart';
import 'package:taskflow/features/chat/data/data_sources/remote/chat_group_remote_data_source.dart';
import 'package:taskflow/features/chat/data/data_sources/remote/chat_image_picker_data_source.dart';
import 'package:taskflow/features/chat/data/data_sources/remote/chat_make_admin_remote_data_source.dart';
import 'package:taskflow/features/chat/data/data_sources/remote/chat_messages_remote_data_source.dart';
import 'package:taskflow/features/chat/data/data_sources/remote/group_actions_remote_data_source.dart';
import 'package:taskflow/features/chat/data/repositories/chat_member_repository_impl.dart';
import 'package:taskflow/features/chat/data/repositories/chat_make_admin_repository_impl.dart';
import 'package:taskflow/features/chat/data/repositories/group_actions_repository_impl.dart';
import 'package:taskflow/features/chat/domain/repositories/chat_member_repo.dart';
import 'package:taskflow/features/chat/domain/repositories/chat_make_admin_repo.dart';
import 'package:taskflow/features/chat/domain/repositories/group_actions_repo.dart';
import 'package:taskflow/features/chat/domain/use_cases/chat/add_member_use_case.dart';
import 'package:taskflow/features/chat/domain/use_cases/chat/leave_group_use_case.dart';
import 'package:taskflow/features/chat/domain/use_cases/chat/make_group_admin_use_case.dart';
import 'package:taskflow/features/chat/domain/use_cases/chat/remove_member_use_case.dart';
import 'package:taskflow/features/my_tasks/data/data_sources/my_tasks_local_data_source.dart';
import 'package:taskflow/features/my_tasks/data/data_sources/my_tasks_remote_data_source.dart';
import 'package:taskflow/features/my_tasks/data/repositories/my_tasks_repository_impl.dart';
import 'package:taskflow/features/my_tasks/domain/repositories/my_tasks_repo.dart';
import 'package:taskflow/features/my_tasks/domain/use_cases/fetch_my_tasks_use_case.dart';
import 'package:taskflow/features/profile/data/data_sources/my_profile_local_data_source.dart';
import 'package:taskflow/features/profile/data/data_sources/my_profile_remote_data_source.dart';
import 'package:taskflow/features/profile/data/repositories/my_profile_repository_impl.dart';
import 'package:taskflow/features/profile/domain/repositories/my_profile_repo.dart';
import 'package:taskflow/features/profile/domain/use_cases/get_my_profile_use_case.dart';
import 'package:taskflow/features/security/data/data_sources/change_password_remote_data_source.dart';
import 'package:taskflow/features/security/data/repositories/change_password_repository_impl.dart';
import 'package:taskflow/features/security/domain/repositories/change_password_repo.dart';
import 'package:taskflow/features/security/domain/use_cases/change_password_use_case.dart';
import 'package:taskflow/shared/data/data_sources/chat_task_remote_data_source.dart';
import 'package:taskflow/features/chat/data/data_sources/remote/chat_upload_image_data_source.dart';
import 'package:taskflow/features/chat/data/data_sources/web_socket/receive_messages_web_socket_data_source.dart';
import 'package:taskflow/features/chat/data/data_sources/web_socket/send_messages_web_socket_data_source.dart';
import 'package:taskflow/features/chat/data/models/messages_model.dart';
import 'package:taskflow/features/chat/data/repositories/chat_group_repository_impl.dart';
import 'package:taskflow/features/chat/data/repositories/chat_image_picker_repository_impl.dart';
import 'package:taskflow/features/chat/data/repositories/chat_messages_repository_impl.dart';
import 'package:taskflow/shared/data/repositories/chat_task_repository_impl.dart';
import 'package:taskflow/features/chat/data/repositories/chat_upload_image_repository_impl.dart';
import 'package:taskflow/features/chat/data/repositories/send_messages_repository_impl.dart';
import 'package:taskflow/features/chat/domain/repositories/chat_group_repo.dart';
import 'package:taskflow/features/chat/domain/repositories/chat_image_picker_repo.dart';
import 'package:taskflow/features/chat/domain/repositories/chat_messages_repo.dart';
import 'package:taskflow/shared/domain/repositories/chat_task_repo.dart';
import 'package:taskflow/features/chat/domain/repositories/chat_upload_image_repo.dart';
import 'package:taskflow/features/chat/domain/repositories/send_messages_repo.dart';
import 'package:taskflow/features/chat/domain/use_cases/chat/listen_to_message_use_case.dart';
import 'package:taskflow/features/chat/domain/use_cases/image/chat_image_picker_use_case.dart';
import 'package:taskflow/features/chat/domain/use_cases/image/chat_upload_image_use_case.dart';
import 'package:taskflow/features/chat/domain/use_cases/chat/create_group_use_case.dart';
import 'package:taskflow/shared/domain/use_cases/create_task_use_case.dart';
import 'package:taskflow/features/chat/domain/use_cases/chat/fetch_messages_use_case.dart';
import 'package:taskflow/features/chat/domain/use_cases/chat/get_chat_group_use_case.dart';
import 'package:taskflow/features/chat/domain/use_cases/chat/get_my_groups_use_case.dart';
import 'package:taskflow/features/chat/domain/use_cases/chat/send_message_use_case.dart';
import 'package:taskflow/shared/domain/use_cases/update_task_use_case.dart';


final authLocator = GetIt.instance;
final sharedLocator = GetIt.instance;
final packagesLocator = GetIt.instance;
final chatLocator = GetIt.instance;
final taskLocator = GetIt.instance;
final profileLocator = GetIt.instance;
final imageLocator = GetIt.instance;
final messageLocator = GetIt.instance;
final webSocketLocator = GetIt.instance;

void setupServiceLocator(){
  //Packages
  packagesLocator.registerLazySingleton<http.Client>(() => http.Client());
  packagesLocator.registerLazySingleton<ImagePicker>(() => ImagePicker());
  packagesLocator.registerLazySingleton<IO.Socket>(() {
    final token = Hive.box('SETTINGS').get('token');

    return IO.io(ApiConstants.webSocket, IO.OptionBuilder()
        .setTransports(['websocket'])  // WebSocket transport
        .setExtraHeaders({'Authorization': 'Bearer $token'})  // Optional for HTTP headers
        .setAuth({'token': token})  // Send token in the handshake
        .build());
  });

  sharedLocator.registerLazySingleton<NotificationServices>(
          () => NotificationServices());
  //Auth
  authLocator.registerLazySingleton<AuthRemoteDataSource>(
          () => AuthRemoteDataSourceImpl(packagesLocator<http.Client>(),sharedLocator<NotificationServices>()));

  authLocator.registerLazySingleton<AuthRepository>(
          () => AuthRepositoryImpl(authLocator<AuthRemoteDataSource>()));

  authLocator.registerLazySingleton(() => LoginUseCase(authLocator<AuthRepository>()));
  authLocator.registerLazySingleton(() => SignupUseCase(authLocator<AuthRepository>()));

  authLocator.registerLazySingleton<ChangePasswordRemoteDataSource>(
          () => ChangePasswordRemoteDataSourceImpl(packagesLocator<http.Client>()));

  authLocator.registerLazySingleton<ChangePasswordRepository>(
          () => ChangePasswordRepositoryImpl(authLocator<ChangePasswordRemoteDataSource>()));

  authLocator.registerLazySingleton(() => ChangePasswordUseCase(authLocator<ChangePasswordRepository>()));
  //web sockets
  webSocketLocator.registerLazySingleton<WebSocketService>(
        () => WebSocketService(webSocketLocator<IO.Socket>()),
  );

  webSocketLocator.registerLazySingleton<StreamController<MessageModel>>(
        () => StreamController<MessageModel>.broadcast(),
  );
  webSocketLocator.registerLazySingleton<SendMessagesWebSocketDataSource>(
        () => SendMessagesWebSocketDataSourceImpl(
      webSocketLocator<WebSocketService>(),
    ),
  );
  webSocketLocator.registerLazySingleton<ReceiveMessagesWebSocketDataSource>(
        () => ReceiveMessagesWebSocketDataSourceImpl(
      webSocketLocator<WebSocketService>(),
      webSocketLocator<StreamController<MessageModel>>(),
    ),
  );

  //chat
  chatLocator.registerLazySingleton<ChatGroupRemoteDataSource>(()=> ChatGroupRemoteDataSourceImpl(packagesLocator<http.Client>()));
  chatLocator.registerLazySingleton<ChatGroupLocalDataSource>(()=> ChatGroupLocalDataSourceImpl());
  chatLocator.registerLazySingleton<ChatGroupRepository>(()=> ChatGroupRepositoryImpl(chatLocator<ChatGroupRemoteDataSource>(),chatLocator<ChatGroupLocalDataSource>()));
  chatLocator.registerLazySingleton(()=> GetMyGroupsUseCase(chatLocator<ChatGroupRepository>()));
  chatLocator.registerLazySingleton(()=> GetChatGroupUseCase(chatLocator<ChatGroupRepository>()));
  chatLocator.registerLazySingleton(()=> CreateGroupUseCase(chatLocator<ChatGroupRepository>()));

  //members
  chatLocator.registerLazySingleton<ChatMemberRemoteDataSource>(()=> ChatMemberRemoteDataSourceImpl(packagesLocator<http.Client>()));
  chatLocator.registerLazySingleton<ChatMemberRepository>(()=> ChatMemberRepositoryImpl(chatLocator<ChatMemberRemoteDataSource>()));
  chatLocator.registerLazySingleton(()=> AddMemberUseCase(chatLocator<ChatMemberRepository>()));
  chatLocator.registerLazySingleton(()=> RemoveMemberUseCase(chatLocator<ChatMemberRepository>()));

  chatLocator.registerLazySingleton<ChatMakeAdminRemoteDataSource>(()=> ChatMakeAdminRemoteDataSourceImpl(packagesLocator<http.Client>()));
  chatLocator.registerLazySingleton<ChatMakeAdminRepository>(()=> ChatMakeAdminRepositoryImpl(chatLocator<ChatMakeAdminRemoteDataSource>()));
  chatLocator.registerLazySingleton(()=> MakeGroupAdminUseCase(chatLocator<ChatMakeAdminRepository>()));

  chatLocator.registerLazySingleton<GroupActionsRemoteDataSource>(()=> GroupActionsRemoteDataSourceImpl(packagesLocator<http.Client>()));
  chatLocator.registerLazySingleton<GroupActionsRepository>(()=> GroupActionsRepositoryImpl(chatLocator<GroupActionsRemoteDataSource>()));
  chatLocator.registerLazySingleton(()=> LeaveGroupUseCase(chatLocator<GroupActionsRepository>()));

  //image
  imageLocator.registerLazySingleton<ChatUploadImageDataSource>(()=>ChatUploadImageDataSourceImpl(packagesLocator<http.Client>()));
  imageLocator.registerLazySingleton<ChatUploadImageRepository>(()=>ChatUploadImageRepositoryImpl(imageLocator<ChatUploadImageDataSource>()));
  imageLocator.registerLazySingleton(()=>ChatUploadImageUseCase(imageLocator<ChatUploadImageRepository>()));

  imageLocator.registerLazySingleton<ChatImagePickerDataSource>(()=>ChatImagePickerDataSourceImpl(packagesLocator<ImagePicker>()));
  imageLocator.registerLazySingleton<ChatImagePickerRepository>(()=>ChatImagePickerRepositoryImpl(imageLocator<ChatImagePickerDataSource>()));
  imageLocator.registerLazySingleton(()=>ChatImagePickerUseCase(imageLocator<ChatImagePickerRepository>()));


  //messages
  messageLocator.registerLazySingleton<ChatMessagesRemoteDataSource>(()=>ChatMessagesRemoteDataSourceImpl(packagesLocator<http.Client>()));
  messageLocator.registerLazySingleton<ChatMessagesLocalDataSource>(()=>ChatMessagesLocalDataSourceImpl());
  messageLocator.registerLazySingleton<ChatMessagesRepository>(()=>ChatMessagesRepositoryImpl(messageLocator<ChatMessagesRemoteDataSource>(),webSocketLocator<ReceiveMessagesWebSocketDataSource>(),messageLocator<ChatMessagesLocalDataSource>()));
  messageLocator.registerLazySingleton(()=>FetchMessageUseCase(messageLocator<ChatMessagesRepository>()));
  webSocketLocator.registerLazySingleton(()=>ListenToMessageUseCase(messageLocator<ChatMessagesRepository>()));

  messageLocator.registerLazySingleton<SendMessagesRepository>(()=>SendMessagesRepositoryImpl(webSocketLocator<SendMessagesWebSocketDataSource>()));
  messageLocator.registerLazySingleton(()=>SendMessageUseCase(messageLocator<SendMessagesRepository>()));

  //tasks
  taskLocator.registerLazySingleton<ChatTaskRemoteDataSource>(()=>ChatTaskRemoteDataSourceImpl(packagesLocator<http.Client>()));
  taskLocator.registerLazySingleton<ChatTaskRepository>(()=>ChatTaskRepositoryImpl(taskLocator<ChatTaskRemoteDataSource>()));
  taskLocator.registerLazySingleton(()=>CreateTaskUseCase(taskLocator<ChatTaskRepository>()));
  taskLocator.registerLazySingleton(()=>UpdateTaskUseCase(taskLocator<ChatTaskRepository>()));

  taskLocator.registerLazySingleton<MyTasksRemoteDataSource>(()=>MyTasksRemoteDataSourceImpl(packagesLocator<http.Client>()));
  taskLocator.registerLazySingleton<MyTasksLocalDataSource>(()=>MyTasksLocalDataSourceImpl());
  taskLocator.registerLazySingleton<MyTasksRepository>(()=>MyTasksRepositoryImpl(taskLocator<MyTasksRemoteDataSource>(),taskLocator<MyTasksLocalDataSource>()));
  taskLocator.registerLazySingleton(()=>FetchMyTasksUseCase(taskLocator<MyTasksRepository>()));

  //profile
  profileLocator.registerLazySingleton<MyProfileRemoteDataSource>(()=>MyProfileRemoteDataSourceImpl(packagesLocator<http.Client>()));
  profileLocator.registerLazySingleton<MyProfileLocalDataSource>(()=>MyProfileLocalDataSourceImpl());
  profileLocator.registerLazySingleton<MyProfileRepository>(()=>MyProfileRepositoryImpl(profileLocator<MyProfileRemoteDataSource>(),profileLocator<MyProfileLocalDataSource>()));
  profileLocator.registerLazySingleton(()=>GetMyProfileUseCase(profileLocator<MyProfileRepository>()));


}

