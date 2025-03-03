import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:taskati/core/model/task_model.dart';
import 'package:taskati/core/services/local_helper.dart';
import 'package:taskati/core/utils/themes.dart';
import 'package:taskati/feature/intro/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("userBox");
  await Hive.openBox<TaskModel>("taskBox");
  Hive.registerAdapter(TaskModelAdapter());
  AppLocalStorage.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppLocalStorage.userBox!.listenable(),
      builder: (context, value, child) {
        bool isDarkTheme =
            AppLocalStorage.getCachedData(AppLocalStorage.isDarkTheme) ?? false;
        return MaterialApp(
            themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            debugShowCheckedModeBanner: false,
            home: const SplashScreen());
      },
    );
  }
}
