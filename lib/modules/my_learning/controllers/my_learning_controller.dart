import 'package:get/get.dart';

import '../../home/controllers/home_controller.dart';

class MyLearningController extends GetxController {
  final HomeController homeController = Get.find<HomeController>();

  final RxString selectedFilter = 'All'.obs;

  final List<String> filters = ['All', 'In Progress', 'Completed'];

  List<Map<String, dynamic>> get filteredCourses {
    final enrolled = homeController.enrolledCourses.toList();

    if (selectedFilter.value == 'In Progress') {
      return enrolled.where((course) {
        final progress = (course['progress'] as num).toDouble();
        return progress > 0 && progress < 1;
      }).toList();
    }

    if (selectedFilter.value == 'Completed') {
      return enrolled.where((course) {
        final progress = (course['progress'] as num).toDouble();
        return progress >= 1;
      }).toList();
    }

    return enrolled;
  }

  int get totalCourses => homeController.enrolledCourses.length;

  int get completedCourses {
    return homeController.enrolledCourses.where((course) {
      return (course['progress'] as num).toDouble() >= 1;
    }).length;
  }

  int get inProgressCourses {
    return homeController.enrolledCourses.where((course) {
      final progress = (course['progress'] as num).toDouble();
      return progress > 0 && progress < 1;
    }).length;
  }

  void selectFilter(String filter) {
    selectedFilter.value = filter;
  }

  void openCourse(Map<String, dynamic> enrolledCourse) {
    final courseId = enrolledCourse['id'];

    final matchingCourses = homeController.courses.where(
      (course) => course['id'] == courseId,
    );

    if (matchingCourses.isEmpty) {
      Get.snackbar(
        'Course Not Found',
        'Course details are currently unavailable.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    homeController.openCourse(matchingCourses.first);
  }

  void continueLearning(Map<String, dynamic> enrolledCourse) {
    openCourse(enrolledCourse);
  }
}
