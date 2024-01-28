import 'package:calcu/core/ui/themes/theme_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ThemeChangeButton extends StatelessWidget {
  final VoidCallback onThemeChange;

  const ThemeChangeButton({super.key, required this.onThemeChange});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onThemeChange,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      child: Column(
        children: [
          Icon(
            ThemeManager.currentThemeMode == ThemeMode.light
                ? Icons.light_mode
                : Icons.dark_mode,
            size: 40,
            color: ThemeManager.currentThemeMode == ThemeMode.light
                ? Theme.of(context).textTheme.bodyLarge?.color
                : Theme.of(context)
                    .colorScheme
                    .onPrimary, // Puedes ajustar el color aquí según tu diseño
          ),
          const SizedBox(height: 8),
          Text(
            ThemeManager.currentThemeMode == ThemeMode.light
                ? 'lighttheme'.tr()
                : 'darktheme'.tr(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
