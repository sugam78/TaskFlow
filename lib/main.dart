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
import 'package:taskflow/core/services/service_locator.dart';
import 'package:taskflow/features/auth/domain/use_cases/login.dart';
import 'package:taskflow/features/auth/domain/use_cases/signup.dart';
import 'package:taskflow/features/auth/presentation/manager/auth_bloc.dart';
import 'package:taskflow/firebase_options.dart';

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
