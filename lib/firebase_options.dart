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
    apiKey: 'AIzaSyAJJD-Ge---CX0Z4sHfDtETXMis7g5vBPg',
    appId: '1:500077980521:web:be1b7a0abf09fa63242bf8',
    messagingSenderId: '500077980521',
    projectId: 'easycalcu',
    authDomain: 'easycalcu.firebaseapp.com',
    databaseURL: 'https://easycalcu-default-rtdb.firebaseio.com',
    storageBucket: 'easycalcu.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDp4285igOOYHU1aAFd3unXtKZhvlHS5-8',
    appId: '1:500077980521:android:1844dc2ff1ba45c2242bf8',
    messagingSenderId: '500077980521',
    projectId: 'easycalcu',
    databaseURL: 'https://easycalcu-default-rtdb.firebaseio.com',
    storageBucket: 'easycalcu.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyACVsPkaCpVDFqF0VauzTA6fjwlddxd4vg',
    appId: '1:500077980521:ios:6f7c0c03220a0357242bf8',
    messagingSenderId: '500077980521',
    projectId: 'easycalcu',
    databaseURL: 'https://easycalcu-default-rtdb.firebaseio.com',
    storageBucket: 'easycalcu.appspot.com',
    iosBundleId: 'com.argrealms.calcu',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyACVsPkaCpVDFqF0VauzTA6fjwlddxd4vg',
    appId: '1:500077980521:ios:bccd3b2fd55dc3e1242bf8',
    messagingSenderId: '500077980521',
    projectId: 'easycalcu',
    databaseURL: 'https://easycalcu-default-rtdb.firebaseio.com',
    storageBucket: 'easycalcu.appspot.com',
    iosBundleId: 'com.argrealms.calcu.RunnerTests',
  );
}
