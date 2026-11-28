import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_services.dart';

class ChangePasswordController extends GetxController {
  final ApiServices _apiServices = ApiServices();

  final formKey = GlobalKey<FormState>();

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final RxBool isCurrentPasswordVisible = false.obs;
  final RxBool isNewPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
  final RxBool isLoading = false.obs;

  String? validateCurrentPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your current password';
    }
    return null;
  }

  String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a new password';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (value == currentPasswordController.text) {
      return 'New password must be different';
    }

    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your new password';
    }

    if (value != newPasswordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  Future<void> changePassword() async {
    if (isLoading.value) return;

    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    isLoading.value = true;

    try {
      final requestData = {
        'current_password': currentPasswordController.text.trim(),
        'password': newPasswordController.text.trim(),
        'password_confirmation': confirmPasswordController.text.trim(),
      };

      final response = await _apiServices.postMethod(
        ApiEndpoints.changePasswordUrl,
        requestData,
        true,
      );

      final responseData = jsonDecode(response);

      if (responseData is Map && responseData['success'] == true) {
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();

        Get.back();

        Get.snackbar(
          'Success',
          responseData['message']?.toString() ??
              'Password changed successfully.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          responseData is Map
              ? responseData['message']?.toString() ??
                    'Unable to change password.'
              : 'Unable to change password.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Change Password Error: $e');

      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
