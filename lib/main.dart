import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app/app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize GetStorage for API token and user data
  await GetStorage.init();

  // Load saved theme preference
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('dark_mode_enabled') ?? false;

  runApp(
    LMSApp(initialThemeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light),
  );
}
