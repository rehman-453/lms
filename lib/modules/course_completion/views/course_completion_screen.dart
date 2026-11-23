import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../controllers/course_completion_controller.dart';

class CourseCompletionScreen extends GetView<CourseCompletionController> {
  const CourseCompletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Course Completion',
          style: AppTextStyles.heading(size: 20),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Obx(() {
        final completed = controller.isCourseCompleted;

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Completion Header
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Container(
                    height: 85,
                    width: 85,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.emoji_events_rounded,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    completed ? 'Congratulations!' : 'Keep Going!',
                    style: AppTextStyles.heading(size: 25, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    completed ? 'You have successfully completed this course.' : 'You are making progress. Complete the remaining requirements.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body(
                      size: 13,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Text('Course Summary', style: AppTextStyles.heading(size: 18)),
            const SizedBox(height: 14),

            _summaryCard(),

            const SizedBox(height: 25),

            Text(
              'Completion Requirements',
              style: AppTextStyles.heading(size: 18),
            ),
            const SizedBox(height: 14),

            _requirementTile(
              icon: Icons.menu_book_rounded,
              title: 'Complete All Lessons',
              subtitle:
                  '${controller.completedLessons.value} / ${controller.totalLessons.value} lessons completed',
              isCompleted:
                  controller.completedLessons.value >=
                  controller.totalLessons.value,
            ),

            const SizedBox(height: 10),

            _requirementTile(
              icon: Icons.quiz_rounded,
              title: 'Complete Final Quiz',
              subtitle: 'Final assessment',
              isCompleted: controller.quizCompleted.value,
            ),

            const SizedBox(height: 25),

            // Certificate Preview Button
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: completed ? controller.openCertificate : null,
                icon: const Icon(Icons.workspace_premium_rounded),
                label: const Text('View My Certificate'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.border,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Share Feedback Button
            SizedBox(
              height: 52,
              child: OutlinedButton.icon(
                onPressed: completed
                    ? () {
                        Get.toNamed(
                          AppRoutes.courseFeedback,
                          arguments: {
                            'course_id': controller.courseId.value,
                            'course_title': controller.courseTitle.value,
                            'instructor_name': controller.instructorName.value,
                          },
                        );
                      }
                    : null,
                icon: const Icon(Icons.rate_review_outlined),
                label: const Text('Share Your Feedback'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(
                    color: completed ? AppColors.primary : AppColors.border,
                  ),
                  disabledForegroundColor: AppColors.textSecondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        );
      }),
    );
  }

  Widget _summaryCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            controller.courseTitle.value,
            style: AppTextStyles.heading(size: 16),
          ),
          const SizedBox(height: 7),
          Text(
            'Instructor: ${controller.instructorName.value}',
            style: AppTextStyles.body(size: 13),
          ),
          const SizedBox(height: 18),
          Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Course Progress',
                      style: AppTextStyles.body(size: 12),
                    ),
                    Text(
                      '${(controller.completionPercentage * 100).round()}%',
                      style: AppTextStyles.heading(
                        size: 13,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: controller.completionPercentage.clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor: AppColors.lightBlue,
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _requirementTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isCompleted,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 25),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.heading(size: 13)),
                const SizedBox(height: 4),
                Text(subtitle, style: AppTextStyles.body(size: 11)),
              ],
            ),
          ),
          Icon(
            isCompleted
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked,
            color: isCompleted ? AppColors.success : AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
