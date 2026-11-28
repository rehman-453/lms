import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_services.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/storage/local_storage_keys.dart';

class ProfileController extends GetxController {
  final ApiServices _apiServices = ApiServices();

  final RxBool isLoggingOut = false.obs;
  final RxBool isLoadingProfile = true.obs;

  final RxString name = ''.obs;
  final RxString email = ''.obs;
  final RxString profileImage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  // Fetch profile from backend
  Future<void> fetchProfile() async {
    isLoadingProfile.value = true;

    try {
      final response = await _apiServices.getMethod(ApiEndpoints.meUrl, true);

      final decoded = jsonDecode(response);

      if (decoded is Map<String, dynamic>) {
        final data = decoded['data'] ?? {};

        final user = data['user'] ?? {};
        final profile = data['profile'] ?? {};

        if (user is Map<String, dynamic>) {
          name.value = user['name']?.toString() ?? '';
          email.value = user['email']?.toString() ?? '';
        }

        if (profile is Map<String, dynamic>) {
          final imagePath = profile['profile_image']?.toString() ?? '';

          profileImage.value = imagePath.isNotEmpty
              ? _buildImageUrl(imagePath)
              : '';
        }
      }
    } catch (e) {
      debugPrint('Profile fetch error: $e');
    } finally {
      isLoadingProfile.value = false;
    }
  }

  // Convert storage path into public image URL
  String _buildImageUrl(String imagePath) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    }

    final baseUrl = ApiEndpoints.baseUrl.replaceFirst('/api/v1', '');

    return '$baseUrl/storage/$imagePath';
  }

  Future<void> logout() async {
    if (isLoggingOut.value) return;

    isLoggingOut.value = true;

    try {
      try {
        await _apiServices.deleteMethod(ApiEndpoints.deleteFcmTokenUrl, true);
      } catch (e) {
        debugPrint('FCM token removal failed: $e');
      }

      try {
        await _apiServices.postMethod(ApiEndpoints.logoutUrl, {}, true);
      } catch (e) {
        debugPrint('Backend logout failed: $e');
      }
    } catch (e) {
      debugPrint('Logout process error: $e');
    } finally {
      try {
        await LocalStorage.deleteData(key: LocalStorageKeys.accessTokenKey);

        await LocalStorage.deleteData(key: LocalStorageKeys.userDataKey);
      } catch (e) {
        debugPrint('Local token removal failed: $e');
      }

      isLoggingOut.value = false;

      try {
        Get.offAllNamed(AppRoutes.login);
      } catch (e) {
        debugPrint('Navigation to login failed: $e');
      }
    }
  }
}
