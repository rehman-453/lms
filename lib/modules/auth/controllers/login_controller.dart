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
    text: kDebugMode ? 'student@example.com' : '',
  );

  final passwordController = TextEditingController(
    text: kDebugMode ? 'password123' : '',
  );

  final isPasswordVisible = false.obs;
  final rememberMe = true.obs;
  final isLoading = false.obs;

  final ApiServices _apiServices = ApiServices();

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

  // Forgot Password
  void forgotPassword() {
    Get.toNamed(AppRoutes.forgotPassword);
  }

  // Navigate to Register
  void goToRegister() {
    Get.toNamed(AppRoutes.register);
  }

  // Login
  Future<void> login() async {
    if (isLoading.value) return;

    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    try {
      isLoading.value = true;

      final responseFromAPI = await _apiServices.postMethod(
        ApiEndpoints.loginUrl,
        {
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
        },
      );

      final responseData = jsonDecode(responseFromAPI);

      final extractedAccessToken = responseData['data']['token']?.toString();

      if (extractedAccessToken == null || extractedAccessToken.isEmpty) {
        throw Exception('Authentication token not received.');
      }

      LocalStorage.saveData(
        key: LocalStorageKeys.accessTokenKey,
        dataToSave: extractedAccessToken,
      );

      await getDeviceFCMToken();

      Get.snackbar(
        'Success',
        'User logged in successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.offAllNamed(AppRoutes.bottomnav);
    } catch (e) {
      debugPrint('Login Error: $e');

      Get.snackbar(
        'Login Failed',
        'Unable to login. Please check your credentials and try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Get FCM Token and save it to Laravel
  Future<void> getDeviceFCMToken() async {
    try {
      final settings = await FirebaseMessaging.instance.requestPermission();

      debugPrint('Notification Permission: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        debugPrint('Notification permission denied.');
        return;
      }

      // ignore: deprecated_member_use
      final String? fcmToken = await FirebaseMessaging.instance.getToken();

      if (fcmToken == null || fcmToken.isEmpty) {
        debugPrint('FCM token not generated.');
        return;
      }

      debugPrint('FCM Token: $fcmToken');

      // Send token to Laravel API using authenticated request
      final response = await _apiServices.postMethod(
        ApiEndpoints.saveFcmTokenUrl,
        {'fcm_token': fcmToken},
        true,
      );

      debugPrint('FCM Token API Response: $response');
    } catch (e) {
      debugPrint('FCM Token Sync Error: $e');
    }
  }

  void listenToFCMTokenRefresh() {
    // ignore: deprecated_member_use
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      try {
        final accessToken = LocalStorage.getData(
          key: LocalStorageKeys.accessTokenKey,
        );

        if (accessToken.isEmpty) return;

        await _apiServices.postMethod(ApiEndpoints.saveFcmTokenUrl, {
          'fcm_token': newToken,
        }, true);

        debugPrint('Refreshed FCM token synced successfully.');
      } catch (e) {
        debugPrint('FCM Refresh Sync Error: $e');
      }
    });
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
