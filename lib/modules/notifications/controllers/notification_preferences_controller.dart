import 'package:get/get.dart';

class NotificationPreferencesController extends GetxController {
  final RxBool pushNotifications = true.obs;
  final RxBool courseUpdates = true.obs;
  final RxBool lessonReminders = true.obs;
  final RxBool quizResults = true.obs;
  final RxBool announcements = false.obs;
  final RxBool emailNotifications = true.obs;

  void togglePush(bool value) {
    pushNotifications.value = value;

    if (!value) {
      courseUpdates.value = false;
      lessonReminders.value = false;
      quizResults.value = false;
      announcements.value = false;
    }
  }

  void togglePreference(RxBool preference, bool value) {
    if (pushNotifications.value) {
      preference.value = value;
    }
  }

  void savePreferences() {
    Get.snackbar(
      'Preferences Saved',
      'Your notification preferences have been updated.',
      snackPosition: SnackPosition.BOTTOM,
    );

    // TODO: Save preferences through Laravel API.
  }
}
