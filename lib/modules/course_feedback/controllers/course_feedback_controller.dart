import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CourseFeedbackController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final RxInt courseRating = 0.obs;
  final RxInt instructorRating = 0.obs;

  final feedbackController = TextEditingController();

  final RxBool isSubmitting = false.obs;
  final RxBool isSubmitted = false.obs;

  final RxInt courseId = 0.obs;
  final RxString courseTitle = 'Complete Flutter Development'.obs;
  final RxString instructorName = 'John Smith'.obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args is Map) {
      courseId.value = int.tryParse(args['course_id']?.toString() ?? '') ?? 0;

      courseTitle.value = args['course_title']?.toString() ?? courseTitle.value;

      instructorName.value =
          args['instructor_name']?.toString() ?? instructorName.value;
    }
  }

  void setCourseRating(int rating) {
    if (rating >= 1 && rating <= 5) {
      courseRating.value = rating;
    }
  }

  void setInstructorRating(int rating) {
    if (rating >= 1 && rating <= 5) {
      instructorRating.value = rating;
    }
  }

  Future<void> submitFeedback() async {
    if (isSubmitting.value || isSubmitted.value) return;

    if (courseRating.value == 0) {
      Get.snackbar(
        'Course Rating Required',
        'Please rate the course before submitting.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (instructorRating.value == 0) {
      Get.snackbar(
        'Instructor Rating Required',
        'Please rate your instructor.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Feedback is optional, but validate the form if available.
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    isSubmitting.value = true;

    try {
      // TODO: Submit feedback through Laravel API.
      await Future.delayed(const Duration(seconds: 2));

      isSubmitted.value = true;

      Get.snackbar(
        'Feedback Submitted',
        'Thank you for sharing your feedback!',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Submission Failed',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  void resetFeedback() {
    courseRating.value = 0;
    instructorRating.value = 0;
    feedbackController.clear();
    isSubmitted.value = false;
    isSubmitting.value = false;
    formKey.currentState?.reset();
  }

  @override
  void onClose() {
    feedbackController.dispose();
    super.onClose();
  }
}
