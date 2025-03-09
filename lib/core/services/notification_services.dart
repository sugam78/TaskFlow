import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      sound: true,
      badge: true,
      provisional: true,
      announcement: true,
      criticalAlert: true,
      carPlay: true,
    );
  }

  void firebaseInit(){
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if(Platform.isAndroid) {
        initLocalNotifications();
        _showNotification(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    });
  }

  void initLocalNotifications()async{
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidSettings,
    );
    await _localNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (payload){
        }
    );
  }

  Future<void> _showNotification(RemoteMessage message) async {
    final RemoteNotification? notification = message.notification;
    final AndroidNotification? android = notification?.android;
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(100000).toString(),
        'High Importance Notifications',
        importance: Importance.max
    );

    if (notification != null && android != null) {
      AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        channel.id,
        channel.name,
        importance: channel.importance,
        priority: Priority.high,
        showWhen: true,
      );
      final darwinNotificationDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      NotificationDetails platformDetails = NotificationDetails(
          android: androidDetails,
          iOS: darwinNotificationDetails
      );

      await _localNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        platformDetails,
      );
    }
  }

  Future<String> getToken() async {
    final token = await firebaseMessaging.getToken();
    return token!;
  }
}
