import 'package:get/get.dart';

import '../../home/controllers/home_controller.dart';
import '../views/certificate_preview_screen.dart';

class CourseCompletionController extends GetxController {
  final RxString studentName = 'Sami Ur Rehman'.obs;
  final RxString courseTitle = ''.obs;
  final RxString instructorName = ''.obs;

  final RxInt courseId = 0.obs;
  final RxInt completedLessons = 0.obs;
  final RxInt totalLessons = 0.obs;
  final RxInt quizScore = 0.obs;
  final RxInt quizTotal = 0.obs;

  final RxBool quizCompleted = false.obs;
  final RxBool isGenerating = false.obs;

  String get issueDate {
    final date = DateTime.now();

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  bool get isCourseCompleted {
    return totalLessons.value > 0 &&
        completedLessons.value >= totalLessons.value &&
        quizCompleted.value;
  }

  double get completionPercentage {
    if (totalLessons.value == 0) return 0;

    return (completedLessons.value / totalLessons.value).clamp(0.0, 1.0);
  }

  double get quizPercentage {
    if (quizTotal.value == 0) return 0;

    return (quizScore.value / quizTotal.value) * 100;
  }

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args is Map) {
      courseId.value = int.tryParse(args['course_id']?.toString() ?? '') ?? 0;

      courseTitle.value = args['course_title']?.toString() ?? '';

      instructorName.value = args['instructor_name']?.toString() ?? '';
    }

    loadCourseData();
  }

  int _toInt(dynamic value) {
    if (value is num) return value.toInt();

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  void loadCourseData() {
    if (courseId.value <= 0 || !Get.isRegistered<HomeController>()) {
      return;
    }

    final homeController = Get.find<HomeController>();

    final index = homeController.enrolledCourses.indexWhere(
      (course) => course['id'].toString() == courseId.value.toString(),
    );

    if (index == -1) return;

    final course = homeController.enrolledCourses[index];

    courseTitle.value = course['title']?.toString() ?? courseTitle.value;

    instructorName.value =
        course['instructor']?.toString() ?? instructorName.value;

    completedLessons.value = _toInt(
      course['completed_lessons'] ?? course['completedLessons'],
    );

    totalLessons.value = _toInt(
      course['total_lessons'] ?? course['totalLessons'],
    );

    quizCompleted.value = course['quiz_passed'] == true;

    quizScore.value = _toInt(course['quiz_score']);
    quizTotal.value = _toInt(course['quiz_total']);
  }

  void openCertificate() {
    loadCourseData();

    if (!isCourseCompleted) {
      Get.snackbar(
        'Course Incomplete',
        'Complete all lessons and pass the quiz to unlock your certificate.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.to(() => const CertificatePreviewScreen());
  }

  Future<void> generateCertificate() async {
    loadCourseData();

    if (!isCourseCompleted) return;

    isGenerating.value = true;

    try {
      // TODO: Connect Laravel API for certificate generation.
      await Future.delayed(const Duration(seconds: 2));

      Get.snackbar(
        'Certificate Ready',
        'Certificate preview is ready.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isGenerating.value = false;
    }
  }
}
