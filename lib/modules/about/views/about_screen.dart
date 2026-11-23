import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../controllers/about_controller.dart';

class AboutScreen extends GetView<AboutController> {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('About App', style: AppTextStyles.heading(size: 21)),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              children: [
                Container(
                  height: 85,
                  width: 85,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  controller.appName,
                  style: AppTextStyles.heading(size: 23, color: Colors.white),
                ),
                const SizedBox(height: 7),
                Text(
                  'Learn • Practice • Grow',
                  style: AppTextStyles.body(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Version ${controller.appVersion}',
                    style: AppTextStyles.body(
                      color: Colors.white,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          _sectionTitle('ABOUT'),
          const SizedBox(height: 10),
          _infoCard(
            'About Flutter LMS',
            'Flutter LMS is a learning platform designed to help students access courses, watch lessons, attempt quizzes and track their learning progress.',
            Icons.info_outline,
          ),
          const SizedBox(height: 22),
          _sectionTitle('INSTITUTE'),
          const SizedBox(height: 10),
          _infoCard(
            controller.instituteName,
            'Official learning platform for students of our institute.',
            Icons.account_balance_outlined,
          ),
          const SizedBox(height: 22),
          _sectionTitle('LEGAL INFORMATION'),
          const SizedBox(height: 10),
          _navigationTile(
            'Privacy Policy',
            'How your information is handled',
            Icons.privacy_tip_outlined,
            controller.openPrivacyPolicy,
          ),
          const SizedBox(height: 10),
          _navigationTile(
            'Terms & Conditions',
            'Rules for using this application',
            Icons.description_outlined,
            controller.openTermsConditions,
          ),
          const SizedBox(height: 25),
          Center(
            child: Text(
              'Made for better learning experiences',
              style: AppTextStyles.body(size: 11),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              '© ${DateTime.now().year} Flutter LMS',
              style: AppTextStyles.body(size: 11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.body(
        size: 11,
        weight: FontWeight.w700,
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _infoCard(String title, String description, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 25),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body(
                    color: AppColors.textPrimary,
                    weight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 7),
                Text(description, style: AppTextStyles.body(size: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _navigationTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(15),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: AppColors.border),
        ),
        leading: Icon(icon, color: AppColors.primary),
        title: Text(
          title,
          style: AppTextStyles.body(
            color: AppColors.textPrimary,
            weight: FontWeight.w700,
          ),
        ),
        subtitle: Text(subtitle, style: AppTextStyles.body(size: 11)),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 15,
          color: AppColors.textSecondary,
        ),
        onTap: onTap,
      ),
    );
  }
}
