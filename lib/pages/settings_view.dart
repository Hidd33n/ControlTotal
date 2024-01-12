import 'package:calcu/assets/functions/settings_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class SettingsView extends StatelessWidget {
  final SettingsServices settingsService = SettingsServices();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  SettingsView({super.key});

  // Esta función maneja el cierre de sesión

  @override
  Widget build(BuildContext context) {
    User? currentUser = _auth.currentUser;
    String displayName = currentUser?.displayName ?? 'N/A';
    String email = currentUser?.email ?? 'N/A';
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: ListView(children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Text(
                    displayName,
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontFamily: 'poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 18.0, // Ajusta el tamaño según tu preferencia
                      ),
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    email,
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontFamily: 'poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0, // Ajusta el tamaño según tu preferencia
                      ),
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                      height:
                          8.0), // Ajusta el espacio entre los textos y la lista
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
                  style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          fontFamily: 'poppins', fontWeight: FontWeight.w400),
                      color: Colors.white),
                ),
                onTap: () => settingsService.taxessettings(context),
              ),
              context.locale.languageCode == 'en'
                  ? ListTile(
                      leading: const Icon(Icons.abc_sharp),
                      title: Text(
                        'es'.tr(),
                        style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.w400),
                            color: Colors.white),
                      ),
                      onTap: () async =>
                          await (context.setLocale(const Locale('es', 'ES'))),
                    )
                  : ListTile(
                      leading: const Icon(Icons.abc_sharp),
                      title: Text(
                        'en'.tr(),
                        style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.w400),
                            color: Colors.white),
                      ),
                      onTap: () async =>
                          await (context.setLocale(const Locale('en', 'US'))),
                    ),
              ListTile(
                leading: const Icon(Icons.dangerous),
                title: Text(
                  'cooming soon'.tr(),
                  style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          fontFamily: 'poppins', fontWeight: FontWeight.w400),
                      color: Colors.white),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: Text(
                  'logout'.tr(),
                  style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          fontFamily: 'poppins', fontWeight: FontWeight.w400),
                      color: Colors.white),
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
