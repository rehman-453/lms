import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Privacy Policy', style: AppTextStyles.heading(size: 20)),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _heading('1. Introduction'),
          _paragraph(
            'This Privacy Policy explains how LMS may collect, use and protect information when students use the application.',
          ),
          _heading('2. Information We Collect'),
          _paragraph(
            'The platform may process student information such as name, email address, profile details, course enrollments, quiz results and learning progress.',
          ),
          _heading('3. How We Use Information'),
          _paragraph(
            'Information may be used to manage student accounts, provide course access, track learning progress, display results and communicate important updates.',
          ),
          _heading('4. Data Protection'),
          _paragraph(
            'We intend to apply reasonable security measures to protect student information against unauthorized access, alteration or disclosure.',
          ),
          _heading('5. Third-Party Services'),
          _paragraph(
            'Some application features may use third-party services for authentication, notifications, video delivery or other functionality.',
          ),
          _heading('6. Student Responsibilities'),
          _paragraph(
            'Students should keep their login credentials confidential and report any suspected unauthorized account activity.',
          ),
          _heading('7. Policy Updates'),
          _paragraph(
            'This policy may be updated as the application and its services evolve. Updated terms should be made available through the application.',
          ),
          _heading('8. Contact'),
          _paragraph(
            'For privacy-related questions, contact your institute through its officially provided support channels.',
          ),
          const SizedBox(height: 20),
          Text(
            'Draft policy — requires review and approval by the institute before production use.',
            style: AppTextStyles.body(
              size: 11,
              color: AppColors.error,
              weight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _heading(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 8),
      child: Text(title, style: AppTextStyles.heading(size: 16)),
    );
  }

  Widget _paragraph(String text) {
    return Text(text, style: AppTextStyles.body(size: 13));
  }
}
