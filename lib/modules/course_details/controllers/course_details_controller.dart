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

  Future<void> fetchCourseDetails() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _apiServices.getMethod(
        ApiEndpoints.courseDetailsUrl(courseId),
      );

      final responseData = jsonDecode(response);

      if (responseData['success'] == true && responseData['data'] is Map) {
        courseDetails.value = CourseDetailsModel.fromJson(
          Map<String, dynamic>.from(responseData['data']),
        );

        expandedSections.assignAll(
          courseDetails.value!.sections.isNotEmpty ? [0] : [],
        );
      } else {
        errorMessage.value =
            responseData['message'] ?? 'Unable to load course details.';
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      debugPrint('Course Details API Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ENROLL COURSE
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

    final alreadyEnrolled = homeController.enrolledCourses.any(
      (item) => item['id'].toString() == courseId.toString(),
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

    final details = courseDetails.value;

    final courseForEnrollment = {
      ...course,
      'id': details?.id ?? courseId,
      'title': courseTitle,
      'instructor': instructor,
      'category': category,
      'duration': duration,
      'price': price,
      'total_lessons': totalLessons,
      'lessons': totalLessons,
      'description': description,
    };

    await homeController.enrollCourse(courseForEnrollment);

    checkEnrollment();
  }

  void checkEnrollment() {
    if (!Get.isRegistered<HomeController>() || courseId == null) return;

    final homeController = Get.find<HomeController>();

    isEnrolled.value = homeController.enrolledCourses.any(
      (item) => item['id'].toString() == courseId.toString(),
    );
  }

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
      (total, section) => total + section['lessons'].length as int,
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

    Get.find<HomeController>().toggleFavorite(course);
  }

  void toggleSection(int index) {
    if (expandedSections.contains(index)) {
      expandedSections.remove(index);
    } else {
      expandedSections.add(index);
    }
  }

  // void enrollNow() {
  //   if (course.isEmpty) return;

  //   final homeController = Get.find<HomeController>();

  //   final alreadyEnrolled = homeController.enrolledCourses.any(
  //     (item) => item['id'].toString() == courseId.toString(),
  //   );

  //   if (alreadyEnrolled) {
  //     isEnrolled.value = true;

  //     Get.snackbar(
  //       'Already Enrolled',
  //       'You are already enrolled in this course.',
  //       snackPosition: SnackPosition.BOTTOM,
  //     );

  //     return;
  //   }

  //   final details = courseDetails.value;

  //   final courseForEnrollment = {
  //     ...course,
  //     'id': details?.id ?? courseId,
  //     'title': courseTitle,
  //     'instructor': instructor,
  //     'category': category,
  //     'duration': duration,
  //     'price': price,
  //     'total_lessons': totalLessons,
  //     'lessons': totalLessons,
  //     'description': description,
  //   };

  //   if (totalLessons <= 0) {
  //     Get.snackbar(
  //       'Unable to Enroll',
  //       'Course lesson information is unavailable.',
  //     );
  //     return;
  //   }

  //   homeController.enrollCourse(courseForEnrollment);
  //   checkEnrollment();
  // }

  void openLesson(Map<String, dynamic> lesson) {
    final allLessons = curriculum
        .expand((section) => section['lessons'] as List<Map<String, dynamic>>)
        .toList();

    Get.toNamed(
      AppRoutes.lessonPlayer,
      arguments: {
        'course': {
          ...course,
          'id': courseDetails.value?.id ?? courseId,
          'title': courseTitle,
        },
        'lessons': allLessons,
      },
    );
  }
}
