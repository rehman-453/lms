import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lms/app/routes/app_routes.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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

  Future<void> login() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    isLoading.value = true;

    try {
      // Temporary dummy login without Laravel API.
      await Future.delayed(const Duration(milliseconds: 800));

      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      Get.snackbar(
        'Login Failed',
        'Unable to login. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> login() async {
  //   if (!(formKey.currentState?.validate() ?? false)) {
  //     return;
  //   }

  //   // API integration will be added later.
  //   isLoading.value = true;

  //   await Future.delayed(const Duration(seconds: 1));

  //   isLoading.value = false;

  //   Get.snackbar(
  //     'Login',
  //     'Laravel API will be connected in the next phase.',
  //     snackPosition: SnackPosition.BOTTOM,
  //   );
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
