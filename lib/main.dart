import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:reefquest/config/dependencies.dart';
import 'package:reefquest/rooting/router.dart';

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: providersLocal, child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Reef Quest',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        visualDensity:VisualDensity.adaptivePlatformDensity
      ),
      routerConfig: /*Scaffold(
        body: ImportantTasksList(
            viewModel:
                ImportantTasksListViewModel(taskRepository: context.read())),
      )*/ AppRouter.router,
    );
  }
}
