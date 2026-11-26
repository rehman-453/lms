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
