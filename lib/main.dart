import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('dark_mode_enabled') ?? false;

  runApp(
    LMSApp(initialThemeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light),
  );
}
