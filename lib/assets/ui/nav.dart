import 'package:calcu/pages/authsystem/auth.dart';
import 'package:calcu/pages/home_view.dart';
import 'package:calcu/pages/noti_view.dart';
import 'package:calcu/pages/search_view.dart';
import 'package:calcu/pages/settings_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:badges/badges.dart' as badges;

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;
  int _unReadNotificationsCount =
      0; // Añadir variable para el recuento de notificaciones no leídas

  @override
  void initState() {
    super.initState();
    listenToNotifications(); // Añadir llamada a la función que escucha las notificaciones
  }

  // Función para escuchar las notificaciones
  void listenToNotifications() {
    firebase_auth.User? user = firebase_auth.FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('notifications')
          .where('read',
              isEqualTo:
                  false) // Asegúrate de tener un campo 'read' en tus documentos de notificaciones
          .snapshots()
          .listen((snapshot) {
        setState(() {
          _unReadNotificationsCount = snapshot
              .docs.length; // Actualizar con el número de documentos no leídos
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<firebase_auth.User?>(
      stream: firebase_auth.FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Añadir chequeo de conexión y de error si es necesario

        // Si el snapshot tiene datos y por lo tanto el usuario está autenticado, mostramos la pantalla de navegación
        if (snapshot.hasData) {
          return Scaffold(
            body: Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
            bottomNavigationBar: _buildBottomNavigationBar(),
          );
        } else {
          // Si no hay datos, el usuario no está autenticado y mostramos la pantalla de autenticación
          return const AuthPage(); // Asegúrate de que AuthPage es tu página de inicio de sesión/registro
        }
      },
    );
  }

  Card _buildBottomNavigationBar() {
    return Card(
      elevation: 8, // Ajusta el valor de la elevación según sea necesario
      margin: EdgeInsets
          .zero, // Para evitar un pequeño espacio adicional alrededor del Card
      child: Container(
        decoration: BoxDecoration(
          color: Colors.teal,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.tealAccent,
              hoverColor: Colors.tealAccent,
              gap: 8,
              activeColor: Colors.grey[500],
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.teal,
              color: Colors.black,
              tabs: [
                GButton(
                  icon: LineIcons.home,
                  iconColor: Colors.white,
                  text: 'home'.tr(),
                  textStyle: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          fontFamily: 'poppins', fontWeight: FontWeight.w400),
                      color: Colors.white),
                ),
                GButton(
                  icon: LineIcons.heart,
                  iconColor: Colors.white,
                  text: 'Noti',
                  textStyle: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          fontFamily: 'poppins', fontWeight: FontWeight.w400),
                      color: Colors.white),
                  // Añadir el recuento de notificaciones no leídas como insignia
                  leading: _unReadNotificationsCount > 0
                      ? badges.Badge(
                          badgeContent: Text(
                              _unReadNotificationsCount > 99
                                  ? '99+'
                                  : '$_unReadNotificationsCount',
                              style: const TextStyle(color: Colors.white)),
                          child: const Icon(LineIcons.heart),
                        )
                      : null,
                ),
                GButton(
                  icon: LineIcons.search,
                  iconColor: Colors.white,
                  text: 'search'.tr(),
                  textStyle: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          fontFamily: 'poppins', fontWeight: FontWeight.w400),
                      color: Colors.white),
                ),
                GButton(
                  icon: LineIcons.user,
                  iconColor: Colors.white,
                  text: 'settings'.tr(),
                  textStyle: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          fontFamily: 'poppins', fontWeight: FontWeight.w400),
                      color: Colors.white),
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  // Definir las opciones de widget fuera del método build para evitar recrear el estado cada vez
  static final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const NotifyView(),
    const SearchView(),
    SettingsView()
  ];
}
