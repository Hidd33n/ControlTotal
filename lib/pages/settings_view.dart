import 'package:calcu/assets/functions/settings_service.dart';
import 'package:calcu/assets/ui/themes/theme_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final SettingsServices settingsService = SettingsServices();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    User? currentUser = _auth.currentUser;
    String displayName = currentUser?.displayName ?? 'N/A';
    String email = currentUser?.email ?? 'N/A';
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primary,
        child: ListView(children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Text(
                    displayName,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    email,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  const Divider(
                    color: Colors.white,
                    thickness: 2.0,
                  ),
                ],
              ),
            ),
          ),
          ...ListTile.divideTiles(
            context: context,
            tiles: [
              ListTile(
                leading: const Icon(Icons.attach_money),
                title: Text(
                  'fix taxs'.tr(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () => settingsService.taxessettings(context),
              ),
              ListTile(
                leading: const Icon(Icons.abc_sharp),
                title: Text(
                  context.locale.languageCode == 'en' ? 'es'.tr() : 'en'.tr(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () async => await (context.setLocale(
                  context.locale.languageCode == 'en'
                      ? const Locale('es', 'ES')
                      : const Locale('en', 'US'),
                )),
              ),
              ListTile(
                leading: Icon(
                  ThemeManager.currentThemeMode == ThemeMode.light
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
                title: Text(
                  ThemeManager.currentThemeMode == ThemeMode.light
                      ? 'lighttheme'.tr()
                      : 'darktheme'.tr(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  ThemeMode currentTheme = ThemeManager.currentThemeMode;
                  ThemeManager.setTheme(
                    currentTheme == ThemeMode.light
                        ? ThemeMode.dark
                        : ThemeMode.light,
                  );
                  setState(() {});
                },
              ),

              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: Text(
                  'logout'.tr(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () => settingsService.confirmSignOut(context),
              ),
              // Agrega más ListTiles aquí para otros ajustes si es necesario
            ],
          ).toList(),
        ]),
      ),
    );
  }
}
