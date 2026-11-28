import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_services.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/profile_controller.dart';

class EditProfileController extends GetxController {
  final ApiServices _apiServices = ApiServices();

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final studentIdController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isFetchingProfile = true.obs;

  final ImagePicker _imagePicker = ImagePicker();

  // SELECTED IMAGE
  final Rxn<File> profileImage = Rxn<File>();

  // EXISTING SERVER IMAGE
  final RxString existingProfileImageUrl = ''.obs;

  // REMOVE EXISTING IMAGE
  final RxBool removeExistingImage = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  // FETCH PROFILE
  Future<void> fetchProfile() async {
    isFetchingProfile.value = true;

    try {
      final response = await _apiServices.getMethod(ApiEndpoints.meUrl, true);

      final decoded = jsonDecode(response);

      if (decoded is Map<String, dynamic> && decoded['success'] == true) {
        final data = decoded['data'];

        if (data is Map) {
          final user = data['user'] is Map ? data['user'] : <String, dynamic>{};

          final profile = data['profile'] is Map
              ? data['profile']
              : <String, dynamic>{};

          nameController.text = user['name']?.toString() ?? '';
          emailController.text = user['email']?.toString() ?? '';

          phoneController.text = profile['phone']?.toString() ?? '';
          studentIdController.text = profile['student_id']?.toString() ?? '';

          final imagePath = profile['profile_image']?.toString() ?? '';

          existingProfileImageUrl.value = imagePath.isNotEmpty
              ? _buildImageUrl(imagePath)
              : '';

          profileImage.value = null;
          removeExistingImage.value = false;
        }
      } else {
        _showError(
          decoded['message']?.toString() ??
              'Unable to load profile information.',
        );
      }
    } catch (e) {
      _showError('Unable to load profile information.');
      debugPrint('Edit profile fetch error: $e');
    } finally {
      isFetchingProfile.value = false;
    }
  }

  // BUILD IMAGE URL
  String _buildImageUrl(String imagePath) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    }

    final storageBaseUrl = ApiEndpoints.baseUrl.replaceFirst('/api/v1', '');

    final cleanPath = imagePath.startsWith('/')
        ? imagePath.substring(1)
        : imagePath;

    return '$storageBaseUrl/storage/$cleanPath';
  }

  // PICK PROFILE IMAGE
  Future<void> pickProfileImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1000,
      );

      if (pickedFile == null) return;

      profileImage.value = File(pickedFile.path);

      // New image selected, so do not remove the existing image separately.
      removeExistingImage.value = false;
    } catch (e) {
      debugPrint('Image picker error: $e');
      _showError('Unable to select image. Please try again.');
    }
  }

  // REMOVE PROFILE IMAGE
  void removeProfileImage() {
    profileImage.value = null;
    existingProfileImageUrl.value = '';
    removeExistingImage.value = true;
  }

  // VALIDATE NAME
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your full name';
    }

    if (value.trim().length < 3) {
      return 'Name must be at least 3 characters';
    }

    return null;
  }

  // VALIDATE EMAIL
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }

    if (!GetUtils.isEmail(value.trim())) {
      return 'Please enter a valid email';
    }

    return null;
  }

  // VALIDATE PHONE
  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    if (!GetUtils.isPhoneNumber(value.trim())) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  // SAVE PROFILE
  Future<void> saveProfile() async {
    if (isLoading.value || isFetchingProfile.value) return;

    if (!(formKey.currentState?.validate() ?? false)) return;

    isLoading.value = true;

    try {
      final fields = <String, String>{
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
      };

      // REMOVE EXISTING PROFILE IMAGE
      if (removeExistingImage.value) {
        fields['remove_profile_image'] = 'true';
      }

      // UPDATE PROFILE API
      final response = await _apiServices.multipartPostMethod(
        ApiEndpoints.studentProfileUrl,
        fields,
        filePath: profileImage.value?.path,
        isAccessToken: true,
      );

      final decoded = jsonDecode(response);

      if (decoded is Map<String, dynamic> && decoded['success'] == true) {
        // REFRESH PROFILE SCREEN DATA
        if (Get.isRegistered<ProfileController>()) {
          await Get.find<ProfileController>().fetchProfile();
        }

        // REFRESH HOME SCREEN NAME AND PROFILE IMAGE
        if (Get.isRegistered<HomeController>()) {
          await Get.find<HomeController>().fetchStudentProfile();
        }

        // CLOSE EDIT PROFILE SCREEN
        Get.back();

        Get.snackbar(
          'Profile Updated',
          decoded['message']?.toString() ??
              'Your profile has been updated successfully.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      } else {
        _showError(
          decoded['message']?.toString() ?? 'Unable to update profile.',
        );
      }
    } catch (e) {
      debugPrint('Profile update error: $e');
      _showError(_extractError(e));
    } finally {
      isLoading.value = false;
    }
  }

  // EXTRACT ERROR MESSAGE
  String _extractError(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }

  // SHOW ERROR
  void _showError(String message) {
    Get.snackbar('Error', message, snackPosition: SnackPosition.BOTTOM);
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
