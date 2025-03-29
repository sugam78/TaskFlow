
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflow/core/common/widgets/bottom_nav_bar.dart';
import 'package:taskflow/features/profile/presentation/pages/my_profile.dart';
import 'package:taskflow/features/auth/presentation/pages/login_screen.dart';
import 'package:taskflow/features/auth/presentation/pages/signup_screen.dart';
import 'package:taskflow/features/chat/presentation/pages/chat_group_details.dart';
import 'package:taskflow/features/my_tasks/presentation/pages/task_home.dart';
import 'package:taskflow/features/security/presentation/pages/change_password.dart';
import 'package:taskflow/features/splash/presentation/pages/splash_screen.dart';
import 'package:taskflow/features/chat/presentation/pages/chat_home.dart';


final rootNavigatorKey = GlobalKey<NavigatorState>();
final rootNavigatorHomeKey = GlobalKey<NavigatorState>();
final rootNavigatorHistoryKey = GlobalKey<NavigatorState>();
final rootNavigatorProfileKey = GlobalKey<NavigatorState>();

final route = GoRouter(
    initialLocation: '/splash',
    navigatorKey: rootNavigatorKey,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return BottomNavBar(
            navigationShell: navigationShell,
          );
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: rootNavigatorHomeKey,
            routes: [
              GoRoute(
                path: '/chatHome',
                name: 'chatHome',
                pageBuilder: (context, state) => customAnimatedSwitcher(
                  key: state.pageKey,
                  child: const ChatHome(),
                ),
                builder: (context, state) => const ChatHome(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: rootNavigatorHistoryKey,
            routes: [
              GoRoute(
                path: '/taskHome',
                name: 'taskHome',
                pageBuilder: (context, state) => customAnimatedSwitcher(
                  key: state.pageKey,
                  child: const TaskHome(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: rootNavigatorProfileKey,
            routes: [
              GoRoute(
                path: '/myProfile',
                name: 'myProfile',
                pageBuilder: (context, state) => customAnimatedSwitcher(
                  key: state.pageKey,
                  child: const MyProfile(),
                ),
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/changePassword',
        name: 'changePassword',
        builder: (context, state) => const ChangePassword(),
      ),
      GoRoute(
        path: '/chatGroupDetails',
        name: 'chatGroupDetails',
        builder: (context, state) {
          final groupId = state.extra as String;
          return ChatGroupDetails(groupId: groupId);
        },
      ),

    ]);
customAnimatedSwitcher({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage(
    key: key,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offsetAnimation = Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeIn,
        ),
      );

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}
