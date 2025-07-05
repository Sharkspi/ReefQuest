import 'package:flutter/material.dart';

abstract final class Routes {
  ///Les noms et les chemins des différentes routes de l'application

  static const dailyTasks = '/';
  static const dailyTasksName = 'dailyTasks';
  static const importantTasks = '/$importantTasksName';
  static const importantTasksName = 'importantTasks';
  static const selfCareTasks = '/$selfCareTasksName';
  static const selfCareTasksName = 'selfcareTasks';
/*
  Exemple avec ID :
  static const booking = '/$bookingRelative';
  static const bookingRelative = 'booking';
  static String bookingWithId(int id) => '$booking/$id';*/
}

enum MenuRoutes {
  /// Représente les routes de l'application.
  /// L'ordre dans l'énumération correspond à l'ordre d'affichage dans le menu partagé
  home(Routes.dailyTasksName, Routes.dailyTasks, Icons.home_outlined, Icons.home, 'Daily tasks'),
  importantTasks(Routes.importantTasksName, Routes.importantTasks,
      Icons.assignment_outlined, Icons.assignment, 'Important tasks'),
  selfCareTasks(Routes.selfCareTasksName, Routes.selfCareTasks,
      Icons.spa_outlined, Icons.spa, 'Self Care tasks');

  final String name;
  final String path;
  final IconData icon;
  final IconData iconSelected;
  final String label;

  const MenuRoutes(
      this.name, this.path, this.icon, this.iconSelected, this.label);

  static int menuIndexFromName(String name) {
    for (final MenuRoutes route in MenuRoutes.values) {
      if (route.name == name) return route.index;
    }
    return -1; //Invalid index if Route doesn't exist
  }
}
