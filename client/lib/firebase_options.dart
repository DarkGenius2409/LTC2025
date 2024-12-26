// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyAg6QDCgK-Eyl4XdJ9j-sLN6EfLuo4gmRM',
    appId: '1:753680020144:web:7e84bac07d5461c99c4175',
    messagingSenderId: '753680020144',
    projectId: 'ltc2025-81ee7',
    authDomain: 'ltc2025-81ee7.firebaseapp.com',
    storageBucket: 'ltc2025-81ee7.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAahFqSrunjW3w-x09Tty8nERWGBUVjx2c',
    appId: '1:753680020144:android:770ff56928866d159c4175',
    messagingSenderId: '753680020144',
    projectId: 'ltc2025-81ee7',
    storageBucket: 'ltc2025-81ee7.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBGHz-rmUaZnyJ11L_XJ5MBPLncd4GrQnc',
    appId: '1:753680020144:ios:b6a047f3fa19fda79c4175',
    messagingSenderId: '753680020144',
    projectId: 'ltc2025-81ee7',
    storageBucket: 'ltc2025-81ee7.firebasestorage.app',
    iosBundleId: 'com.example.client',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBGHz-rmUaZnyJ11L_XJ5MBPLncd4GrQnc',
    appId: '1:753680020144:ios:b6a047f3fa19fda79c4175',
    messagingSenderId: '753680020144',
    projectId: 'ltc2025-81ee7',
    storageBucket: 'ltc2025-81ee7.firebasestorage.app',
    iosBundleId: 'com.example.client',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAg6QDCgK-Eyl4XdJ9j-sLN6EfLuo4gmRM',
    appId: '1:753680020144:web:ef1f2b2a525a62db9c4175',
    messagingSenderId: '753680020144',
    projectId: 'ltc2025-81ee7',
    authDomain: 'ltc2025-81ee7.firebaseapp.com',
    storageBucket: 'ltc2025-81ee7.firebasestorage.app',
  );
}