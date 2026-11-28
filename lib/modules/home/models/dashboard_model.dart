class DashboardModel {
  final DashboardStats stats;
  final List<RecentCourse> recentCourses;

  DashboardModel({required this.stats, required this.recentCourses});

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    final data = _asMap(json['data']);

    return DashboardModel(
      stats: DashboardStats.fromJson(_asMap(data['stats'])),
      recentCourses: _asList(data['recent_courses'])
          .map((item) => RecentCourse.fromJson(_asMap(item)))
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
      totalEnrolledCourses: _toInt(json['total_enrolled_courses']),
      completedCourses: _toInt(json['completed_courses']),
      inProgressCourses: _toInt(json['in_progress_courses']),
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
      id: _toInt(json['id']),
      status: _toString(json['status']),
      enrollmentNumber: _toString(json['enrollment_number']),
      progress: CourseProgress.fromJson(_asMap(json['progress'])),
      course: DashboardCourse.fromJson(_asMap(json['course'])),
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
      totalLessons: _toInt(json['total_lessons']),
      completedLessons: _toInt(json['completed_lessons']),
      inProgressLessons: _toInt(json['in_progress_lessons']),
      notStartedLessons: _toInt(json['not_started_lessons']),
      totalWatchedSeconds: _toInt(json['total_watched_seconds']),
      completionPercentage: _toDouble(json['completion_percentage']),
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
      id: _toInt(json['id']),
      title: _toString(json['title']),
      shortDescription: _toString(json['short_description']),
      thumbnail: json['thumbnail']?.toString(),
      level: _toString(json['level']),
      durationMinutes: _toInt(json['duration_minutes']),
      category: json['category'] is Map
          ? DashboardCategory.fromJson(_asMap(json['category']))
          : null,
      instructor: json['instructor'] is Map
          ? DashboardInstructor.fromJson(_asMap(json['instructor']))
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
      id: _toInt(json['id']),
      name: _toString(json['name']),
    );
  }
}

class DashboardInstructor {
  final String name;

  DashboardInstructor({required this.name});

  factory DashboardInstructor.fromJson(Map<String, dynamic> json) {
    final user = _asMap(json['user']);

    return DashboardInstructor(name: _toString(user['name']));
  }
}

// JSON HELPERS

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }

  return <String, dynamic>{};
}

List<dynamic> _asList(dynamic value) {
  return value is List ? value : <dynamic>[];
}

int _toInt(dynamic value) {
  if (value is num) return value.toInt();

  return int.tryParse(value?.toString() ?? '') ?? 0;
}

double _toDouble(dynamic value) {
  if (value is num) return value.toDouble();

  return double.tryParse(value?.toString() ?? '') ?? 0.0;
}

String _toString(dynamic value) {
  return value?.toString() ?? '';
}
