import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../controllers/course_feedback_controller.dart';

class CourseFeedbackScreen extends GetView<CourseFeedbackController> {
  const CourseFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text('Course Feedback', style: AppTextStyles.heading(size: 20)),
      ),
      body: Obx(
        () => controller.isSubmitted.value
            ? _buildSuccessView()
            : _buildFeedbackForm(),
      ),
    );
  }

  Widget _buildFeedbackForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCourseCard(),

            const SizedBox(height: 24),

            _buildRatingCard(
              title: 'Rate this Course',
              subtitle: 'How would you rate your learning experience?',
              rating: controller.courseRating,
              onRatingChanged: controller.setCourseRating,
            ),

            const SizedBox(height: 16),

            _buildRatingCard(
              title: 'Rate your Instructor',
              subtitle: 'How was the instructor’s teaching?',
              rating: controller.instructorRating,
              onRatingChanged: controller.setInstructorRating,
            ),

            const SizedBox(height: 20),

            _buildFeedbackField(),

            const SizedBox(height: 24),

            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: controller.isSubmitting.value
                      ? null
                      : controller.submitFeedback,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: controller.isSubmitting.value
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          'Submit Feedback',
                          style: AppTextStyles.body(
                            size: 15,
                            weight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            height: 58,
            width: 58,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.school_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'COURSE COMPLETED',
                  style: AppTextStyles.body(
                    size: 10,
                    weight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 6),

                Obx(
                  () => Text(
                    controller.courseTitle.value,
                    style: AppTextStyles.heading(size: 16, color: Colors.white),
                  ),
                ),

                const SizedBox(height: 4),

                Obx(
                  () => Text(
                    'Instructor: ${controller.instructorName.value}',
                    style: AppTextStyles.body(size: 12, color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingCard({
    required String title,
    required String subtitle,
    required RxInt rating,
    required Function(int) onRatingChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.heading(size: 16)),

          const SizedBox(height: 5),

          Text(subtitle, style: AppTextStyles.body(size: 12)),

          const SizedBox(height: 16),

          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starNumber = index + 1;
                final selected = starNumber <= rating.value;

                return IconButton(
                  onPressed: () => onRatingChanged(starNumber),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    selected ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 38,
                    color: selected
                        ? const Color(0xFFFFB547)
                        : AppColors.border,
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 8),

          Obx(
            () => Center(
              child: Text(
                _ratingLabel(rating.value),
                style: AppTextStyles.body(
                  size: 13,
                  weight: FontWeight.w600,
                  color: rating.value > 0
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _ratingLabel(int rating) {
    switch (rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent!';
      default:
        return 'Tap a star to rate';
    }
  }

  Widget _buildFeedbackField() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your Feedback', style: AppTextStyles.heading(size: 16)),

          const SizedBox(height: 6),

          Text(
            'Share your thoughts or suggestions (optional)',
            style: AppTextStyles.body(size: 12),
          ),

          const SizedBox(height: 14),

          TextFormField(
            controller: controller.feedbackController,
            maxLines: 5,
            maxLength: 500,
            decoration: InputDecoration(
              hintText: 'Write your feedback here...',
              hintStyle: AppTextStyles.body(size: 13),
              filled: true,
              fillColor: AppColors.background,
              counterStyle: AppTextStyles.body(size: 11),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if ((value ?? '').trim().length > 500) {
                return 'Feedback cannot exceed 500 characters.';
              }

              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 110,
              width: 110,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColors.success,
                size: 72,
              ),
            ),

            const SizedBox(height: 24),

            Text('Thank You!', style: AppTextStyles.heading(size: 28)),

            const SizedBox(height: 12),

            Text(
              'Your feedback has been submitted successfully. '
              'Your opinion helps us improve the learning experience.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body(size: 14),
            ),

            const SizedBox(height: 24),

            _buildSubmittedRatings(),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: Get.back,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmittedRatings() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _submittedRatingRow('Course Rating', controller.courseRating),

          const SizedBox(height: 12),

          _submittedRatingRow('Instructor Rating', controller.instructorRating),
        ],
      ),
    );
  }

  Widget _submittedRatingRow(String title, RxInt rating) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.body(
              size: 13,
              weight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),

          Row(
            children: [
              const Icon(
                Icons.star_rounded,
                color: Color(0xFFFFB547),
                size: 20,
              ),

              const SizedBox(width: 4),

              Text('${rating.value}/5', style: AppTextStyles.heading(size: 14)),
            ],
          ),
        ],
      ),
    );
  }
}
