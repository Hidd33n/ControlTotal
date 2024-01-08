import 'package:calcu/functions/count_services.dart';
import 'package:calcu/functions/home_services.dart';
import 'package:calcu/functions/switch_list.dart';
import 'package:calcu/utils/dialog_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
          _username,
          style: GoogleFonts.nunito(
            textStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
        ),
        titleSpacing: 0.0,
        centerTitle: true,
        toolbarHeight: 60.2,
        toolbarOpacity: 0.8,
        elevation: 0.0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.grey[300],
            height: 1.0,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(_showFriendsCalculations ? Icons.group : Icons.person,
                color: Colors.black),
            onPressed: () {
              setState(() {
                _showFriendsCalculations = !_showFriendsCalculations;
              });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: calculate,
        elevation: 0,
        backgroundColor: Colors.black87,
        label: Text(
          'calculate'.tr(),
          style: const TextStyle(color: Colors.white),
        ),
        icon: const Icon(Icons.calculate, color: Colors.white),
      ),
      body: Column(
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
    );
  }
}
