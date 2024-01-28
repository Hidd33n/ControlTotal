import 'package:calcu/core/ui/themes/theme_manager.dart';
import 'package:calcu/presentation/landing/slider_landing/widgets/slider1_lan.button.dart';
import 'package:calcu/presentation/landing/slider_landing/widgets/slider1_theme_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class Slider1 extends StatefulWidget {
  const Slider1({super.key});

  @override
  State<Slider1> createState() => _Slider1State();
}

class _Slider1State extends State<Slider1> {
  void _handleThemeChange() {
    ThemeMode newThemeMode = ThemeManager.currentThemeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;

    ThemeManager.setTheme(newThemeMode);
    ThemeManager.saveTheme();

    setState(() {});
  }

  void _handleLanguageChange() async {
    await context.setLocale(
      context.locale.languageCode == 'en'
          ? const Locale('es', 'ES')
          : const Locale('en', 'US'),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //logo
                    Icon(
                      Icons.library_books_rounded,
                      size: 60,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    const SizedBox(height: 20),

                    //Primera frase
                    Text('welcome'.tr(),
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontSize: 20.0,
                                )),
                    const SizedBox(
                      height: 10,
                    ),
                    //Segunda frase
                    Text(
                      'slidersub1'.tr(),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    //Change theme
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                        child: ThemeChangeButton(
                            onThemeChange: _handleThemeChange)),
                    //Change Lenguage
                    const SizedBox(
                      height: 30,
                    ),
                    Text('slidertext1'.tr(),
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontSize: 20.0,
                                )),
                    const SizedBox(
                      height: 30,
                    ),
                    LanButton(LanChange: _handleLanguageChange)
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
