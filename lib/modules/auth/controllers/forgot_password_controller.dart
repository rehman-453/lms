import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_services.dart';

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

  // Forgot Password API
  Future<void> verifyEmail() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    try {
      isLoading.value = true;

      var responseFromAPI = await ApiServices().postMethod(
        ApiEndpoints.forgotPasswordUrl,
        {"email": emailController.text.trim()},
      );

      String successMessage = jsonDecode(responseFromAPI)['message'];

      Get.snackbar(
        "Success",
        successMessage,
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.toNamed(
        AppRoutes.resetPassword,
        arguments: {'email': emailController.text.trim()},
      );
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');

      Get.snackbar('Error', errorMessage, snackPosition: SnackPosition.BOTTOM);
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
