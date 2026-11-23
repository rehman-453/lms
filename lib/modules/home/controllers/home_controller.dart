import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';

class HomeController extends GetxController {
  // STUDENT
  final RxString studentName = 'Sami'.obs;

  // NAVIGATION
  final RxInt selectedIndex = 0.obs;

  // SEARCH & CATEGORY
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'All'.obs;

  // CATEGORIES
  final List<String> categories = [
    'All',
    'Development',
    'Design',
    'Business',
    'Marketing',
  ];

  // ALL COURSES
  final List<Map<String, dynamic>> courses = [
    {
      'id': 1,
      'title': 'Complete Flutter Development',
      'instructor': 'John Smith',
      'category': 'Development',
      'lessons': 32,
      'total_lessons': 32,
      'duration': '12h 30m',
      'progress': 0.65,
      'rating': 4.8,
      'price': 'Free',
      'icon': 'code',
    },
    {
      'id': 2,
      'title': 'UI/UX Design Masterclass',
      'instructor': 'Sarah Johnson',
      'category': 'Design',
      'lessons': 24,
      'total_lessons': 24,
      'duration': '8h 20m',
      'progress': 0.35,
      'rating': 4.9,
      'price': 'Free',
      'icon': 'design',
    },
    {
      'id': 3,
      'title': 'Laravel API Development',
      'instructor': 'Michael Brown',
      'category': 'Development',
      'lessons': 28,
      'total_lessons': 28,
      'duration': '10h 15m',
      'rating': 4.7,
      'price': 'Free',
      'icon': 'api',
    },
    {
      'id': 4,
      'title': 'Digital Marketing Basics',
      'instructor': 'Emma Wilson',
      'category': 'Marketing',
      'lessons': 18,
      'total_lessons': 18,
      'duration': '6h 10m',
      'rating': 4.6,
      'price': 'Free',
      'icon': 'marketing',
    },
    {
      'id': 5,
      'title': 'Business Management',
      'instructor': 'David Miller',
      'category': 'Business',
      'lessons': 20,
      'total_lessons': 20,
      'duration': '7h 45m',
      'rating': 4.8,
      'price': 'Free',
      'icon': 'business',
    },
  ];

  // ENROLLED COURSES
  final RxList<Map<String, dynamic>> enrolledCourses = <Map<String, dynamic>>[
    {
      'id': 1,
      'title': 'Complete Flutter Development',
      'instructor': 'John Smith',
      'progress': 0.65,
      'completed_lessons': 21,
      'total_lessons': 32,
      'completedLessons': 21,
      'totalLessons': 32,
      'completed_lesson_indexes': List<int>.generate(21, (i) => i),
      'quiz_attempted': false,
      'quiz_passed': false,
      'quiz_score': 0,
      'quiz_total': 0,
      'is_completed': false,
      'completion_notified': false,
    },
    {
      'id': 2,
      'title': 'UI/UX Design Masterclass',
      'instructor': 'Sarah Johnson',
      'progress': 0.35,
      'completed_lessons': 8,
      'total_lessons': 24,
      'completedLessons': 8,
      'totalLessons': 24,
      'completed_lesson_indexes': List<int>.generate(8, (i) => i),
      'quiz_attempted': false,
      'quiz_passed': false,
      'quiz_score': 0,
      'quiz_total': 0,
      'is_completed': false,
      'completion_notified': false,
    },
  ].obs;

  // NOTIFICATIONS
  final RxList<Map<String, dynamic>> notifications = <Map<String, dynamic>>[
    {
      'title': 'New lesson available',
      'message': 'A new Flutter lesson has been added.',
      'time': '10 min ago',
      'isRead': false,
    },
    {
      'title': 'Course progress',
      'message': 'You are making great progress!',
      'time': '2 hours ago',
      'isRead': false,
    },
    {
      'title': 'Welcome to LMS',
      'message': 'Start learning and improve your skills.',
      'time': 'Yesterday',
      'isRead': true,
    },
  ].obs;

  // FAVORITES
  final RxList<int> favoriteCourseIds = <int>[].obs;

  // NOTIFICATION FILTER
  final RxString selectedNotificationFilter = 'All'.obs;

  final List<String> notificationFilters = ['All', 'Unread', 'Read'];

  // HELPERS
  int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }

  int _findEnrolledCourseIndex(dynamic courseId) {
    return enrolledCourses.indexWhere(
      (item) => item['id'].toString() == courseId.toString(),
    );
  }

  // COMPLETED COURSES COUNT
  int get completedCoursesCount {
    return enrolledCourses.where((course) {
      return course['is_completed'] == true || isCourseCompleted(course['id']);
    }).length;
  }

  // FILTERED COURSES
  List<Map<String, dynamic>> get filteredCourses {
    final query = searchQuery.value.toLowerCase().trim();

    return courses.where((course) {
      final title = course['title']?.toString().toLowerCase() ?? '';
      final instructor = course['instructor']?.toString().toLowerCase() ?? '';
      final category = course['category']?.toString() ?? '';

      final matchesSearch = title.contains(query) || instructor.contains(query);

      final matchesCategory =
          selectedCategory.value == 'All' || category == selectedCategory.value;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  // CONTINUE LEARNING
  List<Map<String, dynamic>> get continueLearningCourses {
    return enrolledCourses.where((course) {
      return _toDouble(course['progress']) > 0 &&
          course['is_completed'] != true;
    }).toList();
  }

  // FAVORITE COURSES
  List<Map<String, dynamic>> get favoriteCourses {
    return courses.where((course) {
      return favoriteCourseIds.contains(_toInt(course['id']));
    }).toList();
  }

  // NOTIFICATION COUNTS
  int get unreadNotifications {
    return notifications.where((item) => item['isRead'] == false).length;
  }

  int get readNotifications {
    return notifications.where((item) => item['isRead'] == true).length;
  }

  List<MapEntry<int, Map<String, dynamic>>> get filteredNotifications {
    final all = notifications.asMap().entries.toList();

    switch (selectedNotificationFilter.value) {
      case 'Unread':
        return all.where((item) => item.value['isRead'] == false).toList();

      case 'Read':
        return all.where((item) => item.value['isRead'] == true).toList();

      default:
        return all;
    }
  }

  // SEARCH
  void updateSearch(String value) {
    searchQuery.value = value;
  }

  void clearSearch() {
    searchQuery.value = '';
  }

  // CATEGORY
  void selectCategory(String category) {
    selectedCategory.value = category;
    selectedIndex.value = 1;
  }

  // NAVIGATION
  void changeTab(int index) {
    selectedIndex.value = index;
  }

  // COURSE ACTIONS
  void openCourse(Map<String, dynamic> course) {
    Get.toNamed(AppRoutes.courseDetails, arguments: course);
  }

  void openAllCourses() {
    selectedIndex.value = 1;
    selectedCategory.value = 'All';
  }

  // FAVORITES
  bool isFavorite(int courseId) {
    return favoriteCourseIds.contains(courseId);
  }

  void toggleFavorite(Map<String, dynamic> course) {
    final courseId = _toInt(course['id']);

    if (courseId <= 0) return;

    if (favoriteCourseIds.contains(courseId)) {
      favoriteCourseIds.remove(courseId);

      Get.snackbar(
        'Removed',
        'Course removed from favorites.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      favoriteCourseIds.add(courseId);

      Get.snackbar(
        'Added',
        'Course added to favorites.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void removeFavorite(Map<String, dynamic> course) {
    Get.dialog(
      AlertDialog(
        title: const Text('Remove Favorite?'),
        content: Text(
          'Are you sure you want to remove '
          '"${course['title']}" from favorites?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              favoriteCourseIds.remove(_toInt(course['id']));
              Get.back();

              Get.snackbar('Removed', 'Course removed from favorites.');
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // NOTIFICATIONS
  void openNotifications() {
    Get.toNamed(AppRoutes.notifications);
  }

  void markNotificationAsRead(int index) {
    if (index < 0 || index >= notifications.length) return;

    final notification = Map<String, dynamic>.from(notifications[index]);

    notification['isRead'] = true;
    notifications[index] = notification;
  }

  void markAllNotificationsAsRead() {
    for (int i = 0; i < notifications.length; i++) {
      final notification = Map<String, dynamic>.from(notifications[i]);

      notification['isRead'] = true;
      notifications[i] = notification;
    }
  }

  void deleteNotification(int index) {
    if (index < 0 || index >= notifications.length) return;

    notifications.removeAt(index);

    Get.snackbar('Deleted', 'Notification deleted successfully.');
  }

  void selectNotificationFilter(String filter) {
    selectedNotificationFilter.value = filter;
  }

  // ENROLLMENT
  void enrollCourse(Map<String, dynamic> course) {
    final courseId = course['id'];

    final alreadyEnrolled = enrolledCourses.any(
      (item) => item['id'].toString() == courseId.toString(),
    );

    if (alreadyEnrolled) {
      Get.snackbar(
        'Already Enrolled',
        'You are already enrolled in this course.',
      );
      return;
    }

    final totalLessons = _toInt(course['total_lessons'] ?? course['lessons']);

    if (totalLessons <= 0) {
      Get.snackbar(
        'Unable to Enroll',
        'Course lesson information is unavailable.',
      );
      return;
    }

    enrolledCourses.add({
      ...course,
      'progress': 0.0,
      'completed_lessons': 0,
      'total_lessons': totalLessons,
      'completedLessons': 0,
      'totalLessons': totalLessons,
      'completed_lesson_indexes': <int>[],
      'quiz_attempted': false,
      'quiz_passed': false,
      'quiz_score': 0,
      'quiz_total': 0,
      'is_completed': false,
      'completion_notified': false,
      'enrolled_at': DateTime.now().toIso8601String(),
    });

    Get.snackbar(
      'Enrollment Successful',
      'You have successfully enrolled in this course.',
    );
  }

  // MARK LESSON COMPLETED
  void markLessonCompleted({
    required dynamic courseId,
    required int lessonIndex,
    required int totalLessons,
  }) {
    final index = _findEnrolledCourseIndex(courseId);

    if (index == -1 || totalLessons <= 0) return;
    if (lessonIndex < 0 || lessonIndex >= totalLessons) return;

    final course = Map<String, dynamic>.from(enrolledCourses[index]);

    final completedIndexes = List<int>.from(
      course['completed_lesson_indexes'] ?? <int>[],
    );

    if (completedIndexes.contains(lessonIndex)) return;

    completedIndexes.add(lessonIndex);

    final completedCount = completedIndexes.length;
    final progress = (completedCount / totalLessons).clamp(0.0, 1.0);

    course['completed_lesson_indexes'] = completedIndexes;
    course['completed_lessons'] = completedCount;
    course['total_lessons'] = totalLessons;
    course['completedLessons'] = completedCount;
    course['totalLessons'] = totalLessons;
    course['progress'] = progress;

    course['is_completed'] =
        completedCount >= totalLessons && course['quiz_passed'] == true;

    enrolledCourses[index] = Map<String, dynamic>.from(course);

    checkCourseCompletion(courseId);
  }

  // SAVE QUIZ RESULT
  void saveQuizResult({
    required dynamic courseId,
    required int score,
    required int totalQuestions,
  }) {
    final index = _findEnrolledCourseIndex(courseId);

    if (index == -1 || totalQuestions <= 0) return;
    if (score < 0 || score > totalQuestions) return;

    final course = Map<String, dynamic>.from(enrolledCourses[index]);

    final percentage = (score / totalQuestions) * 100;
    final passed = percentage >= 60;

    course['quiz_attempted'] = true;
    course['quiz_passed'] = passed;
    course['quiz_score'] = score;
    course['quiz_total'] = totalQuestions;
    course['quiz_percentage'] = percentage;

    final completed = _toInt(
      course['completed_lessons'] ?? course['completedLessons'],
    );

    final total = _toInt(course['total_lessons'] ?? course['totalLessons']);

    course['completed_lessons'] = completed;
    course['completedLessons'] = completed;
    course['total_lessons'] = total;
    course['totalLessons'] = total;

    final isCompleted = total > 0 && completed >= total && passed;

    course['is_completed'] = isCompleted;

    enrolledCourses[index] = Map<String, dynamic>.from(course);

    checkCourseCompletion(courseId);
  }

  // COURSE COMPLETION CHECK
  bool isCourseCompleted(dynamic courseId) {
    final index = _findEnrolledCourseIndex(courseId);

    if (index == -1) return false;

    final course = enrolledCourses[index];

    final completed = _toInt(
      course['completed_lessons'] ?? course['completedLessons'],
    );

    final total = _toInt(course['total_lessons'] ?? course['totalLessons']);

    return total > 0 && completed >= total && course['quiz_passed'] == true;
  }

  void checkCourseCompletion(dynamic courseId) {
    if (!isCourseCompleted(courseId)) return;

    final index = _findEnrolledCourseIndex(courseId);
    if (index == -1) return;

    final course = Map<String, dynamic>.from(enrolledCourses[index]);

    if (course['completion_notified'] == true) return;

    course['completion_notified'] = true;
    course['is_completed'] = true;

    enrolledCourses[index] = Map<String, dynamic>.from(course);

    Get.snackbar(
      'Course Completed!',
      'Congratulations! You have completed this course.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }
}
