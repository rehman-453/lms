import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../controllers/quiz_controller.dart';

class QuizScreen extends GetView<QuizController> {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Obx(
          () => Text(
            controller.quizTitle.value.isEmpty
                ? 'Course Quiz'
                : controller.quizTitle.value,
            style: AppTextStyles.heading(size: 18),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value || controller.isStarting.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.questions.isEmpty || controller.attemptId.value == 0) {
            return const Center(child: Text('Quiz could not be loaded.'));
          }

          final question = controller.currentQuestion;
          final options = question['options'] as List;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildQuizHeader(),
                      const SizedBox(height: 24),
                      _buildTimer(),
                      const SizedBox(height: 24),
                      _buildProgress(),
                      const SizedBox(height: 28),
                      Text(
                        'Question ${controller.currentQuestionIndex.value + 1} '
                        'of ${controller.totalQuestions}',
                        style: AppTextStyles.body(
                          size: 13,
                          weight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        question['question']?.toString() ?? '',
                        style: AppTextStyles.heading(
                          size: 22,
                          weight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ...List.generate(options.length, (index) {
                        final option = Map<String, dynamic>.from(
                          options[index],
                        );

                        final optionId = int.parse(option['id'].toString());

                        return _buildOption(
                          index: index,
                          optionId: optionId,
                          title: option['option_text'].toString(),
                        );
                      }),
                      const SizedBox(height: 20),
                      _buildQuestionInfo(),
                    ],
                  ),
                ),
              ),
              _buildBottomNavigation(),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildQuizHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.quiz_rounded, color: Colors.white, size: 32),
          const SizedBox(height: 12),
          Text(
            'Test Your Knowledge',
            style: AppTextStyles.heading(size: 20, color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(
            controller.quizDescription.value.isEmpty
                ? 'Answer all questions to complete your quiz.'
                : controller.quizDescription.value,
            style: AppTextStyles.body(color: Colors.white70, size: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildTimer() {
    return Row(
      children: [
        const Icon(Icons.timer_outlined, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          'Time remaining',
          style: AppTextStyles.body(size: 13, weight: FontWeight.w600),
        ),
        const Spacer(),
        Obx(
          () => Text(
            controller.formattedTime,
            style: AppTextStyles.body(
              size: 16,
              weight: FontWeight.bold,
              color: controller.remainingSeconds.value <= 60
                  ? Colors.red
                  : AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Quiz Progress',
              style: AppTextStyles.body(
                color: AppColors.textPrimary,
                weight: FontWeight.w600,
              ),
            ),
            Text(
              '${controller.answeredQuestions}/${controller.totalQuestions} answered',
              style: AppTextStyles.body(size: 12),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: controller.progress,
            minHeight: 8,
            backgroundColor: AppColors.border,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildOption({
    required int index,
    required int optionId,
    required String title,
  }) {
    return Obx(() {
      final isSelected = controller.isOptionSelected(optionId);

      return GestureDetector(
        onTap: () => controller.selectAnswer(optionId),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.lightBlue : AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.background,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  String.fromCharCode(65 + index),
                  style: AppTextStyles.body(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    weight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.body(
                    size: 14,
                    color: AppColors.textPrimary,
                    weight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle, color: AppColors.primary),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildQuestionInfo() {
    return Row(
      children: [
        const Icon(
          Icons.info_outline,
          size: 17,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Select one answer for each question.',
            style: AppTextStyles.body(size: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigation() {
    return Obx(() {
      final isLastQuestion =
          controller.currentQuestionIndex.value ==
          controller.totalQuestions - 1;

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: controller.currentQuestionIndex.value > 0
                    ? controller.previousQuestion
                    : null,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Previous'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: controller.isSubmitting.value
                    ? null
                    : isLastQuestion
                    ? controller.submitQuiz
                    : controller.nextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: controller.isSubmitting.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(isLastQuestion ? 'Submit Quiz' : 'Next'),
              ),
            ),
          ],
        ),
      );
    });
  }
}
