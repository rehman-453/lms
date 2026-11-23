import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Terms & Conditions',
          style: AppTextStyles.heading(size: 20),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _heading('1. Acceptance of Terms'),
          _paragraph(
            'By accessing Flutter LMS, students agree to follow the applicable rules and conditions established by the institute.',
          ),
          _heading('2. Student Accounts'),
          _paragraph(
            'Students are responsible for maintaining the confidentiality of their account credentials and for activity performed through their accounts.',
          ),
          _heading('3. Course Content'),
          _paragraph(
            'Course materials are provided for educational purposes. Students must not reproduce, distribute or commercially use protected content without authorization.',
          ),
          _heading('4. Acceptable Use'),
          _paragraph(
            'Students must not misuse the platform, interfere with its operation or attempt unauthorized access to accounts, data or services.',
          ),
          _heading('5. Assessments'),
          _paragraph(
            'Students must complete quizzes and assessments honestly and according to the instructions provided by the institute.',
          ),
          _heading('6. Certificates'),
          _paragraph(
            'Certificates may be issued subject to the completion requirements and assessment criteria defined by the institute.',
          ),
          _heading('7. Account Suspension'),
          _paragraph(
            'The institute may restrict or suspend access in accordance with its applicable student policies and procedures.',
          ),
          _heading('8. Changes to Terms'),
          _paragraph(
            'These terms may be revised when necessary. Students should review the latest version made available through the application.',
          ),
          _heading('9. Contact'),
          _paragraph(
            'For questions about these terms, contact the institute through its officially provided support channels.',
          ),
          const SizedBox(height: 20),
          Text(
            'Draft terms — require review and approval by the institute before production use.',
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
