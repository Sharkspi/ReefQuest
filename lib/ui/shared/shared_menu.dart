import 'package:flutter/material.dart';
import 'package:reefquest/ui/shared/shared_app_bar.dart';
import 'package:reefquest/ui/shared/shared_nav_drawer.dart';


class SharedMenu extends StatelessWidget {
  final Widget child;

  const SharedMenu({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: SharedAppBar(),
        body: child,
        drawer: SharedNavigationDrawer(),
      ),
    );
  }
}
