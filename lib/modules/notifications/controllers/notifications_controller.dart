import 'package:get/get.dart';

class NotificationsController extends GetxController {
  final notifications = <Map<String, dynamic>>[].obs;

  final unreadCount = 0.obs;

  void markAllAsRead() {
    for (final notification in notifications) {
      notification['isRead'] = true;
    }

    notifications.refresh();
    unreadCount.value = 0;
  }

  void markAsRead(int index) {
    if (index >= 0 && index < notifications.length) {
      notifications[index]['isRead'] = true;
      notifications.refresh();

      unreadCount.value = notifications
          .where((item) => item['isRead'] == false)
          .length;
    }
  }

  void clearAll() {
    notifications.clear();
    unreadCount.value = 0;
  }
}
