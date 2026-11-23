import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    resetToken = arguments['reset_token']?.toString() ?? '';
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

  Future<void> resetPassword() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    if (resetToken.isEmpty) {
      Get.snackbar(
        'Verification Required',
        'Please verify your email address again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      // TODO: Connect Laravel reset-password API here.
      // Send email, password, password_confirmation and resetToken.
      await Future.delayed(const Duration(seconds: 1));

      Get.offAllNamed(AppRoutes.login);

      Get.snackbar(
        'Password Reset',
        'Password reset API will be connected in the backend phase.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to reset password. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void backToVerifyEmail() {
    Get.back();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
