import 'package:get/get.dart';

import '../controllers/notification_preferences_controller.dart';

class NotificationPreferencesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationPreferencesController>(
      () => NotificationPreferencesController(),
    );
  }
}
