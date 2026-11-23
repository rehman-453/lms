import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  final RxBool notificationsEnabled = true.obs;
  final RxBool downloadOverWifiOnly = true.obs;
  final RxBool darkModeEnabled = false.obs;

  static const String _darkModeKey = 'dark_mode_enabled';
  static const String _notificationsKey = 'notifications_enabled';
  static const String _wifiOnlyKey = 'download_over_wifi_only';

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  // Load saved settings
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final isDarkMode = prefs.getBool(_darkModeKey) ?? false;
    final notifications = prefs.getBool(_notificationsKey) ?? true;
    final wifiOnly = prefs.getBool(_wifiOnlyKey) ?? true;

    darkModeEnabled.value = isDarkMode;
    notificationsEnabled.value = notifications;
    downloadOverWifiOnly.value = wifiOnly;

    // Apply saved theme
    Get.changeThemeMode(isDarkMode ? ThemeMode.dark : ThemeMode.light);
  }

  // Toggle Notifications
  Future<void> toggleNotifications(bool value) async {
    notificationsEnabled.value = value;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsKey, value);
  }

  // Toggle Wi-Fi Only
  Future<void> toggleWifiOnly(bool value) async {
    downloadOverWifiOnly.value = value;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_wifiOnlyKey, value);
  }

  // Toggle Dark Mode
  Future<void> toggleDarkMode(bool value) async {
    darkModeEnabled.value = value;

    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode_enabled', value);
  }

  // Logout Confirmation
  void showLogoutConfirmation() {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();

              Get.snackbar(
                'Logout',
                'Connect the logout API to complete this action.',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Coming Soon
  void showComingSoon(String feature) {
    Get.snackbar(
      feature,
      'This feature will be available soon.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
