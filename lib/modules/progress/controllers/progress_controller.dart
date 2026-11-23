import 'package:get/get.dart';

class ProgressController extends GetxController {
  final RxInt selectedPeriod = 0.obs;

  final List<String> periods = ['Week', 'Month', 'Year'];

  final RxList<Map<String, dynamic>> courseProgress = <Map<String, dynamic>>[
    {
      'title': 'Flutter Development',
      'category': 'Mobile Development',
      'progress': 0.75,
      'completedLessons': 15,
      'totalLessons': 20,
      'color': 0xFF2F6BFF,
    },
    {
      'title': 'UI/UX Design Fundamentals',
      'category': 'Design',
      'progress': 0.45,
      'completedLessons': 9,
      'totalLessons': 20,
      'color': 0xFF8B5CF6,
    },
    {
      'title': 'Laravel API Development',
      'category': 'Backend Development',
      'progress': 0.90,
      'completedLessons': 18,
      'totalLessons': 20,
      'color': 0xFF20B486,
    },
    {
      'title': 'Database Management',
      'category': 'Database',
      'progress': 0.30,
      'completedLessons': 6,
      'totalLessons': 20,
      'color': 0xFFFFB547,
    },
  ].obs;

  final RxList<Map<String, dynamic>> weeklyActivity = <Map<String, dynamic>>[
    {'day': 'Mon', 'hours': 1.5},
    {'day': 'Tue', 'hours': 2.5},
    {'day': 'Wed', 'hours': 1.0},
    {'day': 'Thu', 'hours': 3.0},
    {'day': 'Fri', 'hours': 2.0},
    {'day': 'Sat', 'hours': 3.5},
    {'day': 'Sun', 'hours': 1.5},
  ].obs;

  final RxList<Map<String, dynamic>> recentActivities = <Map<String, dynamic>>[
    {
      'title': 'Introduction to Flutter',
      'subtitle': 'Flutter Development',
      'type': 'Lesson Completed',
      'time': '2 hours ago',
      'icon': 'lesson',
      'color': 0xFF2F6BFF,
    },
    {
      'title': 'Flutter Basics Quiz',
      'subtitle': 'Flutter Development',
      'type': 'Quiz Completed',
      'time': 'Yesterday',
      'icon': 'quiz',
      'color': 0xFF8B5CF6,
    },
    {
      'title': 'Laravel Routing',
      'subtitle': 'Laravel API Development',
      'type': 'Lesson Completed',
      'time': '2 days ago',
      'icon': 'lesson',
      'color': 0xFF20B486,
    },
  ].obs;

  int get totalCourses => courseProgress.length;

  int get completedLessons => courseProgress.fold(
    0,
    (sum, course) => sum + (course['completedLessons'] as int),
  );

  int get totalLessons => courseProgress.fold(
    0,
    (sum, course) => sum + (course['totalLessons'] as int),
  );

  int get overallProgress {
    if (totalLessons == 0) return 0;

    return ((completedLessons / totalLessons) * 100).round();
  }

  int get completedCourses => courseProgress.where((course) {
    return (course['progress'] as double) >= 1.0;
  }).length;

  double get totalLearningHours {
    return weeklyActivity.fold(
      0.0,
      (sum, activity) => sum + (activity['hours'] as double),
    );
  }

  double get averageQuizScore => 84.0;

  double get maxWeeklyHours {
    if (weeklyActivity.isEmpty) return 1.0;

    final maxValue = weeklyActivity
        .map((activity) => activity['hours'] as double)
        .reduce((a, b) => a > b ? a : b);

    return maxValue <= 0 ? 1.0 : maxValue;
  }

  void changePeriod(int index) {
    selectedPeriod.value = index;
  }
}
