import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lms/modules/profile/controllers/profile_controller.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('My Profile', style: AppTextStyles.heading(size: 24)),

              const SizedBox(height: 30),

              // Profile Information
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 45,
                      backgroundColor: AppColors.lightBlue,
                      child: Icon(
                        Icons.person,
                        size: 45,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text('Sami', style: AppTextStyles.heading(size: 20)),
                    Text('student@example.com', style: AppTextStyles.body()),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Text(
                'ACCOUNT',
                style: AppTextStyles.body(size: 11, weight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              _item(
                Icons.person_outline,
                'Personal Information',
                onTap: () {
                  Get.toNamed(AppRoutes.editProfile);
                },
              ),

              _item(
                Icons.school_outlined,
                'My Learning',
                onTap: () {
                  Get.toNamed(AppRoutes.myLearning);
                },
              ),

              _item(
                Icons.workspace_premium_outlined,
                'My Certificates',
                onTap: () {
                  Get.toNamed(AppRoutes.certificates);
                },
              ),

              // Temporary testing navigation
              _item(
                Icons.emoji_events_outlined,
                'Course Completion',
                onTap: () {
                  Get.toNamed(AppRoutes.courseCompletion);
                },
              ),

              const SizedBox(height: 15),

              Text(
                'PREFERENCES',
                style: AppTextStyles.body(size: 11, weight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              _item(
                Icons.settings_outlined,
                'Settings',
                onTap: () {
                  Get.toNamed(AppRoutes.settings);
                },
              ),

              _item(
                Icons.help_outline,
                'Help & Support',
                onTap: () {
                  Get.toNamed(AppRoutes.support);
                },
              ),

              const SizedBox(height: 15),

              _item(
                Icons.logout_rounded,
                'Logout',
                iconColor: AppColors.error,
                onTap: () {
                  controller.logout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(
    IconData icon,
    String title, {
    required VoidCallback onTap,
    Color iconColor = AppColors.primary,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: AppTextStyles.body(
          color: AppColors.textPrimary,
          weight: FontWeight.w600,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }
}
