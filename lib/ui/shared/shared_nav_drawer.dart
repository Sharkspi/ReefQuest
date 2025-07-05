import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../rooting/routes.dart';

class SharedNavigationDrawer extends StatefulWidget {
  const SharedNavigationDrawer({super.key});

  @override
  State<SharedNavigationDrawer> createState() => _SharedNavigationDrawerState();
}

class _SharedNavigationDrawerState extends State<SharedNavigationDrawer> {
  int screenIndex = -1;

  void _handleScreenChange(int selectedScreen) {
    setState(() {
      screenIndex = selectedScreen;
      final routes = MenuRoutes.values;
      if (screenIndex < routes.length && screenIndex >= 0) {
        context.go(MenuRoutes.values[screenIndex].path);
      } else {
        context.go(Routes.dailyTasks); //Par défaut on va à la page d'accueil
      }
    });
    Navigator.pop(context); //Permet de fermer le drawer
  }

  int _getSelectedIndexFromRoute(String location) {
    return MenuRoutes.menuIndexFromName(location);
  }

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouter.of(context).state.name;
    debugPrint(currentLocation);
    return NavigationDrawer(
      onDestinationSelected: _handleScreenChange,
      selectedIndex: _getSelectedIndexFromRoute(currentLocation!),
      children: <Widget>[
        Padding(padding: EdgeInsets.all(8), child: Text('Menus')),
        ...MenuRoutes.values.map((route) => NavigationDrawerDestination(
            icon: Icon(route.icon),
            selectedIcon: Icon(route.iconSelected),
            label: Text(route.label)))
      ],
    );
  }
}
