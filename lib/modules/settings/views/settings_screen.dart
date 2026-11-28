import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lms/app/routes/app_routes.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../controllers/settings_controller.dart';

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: AppColors.textPrimary,
          ),
        ),
        title: Text('Settings', style: AppTextStyles.heading(size: 22)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('ACCOUNT'),
            _settingsCard([
              _navigationItem(
                icon: Icons.person_outline,
                title: 'Edit Profile',
                subtitle: 'Update your personal information',
                onTap: () {
                  Get.toNamed(AppRoutes.editProfile);
                },
              ),
              _divider(),
              _navigationItem(
                icon: Icons.lock_outline,
                title: 'Change Password',
                subtitle: 'Update your account password',
                onTap: () {
                  Get.toNamed(AppRoutes.changePassword);
                },
              ),
            ]),

            const SizedBox(height: 25),

            _sectionTitle('APP PREFERENCES'),
            _settingsCard([
              Obx(
                () => _switchItem(
                  icon: Icons.notifications_none_rounded,
                  title: 'Push Notifications',
                  subtitle: 'Receive course and learning updates',
                  value: controller.notificationsEnabled.value,
                  onChanged: controller.toggleNotifications,
                ),
              ),
              _divider(),
            ]),

            const SizedBox(height: 25),

            _sectionTitle('SUPPORT & INFORMATION'),
            _settingsCard([
              // _navigationItem(
              //   icon: Icons.privacy_tip_outlined,
              //   title: 'Privacy Policy',
              //   onTap: () => controller.showComingSoon('Privacy Policy'),
              // ),
              // _divider(),
              // _navigationItem(
              //   icon: Icons.description_outlined,
              //   title: 'Terms & Conditions',
              //   onTap: () => controller.showComingSoon('Terms & Conditions'),
              // ),
              // _divider(),
              _navigationItem(
                icon: Icons.info_outline,
                title: 'About App',
                subtitle: 'LMS v1.0.0',
                onTap: () {
                  Get.toNamed(AppRoutes.about);
                },
              ),
            ]),

            const SizedBox(height: 25),

            _settingsCard([
              _navigationItem(
                icon: Icons.logout_rounded,
                title: 'Logout',
                titleColor: AppColors.error,
                iconColor: AppColors.error,
                onTap: controller.showLogoutConfirmation,
              ),
            ]),

            const SizedBox(height: 30),

            Center(
              child: Text(
                'LMS • Version 1.0.0',
                style: AppTextStyles.body(size: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: AppTextStyles.body(
          size: 11,
          weight: FontWeight.bold,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _settingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }

  Widget _divider() {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 55,
      endIndent: 15,
      color: AppColors.border,
    );
  }

  Widget _navigationItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color iconColor = AppColors.primary,
    Color titleColor = AppColors.textPrimary,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      leading: Icon(icon, color: iconColor, size: 23),
      title: Text(
        title,
        style: AppTextStyles.body(color: titleColor, weight: FontWeight.w600),
      ),
      subtitle: subtitle == null
          ? null
          : Text(subtitle, style: AppTextStyles.body(size: 12)),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textSecondary,
      ),
      onTap: onTap,
    );
  }

  Widget _switchItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      leading: Icon(icon, color: AppColors.primary, size: 23),
      title: Text(
        title,
        style: AppTextStyles.body(
          color: AppColors.textPrimary,
          weight: FontWeight.w600,
        ),
      ),
      subtitle: Text(subtitle, style: AppTextStyles.body(size: 12)),
      trailing: Switch.adaptive(
        value: value,
        activeTrackColor: AppColors.primary,
        onChanged: onChanged,
      ),
    );
  }
}
