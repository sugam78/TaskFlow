import 'dart:async';


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/services/notification_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), (){
       navigate();
    });
  }
  void navigate() async {
    String? token = await Hive.box('SETTINGS').get('token');

    if (!mounted) return;

    if (token == null) {
      context.go('/login');
    } else {
      context.go('/chatHome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text('Taskflow'),
          ),
        ],
      ),
    );
  }
}
