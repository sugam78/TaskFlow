import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskflow/core/common/cubit/password_visibility/password_visibility_cubit.dart';
import 'package:taskflow/core/common/cubit/theme_cubit/theme_cubit.dart';
import 'package:taskflow/core/resources/dimensions.dart';
import 'package:taskflow/core/resources/theme.dart';
import 'package:taskflow/core/routes/routes.dart';
import 'package:taskflow/core/services/notification_services.dart';
import 'package:taskflow/core/services/service_locator.dart';
import 'package:taskflow/features/auth/domain/use_cases/login.dart';
import 'package:taskflow/features/auth/domain/use_cases/signup.dart';
import 'package:taskflow/features/auth/presentation/manager/auth_bloc.dart';
import 'package:taskflow/features/chat/domain/use_cases/chat/create_group_use_case.dart';
import 'package:taskflow/features/chat/domain/use_cases/chat/fetch_messages_use_case.dart';
import 'package:taskflow/features/chat/domain/use_cases/chat/get_chat_group_use_case.dart';
import 'package:taskflow/features/chat/domain/use_cases/chat/get_my_groups_use_case.dart';
import 'package:taskflow/features/chat/domain/use_cases/chat/listen_to_message_use_case.dart';
import 'package:taskflow/features/chat/domain/use_cases/chat/send_message_use_case.dart';
import 'package:taskflow/features/chat/domain/use_cases/image/chat_image_picker_use_case.dart';
import 'package:taskflow/features/chat/domain/use_cases/image/chat_upload_image_use_case.dart';
import 'package:taskflow/features/chat/presentation/manager/chat_messages_bloc/chat_messages_bloc.dart';
import 'package:taskflow/features/chat/presentation/manager/chat_pick_image_bloc/chat_pick_image_bloc.dart';
import 'package:taskflow/features/chat/presentation/manager/chat_upload_image_bloc/chat_upload_image_bloc.dart';
import 'package:taskflow/features/chat/presentation/manager/create_group_bloc/create_group_bloc.dart';
import 'package:taskflow/features/chat/presentation/manager/group_details_bloc/group_details_bloc.dart';
import 'package:taskflow/features/chat/presentation/manager/my_groups_bloc/my_groups_bloc.dart';
import 'package:taskflow/features/chat/presentation/manager/send_messages_bloc/send_message_bloc.dart';
import 'package:taskflow/features/my_tasks/domain/use_cases/fetch_my_tasks_use_case.dart';
import 'package:taskflow/features/my_tasks/presentation/manager/my_tasks_bloc/my_tasks_bloc.dart';
import 'package:taskflow/features/profile/domain/use_cases/get_my_profile_use_case.dart';
import 'package:taskflow/features/profile/presentation/manager/my_profile_bloc/my_profile_bloc.dart';
import 'package:taskflow/features/security/domain/use_cases/change_password_use_case.dart';
import 'package:taskflow/features/security/presentation/manager/change_password_bloc/change_password_bloc.dart';
import 'package:taskflow/firebase_options.dart';
import 'package:taskflow/shared/domain/use_cases/create_task_use_case.dart';
import 'package:taskflow/shared/domain/use_cases/update_task_use_case.dart';
import 'package:taskflow/shared/presentation/manager/chat_task_bloc/chat_task_bloc.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Hive.initFlutter();
  await  Hive.openBox('SETTINGS');
  await  Hive.openBox('Biometrics');
  final settingsBox = await Hive.openBox('SettingBox');

  setupServiceLocator();

  runApp( MyApp(settingsBox: settingsBox,));
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message)async {
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  final Box settingsBox;
  const MyApp({super.key, required this.settingsBox});

  @override
  Widget build(BuildContext context) {
    NotificationServices().firebaseInit();
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PasswordVisibilityCubit()),
        BlocProvider(
            create: (context) => AuthBloc(
              authLocator<LoginUseCase>(),
              authLocator<SignupUseCase>(),
            )),
        BlocProvider(
            create: (context) => MyGroupsBloc(chatLocator<GetMyGroupsUseCase>())),
        BlocProvider(
            create: (context) => CreateGroupBloc(chatLocator<CreateGroupUseCase>())),
        BlocProvider(
            create: (context) => GroupDetailsBloc(chatLocator<GetChatGroupUseCase>())),
        BlocProvider(
            create: (context) => ChatMessagesBloc(messageLocator<FetchMessageUseCase>(),messageLocator<ListenToMessageUseCase>())),
        BlocProvider(
            create: (context) => SendMessageBloc(messageLocator<SendMessageUseCase>())),
        BlocProvider(
            create: (context) => ChatTaskBloc(taskLocator<CreateTaskUseCase>(),taskLocator<UpdateTaskUseCase>())),
        BlocProvider(
            create: (context) => ChatUploadImageBloc(imageLocator<ChatUploadImageUseCase>())),
        BlocProvider(
            create: (context) => ChatPickImageBloc(imageLocator<ChatImagePickerUseCase>())),
        BlocProvider(
            create: (context) => MyTasksBloc(taskLocator<FetchMyTasksUseCase>())),
        BlocProvider(
            create: (context) => MyProfileBloc(profileLocator<GetMyProfileUseCase>())),
        BlocProvider(
            create: (context) => ChangePasswordBloc(authLocator<ChangePasswordUseCase>())),
        BlocProvider(
            create: (context) => ThemeCubit(settingsBox)),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: state,
            routerConfig: route,

          );
        },
      ),
    );
  }
}
