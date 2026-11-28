import 'dart:convert';

import 'package:get/get.dart';

import '../../../core/network/api_services.dart';
import '../../../core/network/api_endpoints.dart';

// import '../../../core/constants/api_endpoints.dart';

class ProgressController extends GetxController {
  final ApiServices apiServices = ApiServices();

  // Loading and error
  final RxBool isLoading = false.obs;
  final RxBool isActivityLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString activityErrorMessage = ''.obs;

  // Selected chart period
  final RxInt selectedPeriod = 0.obs;

  final List<String> periods = ['Week', 'Month', 'Year'];
  final List<String> periodKeys = ['week', 'month', 'year'];

  // Overview values
  final RxInt totalCourses = 0.obs;
  final RxInt completedCourses = 0.obs;
  final RxInt completedLessons = 0.obs;
  final RxInt totalLessons = 0.obs;
  final RxInt overallProgress = 0.obs;

  final RxDouble totalLearningHours = 0.0.obs;
  final RxDouble averageQuizScore = 0.0.obs;

  // Course progress
  final RxList<Map<String, dynamic>> courseProgress =
      <Map<String, dynamic>>[].obs;

  // Activity chart
  final RxList<Map<String, dynamic>> weeklyActivity =
      <Map<String, dynamic>>[].obs;

  final RxDouble activityTotalHours = 0.0.obs;

  // Recent activities
  final RxList<Map<String, dynamic>> recentActivities =
      <Map<String, dynamic>>[].obs;

  // Chart colors
  final List<int> courseColors = [
    0xFF2F6BFF,
    0xFF8B5CF6,
    0xFF20B486,
    0xFFFFB547,
    0xFFEC4899,
    0xFF06B6D4,
  ];

  double get maxWeeklyHours {
    if (weeklyActivity.isEmpty) return 1.0;

    final maxValue = weeklyActivity
        .map((activity) => (activity['hours'] as num).toDouble())
        .fold<double>(0.0, (a, b) => a > b ? a : b);

    return maxValue <= 0 ? 1.0 : maxValue;
  }

  @override
  void onInit() {
    super.onInit();
    fetchProgress();
  }

  // Fetch complete progress dashboard
  Future<void> fetchProgress() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await apiServices.getMethod(
        ApiEndpoints.studentProgressUrl,
        true,
      );

      final decoded = jsonDecode(response);

      if (decoded is! Map<String, dynamic> || decoded['success'] != true) {
        throw Exception(
          decoded is Map ? decoded['message'] : 'Invalid server response',
        );
      }

      final data = decoded['data'] as Map<String, dynamic>;
      final overview = data['overview'] as Map<String, dynamic>;

      totalCourses.value = _toInt(overview['total_courses']);
      completedCourses.value = _toInt(overview['completed_courses']);
      totalLessons.value = _toInt(overview['total_lessons']);
      completedLessons.value = _toInt(overview['completed_lessons']);
      overallProgress.value = _toInt(overview['overall_progress']);

      totalLearningHours.value = _toDouble(overview['total_learning_hours']);

      averageQuizScore.value = _toDouble(overview['average_quiz_score']);

      // Course progress
      final courses = data['course_progress'] as List? ?? [];

      courseProgress.assignAll(
        courses.asMap().entries.map((entry) {
          final index = entry.key;
          final course = Map<String, dynamic>.from(entry.value);

          final progress = _toDouble(course['progress']);

          return {
            'id': course['course_id'],
            'title': course['course_title'] ?? 'Untitled Course',
            'category': 'Course',
            'progress': progress,
            'completedLessons': _toInt(course['completed_lessons']),
            'totalLessons': _toInt(course['total_lessons']),
            'percentage': _toInt(course['percentage']),
            'thumbnail': course['thumbnail'],
            'color': courseColors[index % courseColors.length],
          };
        }).toList(),
      );

      // Recent activities
      final activities = data['recent_activities'] as List? ?? [];

      recentActivities.assignAll(
        activities.map((item) {
          final activity = Map<String, dynamic>.from(item);

          final isQuiz = activity['type'] == 'quiz';

          return {
            'title': activity['title'] ?? 'Activity',
            'subtitle': activity['course_title'] ?? 'Course',
            'type': isQuiz ? 'Quiz Completed' : 'Lesson Completed',
            'time': _formatTime(activity['activity_at']),
            'icon': isQuiz ? 'quiz' : 'lesson',
            'color': isQuiz ? 0xFF8B5CF6 : 0xFF2F6BFF,
            'percentage': activity['percentage'],
            'isPassed': activity['is_passed'],
          };
        }).toList(),
      );

      // Load chart for currently selected period
      await fetchActivity();
    } catch (e) {
      errorMessage.value = _errorText(e);
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch activity chart
  Future<void> fetchActivity() async {
    try {
      isActivityLoading.value = true;
      activityErrorMessage.value = '';

      final period = periodKeys[selectedPeriod.value];

      final response = await apiServices.getMethod(
        ApiEndpoints.studentProgressActivityUrl(period),
        true,
      );

      final decoded = jsonDecode(response);

      if (decoded is! Map<String, dynamic> || decoded['success'] != true) {
        throw Exception(
          decoded is Map ? decoded['message'] : 'Invalid activity response',
        );
      }

      final data = decoded['data'] as Map<String, dynamic>;

      activityTotalHours.value = _toDouble(data['total_hours']);

      final chart = data['chart'] as List? ?? [];

      weeklyActivity.assignAll(
        chart.map((item) {
          final point = Map<String, dynamic>.from(item);

          return {
            'day': point['label']?.toString() ?? '',
            'date': point['date']?.toString() ?? '',
            'hours': _toDouble(point['hours']),
            'totalSeconds': _toInt(point['total_seconds']),
          };
        }).toList(),
      );
    } catch (e) {
      activityErrorMessage.value = _errorText(e);
      weeklyActivity.clear();
      activityTotalHours.value = 0;
    } finally {
      isActivityLoading.value = false;
    }
  }

  // Change chart period
  void changePeriod(int index) {
    if (index < 0 || index >= periods.length) return;
    if (selectedPeriod.value == index) return;

    selectedPeriod.value = index;
    fetchActivity();
  }

  // Refresh all progress data
  Future<void> refreshProgress() async {
    await fetchProgress();
  }

  int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.round();
    return int.tryParse(value.toString()) ?? 0;
  }

  double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  String _errorText(dynamic error) {
    return error.toString().replaceFirst('Exception: ', '');
  }

  String _formatTime(dynamic value) {
    if (value == null) return '';

    final date = DateTime.tryParse(value.toString());

    if (date == null) return '';

    final difference = DateTime.now().difference(date.toLocal());

    if (difference.isNegative) return 'Just now';
    if (difference.inSeconds < 60) return 'Just now';
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    }
    if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    }
    if (difference.inDays == 1) return 'Yesterday';
    if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    }

    return '${date.day}/${date.month}/${date.year}';
  }
}
