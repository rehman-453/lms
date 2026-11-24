import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../controllers/course_completion_controller.dart';

class CertificatePreviewScreen extends GetView<CourseCompletionController> {
  const CertificatePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Certificate', style: AppTextStyles.heading(size: 20)),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFEFA),
              border: Border.all(color: const Color(0xFFD6B76C), width: 3),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.school_rounded,
                  size: 42,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 10),
                Text(
                  'LMS',
                  style: AppTextStyles.heading(
                    size: 18,
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  'CERTIFICATE',
                  style: AppTextStyles.heading(
                    size: 23,
                    color: const Color(0xFF9C792D),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'OF COMPLETION',
                  style: AppTextStyles.body(
                    size: 11,
                    weight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 25),
                Text(
                  'This certificate is proudly presented to',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body(size: 12),
                ),
                const SizedBox(height: 13),
                Obx(() {
                  return Text(
                    controller.studentName.value,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.heading(
                      size: 21,
                      color: AppColors.primaryDark,
                    ),
                  );
                }),
                const SizedBox(height: 10),
                Container(
                  height: 1,
                  width: 180,
                  color: const Color(0xFFD6B76C),
                ),
                const SizedBox(height: 18),
                Text(
                  'For successfully completing the course',
                  style: AppTextStyles.body(size: 12),
                ),
                const SizedBox(height: 12),
                Obx(() {
                  return Text(
                    controller.courseTitle.value,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.heading(size: 16),
                  );
                }),
                const SizedBox(height: 25),
                const Icon(
                  Icons.workspace_premium_rounded,
                  size: 55,
                  color: Color(0xFFD6B76C),
                ),
                const SizedBox(height: 22),
                Text('Date of Issue', style: AppTextStyles.body(size: 11)),
                const SizedBox(height: 5),
                Text(
                  controller.issueDate,
                  style: AppTextStyles.heading(size: 13),
                ),
                const SizedBox(height: 20),
                Text(
                  'Authorized by LMS',
                  style: AppTextStyles.body(size: 11, weight: FontWeight.w600),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          SizedBox(
            height: 52,
            child: Obx(() {
              return ElevatedButton.icon(
                onPressed: controller.isGenerating.value
                    ? null
                    : controller.generateCertificate,
                icon: controller.isGenerating.value
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.download_rounded),
                label: Text(
                  controller.isGenerating.value
                      ? 'Preparing...'
                      : 'Download Certificate',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
