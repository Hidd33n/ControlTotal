import 'package:calcu/assets/ui/themes/theme_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class Slider1 extends StatefulWidget {
  const Slider1({super.key});

  @override
  State<Slider1> createState() => _Slider1State();
}

class _Slider1State extends State<Slider1> {
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
                      height: 60,
                    ),
                    Center(
                        child: ElevatedButton(
                      onPressed: () {
                        ThemeMode currentTheme = ThemeManager.currentThemeMode;
                        ThemeManager.setTheme(
                          currentTheme == ThemeMode.light
                              ? ThemeMode.dark
                              : ThemeMode.light,
                        );
                        ThemeManager.saveTheme();
                        setState(() {});
                      },
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
                            color: ThemeManager.currentThemeMode ==
                                    ThemeMode.light
                                ? Colors.black // Color del ícono en light theme
                                : Colors.white, // Color del ícono en dark theme
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
                    )),
                    //Change Lenguage
                    const SizedBox(
                      height: 60,
                    ),
                    Text('slidertext1'.tr(),
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontSize: 20.0,
                                )),
                    const SizedBox(
                      height: 60,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await context.setLocale(
                          context.locale.languageCode == 'en'
                              ? const Locale('es', 'ES')
                              : const Locale('en', 'US'),
                        );
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.language,
                            size: 40,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            context.locale.languageCode == 'en'
                                ? 'es'.tr()
                                : 'en'.tr(),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
