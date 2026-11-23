import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';

class SplashController extends GetxController {
  final RxBool isVisible = false.obs;

  @override
  void onReady() {
    super.onReady();

    isVisible.value = true;

    Future.delayed(const Duration(seconds: 3), () {
      Get.offNamed(AppRoutes.onboarding);
    });
  }
}
