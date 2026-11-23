import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';

class ForgotPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  final isLoading = false.obs;

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required';
    }

    if (!GetUtils.isEmail(value.trim())) {
      return 'Enter a valid email address';
    }

    return null;
  }

  Future<void> verifyEmail() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    isLoading.value = true;

    try {
      // TODO: Call Laravel email verification API here.
      // Expected response should include a secure reset token.
      await Future.delayed(const Duration(seconds: 1));

      // Temporary development response.
      // Replace this with the token returned by Laravel.
      const resetToken = 'temporary-reset-token';

      Get.toNamed(
        AppRoutes.resetPassword,
        arguments: {
          'email': emailController.text.trim(),
          'reset_token': resetToken,
        },
      );
    } catch (e) {
      Get.snackbar(
        'Verification Failed',
        'Unable to verify this email. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void backToLogin() {
    Get.back();
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
