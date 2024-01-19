import 'package:calcu/assets/functions/count_services.dart';
import 'package:calcu/assets/functions/home_services.dart';
import 'package:calcu/assets/functions/switch_list.dart';
import 'package:calcu/utils/dialog_utils.dart';
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
        elevation: 0.0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Theme.of(context).appBarTheme.backgroundColor,
            height: 1.0,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(_showFriendsCalculations ? Icons.group : Icons.person,
                color: Theme.of(context).iconTheme.color),
            onPressed: () {
              setState(() {
                _showFriendsCalculations = !_showFriendsCalculations;
              });
            },
          ),
        ],
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
