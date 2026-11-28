import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lms/app/routes/app_routes.dart';
import 'package:video_player/video_player.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_services.dart';

// Apne project mein HomeController ka actual path verify karein.
import '../../home/controllers/home_controller.dart';

class LessonPlayerController extends GetxController {
  final ApiServices _apiServices = ApiServices();

  final Map<String, dynamic> course = {};

  dynamic enrollmentId;
  dynamic selectedSectionId;
  dynamic selectedLessonId;

  String selectedSectionTitle = '';

  final RxList<Map<String, dynamic>> lessons = <Map<String, dynamic>>[].obs;

  final RxInt currentLessonIndex = 0.obs;
  final RxList<int> completedLessons = <int>[].obs;

  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxBool isExpanded = true.obs;

  final RxBool isPlaying = false.obs;
  final RxBool isSavingProgress = false.obs;

  final RxDouble videoPosition = 0.0.obs;
  final RxDouble videoDuration = 0.0.obs;

  final RxMap<String, dynamic> progressData = <String, dynamic>{}.obs;

  VideoPlayerController? videoController;

  bool _isClosing = false;
  int _videoRequestId = 0;

  final Map<String, int> _watchedSecondsByLesson = {};

  // --------------------------------------------------
  // GETTERS
  // --------------------------------------------------

  Map<String, dynamic> get currentLesson {
    if (lessons.isEmpty) return {};

    final index = currentLessonIndex.value;

    if (index < 0 || index >= lessons.length) return {};

    return lessons[index];
  }

  int get totalLessons => lessons.length;

  int get completedCount => completedLessons.length;

  double get progress {
    final percentage = _toDouble(progressData['completion_percentage']);

    return (percentage / 100).clamp(0.0, 1.0);
  }

  int get courseTotalLessons => _toInt(progressData['total_lessons']);

  int get courseCompletedLessons => _toInt(progressData['completed_lessons']);

  bool get isCurrentLessonCompleted =>
      completedLessons.contains(currentLessonIndex.value);

  bool get areAllLessonsCompleted =>
      totalLessons > 0 && completedCount >= totalLessons;

  bool get areAllCourseLessonsCompleted =>
      courseTotalLessons > 0 && courseCompletedLessons >= courseTotalLessons;

  bool get canStartQuiz => areAllCourseLessonsCompleted;

  // --------------------------------------------------
  // INIT
  // --------------------------------------------------

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args is Map) {
      final courseData = args['course'];

      if (courseData is Map) {
        course.addAll(Map<String, dynamic>.from(courseData));
      }

      enrollmentId = args['enrollment_id'];

      selectedSectionId = args['selected_section_id'];

      selectedSectionTitle = args['selected_section_title']?.toString() ?? '';

      selectedLessonId = args['selected_lesson_id'];

      final suppliedLessons = args['lessons'];

      if (suppliedLessons is List) {
        lessons.assignAll(
          suppliedLessons
              .whereType<Map>()
              .map((item) => Map<String, dynamic>.from(item))
              .toList(),
        );
      }

      currentLessonIndex.value = _toInt(args['selected_lesson_index']);
    }

    if (enrollmentId == null) {
      isLoading.value = false;
      hasError.value = true;

      _showError('Enrollment information is missing.');
      return;
    }

    fetchEnrollmentDetails();
  }

  // --------------------------------------------------
  // HELPERS
  // --------------------------------------------------

  int _toInt(dynamic value) {
    if (value is num) return value.toInt();

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();

    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }

  bool _sameId(dynamic first, dynamic second) {
    if (first == null || second == null) return false;

    return first.toString() == second.toString();
  }

  void _showError(String message) {
    if (_isClosing) return;

    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }

  // --------------------------------------------------
  // VIDEO URL RESOLVER
  // --------------------------------------------------

  String _resolveVideoUrl(dynamic value) {
    final rawUrl = value?.toString().trim() ?? '';

    if (rawUrl.isEmpty) return '';

    final uri = Uri.tryParse(rawUrl);

    if (uri == null) return '';

    if (uri.hasScheme) {
      if (uri.scheme != 'http' && uri.scheme != 'https') {
        return '';
      }

      return uri.toString();
    }

    final baseUri = Uri.tryParse(ApiEndpoints.baseUrl);

    if (baseUri == null || !baseUri.hasAuthority) {
      debugPrint('Invalid API base URL: ${ApiEndpoints.baseUrl}');
      return '';
    }

    final origin = Uri(
      scheme: baseUri.scheme,
      host: baseUri.host,
      port: baseUri.hasPort ? baseUri.port : null,
    );

    final resolvedUri = origin.resolve(rawUrl);

    if (resolvedUri.scheme != 'http' && resolvedUri.scheme != 'https') {
      return '';
    }

    return resolvedUri.toString();
  }

  // --------------------------------------------------
  // FETCH ENROLLMENT DETAILS
  // --------------------------------------------------

  Future<void> fetchEnrollmentDetails() async {
    if (_isClosing) return;

    isLoading.value = true;
    hasError.value = false;

    try {
      final response = await _apiServices.getMethod(
        ApiEndpoints.enrollmentDetailsUrl(enrollmentId),
        true,
      );

      if (_isClosing) return;

      final decoded = jsonDecode(response);

      if (decoded is! Map || decoded['success'] != true) {
        throw Exception(
          decoded is Map
              ? decoded['message'] ?? 'Unable to load enrollment.'
              : 'Invalid API response.',
        );
      }

      final data = decoded['data'];

      if (data is! Map) {
        throw Exception('Enrollment data is invalid.');
      }

      final enrollment = data['enrollment'];

      if (enrollment is! Map) {
        throw Exception('Enrollment details not found.');
      }

      _parseEnrollment(Map<String, dynamic>.from(enrollment), data['progress']);

      if (lessons.isEmpty) {
        isLoading.value = false;
        hasError.value = true;

        debugPrint('No published lessons found in selected section.');

        return;
      }

      if (currentLessonIndex.value < 0 ||
          currentLessonIndex.value >= lessons.length) {
        currentLessonIndex.value = 0;
      }

      await initializeVideo();
    } catch (e, stackTrace) {
      debugPrint('ENROLLMENT FETCH ERROR: $e');
      debugPrint('$stackTrace');

      if (_isClosing) return;

      isLoading.value = false;
      hasError.value = true;

      _showError(e.toString());
    }
  }

  // --------------------------------------------------
  // PARSE ENROLLMENT / SELECTED SECTION / PROGRESS
  // --------------------------------------------------

  void _parseEnrollment(Map<String, dynamic> enrollment, dynamic progress) {
    final courseData = enrollment['course'];

    if (courseData is Map) {
      course.addAll(Map<String, dynamic>.from(courseData));
    }

    course['enrollment_id'] = enrollment['id'];
    course['enrollment_status'] = enrollment['status'];

    enrollmentId = enrollment['id'] ?? enrollmentId;

    final sections = course['sections'];

    final List<Map<String, dynamic>> selectedSectionLessons = [];

    if (sections is List) {
      for (final sectionItem in sections) {
        if (sectionItem is! Map) continue;

        final section = Map<String, dynamic>.from(sectionItem);

        if (selectedSectionId != null &&
            !_sameId(section['id'], selectedSectionId)) {
          continue;
        }

        final sectionLessons = section['lessons'];

        if (sectionLessons is! List) continue;

        for (final lessonItem in sectionLessons) {
          if (lessonItem is! Map) continue;

          final lesson = Map<String, dynamic>.from(lessonItem);

          if (lesson['is_published'] == false) continue;

          lesson['section_id'] = section['id'];
          lesson['section_title'] = section['title'];

          selectedSectionLessons.add(lesson);
        }

        if (selectedSectionId != null) break;
      }
    }

    lessons.assignAll(selectedSectionLessons);

    // Resolve selected lesson index using its ID.
    if (selectedLessonId != null) {
      final selectedIndex = lessons.indexWhere(
        (lesson) => _sameId(lesson['id'], selectedLessonId),
      );

      if (selectedIndex != -1) {
        currentLessonIndex.value = selectedIndex;
      }
    }

    // --------------------------------------------------
    // LESSON PROGRESS
    // --------------------------------------------------

    _watchedSecondsByLesson.clear();
    completedLessons.clear();

    final lessonProgressRecords = enrollment['lesson_progress'];

    if (lessonProgressRecords is List) {
      for (final recordItem in lessonProgressRecords) {
        if (recordItem is! Map) continue;

        final record = Map<String, dynamic>.from(recordItem);

        final lessonId = record['lesson_id'];

        final watchedSeconds = _toInt(record['watched_seconds']);

        if (lessonId != null) {
          _watchedSecondsByLesson[lessonId.toString()] = watchedSeconds;
        }

        if (record['is_completed'] == true && lessonId != null) {
          final lessonIndex = lessons.indexWhere(
            (lesson) => _sameId(lesson['id'], lessonId),
          );

          if (lessonIndex != -1) {
            completedLessons.add(lessonIndex);
          }
        }
      }
    }

    completedLessons.sort();

    // --------------------------------------------------
    // OVERALL COURSE PROGRESS
    // --------------------------------------------------

    if (progress is Map) {
      progressData.assignAll(Map<String, dynamic>.from(progress));
    } else {
      progressData.clear();
    }

    course['total_lessons'] = totalLessons;
    course['completed_lessons'] = completedCount;

    course['progress'] = progress;
  }

  // --------------------------------------------------
  // VIDEO PLAYER
  // --------------------------------------------------

  Future<void> initializeVideo() async {
    if (_isClosing) return;

    if (lessons.isEmpty || currentLesson.isEmpty) {
      isLoading.value = false;
      hasError.value = true;
      return;
    }

    final requestId = ++_videoRequestId;

    isLoading.value = true;
    hasError.value = false;

    isPlaying.value = false;
    videoPosition.value = 0;
    videoDuration.value = 0;

    final oldController = videoController;
    videoController = null;

    if (oldController != null) {
      oldController.removeListener(_videoListener);

      try {
        await oldController.dispose();
      } catch (e) {
        debugPrint('OLD VIDEO DISPOSE ERROR: $e');
      }
    }

    if (_isClosing || requestId != _videoRequestId) return;

    final lesson = currentLesson;

    final url = _resolveVideoUrl(lesson['video_url']);

    debugPrint('LESSON VIDEO URL: ${lesson['video_url']}');
    debugPrint('RESOLVED VIDEO URL: $url');

    if (url.isEmpty) {
      isLoading.value = false;
      hasError.value = true;

      debugPrint('VIDEO ERROR: Invalid or missing video URL.');

      return;
    }

    final uri = Uri.tryParse(url);

    if (uri == null || !uri.hasAuthority) {
      isLoading.value = false;
      hasError.value = true;

      debugPrint('VIDEO ERROR: Invalid video URI.');

      return;
    }

    final newController = VideoPlayerController.networkUrl(uri);

    videoController = newController;

    try {
      await newController.initialize();

      if (_isClosing ||
          requestId != _videoRequestId ||
          videoController != newController) {
        await newController.dispose();
        return;
      }

      await newController.setLooping(false);

      if (_isClosing ||
          requestId != _videoRequestId ||
          videoController != newController) {
        await newController.dispose();
        return;
      }

      newController.addListener(_videoListener);

      videoDuration.value = newController.value.duration.inMilliseconds
          .toDouble();

      final lessonId = lesson['id']?.toString() ?? '';

      final watchedSeconds = _watchedSecondsByLesson[lessonId] ?? 0;

      if (watchedSeconds > 0 &&
          watchedSeconds < newController.value.duration.inSeconds) {
        await newController.seekTo(Duration(seconds: watchedSeconds));
      }

      if (_isClosing ||
          requestId != _videoRequestId ||
          videoController != newController) {
        return;
      }

      isLoading.value = false;
      hasError.value = false;

      debugPrint('VIDEO INITIALIZED SUCCESSFULLY: $url');
    } catch (e, stackTrace) {
      debugPrint('VIDEO INITIALIZATION ERROR: $e');
      debugPrint('$stackTrace');

      if (videoController == newController) {
        videoController = null;
      }

      newController.removeListener(_videoListener);

      try {
        await newController.dispose();
      } catch (disposeError) {
        debugPrint('VIDEO DISPOSE ERROR: $disposeError');
      }

      if (!_isClosing && requestId == _videoRequestId) {
        isLoading.value = false;
        hasError.value = true;
      }
    }
  }

  void _videoListener() {
    final player = videoController;

    if (_isClosing || player == null || !player.value.isInitialized) {
      return;
    }

    isPlaying.value = player.value.isPlaying;

    videoPosition.value = player.value.position.inMilliseconds.toDouble();

    videoDuration.value = player.value.duration.inMilliseconds.toDouble();
  }

  Future<void> togglePlayPause() async {
    final player = videoController;

    if (player == null || !player.value.isInitialized) {
      return;
    }

    try {
      if (player.value.isPlaying) {
        await player.pause();
      } else {
        await player.play();
      }
    } catch (e) {
      debugPrint('VIDEO PLAY/PAUSE ERROR: $e');

      _showError('Unable to play this video.');
    }
  }

  Future<void> seekVideo(double milliseconds) async {
    final player = videoController;

    if (player == null || !player.value.isInitialized) {
      return;
    }

    final maxMilliseconds = player.value.duration.inMilliseconds;

    final safeMilliseconds = milliseconds.round().clamp(0, maxMilliseconds);

    try {
      await player.seekTo(Duration(milliseconds: safeMilliseconds));
    } catch (e) {
      debugPrint('VIDEO SEEK ERROR: $e');
    }
  }

  // --------------------------------------------------
  // LESSON NAVIGATION
  // --------------------------------------------------

  Future<void> playLesson(int index) async {
    if (_isClosing || index < 0 || index >= lessons.length) {
      return;
    }

    if (currentLessonIndex.value == index &&
        videoController != null &&
        videoController!.value.isInitialized) {
      return;
    }

    currentLessonIndex.value = index;

    await initializeVideo();
  }

  Future<void> nextLesson() async {
    if (currentLessonIndex.value < lessons.length - 1) {
      await playLesson(currentLessonIndex.value + 1);
    }
  }

  Future<void> previousLesson() async {
    if (currentLessonIndex.value > 0) {
      await playLesson(currentLessonIndex.value - 1);
    }
  }

  // --------------------------------------------------
  // MARK LESSON COMPLETED
  // --------------------------------------------------

  Future<void> markAsCompleted() async {
    final lesson = currentLesson;

    if (lesson.isEmpty) {
      _showError('No lesson is selected.');
      return;
    }

    if (isCurrentLessonCompleted) {
      Get.snackbar(
        'Already Completed',
        'This lesson is already marked as completed.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    if (isSavingProgress.value) return;

    final lessonId = lesson['id'];

    if (lessonId == null || enrollmentId == null) {
      _showError('Lesson or enrollment ID is missing.');
      return;
    }

    isSavingProgress.value = true;

    try {
      final player = videoController;

      final currentWatchedSeconds = player != null && player.value.isInitialized
          ? player.value.position.inSeconds
          : 0;

      final previouslyWatchedSeconds =
          _watchedSecondsByLesson[lessonId.toString()] ?? 0;

      final watchedSeconds = currentWatchedSeconds > previouslyWatchedSeconds
          ? currentWatchedSeconds
          : previouslyWatchedSeconds;

      final response = await _apiServices.putMethod(
        ApiEndpoints.updateLessonProgressUrl(enrollmentId, lessonId),
        {'is_completed': true, 'watched_seconds': watchedSeconds},
        true,
      );

      if (_isClosing) return;

      final decoded = jsonDecode(response);

      if (decoded is! Map || decoded['success'] != true) {
        throw Exception(
          decoded is Map
              ? decoded['message'] ?? 'Progress update failed.'
              : 'Invalid API response.',
        );
      }

      // Immediately update local lesson completion.
      if (!completedLessons.contains(currentLessonIndex.value)) {
        completedLessons.add(currentLessonIndex.value);
        completedLessons.sort();
      }

      _watchedSecondsByLesson[lessonId.toString()] = watchedSeconds;

      course['completed_lessons'] = completedCount;

      // Refresh the latest enrollment progress from backend.
      await fetchProgressAfterCompletion();

      if (_isClosing) return;

      // Refresh Home dashboard and enrollment counts.
      await refreshHomeDashboard();

      if (_isClosing) return;

      Get.snackbar(
        'Lesson Completed',
        'Your lesson progress has been saved.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e, stackTrace) {
      debugPrint('MARK LESSON COMPLETED ERROR: $e');
      debugPrint('$stackTrace');

      if (!_isClosing) {
        _showError(e.toString());
      }
    } finally {
      if (!_isClosing) {
        isSavingProgress.value = false;
      }
    }
  }

  // --------------------------------------------------
  // REFRESH HOME DASHBOARD
  // --------------------------------------------------

  Future<void> refreshHomeDashboard() async {
    if (_isClosing) return;

    try {
      if (Get.isRegistered<HomeController>()) {
        final homeController = Get.find<HomeController>();

        await Future.wait([
          homeController.fetchEnrollments(),
          homeController.fetchDashboard(),
        ]);
      }
    } catch (e, stackTrace) {
      debugPrint('HOME DASHBOARD REFRESH ERROR: $e');
      debugPrint('$stackTrace');
    }
  }

  // --------------------------------------------------
  // REFRESH PROGRESS
  // --------------------------------------------------

  Future<void> fetchProgressAfterCompletion() async {
    try {
      final response = await _apiServices.getMethod(
        ApiEndpoints.enrollmentDetailsUrl(enrollmentId),
        true,
      );

      if (_isClosing) return;

      final decoded = jsonDecode(response);

      if (decoded is Map && decoded['success'] == true) {
        final data = decoded['data'];

        if (data is Map) {
          final enrollment = data['enrollment'];
          final progress = data['progress'];

          if (enrollment is Map) {
            _parseEnrollment(Map<String, dynamic>.from(enrollment), progress);
          }
        }
      }
    } catch (e, stackTrace) {
      debugPrint('REFRESH PROGRESS ERROR: $e');
      debugPrint('$stackTrace');
    }
  }

  // --------------------------------------------------
  // QUIZ
  // --------------------------------------------------

  void startQuiz() {
    if (selectedSectionId == null) {
      _showError('Section information is missing.');
      return;
    }

    Get.toNamed(
      AppRoutes.quiz,
      arguments: {
        'section_id': selectedSectionId,
        'section_title': selectedSectionTitle,
        'course_id': course['id'],
        'course_title': course['title'],
        'instructor_name': course['instructor'],
      },
    );
  }

  // --------------------------------------------------
  // FORMATTING
  // --------------------------------------------------

  String formatDuration(double milliseconds) {
    final seconds = (milliseconds / 1000).floor();

    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // --------------------------------------------------
  // CLEANUP
  // --------------------------------------------------

  @override
  void onClose() {
    _isClosing = true;
    _videoRequestId++;

    final player = videoController;
    videoController = null;

    if (player != null) {
      player.removeListener(_videoListener);
      player.dispose();
    }

    super.onClose();
  }
}
