// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBE1aWCpZOk_ebijppGd5TewgKIT3B2NxU',
    appId: '1:561873972185:web:c670b819840d75e70947c8',
    messagingSenderId: '561873972185',
    projectId: 'taskflow-10e78',
    authDomain: 'taskflow-10e78.firebaseapp.com',
    storageBucket: 'taskflow-10e78.firebasestorage.app',
    measurementId: 'G-K1ZZ6XY5TE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDUPYuvJcVBHb--_iXtRP-wLCPZPXApeUo',
    appId: '1:561873972185:android:100541887b90042e0947c8',
    messagingSenderId: '561873972185',
    projectId: 'taskflow-10e78',
    storageBucket: 'taskflow-10e78.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCCpd7LNoXNCo0hNAvnE-D9dwaqWhe5m1A',
    appId: '1:561873972185:ios:2be4cef098e554a70947c8',
    messagingSenderId: '561873972185',
    projectId: 'taskflow-10e78',
    storageBucket: 'taskflow-10e78.firebasestorage.app',
    iosBundleId: 'com.example.taskflow',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCCpd7LNoXNCo0hNAvnE-D9dwaqWhe5m1A',
    appId: '1:561873972185:ios:2be4cef098e554a70947c8',
    messagingSenderId: '561873972185',
    projectId: 'taskflow-10e78',
    storageBucket: 'taskflow-10e78.firebasestorage.app',
    iosBundleId: 'com.example.taskflow',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBE1aWCpZOk_ebijppGd5TewgKIT3B2NxU',
    appId: '1:561873972185:web:ebe27fd39dfd361b0947c8',
    messagingSenderId: '561873972185',
    projectId: 'taskflow-10e78',
    authDomain: 'taskflow-10e78.firebaseapp.com',
    storageBucket: 'taskflow-10e78.firebasestorage.app',
    measurementId: 'G-H3SYBN1VGF',
  );
}
