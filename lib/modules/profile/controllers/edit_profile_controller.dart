import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController {
  // Form
  final formKey = GlobalKey<FormState>();

  // Text Controllers
  final nameController = TextEditingController(text: 'Sami');
  final emailController = TextEditingController(text: 'student@example.com');
  final phoneController = TextEditingController();
  final studentIdController = TextEditingController(text: 'STU-001');

  // Loading State
  final RxBool isLoading = false.obs;

  // Profile Image
  final ImagePicker _imagePicker = ImagePicker();
  final Rxn<File> profileImage = Rxn<File>();

  // Pick Profile Image From Gallery
  Future<void> pickProfileImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1000,
      );

      if (pickedFile == null) return;

      profileImage.value = File(pickedFile.path);
    } catch (e) {
      Get.snackbar(
        'Image Error',
        'Unable to select image. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Remove Selected Profile Image
  void removeProfileImage() {
    profileImage.value = null;
  }

  // Name Validation
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your full name';
    }

    if (value.trim().length < 3) {
      return 'Name must be at least 3 characters';
    }

    return null;
  }

  // Email Validation
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }

    if (!GetUtils.isEmail(value.trim())) {
      return 'Please enter a valid email';
    }

    return null;
  }

  // Phone Validation
  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    if (!GetUtils.isPhoneNumber(value.trim())) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  // Save Profile
  Future<void> saveProfile() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      // TODO: Connect Laravel profile update API here.
      // Send profileImage.value using multipart/form-data.
      await Future.delayed(const Duration(seconds: 1));

      Get.back();

      Get.snackbar(
        'Profile Updated',
        'Your profile information has been saved locally for this demo.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to update profile. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    studentIdController.dispose();

    super.onClose();
  }
}
