import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../home/controllers/home_controller.dart';

class NotificationsScreen extends GetView<HomeController> {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Notifications', style: AppTextStyles.heading(size: 22)),
        actions: [
          IconButton(
            tooltip: 'Notification Preferences',
            onPressed: () {
              Get.toNamed(AppRoutes.notificationPreferences);
            },
            icon: const Icon(
              Icons.settings_outlined,
              color: AppColors.textPrimary,
            ),
          ),
          Obx(
            () => TextButton(
              onPressed: controller.unreadNotifications == 0
                  ? null
                  : controller.markAllNotificationsAsRead,
              child: Text(
                'Mark all read',
                style: AppTextStyles.body(
                  color: controller.unreadNotifications == 0
                      ? AppColors.textSecondary
                      : AppColors.primary,
                  weight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildSummary(),
            _buildFilters(),
            Expanded(child: _buildNotificationList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Obx(
        () => Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.notifications_active_outlined,
                  color: Colors.white,
                  size: 25,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${controller.notifications.length} Notifications',
                      style: AppTextStyles.heading(
                        size: 17,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${controller.unreadNotifications} unread notifications',
                      style: AppTextStyles.body(
                        size: 12,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.notifications_none_rounded,
                color: Colors.white,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: controller.notificationFilters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final filter = controller.notificationFilters[index];

          return Obx(() {
            final isSelected =
                controller.selectedNotificationFilter.value == filter;

            return GestureDetector(
              onTap: () => controller.selectNotificationFilter(filter),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                ),
                child: Text(
                  filter,
                  style: AppTextStyles.body(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildNotificationList() {
    return Obx(() {
      final items = controller.filteredNotifications;

      if (items.isEmpty) {
        return _buildEmptyState();
      }

      return ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final entry = items[index];
          final notification = entry.value;
          final originalIndex = entry.key;
          final isRead = notification['isRead'] == true;

          return _buildNotificationCard(notification, originalIndex, isRead);
        },
      );
    });
  }

  Widget _buildNotificationCard(
    Map<String, dynamic> notification,
    int index,
    bool isRead,
  ) {
    final title = notification['title']?.toString() ?? 'Notification';
    final message = notification['message']?.toString() ?? '';
    final time = notification['time']?.toString() ?? '';

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          if (!isRead) {
            controller.markNotificationAsRead(index);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: _notificationColor(title).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  _notificationIcon(title),
                  color: _notificationColor(title),
                  size: 23,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: AppTextStyles.body(
                              size: 14,
                              color: AppColors.textPrimary,
                              weight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (!isRead)
                          Container(
                            height: 8,
                            width: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(message, style: AppTextStyles.body(size: 12)),
                    const SizedBox(height: 10),
                    Text(
                      time,
                      style: AppTextStyles.body(
                        size: 11,
                        color: AppColors.primary,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.more_vert,
                  color: AppColors.textSecondary,
                  size: 21,
                ),
                onSelected: (value) {
                  if (value == 'read' && !isRead) {
                    controller.markNotificationAsRead(index);
                  } else if (value == 'delete') {
                    _confirmDelete(index);
                  }
                },
                itemBuilder: (_) => [
                  if (!isRead)
                    const PopupMenuItem(
                      value: 'read',
                      child: Text('Mark as read'),
                    ),
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 85,
              width: 85,
              decoration: const BoxDecoration(
                color: AppColors.lightBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_off_outlined,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No notifications found',
              style: AppTextStyles.heading(size: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'You are all caught up. Check back later!',
              textAlign: TextAlign.center,
              style: AppTextStyles.body(size: 13),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(int index) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.white,
        title: Text(
          'Delete Notification?',
          style: AppTextStyles.heading(size: 18),
        ),
        content: Text(
          'Are you sure you want to delete this notification?',
          style: AppTextStyles.body(size: 13),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              controller.deleteNotification(index);
              Get.back();
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  IconData _notificationIcon(String title) {
    final value = title.toLowerCase();

    if (value.contains('lesson')) {
      return Icons.play_circle_outline_rounded;
    }

    if (value.contains('course') || value.contains('progress')) {
      return Icons.school_outlined;
    }

    if (value.contains('welcome')) {
      return Icons.waving_hand_outlined;
    }

    return Icons.notifications_none_rounded;
  }

  Color _notificationColor(String title) {
    final value = title.toLowerCase();

    if (value.contains('lesson')) {
      return AppColors.primary;
    }

    if (value.contains('course') || value.contains('progress')) {
      return AppColors.success;
    }

    if (value.contains('welcome')) {
      return AppColors.warning;
    }

    return AppColors.primary;
  }
}
