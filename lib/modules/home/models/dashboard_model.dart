class DashboardModel {
  final DashboardStats stats;
  final List<RecentCourse> recentCourses;

  DashboardModel({required this.stats, required this.recentCourses});

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};

    return DashboardModel(
      stats: DashboardStats.fromJson(data['stats'] ?? {}),
      recentCourses: (data['recent_courses'] as List? ?? [])
          .map((item) => RecentCourse.fromJson(item))
          .toList(),
    );
  }
}

class DashboardStats {
  final int totalEnrolledCourses;
  final int completedCourses;
  final int inProgressCourses;

  DashboardStats({
    required this.totalEnrolledCourses,
    required this.completedCourses,
    required this.inProgressCourses,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalEnrolledCourses:
          int.tryParse(json['total_enrolled_courses'].toString()) ?? 0,
      completedCourses: int.tryParse(json['completed_courses'].toString()) ?? 0,
      inProgressCourses:
          int.tryParse(json['in_progress_courses'].toString()) ?? 0,
    );
  }
}

class RecentCourse {
  final int id;
  final String status;
  final String enrollmentNumber;
  final CourseProgress progress;
  final DashboardCourse course;

  RecentCourse({
    required this.id,
    required this.status,
    required this.enrollmentNumber,
    required this.progress,
    required this.course,
  });

  factory RecentCourse.fromJson(Map<String, dynamic> json) {
    return RecentCourse(
      id: int.tryParse(json['id'].toString()) ?? 0,
      status: json['status'] ?? '',
      enrollmentNumber: json['enrollment_number'] ?? '',
      progress: CourseProgress.fromJson(json['progress'] ?? {}),
      course: DashboardCourse.fromJson(json['course'] ?? {}),
    );
  }
}

class CourseProgress {
  final int totalLessons;
  final int completedLessons;
  final int inProgressLessons;
  final int notStartedLessons;
  final int totalWatchedSeconds;
  final double completionPercentage;
  final bool isCourseCompleted;

  CourseProgress({
    required this.totalLessons,
    required this.completedLessons,
    required this.inProgressLessons,
    required this.notStartedLessons,
    required this.totalWatchedSeconds,
    required this.completionPercentage,
    required this.isCourseCompleted,
  });

  factory CourseProgress.fromJson(Map<String, dynamic> json) {
    return CourseProgress(
      totalLessons: int.tryParse(json['total_lessons'].toString()) ?? 0,
      completedLessons: int.tryParse(json['completed_lessons'].toString()) ?? 0,
      inProgressLessons:
          int.tryParse(json['in_progress_lessons'].toString()) ?? 0,
      notStartedLessons:
          int.tryParse(json['not_started_lessons'].toString()) ?? 0,
      totalWatchedSeconds:
          int.tryParse(json['total_watched_seconds'].toString()) ?? 0,
      completionPercentage:
          double.tryParse(json['completion_percentage'].toString()) ?? 0.0,
      isCourseCompleted: json['is_course_completed'] == true,
    );
  }
}

class DashboardCourse {
  final int id;
  final String title;
  final String shortDescription;
  final String? thumbnail;
  final String level;
  final int durationMinutes;
  final DashboardCategory? category;
  final DashboardInstructor? instructor;

  DashboardCourse({
    required this.id,
    required this.title,
    required this.shortDescription,
    this.thumbnail,
    required this.level,
    required this.durationMinutes,
    this.category,
    this.instructor,
  });

  factory DashboardCourse.fromJson(Map<String, dynamic> json) {
    return DashboardCourse(
      id: int.tryParse(json['id'].toString()) ?? 0,
      title: json['title'] ?? '',
      shortDescription: json['short_description'] ?? '',
      thumbnail: json['thumbnail'],
      level: json['level'] ?? '',
      durationMinutes: int.tryParse(json['duration_minutes'].toString()) ?? 0,
      category: json['category'] is Map
          ? DashboardCategory.fromJson(json['category'])
          : null,
      instructor: json['instructor'] is Map
          ? DashboardInstructor.fromJson(json['instructor'])
          : null,
    );
  }
}

class DashboardCategory {
  final int id;
  final String name;

  DashboardCategory({required this.id, required this.name});

  factory DashboardCategory.fromJson(Map<String, dynamic> json) {
    return DashboardCategory(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class DashboardInstructor {
  final String name;

  DashboardInstructor({required this.name});

  factory DashboardInstructor.fromJson(Map<String, dynamic> json) {
    final user = json['user'] is Map ? json['user'] : {};

    return DashboardInstructor(name: user['name'] ?? '');
  }
}
