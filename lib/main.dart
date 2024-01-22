import 'package:calcu/assets/ui/themes/theme_manager.dart';
import 'package:calcu/pages/authsystem/auth.dart';
import 'package:calcu/pages/home_view.dart';
import 'package:calcu/pages/landing_view.dart';
import 'package:calcu/pages/noti_view.dart';
import 'package:calcu/pages/search_view.dart';
import 'package:calcu/pages/settings_view.dart';
import 'package:calcu/assets/widgets/nav.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'package:calcu/assets/ui/themes/light_theme.dart' as light;
import 'package:calcu/assets/ui/themes/dark_theme.dart' as dark;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await ThemeManager.loadTheme();

  bool isAuthenticated = false;
  firebase_auth.User? user = firebase_auth.FirebaseAuth.instance.currentUser;
  if (user != null) {
    isAuthenticated = true;
  }
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('es', 'ES')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      startLocale: const Locale('en', 'US'),
      child: MyApp(isAuthenticated: isAuthenticated),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isAuthenticated;

  const MyApp({Key? key, required this.isAuthenticated}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ThemeMode>(
      stream: ThemeManager.themeChanges,
      initialData: ThemeManager.currentThemeMode,
      builder: (context, snapshot) {
        ThemeMode selectedTheme = snapshot.data ?? ThemeMode.system;

        // Si no hay un tema guardado, selecciona el tema claro como predeterminado
        if (selectedTheme == ThemeMode.system) {
          selectedTheme = ThemeMode.light;
        }

        print('Selected theme: $selectedTheme');
        return MaterialApp(
          key: key,
          themeMode: selectedTheme,
          theme: selectedTheme == ThemeMode.light
              ? light.lightTheme
              : ThemeData.light(),
          darkTheme: selectedTheme == ThemeMode.dark
              ? dark.darkTheme
              : ThemeData.dark(),
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          routes: {
            '/': (context) =>
                isAuthenticated ? const NavigationScreen() : const AuthPage(),
            '/landing': (context) => LandingPage(),
            '/home': (context) => const HomePage(),
            '/noti': (context) => const NotifyView(),
            '/search': (context) => const SearchView(),
            '/settings': (context) => const SettingsView(),
          },
          initialRoute: '/landing',
          builder: (context, child) {
            FirebaseMessaging.onMessage.listen((RemoteMessage message) {});

            return child!;
          },
        );
      },
    );
  }
}
