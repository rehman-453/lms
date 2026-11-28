import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_services.dart';
import '../models/dashboard_model.dart';
import '../models/category_model.dart';

class HomeController extends GetxController {
  final ApiServices _apiServices = ApiServices();

  // DASHBOARD
  final RxBool isDashboardLoading = false.obs;
  final RxString dashboardError = ''.obs;
  final Rxn<DashboardModel> dashboardData = Rxn<DashboardModel>();

  DashboardStats? get dashboardStats => dashboardData.value?.stats;

  // STUDENT PROFILE
  final RxString studentName = 'Sami'.obs;
  final RxString studentProfileImage = ''.obs;
  final RxBool isStudentProfileLoading = false.obs;

  // CHECK WHETHER COURSE SHOULD APPEAR IN CONTINUE LEARNING
  bool _shouldShowInContinueLearning(Map<String, dynamic> course) {
    final completionPercentage = _toDouble(course['completion_percentage']);
    final isCompleted = course['is_completed'] == true;

    return !isCompleted && completionPercentage < 100;
  }

  // CONTINUE LEARNING - TYPED MODEL
  List<RecentCourse> get recentCourses {
    return enrolledCourses.where(_shouldShowInContinueLearning).map((item) {
      final instructorName = item['instructor']?.toString() ?? 'Instructor';
      final categoryName = item['category']?.toString() ?? 'General';

      return RecentCourse(
        id: _toInt(item['enrollment_id']),
        status: item['enrollment_status']?.toString() ?? '',
        enrollmentNumber: item['enrollment_number']?.toString() ?? '',
        progress: CourseProgress(
          totalLessons: _toInt(item['total_lessons']),
          completedLessons: _toInt(item['completed_lessons']),
          inProgressLessons: _toInt(item['in_progress_lessons']),
          notStartedLessons: _toInt(item['not_started_lessons']),
          totalWatchedSeconds: _toInt(item['total_watched_seconds']),
          completionPercentage: _toDouble(item['completion_percentage']),
          isCourseCompleted: item['is_completed'] == true,
        ),
        course: DashboardCourse(
          id: _toInt(item['id']),
          title: item['title']?.toString() ?? '',
          shortDescription: item['short_description']?.toString() ?? '',
          thumbnail: item['thumbnail']?.toString(),
          level: item['level']?.toString() ?? '',
          durationMinutes: _toInt(item['duration_minutes']),
          category: DashboardCategory(
            id: _toInt(item['category_id']),
            name: categoryName,
          ),
          instructor: DashboardInstructor(name: instructorName),
        ),
      );
    }).toList();
  }

  // POPULAR COURSES (HOME)
  final RxList<Map<String, dynamic>> courses = <Map<String, dynamic>>[].obs;
  final RxBool isCoursesLoading = false.obs;
  final RxString coursesError = ''.obs;

  // ALL COURSES (EXPLORE)
  final RxList<Map<String, dynamic>> allCourses = <Map<String, dynamic>>[].obs;
  final RxBool isAllCoursesLoading = false.obs;
  final RxString allCoursesError = ''.obs;

  // CATEGORIES
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxBool isCategoriesLoading = false.obs;
  final RxString categoriesError = ''.obs;

  final RxString selectedCategory = 'All'.obs;
  final RxnInt selectedCategoryId = RxnInt();

  // FAVORITES
  final RxList<int> favoriteCourseIds = <int>[].obs;
  final RxBool isFavoritesLoading = false.obs;
  final RxSet<int> favoriteLoadingIds = <int>{}.obs;

  // ENROLLED COURSES
  final RxList<Map<String, dynamic>> enrolledCourses =
      <Map<String, dynamic>>[].obs;

  final RxBool isEnrollmentsLoading = false.obs;
  final RxString enrollmentsError = ''.obs;
  final RxSet<int> enrollmentLoadingIds = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();

    fetchStudentProfile();
    fetchDashboard();
    fetchPopularCourses();
    fetchAllCourses();
    fetchCategories();
    fetchFavorites();
    fetchEnrollments();
  }

  // FETCH STUDENT PROFILE
  Future<void> fetchStudentProfile() async {
    try {
      isStudentProfileLoading.value = true;

      final response = await _apiServices.getMethod(ApiEndpoints.meUrl, true);

      final responseData = jsonDecode(response);

      if (responseData is Map && responseData['success'] == true) {
        final data = responseData['data'];

        if (data is Map) {
          final user = data['user'];
          final profile = data['profile'];

          if (user is Map) {
            studentName.value = user['name']?.toString() ?? 'Student';
          }

          if (profile is Map) {
            final imagePath = profile['profile_image']?.toString() ?? '';

            studentProfileImage.value = imagePath.isNotEmpty
                ? _buildProfileImageUrl(imagePath)
                : '';
          }
        }
      }
    } catch (e) {
      debugPrint('Student Profile API Error: $e');
    } finally {
      isStudentProfileLoading.value = false;
    }
  }

  // BUILD PROFILE IMAGE URL
  String _buildProfileImageUrl(String imagePath) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    }

    final baseUrl = ApiEndpoints.baseUrl.replaceFirst('/api/v1', '');

    final cleanPath = imagePath.startsWith('/')
        ? imagePath.substring(1)
        : imagePath;

    return '$baseUrl/storage/$cleanPath';
  }

  // FETCH STUDENT DASHBOARD
  Future<void> fetchDashboard() async {
    try {
      isDashboardLoading.value = true;
      dashboardError.value = '';

      final response = await _apiServices.getMethod(
        ApiEndpoints.studentDashboardUrl,
        true,
      );

      final responseData = jsonDecode(response);

      if (responseData['success'] == true) {
        dashboardData.value = DashboardModel.fromJson(responseData);
      } else {
        dashboardError.value =
            responseData['message'] ?? 'Unable to load dashboard.';
      }
    } catch (e) {
      dashboardError.value = e.toString().replaceFirst('Exception: ', '');
      debugPrint('Dashboard API Error: $e');
    } finally {
      isDashboardLoading.value = false;
    }
  }

  // FETCH POPULAR COURSES (HOME)
  Future<void> fetchPopularCourses() async {
    try {
      isCoursesLoading.value = true;
      coursesError.value = '';

      final response = await _apiServices.getMethod(
        ApiEndpoints.popularCoursesUrl,
      );

      final responseData = jsonDecode(response);

      if (responseData['success'] == true) {
        final List<dynamic> courseData = responseData['data'] ?? [];

        courses.assignAll(
          courseData.map((item) {
            final course = Map<String, dynamic>.from(item);

            final category = course['category'] is Map
                ? Map<String, dynamic>.from(course['category'])
                : <String, dynamic>{};

            final instructor = course['instructor'] is Map
                ? Map<String, dynamic>.from(course['instructor'])
                : <String, dynamic>{};

            final instructorUser = instructor['user'] is Map
                ? Map<String, dynamic>.from(instructor['user'])
                : <String, dynamic>{};

            final durationMinutes = _toInt(course['duration_minutes']);

            final lessonsCount = _toInt(
              course['lessons_count'] ?? course['total_lessons'],
            );

            return {
              ...course,
              'category': category['name'] ?? 'General',
              'category_id': course['category_id'] ?? category['id'],
              'instructor': instructorUser['name'] ?? 'Instructor',
              'rating': course['rating'],
              'lessons': lessonsCount,
              'lessons_count': lessonsCount,
              'duration_minutes': durationMinutes,
              'duration': _formatCourseDuration(durationMinutes),
              'icon': 'code',
            };
          }).toList(),
        );
      } else {
        coursesError.value =
            responseData['message'] ?? 'Unable to load popular courses.';
      }
    } catch (e) {
      coursesError.value = e.toString().replaceFirst('Exception: ', '');
      debugPrint('Popular Courses API Error: $e');
    } finally {
      isCoursesLoading.value = false;
    }
  }

  // FETCH ALL COURSES (EXPLORE)
  Future<void> fetchAllCourses() async {
    try {
      isAllCoursesLoading.value = true;
      allCoursesError.value = '';

      final response = await _apiServices.getMethod(ApiEndpoints.coursesUrl);

      final responseData = jsonDecode(response);

      if (responseData['success'] == true) {
        final responseCourses = responseData['data'];

        final List<dynamic> courseData = responseCourses is List
            ? responseCourses
            : responseCourses is Map
            ? responseCourses['data'] ?? []
            : [];

        allCourses.assignAll(
          courseData.map((item) {
            final course = Map<String, dynamic>.from(item);

            final category = course['category'] is Map
                ? Map<String, dynamic>.from(course['category'])
                : <String, dynamic>{};

            final instructor = course['instructor'] is Map
                ? Map<String, dynamic>.from(course['instructor'])
                : <String, dynamic>{};

            final instructorUser = instructor['user'] is Map
                ? Map<String, dynamic>.from(instructor['user'])
                : <String, dynamic>{};

            final durationMinutes = _toInt(course['duration_minutes']);

            final lessonsCount = _toInt(
              course['lessons_count'] ?? course['total_lessons'],
            );

            final price = _toDouble(course['price']);
            final discountPrice = _toDouble(course['discount_price']);

            final finalPrice = discountPrice > 0 && discountPrice < price
                ? discountPrice
                : price;

            return {
              ...course,
              'category': category['name'] ?? 'General',
              'category_id': course['category_id'] ?? category['id'],
              'instructor': instructorUser['name'] ?? 'Instructor',
              'rating': course['rating'],
              'lessons': lessonsCount,
              'lessons_count': lessonsCount,
              'duration_minutes': durationMinutes,
              'duration': _formatCourseDuration(durationMinutes),
              'price': finalPrice <= 0
                  ? 'Free'
                  : '${course['currency'] ?? 'PKR'} ${finalPrice.toStringAsFixed(2)}',
              'icon': 'code',
            };
          }).toList(),
        );
      } else {
        allCoursesError.value =
            responseData['message'] ?? 'Unable to load all courses.';
      }
    } catch (e) {
      allCoursesError.value = e.toString().replaceFirst('Exception: ', '');
      debugPrint('All Courses API Error: $e');
    } finally {
      isAllCoursesLoading.value = false;
    }
  }

  // FETCH CATEGORIES
  Future<void> fetchCategories() async {
    try {
      isCategoriesLoading.value = true;
      categoriesError.value = '';

      final response = await _apiServices.getMethod(ApiEndpoints.categoriesUrl);

      final responseData = jsonDecode(response);

      if (responseData['data'] is List) {
        final List<dynamic> categoryData = responseData['data'];

        categories.assignAll(
          categoryData.map((item) {
            return CategoryModel.fromJson(Map<String, dynamic>.from(item));
          }).toList(),
        );
      } else {
        categoriesError.value = 'Unable to load categories.';
      }
    } catch (e) {
      categoriesError.value = e.toString().replaceFirst('Exception: ', '');
      debugPrint('Categories API Error: $e');
    } finally {
      isCategoriesLoading.value = false;
    }
  }

  // FETCH FAVORITES FROM API
  Future<void> fetchFavorites() async {
    try {
      isFavoritesLoading.value = true;

      final response = await _apiServices.getMethod(
        ApiEndpoints.studentFavoritesUrl,
        true,
      );

      final responseData = jsonDecode(response);

      if (responseData['success'] == true) {
        final paginationData = responseData['data'];
        final List<dynamic> favoritesData = paginationData['data'] ?? [];

        favoriteCourseIds.assignAll(
          favoritesData
              .map((item) => _toInt(item['course_id'] ?? item['course']?['id']))
              .where((id) => id > 0),
        );
      }
    } catch (e) {
      debugPrint('Favorites API Error: $e');
    } finally {
      isFavoritesLoading.value = false;
    }
  }

  // FETCH STUDENT ENROLLMENTS
  Future<void> fetchEnrollments() async {
    try {
      isEnrollmentsLoading.value = true;
      enrollmentsError.value = '';

      final response = await _apiServices.getMethod(
        ApiEndpoints.studentEnrollmentsUrl,
        true,
      );

      final responseData = jsonDecode(response);

      if (responseData['success'] == true) {
        final paginationData = responseData['data'];

        final List<dynamic> enrollmentData = paginationData is Map
            ? paginationData['data'] ?? []
            : [];

        enrolledCourses.assignAll(
          enrollmentData.map((item) {
            final enrollment = Map<String, dynamic>.from(item);

            final course = enrollment['course'] is Map
                ? Map<String, dynamic>.from(enrollment['course'])
                : <String, dynamic>{};

            final category = course['category'] is Map
                ? Map<String, dynamic>.from(course['category'])
                : <String, dynamic>{};

            final instructor = course['instructor'] is Map
                ? Map<String, dynamic>.from(course['instructor'])
                : <String, dynamic>{};

            final instructorUser = instructor['user'] is Map
                ? Map<String, dynamic>.from(instructor['user'])
                : <String, dynamic>{};

            final progressData = enrollment['progress'] is Map
                ? Map<String, dynamic>.from(enrollment['progress'])
                : <String, dynamic>{};

            final totalLessons = _toInt(progressData['total_lessons']);
            final completedLessons = _toInt(progressData['completed_lessons']);

            final inProgressLessons = _toInt(
              progressData['in_progress_lessons'],
            );

            final notStartedLessons = _toInt(
              progressData['not_started_lessons'],
            );

            final totalWatchedSeconds = _toInt(
              progressData['total_watched_seconds'],
            );

            final completionPercentage = _toDouble(
              progressData['completion_percentage'],
            ).clamp(0.0, 100.0).toDouble();

            final progress = (completionPercentage / 100)
                .clamp(0.0, 1.0)
                .toDouble();

            final isCourseCompleted =
                progressData['is_course_completed'] == true ||
                completionPercentage >= 100;

            return {
              ...course,
              'category': category['name'] ?? 'General',
              'category_id': course['category_id'] ?? category['id'],
              'instructor': instructorUser['name'] ?? 'Instructor',
              'enrollment_id': enrollment['id'],
              'enrollment_number': enrollment['enrollment_number'],
              'enrollment_status': enrollment['status'],
              'enrolled_at': enrollment['enrolled_at'],
              'progress': progress,
              'completion_percentage': completionPercentage,
              'completed_lessons': completedLessons,
              'total_lessons': totalLessons,
              'completedLessons': completedLessons,
              'totalLessons': totalLessons,
              'in_progress_lessons': inProgressLessons,
              'not_started_lessons': notStartedLessons,
              'total_watched_seconds': totalWatchedSeconds,
              'is_completed': isCourseCompleted,
              'completed_lesson_indexes': <int>[],
              'quiz_attempted': false,
              'quiz_passed': false,
              'quiz_score': 0,
              'quiz_total': 0,
              'completion_notified': isCourseCompleted,
            };
          }).toList(),
        );
      } else {
        enrollmentsError.value =
            responseData['message'] ?? 'Unable to load enrollments.';
      }
    } catch (e) {
      enrollmentsError.value = e.toString().replaceFirst('Exception: ', '');
      debugPrint('Enrollments API Error: $e');
    } finally {
      isEnrollmentsLoading.value = false;
    }
  }

  // ENROLLMENT
  Future<void> enrollCourse(Map<String, dynamic> course) async {
    final courseId = _toInt(course['id']);

    if (courseId <= 0 || enrollmentLoadingIds.contains(courseId)) {
      return;
    }

    final alreadyEnrolled = enrolledCourses.any(
      (item) => _toInt(item['id']) == courseId,
    );

    if (alreadyEnrolled) {
      Get.snackbar(
        'Already Enrolled',
        'You are already enrolled in this course.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      enrollmentLoadingIds.add(courseId);

      final response = await _apiServices.postMethod(
        ApiEndpoints.enrollCourseUrl(courseId),
        {},
        true,
      );

      final responseData = jsonDecode(response);

      if (responseData['success'] == true) {
        await Future.wait([fetchEnrollments(), fetchDashboard()]);

        Get.snackbar(
          'Enrollment Successful',
          responseData['message'] ??
              'You have successfully enrolled in this course.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Enrollment Failed',
          responseData['message'] ?? 'Unable to enroll in this course.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Enrollment Failed',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      enrollmentLoadingIds.remove(courseId);
    }
  }

  // ADD / REMOVE FAVORITE
  Future<void> toggleFavorite(Map<String, dynamic> course) async {
    final courseId = _toInt(course['id']);

    if (courseId <= 0 || favoriteLoadingIds.contains(courseId)) {
      return;
    }

    final isAlreadyFavorite = favoriteCourseIds.contains(courseId);

    try {
      favoriteLoadingIds.add(courseId);

      if (isAlreadyFavorite) {
        await _apiServices.deleteMethod(
          ApiEndpoints.removeCourseFavoriteUrl(courseId),
          true,
        );

        favoriteCourseIds.remove(courseId);

        Get.snackbar(
          'Removed',
          'Course removed from favorites.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        await _apiServices.postMethod(
          ApiEndpoints.addCourseFavoriteUrl(courseId),
          {},
          true,
        );

        favoriteCourseIds.add(courseId);

        Get.snackbar(
          'Added',
          'Course added to favorites.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      favoriteLoadingIds.remove(courseId);
    }
  }

  // FORMAT COURSE DURATION
  String _formatCourseDuration(int minutes) {
    if (minutes <= 0) return 'Duration unavailable';

    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (hours == 0) return '$minutes min';
    if (remainingMinutes == 0) return '$hours hours';

    return '$hours h $remainingMinutes m';
  }

  // NAVIGATION
  final RxInt selectedIndex = 0.obs;

  // SEARCH
  final RxString searchQuery = ''.obs;

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

  // HOME STATS COUNTS
  int get enrolledCoursesCount => enrolledCourses.length;

  int get completedCoursesCount {
    return enrolledCourses.where((course) {
      final percentage = _toDouble(course['completion_percentage']);
      return course['is_completed'] == true || percentage >= 100;
    }).length;
  }

  int get inProgressCoursesCount {
    return enrolledCourses.where((course) {
      final percentage = _toDouble(course['completion_percentage']);
      final isCompleted = course['is_completed'] == true || percentage >= 100;
      return !isCompleted;
    }).length;
  }

  // FILTER POPULAR COURSES (HOME)
  List<Map<String, dynamic>> get filteredCourses {
    final query = searchQuery.value.toLowerCase().trim();

    return courses.where((course) {
      final title = course['title']?.toString().toLowerCase() ?? '';
      final instructor = course['instructor']?.toString().toLowerCase() ?? '';

      final matchesSearch = title.contains(query) || instructor.contains(query);

      final matchesCategory =
          selectedCategoryId.value == null ||
          _toInt(course['category_id']) == selectedCategoryId.value;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  // FILTER ALL COURSES (EXPLORE)
  List<Map<String, dynamic>> get filteredAllCourses {
    final query = searchQuery.value.toLowerCase().trim();

    return allCourses.where((course) {
      final title = course['title']?.toString().toLowerCase() ?? '';
      final instructor = course['instructor']?.toString().toLowerCase() ?? '';

      final matchesSearch = title.contains(query) || instructor.contains(query);

      final matchesCategory =
          selectedCategoryId.value == null ||
          _toInt(course['category_id']) == selectedCategoryId.value;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  // CONTINUE LEARNING
  List<Map<String, dynamic>> get continueLearningCourses {
    return enrolledCourses.where(_shouldShowInContinueLearning).toList();
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

    if (category == 'All') {
      selectedCategoryId.value = null;
      return;
    }

    final selected = categories.firstWhereOrNull(
      (item) => item.name == category,
    );

    selectedCategoryId.value = selected?.id;
  }

  // NAVIGATION
  void changeTab(int index) {
    selectedIndex.value = index;
  }

  void openCourse(Map<String, dynamic> course) {
    Get.toNamed(AppRoutes.courseDetails, arguments: course);
  }

  void openAllCourses() {
    selectedIndex.value = 1;
    selectedCategory.value = 'All';
    selectedCategoryId.value = null;
  }

  // FAVORITES
  bool isFavorite(int courseId) {
    return favoriteCourseIds.contains(courseId);
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

  // PROFILE
  void openProfile() {
    Get.toNamed(AppRoutes.profile);
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

  // MARK LESSON COMPLETED
  Future<void> markLessonCompleted({
    required dynamic courseId,
    required int lessonIndex,
    required int totalLessons,
  }) async {
    await fetchEnrollments();
    await fetchDashboard();
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

    course['quiz_attempted'] = true;
    course['quiz_passed'] = percentage >= 60;
    course['quiz_score'] = score;
    course['quiz_total'] = totalQuestions;
    course['quiz_percentage'] = percentage;

    enrolledCourses[index] = course;
  }

  // COURSE COMPLETION CHECK
  bool isCourseCompleted(dynamic courseId) {
    final index = _findEnrolledCourseIndex(courseId);

    if (index == -1) return false;

    final course = enrolledCourses[index];

    return course['is_completed'] == true ||
        _toDouble(course['completion_percentage']) >= 100;
  }

  void checkCourseCompletion(dynamic courseId) {
    if (!isCourseCompleted(courseId)) return;

    final index = _findEnrolledCourseIndex(courseId);
    if (index == -1) return;

    final course = Map<String, dynamic>.from(enrolledCourses[index]);

    if (course['completion_notified'] == true) return;

    course['completion_notified'] = true;
    enrolledCourses[index] = course;

    Get.snackbar(
      'Course Completed!',
      'Congratulations! You have completed this course.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }
}
