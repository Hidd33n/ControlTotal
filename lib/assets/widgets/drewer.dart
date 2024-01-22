import 'package:calcu/assets/ui/themes/theme_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  final User? currentUser;
  final VoidCallback onFixTaxes;
  final Future<void> Function() onToggleLanguage;
  final VoidCallback onToggleTheme;
  final VoidCallback onLogout;

  MyDrawer({
    required this.currentUser,
    required this.onFixTaxes,
    required this.onToggleLanguage,
    required this.onToggleTheme,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    String displayName = currentUser?.displayName ?? 'N/A';
    String email = currentUser?.email ?? 'N/A';

    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(displayName),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.attach_money),
            title: Text(
              'fix taxs'.tr(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            onTap: onFixTaxes,
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(
              context.locale.languageCode == 'en' ? 'es'.tr() : 'en'.tr(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            onTap: () async => await onToggleLanguage(),
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
            onTap: onToggleTheme,
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: Text(
              'logout'.tr(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}
