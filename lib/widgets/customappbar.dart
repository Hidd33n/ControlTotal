import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String username;
  final VoidCallback onSettingsPressed;
  final TabController tabController; // Nuevo

  const CustomAppBar({
    required this.username,
    required this.onSettingsPressed,
    required this.tabController, // Nuevo
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(100.1);

  String capitalize(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        capitalize(username),
        style: Theme.of(context).appBarTheme.titleTextStyle,
      ),
      titleSpacing: 0.0,
      centerTitle: true,
      toolbarHeight: 60.2,
      toolbarOpacity: 0.8,
      elevation: 8.0,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      automaticallyImplyLeading: false,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(
            Icons.settings,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: onSettingsPressed,
        ),
      ),
      bottom: PreferredSize(
        preferredSize:
            const Size.fromHeight(0), // Altura cero para que no afecte
        child: SizedBox(
          height: 40.0, // Ajusta la altura del TabBar según tus necesidades
          child: TabBar(
            // Nuevo
            controller: tabController,
            tabs: [
              Tab(
                text: 'only'.tr(),
              ),
              Tab(
                text: 'team'.tr(),
              ),
            ],
            indicatorWeight: 2.0,
            indicatorColor: Theme.of(context).colorScheme.onPrimary,
            labelColor: Theme.of(context).textTheme.bodyLarge?.color,
            unselectedLabelColor: Theme.of(context).colorScheme.shadow,
          ),
        ),
      ),
    );
  }
}
