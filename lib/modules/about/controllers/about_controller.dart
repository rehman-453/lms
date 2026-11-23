import 'package:get/get.dart';

class AboutController extends GetxController {
  final String appName = 'Flutter LMS';
  final String appVersion = '1.0.0';
  final String instituteName = 'Your Institute Name';

  void openPrivacyPolicy() {
    Get.toNamed('/privacy-policy');
  }

  void openTermsConditions() {
    Get.toNamed('/terms-conditions');
  }
}
