import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lms/app/routes/app_routes.dart';
import 'package:lms/core/network/api_endpoints.dart';
import 'package:lms/core/network/api_services.dart';
import 'package:lms/core/storage/local_storage.dart';
import 'package:lms/core/storage/local_storage_keys.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController(
    text: kDebugMode ? "student@example.com" : '',
  );
  final passwordController = TextEditingController(
    text: kDebugMode ? "password123" : '',
  );

  final isPasswordVisible = false.obs;
  final rememberMe = true.obs;
  final isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    if (!GetUtils.isEmail(value.trim())) {
      return 'Enter a valid email address';
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  // Login
  void login() async {
    try {
      isLoading.value = true;

      var responseFromAPI = await ApiServices().postMethod(
        ApiEndpoints.loginUrl,
        {
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
        },
      );

      String extractedAccessToken = jsonDecode(
        responseFromAPI,
      )['data']['token'];

      LocalStorage.saveData(
        key: LocalStorageKeys.accessTokenKey,
        dataToSave: extractedAccessToken,
      );

      // Get Device FCM Token
      await getDeviceFCMToken();

      Get.snackbar("Success", "User Logged In successfully!!");

      isLoading.value = false;

      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", e.toString());
    }
  }

  // Get Device FCM Token
  Future<void> getDeviceFCMToken() async {
    try {
      // Request notification permission
      NotificationSettings settings = await FirebaseMessaging.instance
          .requestPermission();

      debugPrint("Notification Permission: ${settings.authorizationStatus}");

      // Get FCM Token
      // ignore: deprecated_member_use
      String? fcmToken = await FirebaseMessaging.instance.getToken();

      if (fcmToken != null) {
        debugPrint("================================");
        debugPrint("DEVICE FCM TOKEN:");
        debugPrint(fcmToken);
        debugPrint("================================");
      } else {
        debugPrint("FCM Token not generated!");
      }
    } catch (e) {
      debugPrint("FCM Token Error: $e");
    }
  }

  // Future<void> login() async {
  //   if (!(formKey.currentState?.validate() ?? false)) return;

  //   isLoading.value = true;

  //   try {
  //     // Temporary dummy login without Laravel API.
  //     await Future.delayed(const Duration(milliseconds: 800));

  //     Get.offAllNamed(AppRoutes.home);
  //   } catch (e) {
  //     Get.snackbar(
  //       'Login Failed',
  //       'Unable to login. Please try again.',
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  void forgotPassword() {
    Get.toNamed(AppRoutes.forgotPassword);
  }

  void googleLogin() {
    Get.snackbar(
      'Google Login',
      'Google authentication will be integrated later.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void goToRegister() {
    Get.toNamed(AppRoutes.register);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
