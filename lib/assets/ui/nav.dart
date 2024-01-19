import 'package:calcu/pages/authsystem/auth.dart';
import 'package:calcu/pages/home_view.dart';
import 'package:calcu/pages/noti_view.dart';
import 'package:calcu/pages/search_view.dart';
import 'package:calcu/pages/settings_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
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
  int _unReadNotificationsCount = 0;

  @override
  void initState() {
    super.initState();
    listenToNotifications();
  }

  void listenToNotifications() {
    firebase_auth.User? user = firebase_auth.FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('notifications')
          .where('read', isEqualTo: false)
          .snapshots()
          .listen((snapshot) {
        setState(() {
          _unReadNotificationsCount = snapshot.docs.length;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<firebase_auth.User?>(
      stream: firebase_auth.FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            body: Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
            bottomNavigationBar: _buildBottomNavigationBar(),
          );
        } else {
          return const AuthPage();
        }
      },
    );
  }

  Card _buildBottomNavigationBar() {
    return Card(
      elevation: 8,
      margin: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Theme.of(context).colorScheme.primary,
              hoverColor: Theme.of(context).colorScheme.primary,
              gap: 8,
              activeColor: Theme.of(context).colorScheme.shadow,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Theme.of(context).colorScheme.primary,
              color: Theme.of(context).colorScheme.onPrimary,
              tabs: [
                GButton(
                  icon: LineIcons.home,
                  iconColor: Theme.of(context).iconTheme.color,
                  text: 'home'.tr(),
                  textStyle: Theme.of(context).textTheme.labelSmall,
                ),
                GButton(
                  icon: LineIcons.heart,
                  iconColor: Theme.of(context).iconTheme.color,
                  text: 'Noti',
                  textStyle: Theme.of(context).textTheme.labelSmall,
                  // Añadir el recuento de notificaciones no leídas como insignia
                  leading: _unReadNotificationsCount > 0
                      ? badges.Badge(
                          badgeContent: Text(
                              _unReadNotificationsCount > 99
                                  ? '99+'
                                  : '$_unReadNotificationsCount',
                              style: Theme.of(context).textTheme.labelSmall),
                          child: const Icon(LineIcons.heart),
                        )
                      : null,
                ),
                GButton(
                  icon: LineIcons.search,
                  iconColor: Theme.of(context).iconTheme.color,
                  text: 'search'.tr(),
                  textStyle: Theme.of(context).textTheme.labelSmall,
                ),
                GButton(
                  icon: LineIcons.user,
                  iconColor: Theme.of(context).iconTheme.color,
                  text: 'settings'.tr(),
                  textStyle: Theme.of(context).textTheme.labelSmall,
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
