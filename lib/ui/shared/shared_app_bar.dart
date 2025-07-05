import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reefquest/rooting/routes.dart';

class SharedAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SharedAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final routeName  = GoRouter.of(context).state.name;
    return AppBar(
      title: Text(MenuRoutes.values[MenuRoutes.menuIndexFromName(routeName!)].label),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
