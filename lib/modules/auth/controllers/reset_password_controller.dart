import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lms/core/network/api_endpoints.dart';
import 'package:lms/core/network/api_services.dart';

import '../../../app/routes/app_routes.dart';

class ResetPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isLoading = false.obs;

  late String resetToken;

  @override
  void onInit() {
    super.onInit();

    final arguments = Get.arguments as Map<String, dynamic>? ?? {};

    emailController.text = arguments['email']?.toString() ?? '';
  }

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.toggle();
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required';
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

  void backToVerifyEmail() {
    Get.back();
  }

  Future<void> resetPassword() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    try {
      isLoading.value = true;

      var responseFromAPI = await ApiServices().postMethod(
        ApiEndpoints.resetPasswordUrl,
        {
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
          "password_confirmation": confirmPasswordController.text.trim(),
        },
      );

      String successMessage = jsonDecode(responseFromAPI)['message'];

      Get.offAllNamed(AppRoutes.login);

      Get.snackbar(
        "Success",
        successMessage,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
