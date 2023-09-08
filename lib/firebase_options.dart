// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyASOmb3QarL28iwvKDP_QtSfYsOGi0JfFo',
    appId: '1:635344454487:web:7f722a9d586e56a50e7412',
    messagingSenderId: '635344454487',
    projectId: 'mohammedabdproject',
    authDomain: 'mohammedabdproject.firebaseapp.com',
    storageBucket: 'mohammedabdproject.appspot.com',
    measurementId: 'G-ZPN3KWR0CX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBCgsj7GA0I1mLKM5F150EoAfoo7eG1jjc',
    appId: '1:635344454487:android:64d4a186e53bf7d10e7412',
    messagingSenderId: '635344454487',
    projectId: 'mohammedabdproject',
    storageBucket: 'mohammedabdproject.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDXevNKfu5VysNy3W6oDnrC1R39TPJYUhk',
    appId: '1:635344454487:ios:8bbddd69c8343e4e0e7412',
    messagingSenderId: '635344454487',
    projectId: 'mohammedabdproject',
    storageBucket: 'mohammedabdproject.appspot.com',
    iosClientId: '635344454487-lk8qoaqh2js0bsebkm67njo80fde7t34.apps.googleusercontent.com',
    iosBundleId: 'com.example.mohammedabdnewproject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDXevNKfu5VysNy3W6oDnrC1R39TPJYUhk',
    appId: '1:635344454487:ios:8bbddd69c8343e4e0e7412',
    messagingSenderId: '635344454487',
    projectId: 'mohammedabdproject',
    storageBucket: 'mohammedabdproject.appspot.com',
    iosClientId: '635344454487-lk8qoaqh2js0bsebkm67njo80fde7t34.apps.googleusercontent.com',
    iosBundleId: 'com.example.mohammedabdnewproject',
  );
}
