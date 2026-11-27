import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lms/app/routes/app_routes.dart';
import 'package:lms/core/network/api_endpoints.dart';
import 'package:lms/core/network/api_services.dart';
import 'package:lms/core/storage/local_storage.dart';
import 'package:lms/core/storage/local_storage_keys.dart';

class SignupController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isLoading = false.obs;
  final agreeToTerms = false.obs;

  final ApiServices _apiServices = ApiServices();

  void togglePasswordVisibility() => isPasswordVisible.toggle();

  void toggleConfirmPasswordVisibility() => isConfirmPasswordVisible.toggle();

  void toggleTerms(bool? value) {
    agreeToTerms.value = value ?? false;
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    if (value.trim().length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
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
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> signup() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    if (!agreeToTerms.value) {
      Get.snackbar(
        'Terms & Conditions',
        'Please accept the Terms & Conditions to continue.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      final String? fcmToken = await generateFCMToken();

      var responseFromRegisterAPI = await _apiServices.postMethod(
        ApiEndpoints.registerUrl,
        {
          "name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
          "password_confirmation": confirmPasswordController.text.trim(),
          "type": "student",
          "fcm_token": fcmToken,
        },
      );

      String extractedAccessToken = jsonDecode(
        responseFromRegisterAPI,
      )['data']['token'];

      LocalStorage.saveData(
        key: LocalStorageKeys.accessTokenKey,
        dataToSave: extractedAccessToken,
      );

      String extractSuccessMessage = jsonDecode(
        responseFromRegisterAPI,
      )['message'];

      Get.snackbar("Success", extractSuccessMessage);

      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> generateFCMToken() async {
    try {
      final settings = await FirebaseMessaging.instance.requestPermission();

      debugPrint('Notification Permission: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        return null;
      }

      final String? fcmToken = await FirebaseMessaging.instance.getToken();

      debugPrint('FCM Token: $fcmToken');

      return fcmToken;
    } catch (e) {
      debugPrint('FCM Token Generation Error: $e');
      return null;
    }
  }

  void goToLogin() {
    Get.back();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
