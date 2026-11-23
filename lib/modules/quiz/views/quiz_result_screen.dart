import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/quiz_controller.dart';

class QuizResultScreen extends GetView<QuizController> {
  const QuizResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.white,
        title: Text('Quiz Result', style: AppTextStyles.heading(size: 18)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(() {
          final total = controller.totalQuestions;
          final score = controller.score.value;
          final percentage = total == 0 ? 0 : (score / total * 100).round();

          final passed = percentage >= 60;

          final courseCompleted =
              passed &&
              controller.courseId.value > 0 &&
              Get.isRegistered<HomeController>() &&
              Get.find<HomeController>().isCourseCompleted(
                controller.courseId.value,
              );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),

                _buildResultIcon(passed),

                const SizedBox(height: 22),

                Text(
                  passed ? 'Congratulations!' : 'Keep Practicing!',
                  style: AppTextStyles.heading(size: 24),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  passed
                      ? 'You have successfully passed the quiz.'
                      : 'You did not reach the passing score. Try again!',
                  style: AppTextStyles.body(size: 14),
                  textAlign: TextAlign.center,
                ),

                if (controller.courseTitle.value.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    controller.courseTitle.value,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body(
                      size: 13,
                      weight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],

                const SizedBox(height: 30),

                _buildScoreCard(score, total, percentage),

                const SizedBox(height: 20),

                _buildStatistics(score, total),

                const SizedBox(height: 20),

                if (passed && !courseCompleted) _buildLessonsPendingMessage(),

                if (courseCompleted) _buildCourseCompletedMessage(),

                const SizedBox(height: 30),

                if (!passed) _buildRetakeButton(),

                if (courseCompleted) _buildCertificateButton(),

                if (passed && !courseCompleted) _buildBackToLearningButton(),

                const SizedBox(height: 12),

                if (!courseCompleted) _buildBackButton(),

                const SizedBox(height: 10),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildResultIcon(bool passed) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        color: passed
            ? AppColors.success.withValues(alpha: 0.12)
            : AppColors.warning.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(
        passed ? Icons.emoji_events_rounded : Icons.school_rounded,
        size: 58,
        color: passed ? AppColors.success : AppColors.warning,
      ),
    );
  }

  Widget _buildScoreCard(int score, int total, int percentage) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(
            'Your Score',
            style: AppTextStyles.body(size: 14, weight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Text(
            '$percentage%',
            style: AppTextStyles.heading(size: 42, color: AppColors.primary),
          ),
          const SizedBox(height: 8),
          Text(
            '$score correct out of $total questions',
            style: AppTextStyles.body(size: 13),
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: total == 0 ? 0 : score / total,
              minHeight: 10,
              backgroundColor: AppColors.border,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics(int score, int total) {
    final incorrect = total - score;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Correct',
            value: score.toString(),
            icon: Icons.check_circle_outline,
            color: AppColors.success,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: 'Incorrect',
            value: incorrect.toString(),
            icon: Icons.cancel_outlined,
            color: AppColors.error,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 27),
          const SizedBox(height: 10),
          Text(value, style: AppTextStyles.heading(size: 24)),
          const SizedBox(height: 4),
          Text(title, style: AppTextStyles.body(size: 12)),
        ],
      ),
    );
  }

  Widget _buildLessonsPendingMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightBlue,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Quiz passed! Complete all remaining course lessons '
              'to unlock your certificate.',
              style: AppTextStyles.body(size: 12, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCompletedMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_rounded, color: AppColors.success),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'All lessons completed and quiz passed. '
              'Your certificate is unlocked!',
              style: AppTextStyles.body(size: 12, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRetakeButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: controller.retakeQuiz,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          'Retake Quiz',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildCertificateButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: () {
          Get.offNamed(
            AppRoutes.courseCompletion,
            arguments: {
              'course_id': controller.courseId.value,
              'course_title': controller.courseTitle.value,
              'instructor_name': controller.instructorName.value,
            },
          );
        },
        icon: const Icon(Icons.workspace_premium_rounded),
        label: const Text(
          'View Course Completion',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  Widget _buildBackToLearningButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () => Get.back(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          'Back to Learning',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: () => Get.back(),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text('Back'),
      ),
    );
  }
}
