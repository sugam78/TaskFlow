import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:taskflow/core/routes/routes.dart';

class NotificationServices {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> requestNotificationPermission() async {
    //NotificationSettings settings =
    await firebaseMessaging.requestPermission(
      alert: true,
      sound: true,
      badge: true,
    );
  }

  void firebaseInit() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (Platform.isAndroid) {
        initLocalNotifications(message);
        _showNotification(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationNavigation(message.data);
    });

    _setupBackgroundNotificationListener();
  }

  void _setupBackgroundNotificationListener() async {
    RemoteMessage? initialMessage = await firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationNavigation(initialMessage.data);
    }
  }

  Future<void> initLocalNotifications(RemoteMessage message) async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings);

    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handleNotificationNavigation(message.data);
      },
    );

    await createNotificationChannel();
  }

  Future<void> createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'Channel for important notifications',
      importance: Importance.max,
    );

    final androidPlugin =
        _localNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(channel);
    }
  }

  Future<void> _showNotification(RemoteMessage message) async {
    try {
      final RemoteNotification? notification = message.notification;
      final AndroidNotification? android = notification?.android;

      if (notification != null && android != null) {
        const String channelId = 'high_importance_channel';

        AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
          channelId,
          'High Importance Notifications',
          channelDescription: 'Used for important notifications',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
        );

        NotificationDetails platformDetails = NotificationDetails(
          android: androidDetails,
        );

        await _localNotificationsPlugin.show(
          notification.hashCode,
          notification.title ?? 'No Title',
          notification.body ?? 'No Body',
          platformDetails,
        );

        debugPrint("Notification displayed successfully.");
      } else {
        debugPrint("Notification or Android details are null.");
      }
    } catch (e, stackTrace) {
      debugPrint("Error in _showNotification: $e\n$stackTrace");
    }
  }

  void _handleNotificationNavigation(Map<String, dynamic> data) async {
    String? token = await Hive.box('SETTINGS').get('token');

    if (token != null && rootNavigatorKey.currentContext != null) {
      String? screen = data['screen'];
      String? extra = data['extra'];

      debugPrint("Received screen: $screen, groupId: $extra");

      if (screen != null) {
        rootNavigatorKey.currentContext!.pushNamed(screen, extra: extra);
      }
    }
  }

  Future<String?> getToken() async {
    try {
      final token = await firebaseMessaging.getToken();
      return token;
    } catch (e) {
      return null;
    }
  }
}
