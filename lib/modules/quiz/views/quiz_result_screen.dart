import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../controllers/quiz_controller.dart';

class QuizResultScreen extends GetView<QuizController> {
  const QuizResultScreen({super.key});

  Map<String, dynamic> get result {
    final args = Get.arguments;

    if (args is Map) {
      return Map<String, dynamic>.from(args);
    }

    return {};
  }

  int get obtainedMarks =>
      int.tryParse(result['obtained_marks']?.toString() ?? '0') ?? 0;

  int get totalMarks =>
      int.tryParse(result['total_marks']?.toString() ?? '0') ?? 0;

  int get percentage =>
      (double.tryParse(result['percentage']?.toString() ?? '0') ?? 0).round();

  bool get passed => result['is_passed'] == true;

  int get courseId => int.tryParse(result['course_id']?.toString() ?? '0') ?? 0;

  @override
  Widget build(BuildContext context) {
    final score = obtainedMarks;
    final total = totalMarks;
    final percentageValue = percentage;
    final isPassed = passed;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.white,
        title: Text('Quiz Result', style: AppTextStyles.heading(size: 18)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              _buildResultIcon(isPassed),

              const SizedBox(height: 22),

              Text(
                isPassed ? 'Congratulations!' : 'Keep Practicing!',
                style: AppTextStyles.heading(size: 24),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                isPassed
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

              _buildScoreCard(score, total, percentageValue),

              const SizedBox(height: 20),

              _buildStatistics(score, total),

              const SizedBox(height: 20),

              if (isPassed) _buildLessonsPendingMessage(),

              const SizedBox(height: 30),

              if (!isPassed) _buildRetakeButton(),

              if (isPassed) _buildBackToLearningButton(),

              const SizedBox(height: 12),

              _buildBackButton(),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultIcon(bool isPassed) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        color: isPassed
            ? AppColors.success.withValues(alpha: 0.12)
            : AppColors.warning.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(
        isPassed ? Icons.emoji_events_rounded : Icons.school_rounded,
        size: 58,
        color: isPassed ? AppColors.success : AppColors.warning,
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
            '$score marks obtained out of $total marks',
            style: AppTextStyles.body(size: 13),
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: total == 0 ? 0 : (score / total).clamp(0.0, 1.0),
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
    final incorrect = (total - score).clamp(0, total);

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Obtained Marks',
            value: score.toString(),
            icon: Icons.check_circle_outline,
            color: AppColors.success,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: 'Remaining Marks',
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
