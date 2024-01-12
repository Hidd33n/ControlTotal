// ignore_for_file: unused_local_variable

import 'package:calcu/pages/authsystem/auth.dart';
import 'package:calcu/pages/home_view.dart';
import 'package:calcu/pages/noti_view.dart';
import 'package:calcu/pages/search_view.dart';
import 'package:calcu/pages/settings_view.dart';
import 'package:calcu/assets/ui/nav.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Verificar si el usuario está autenticado en Firebase
  bool isAuthenticated = false;
  firebase_auth.User? user = firebase_auth.FirebaseAuth.instance.currentUser;
  if (user != null) {
    isAuthenticated = true;
  }
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('es', 'ES')],
      path:
          'assets/translations', // <-- change the path of the translation files
      fallbackLocale: const Locale('en', 'US'),
      startLocale: const Locale('en', 'US'),
      child: MyApp(isAuthenticated: isAuthenticated),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isAuthenticated; // Determina si el usuario está autenticado

  const MyApp({Key? key, required this.isAuthenticated}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) =>
            isAuthenticated ? const NavigationScreen() : const AuthPage(),
        '/home': (context) => const HomePage(),
        '/noti': (context) => const NotifyView(),
        '/search': (context) => const SearchView(),
        '/settings': (context) => SettingsView(),
      },
      initialRoute: '/',
      builder: (context, child) {
        // Escuchar notificaciones entrantes
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          String tituloNotificacion =
              message.notification?.title ?? 'Sin título';
        });

        return child!;
      },
    );
  }
}
