import 'package:calcu/core/functions/settings_service.dart';
import 'package:calcu/presentation/home/functions/onlylist/onlylist.dart';
import 'package:calcu/core/ui/themes/theme_manager.dart';
import 'package:calcu/core/utils/dialog_utils.dart';
import 'package:calcu/presentation/home/functions/home_services.dart';
import 'package:calcu/presentation/home/functions/teamlist/team_list.dart';
import 'package:calcu/widgets/customappbar.dart';
import 'package:calcu/widgets/drawer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _controller = TextEditingController();
  final HomeService _homeService = HomeService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SettingsServices settingsServices = SettingsServices();
  late final TabController _tabController;
  bool isFirstPage = true;
  bool isSecondPage = false;
  bool get wantKeepAlive => true;
  String _username = '';

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _tabController = TabController(
      length: 2, // número de pestañas
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

  void calculate() {
    DialogUtils.showCalculateDialog(context, _controller);
  }

  void eliminarCalculoParaTodos(String documentoId) async {
    await _homeService.eliminarCalculoParaTodos(documentoId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        username: _username,
        onSettingsPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        tabController: _tabController,
      ),
      drawer: MyDrawer(
        currentUser: _auth.currentUser,
        onFixTaxes: () => settingsServices.taxessettings(context),
        onToggleLanguage: () async {
          await context.setLocale(
            context.locale.languageCode == 'en'
                ? const Locale('es', 'ES')
                : const Locale('en', 'US'),
          );
        },
        onToggleTheme: () {
          ThemeMode newThemeMode =
              ThemeManager.currentThemeMode == ThemeMode.dark
                  ? ThemeMode.light
                  : ThemeMode.dark;

          ThemeManager.setTheme(newThemeMode);
          ThemeManager.saveTheme();
        },
        onLogout: () => settingsServices.confirmSignOut(context),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          OnlyList(),
          TeamList(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 60),
        child: FloatingActionButton(
          onPressed: calculate,
          elevation: 8,
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          child: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}
