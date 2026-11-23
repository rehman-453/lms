import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();

  final RxInt currentIndex = 0.obs;

  final int totalPages = 3;

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  void nextPage() {
    if (currentIndex.value < totalPages - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      goToLogin();
    }
  }

  void skip() {
    goToLogin();
  }

  void goToLogin() {
    // Login screen will be implemented in the next part.
    Get.offNamed(AppRoutes.login);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
