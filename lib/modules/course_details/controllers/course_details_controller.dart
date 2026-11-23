import 'package:get/get.dart';

import '../../home/controllers/home_controller.dart';
import '../../../app/routes/app_routes.dart';

class CourseDetailsController extends GetxController {
  late final Map<String, dynamic> course;

  final RxList<int> expandedSections = <int>[0].obs;
  final RxBool isEnrolled = false.obs;

  final List<Map<String, dynamic>> learningOutcomes = [
    {'title': 'Understand the core concepts', 'icon': 'check'},
    {'title': 'Build practical projects', 'icon': 'check'},
    {'title': 'Apply skills to real-world tasks', 'icon': 'check'},
    {'title': 'Develop problem-solving skills', 'icon': 'check'},
  ];

  final List<Map<String, dynamic>> curriculum = [
    {
      'title': 'Getting Started',
      'lessons': [
        {'title': 'Introduction to the Course', 'duration': '08:20'},
        {'title': 'Understanding the Basics', 'duration': '12:45'},
        {'title': 'Setting Up Your Environment', 'duration': '10:15'},
      ],
    },
    {
      'title': 'Core Concepts',
      'lessons': [
        {'title': 'Fundamental Concepts', 'duration': '15:30'},
        {'title': 'Working with Examples', 'duration': '18:40'},
        {'title': 'Practical Implementation', 'duration': '14:20'},
      ],
    },
    {
      'title': 'Practical Projects',
      'lessons': [
        {'title': 'Building Your First Project', 'duration': '22:10'},
        {'title': 'Advanced Techniques', 'duration': '19:35'},
        {'title': 'Final Project', 'duration': '25:00'},
      ],
    },
  ];

  @override
  void onInit() {
    super.onInit();

    final arguments = Get.arguments;

    if (arguments is Map<String, dynamic>) {
      course = arguments;
    } else {
      course = {};
    }

    // Check whether the student is already enrolled.
    if (Get.isRegistered<HomeController>() && course['id'] != null) {
      final homeController = Get.find<HomeController>();

      isEnrolled.value = homeController.enrolledCourses.any(
        (item) => item['id'] == course['id'],
      );
    }
  }

  String get courseTitle => course['title']?.toString() ?? 'Course Details';

  String get instructor => course['instructor']?.toString() ?? 'Instructor';

  String get category => course['category']?.toString() ?? 'General';

  String get duration => course['duration']?.toString() ?? 'N/A';

  String get rating => course['rating']?.toString() ?? 'N/A';

  int get totalLessons => (course['lessons'] as num?)?.toInt() ?? 0;

  String get price => course['price']?.toString() ?? 'Free';

  bool get isFavorite {
    if (!Get.isRegistered<HomeController>() || course['id'] == null) {
      return false;
    }

    return Get.find<HomeController>().isFavorite(course['id'] as int);
  }

  void toggleFavorite() {
    if (course.isEmpty) return;

    Get.find<HomeController>().toggleFavorite(course);
  }

  void toggleSection(int index) {
    if (expandedSections.contains(index)) {
      expandedSections.remove(index);
    } else {
      expandedSections.add(index);
    }
  }

  void enrollNow() {
    if (course.isEmpty) return;

    final homeController = Get.find<HomeController>();

    // Avoid duplicate enrollment.
    final alreadyEnrolled = homeController.enrolledCourses.any(
      (item) => item['id'] == course['id'],
    );

    if (alreadyEnrolled) {
      isEnrolled.value = true;

      Get.snackbar(
        'Already Enrolled',
        'You are already enrolled in this course.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    homeController.enrollCourse(course);

    isEnrolled.value = homeController.enrolledCourses.any(
      (item) => item['id'] == course['id'],
    );
  }

  void openLesson(Map<String, dynamic> lesson) {
    final allLessons = curriculum
        .expand((section) => section['lessons'] as List<Map<String, dynamic>>)
        .toList();

    Get.toNamed(
      AppRoutes.lessonPlayer,
      arguments: {'course': course, 'lessons': allLessons},
    );
  }
}
