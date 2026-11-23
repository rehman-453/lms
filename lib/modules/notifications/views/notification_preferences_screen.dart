import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../controllers/notification_preferences_controller.dart';

class NotificationPreferencesScreen
    extends GetView<NotificationPreferencesController> {
  const NotificationPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Notification Preferences',
          style: AppTextStyles.heading(size: 20),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildIntro(),
            const SizedBox(height: 22),
            _buildSectionTitle('PUSH NOTIFICATIONS'),
            const SizedBox(height: 12),
            _buildMainToggle(),
            const SizedBox(height: 22),
            _buildSectionTitle('NOTIFICATION TYPES'),
            const SizedBox(height: 12),
            _buildPreferenceCard(),
            const SizedBox(height: 22),
            _buildSectionTitle('EMAIL NOTIFICATIONS'),
            const SizedBox(height: 12),
            _buildEmailCard(),
            const SizedBox(height: 30),
            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: controller.savePreferences,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Save Preferences',
                  style: AppTextStyles.body(
                    size: 15,
                    color: Colors.white,
                    weight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntro() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.lightBlue,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.notifications_active_outlined,
            color: AppColors.primary,
            size: 34,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Stay Updated', style: AppTextStyles.heading(size: 16)),
                const SizedBox(height: 5),
                Text(
                  'Choose which updates you would like to receive.',
                  style: AppTextStyles.body(size: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.body(
        size: 11,
        color: AppColors.textSecondary,
        weight: FontWeight.w700,
      ),
    );
  }

  Widget _buildMainToggle() {
    return Obx(
      () => _preferenceTile(
        icon: Icons.notifications_outlined,
        title: 'Push Notifications',
        subtitle: 'Enable or disable all push notifications',
        value: controller.pushNotifications.value,
        onChanged: controller.togglePush,
      ),
    );
  }

  Widget _buildPreferenceCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Obx(
            () => _preferenceTile(
              icon: Icons.school_outlined,
              title: 'Course Updates',
              subtitle: 'New courses and course announcements',
              value: controller.courseUpdates.value,
              enabled: controller.pushNotifications.value,
              onChanged: (value) =>
                  controller.togglePreference(controller.courseUpdates, value),
            ),
          ),
          _divider(),
          Obx(
            () => _preferenceTile(
              icon: Icons.play_circle_outline,
              title: 'Lesson Reminders',
              subtitle: 'Reminders about your learning activities',
              value: controller.lessonReminders.value,
              enabled: controller.pushNotifications.value,
              onChanged: (value) => controller.togglePreference(
                controller.lessonReminders,
                value,
              ),
            ),
          ),
          _divider(),
          Obx(
            () => _preferenceTile(
              icon: Icons.quiz_outlined,
              title: 'Quiz Results',
              subtitle: 'Updates about quiz submissions and results',
              value: controller.quizResults.value,
              enabled: controller.pushNotifications.value,
              onChanged: (value) =>
                  controller.togglePreference(controller.quizResults, value),
            ),
          ),
          _divider(),
          Obx(
            () => _preferenceTile(
              icon: Icons.campaign_outlined,
              title: 'Announcements',
              subtitle: 'Important institute announcements',
              value: controller.announcements.value,
              enabled: controller.pushNotifications.value,
              onChanged: (value) =>
                  controller.togglePreference(controller.announcements, value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailCard() {
    return Obx(
      () => _preferenceTile(
        icon: Icons.email_outlined,
        title: 'Email Notifications',
        subtitle: 'Receive important updates through email',
        value: controller.emailNotifications.value,
        onChanged: (value) => controller.emailNotifications.value = value,
      ),
    );
  }

  Widget _preferenceTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool enabled = true,
  }) {
    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: AppColors.lightBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary, size: 21),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.body(
                      size: 13,
                      color: AppColors.textPrimary,
                      weight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: AppTextStyles.body(size: 10)),
                ],
              ),
            ),
            Switch.adaptive(
              value: value,
              onChanged: enabled ? onChanged : null,
              activeTrackColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return const Divider(height: 1, color: AppColors.border);
  }
}
