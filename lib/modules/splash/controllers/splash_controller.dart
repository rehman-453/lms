import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/storage/local_storage_keys.dart';

class SplashController extends GetxController {
  final RxBool isVisible = false.obs;

  @override
  void onReady() {
    super.onReady();

    isVisible.value = true;

    Future.delayed(const Duration(seconds: 3), () {
      checkUserStatus();
    });
  }

  void checkUserStatus() {
    // 1. Get saved access token
    final token = LocalStorage.getData(
      key: LocalStorageKeys.accessTokenKey,
    );

    // 2. Check onboarding status
    final isFirstTime = LocalStorage.getData(
      key: LocalStorageKeys.isFirstTimeKey,
    );

    // 3. If token exists, navigate to Bottom Navigation
    if (token.isNotEmpty) {
      Get.offAllNamed(AppRoutes.bottomnav);
    }

    // 4. If first time, show onboarding
    else if (isFirstTime.isEmpty || isFirstTime == 'true') {
      Get.offAllNamed(AppRoutes.onboarding);
    }

    // 5. Otherwise, navigate to Login
    else {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}


// import 'package:get/get.dart';

// import '../../../app/routes/app_routes.dart';

// class SplashController extends GetxController {
//   final RxBool isVisible = false.obs;

//   @override
//   void onReady() {
//     super.onReady();

//     isVisible.value = true;

//     Future.delayed(const Duration(seconds: 3), () {
//       Get.offNamed(AppRoutes.onboarding);
//     });
//   }
// }
