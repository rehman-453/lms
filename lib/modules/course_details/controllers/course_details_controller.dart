import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../home/controllers/home_controller.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_services.dart';
import '../models/course_details_model.dart';

class CourseDetailsController extends GetxController {
  final ApiServices _apiServices = ApiServices();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rxn<CourseDetailsModel> courseDetails = Rxn<CourseDetailsModel>();

  final RxList<int> expandedSections = <int>[0].obs;
  final RxBool isEnrolled = false.obs;

  // Completed lesson IDs from enrollment API.
  final RxSet<String> completedLessonIds = <String>{}.obs;

  dynamic enrollmentId;

  late final Map<String, dynamic> course;
  late final dynamic courseId;

  final List<Map<String, dynamic>> learningOutcomes = [
    {'title': 'Understand the core concepts', 'icon': 'check'},
    {'title': 'Build practical projects', 'icon': 'check'},
    {'title': 'Apply skills to real-world tasks', 'icon': 'check'},
    {'title': 'Develop problem-solving skills', 'icon': 'check'},
  ];

  @override
  void onInit() {
    super.onInit();

    final arguments = Get.arguments;

    if (arguments is Map) {
      course = Map<String, dynamic>.from(arguments);
    } else {
      course = {};
    }

    courseId = course['id'];

    if (courseId != null) {
      checkEnrollment();
      fetchCourseDetails();
    } else {
      errorMessage.value = 'Course ID is unavailable.';
    }
  }

  // --------------------------------------------------
  // FETCH COURSE DETAILS
  // --------------------------------------------------

  Future<void> fetchCourseDetails() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _apiServices.getMethod(
        ApiEndpoints.courseDetailsUrl(courseId),
      );

      final responseData = jsonDecode(response);

      if (responseData is Map &&
          responseData['success'] == true &&
          responseData['data'] is Map) {
        courseDetails.value = CourseDetailsModel.fromJson(
          Map<String, dynamic>.from(responseData['data']),
        );

        expandedSections.assignAll(
          courseDetails.value!.sections.isNotEmpty ? [0] : [],
        );
      } else {
        errorMessage.value = responseData is Map
            ? responseData['message']?.toString() ??
                  'Unable to load course details.'
            : 'Invalid server response.';
      }
    } catch (e, stackTrace) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');

      debugPrint('COURSE DETAILS API ERROR: $e');
      debugPrint('$stackTrace');
    } finally {
      isLoading.value = false;
    }
  }

  // --------------------------------------------------
  // ENROLLMENT PROGRESS
  // --------------------------------------------------

  Future<void> fetchEnrollmentProgress() async {
    if (!isEnrolled.value || enrollmentId == null) {
      completedLessonIds.clear();
      return;
    }

    try {
      final response = await _apiServices.getMethod(
        ApiEndpoints.enrollmentDetailsUrl(enrollmentId),
        true,
      );

      final decoded = jsonDecode(response);

      if (decoded is! Map || decoded['success'] != true) {
        debugPrint('ENROLLMENT PROGRESS API: Invalid response.');
        return;
      }

      final data = decoded['data'];

      if (data is! Map) return;

      final enrollment = data['enrollment'];

      if (enrollment is! Map) return;

      final records = enrollment['lesson_progress'];

      final Set<String> completedIds = {};

      if (records is List) {
        for (final item in records) {
          if (item is! Map) continue;

          final lessonId = item['lesson_id'];

          if (lessonId != null && item['is_completed'] == true) {
            completedIds.add(lessonId.toString());
          }
        }
      }

      completedLessonIds.assignAll(completedIds);
    } catch (e, stackTrace) {
      debugPrint('FETCH ENROLLMENT PROGRESS ERROR: $e');
      debugPrint('$stackTrace');
    }
  }

  bool isLessonCompleted(dynamic lessonId) {
    if (lessonId == null) return false;

    return completedLessonIds.contains(lessonId.toString());
  }

  int completedLessonsInSection(List<Map<String, dynamic>> lessons) {
    return lessons.where((lesson) {
      return isLessonCompleted(lesson['id']);
    }).length;
  }

  // --------------------------------------------------
  // ENROLL COURSE
  // --------------------------------------------------

  Future<void> enrollNow() async {
    if (course.isEmpty || courseId == null) return;

    if (!Get.isRegistered<HomeController>()) {
      Get.snackbar(
        'Error',
        'Home controller is unavailable.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final homeController = Get.find<HomeController>();

    final existingEnrollment = homeController.enrolledCourses.firstWhereOrNull(
      (item) => item['id'].toString() == courseId.toString(),
    );

    if (existingEnrollment != null) {
      isEnrolled.value = true;
      enrollmentId = existingEnrollment['enrollment_id'];

      await fetchEnrollmentProgress();

      Get.snackbar(
        'Already Enrolled',
        'You are already enrolled in this course.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final details = courseDetails.value;

    if (details == null) {
      Get.snackbar(
        'Unable to Enroll',
        'Course details are not available.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final courseForEnrollment = {
      ...course,
      'id': details.id ?? courseId,
      'title': courseTitle,
      'instructor': instructor,
      'category': category,
      'duration': duration,
      'price': price,
      'total_lessons': totalLessons,
      'lessons': totalLessons,
      'description': description,
    };

    try {
      await homeController.enrollCourse(courseForEnrollment);

      await homeController.fetchEnrollments();

      checkEnrollment();

      await fetchEnrollmentProgress();

      if (isEnrolled.value) {
        Get.snackbar(
          'Success',
          'You are now enrolled in this course.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      debugPrint('COURSE ENROLLMENT ERROR: $e');

      Get.snackbar(
        'Enrollment Failed',
        'Unable to enroll in this course. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // --------------------------------------------------
  // CHECK ENROLLMENT
  // --------------------------------------------------

  void checkEnrollment() {
    if (!Get.isRegistered<HomeController>() || courseId == null) {
      isEnrolled.value = false;
      enrollmentId = null;
      completedLessonIds.clear();
      return;
    }

    final homeController = Get.find<HomeController>();

    final enrolledCourse = homeController.enrolledCourses.firstWhereOrNull(
      (item) => item['id'].toString() == courseId.toString(),
    );

    isEnrolled.value = enrolledCourse != null;

    enrollmentId = enrolledCourse?['enrollment_id'];

    if (isEnrolled.value && enrollmentId != null) {
      fetchEnrollmentProgress();
    } else {
      completedLessonIds.clear();
    }
  }

  // --------------------------------------------------
  // COURSE GETTERS
  // --------------------------------------------------

  String get courseTitle =>
      courseDetails.value?.title ??
      course['title']?.toString() ??
      'Course Details';

  String get instructor =>
      courseDetails.value?.instructor?.name ??
      course['instructor']?.toString() ??
      'Instructor';

  String get category =>
      courseDetails.value?.category?.name ??
      course['category']?.toString() ??
      'General';

  String get duration {
    final minutes = courseDetails.value?.durationMinutes;

    if (minutes == null || minutes <= 0) {
      return course['duration']?.toString() ?? 'N/A';
    }

    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (hours == 0) return '$remainingMinutes min';
    if (remainingMinutes == 0) return '$hours hours';

    return '$hours h $remainingMinutes m';
  }

  String get rating => course['rating']?.toString() ?? '4.8';

  int get totalLessons {
    return curriculum.fold<int>(
      0,
      (total, section) => total + (section['lessons'] as List).length,
    );
  }

  String get price {
    final details = courseDetails.value;

    if (details == null) {
      return course['price']?.toString() ?? 'Free';
    }

    final amount = double.tryParse(details.price) ?? 0;

    if (amount <= 0) return 'Free';

    final discount = double.tryParse(details.discountPrice ?? '');

    if (discount != null && discount < amount) {
      return '${details.currency} ${discount.toStringAsFixed(2)}';
    }

    return '${details.currency} ${amount.toStringAsFixed(2)}';
  }

  String get description =>
      courseDetails.value?.description ??
      courseDetails.value?.shortDescription ??
      'Course description is unavailable.';

  String get level => courseDetails.value?.level ?? 'All';

  String get instructorBio => courseDetails.value?.instructor?.bio ?? '';

  String get instructorQualification =>
      courseDetails.value?.instructor?.qualification ?? '';

  String get instructorSpecialization =>
      courseDetails.value?.instructor?.specialization ?? '';

  // --------------------------------------------------
  // CURRICULUM
  // --------------------------------------------------

  List<Map<String, dynamic>> get curriculum {
    return (courseDetails.value?.sections ?? []).map((section) {
      return {
        'id': section.id,
        'title': section.title,
        'description': section.description,
        'lessons': section.lessons.where((lesson) => lesson.isPublished).map((
          lesson,
        ) {
          return {
            'id': lesson.id,
            'title': lesson.title,
            'slug': lesson.slug,
            'type': lesson.type,
            'description': lesson.description,
            'content': lesson.content,
            'video_url': lesson.videoUrl,
            'video_duration_seconds': lesson.videoDurationSeconds,
            'duration': lesson.formattedDuration,
            'is_preview': lesson.isPreview,
            'is_published': lesson.isPublished,
          };
        }).toList(),
      };
    }).toList();
  }

  // --------------------------------------------------
  // FAVORITES
  // --------------------------------------------------

  bool get isFavorite {
    if (!Get.isRegistered<HomeController>() || courseId == null) {
      return false;
    }

    return Get.find<HomeController>().isFavorite(
      int.tryParse(courseId.toString()) ?? 0,
    );
  }

  void toggleFavorite() {
    if (course.isEmpty) return;

    if (!Get.isRegistered<HomeController>()) return;

    Get.find<HomeController>().toggleFavorite(course);
  }

  // --------------------------------------------------
  // SECTION EXPANSION
  // --------------------------------------------------

  void toggleSection(int index) {
    if (expandedSections.contains(index)) {
      expandedSections.remove(index);
    } else {
      expandedSections.add(index);
    }
  }

  // --------------------------------------------------
  // OPEN LESSON PLAYER
  // --------------------------------------------------

  Future<void> openLesson(
    Map<String, dynamic> lesson, {
    required Map<String, dynamic> section,
  }) async {
    if (!Get.isRegistered<HomeController>()) {
      Get.snackbar(
        'Error',
        'Enrollment information is not available.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final homeController = Get.find<HomeController>();

    final enrolledCourse = homeController.enrolledCourses.firstWhereOrNull(
      (item) => item['id'].toString() == courseId.toString(),
    );

    final currentEnrollmentId = enrolledCourse?['enrollment_id'];

    if (currentEnrollmentId == null) {
      Get.snackbar(
        'Enrollment Required',
        'Please enroll in this course first.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final sectionLessons =
        (section['lessons'] as List<Map<String, dynamic>>?) ?? [];

    final selectedIndex = sectionLessons.indexWhere(
      (item) => item['id'].toString() == lesson['id'].toString(),
    );

    if (selectedIndex == -1) {
      Get.snackbar(
        'Error',
        'Selected lesson was not found.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    await Get.toNamed(
      AppRoutes.lessonPlayer,
      arguments: {
        'course': {
          'id': courseDetails.value?.id ?? courseId,
          'title': courseTitle,
          'instructor': instructor,
          'category': category,
          'description': description,
          'duration': duration,
        },
        'enrollment_id': currentEnrollmentId,
        'selected_section_id': section['id'],
        'selected_section_title': section['title'],
        'selected_lesson_id': lesson['id'],
        'lessons': sectionLessons,
        'selected_lesson_index': selectedIndex,
      },
    );

    // Refresh completion status when returning from Lesson Player.
    await fetchEnrollmentProgress();
  }
}
