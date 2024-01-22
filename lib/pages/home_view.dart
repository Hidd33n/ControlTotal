import 'package:calcu/assets/functions/count_services.dart';
import 'package:calcu/assets/functions/home_services.dart';
import 'package:calcu/assets/functions/settings_service.dart';
import 'package:calcu/assets/functions/switch_list.dart';
import 'package:calcu/assets/ui/themes/theme_manager.dart';
import 'package:calcu/assets/utils/dialog_utils.dart';
import 'package:calcu/assets/widgets/drewer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
  final HomeService _homeService = HomeService();
  final SwitchList _switchList = SwitchList();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SettingsServices settingsService = SettingsServices();

  String _username = '';
  bool _showFriendsCalculations = false;
  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    _homeService.loadUsername((username) {
      if (mounted) {
        setState(() {
          _username = username;
        });
      }
    });
  }

  String capitalize(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1);
  }

  void calculate() {
    DialogUtils.showCalculateDialog(context, _controller);
  }

  void eliminarCalculoParaTodos(String documentoId) async {
    await _homeService.eliminarCalculoParaTodos(documentoId);
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          capitalize(_username),
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        titleSpacing: 0.0,
        centerTitle: true,
        toolbarHeight: 60.2,
        toolbarOpacity: 0.8,
        elevation: 8.0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        automaticallyImplyLeading:
            false, // Desactiva el botón de retorno automático
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Theme.of(context).colorScheme.onPrimary,
            height: 1.0,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                _showFriendsCalculations = !_showFriendsCalculations;
              });
            },
            child: Container(
              width: 32.0,
              height: 32.0,
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              child: Center(
                child: Icon(
                  _showFriendsCalculations ? Icons.group : Icons.person,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: MyDrawer(
        currentUser: _auth.currentUser,
        onFixTaxes: () => settingsService.taxessettings(context),
        onToggleLanguage: () async => await (context.setLocale(
          context.locale.languageCode == 'en'
              ? const Locale('es', 'ES')
              : const Locale('en', 'US'),
        )),
        onToggleTheme: () {
          ThemeMode currentTheme = ThemeManager.currentThemeMode;
          ThemeManager.setTheme(
            currentTheme == ThemeMode.light ? ThemeMode.dark : ThemeMode.light,
          );
          ThemeManager.saveTheme();
          setState(() {});
        },
        onLogout: () => settingsService.confirmSignOut(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 42),
        child: FloatingActionButton(
          onPressed: calculate,
          elevation: 8,
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          child: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
        ),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Column(
          children: [
            Expanded(
              child: _showFriendsCalculations
                  ? _switchList.buildTeamAccountList()
                  : _switchList.buildAccountList(),
            ),
            Column(
              children: [
                if (_showFriendsCalculations && user != null)
                  CountServices(userId: user.uid, isTeamCount: true),
                if (!_showFriendsCalculations && user != null)
                  CountServices(userId: user.uid, isTeamCount: false),
              ],
            )
          ],
        ),
      ),
    );
  }
}
