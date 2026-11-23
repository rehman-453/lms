import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../home/controllers/home_controller.dart';

class LessonPlayerController extends GetxController {
  late final Map<String, dynamic> course;

  final RxList<Map<String, dynamic>> lessons = <Map<String, dynamic>>[].obs;

  final RxInt currentLessonIndex = 0.obs;
  final RxList<int> completedLessons = <int>[].obs;

  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxBool isExpanded = true.obs;

  final RxBool isPlaying = false.obs;
  final RxDouble videoPosition = 0.0.obs;
  final RxDouble videoDuration = 0.0.obs;

  VideoPlayerController? videoController;

  final String demoVideoUrl =
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';

  bool _isClosing = false;

  Map<String, dynamic> get currentLesson {
    if (lessons.isEmpty) return {};

    if (currentLessonIndex.value < 0 ||
        currentLessonIndex.value >= lessons.length) {
      return {};
    }

    return lessons[currentLessonIndex.value];
  }

  int get totalLessons => lessons.length;

  int get completedCount => completedLessons.length;

  double get progress {
    if (totalLessons == 0) return 0;

    return (completedCount / totalLessons).clamp(0.0, 1.0);
  }

  bool get isCurrentLessonCompleted =>
      completedLessons.contains(currentLessonIndex.value);

  bool get areAllLessonsCompleted =>
      totalLessons > 0 && completedCount >= totalLessons;

  bool get canStartQuiz => areAllLessonsCompleted;

  @override
  void onInit() {
    super.onInit();

    course = {};

    final args = Get.arguments;

    if (args is Map) {
      final courseData = args['course'];

      if (courseData is Map) {
        course.addAll(Map<String, dynamic>.from(courseData));
      }

      final suppliedLessons = args['lessons'];

      if (suppliedLessons is List && suppliedLessons.isNotEmpty) {
        lessons.assignAll(
          suppliedLessons.map((item) {
            final lesson = Map<String, dynamic>.from(item);

            if (lesson['video_url'] == null ||
                lesson['video_url'].toString().isEmpty) {
              lesson['video_url'] = demoVideoUrl;
            }

            return lesson;
          }),
        );
      }
    }

    if (lessons.isEmpty) {
      _loadDemoLessons();
    }

    // Restore local state without modifying HomeController's RxList.
    _restoreCompletedLessons();

    // Initialize video.
    initializeVideo();

    // Update HomeController only after the current frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isClosing) {
        _syncCourseLessonCount();
      }
    });
  }

  int _toInt(dynamic value) {
    if (value is num) return value.toInt();

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  bool _sameId(dynamic first, dynamic second) {
    if (first == null || second == null) return false;

    return first.toString() == second.toString();
  }

  Map<String, dynamic>? get _enrolledCourse {
    if (!Get.isRegistered<HomeController>() || course['id'] == null) {
      return null;
    }

    final homeController = Get.find<HomeController>();

    return homeController.enrolledCourses.firstWhereOrNull(
      (item) => _sameId(item['id'], course['id']),
    );
  }

  void _restoreCompletedLessons() {
    final enrolledCourse = _enrolledCourse;

    if (enrolledCourse == null) return;

    final savedIndexes = enrolledCourse['completed_lesson_indexes'];

    if (savedIndexes is List) {
      completedLessons.assignAll(
        savedIndexes
            .whereType<num>()
            .map((item) => item.toInt())
            .where((index) => index >= 0 && index < totalLessons)
            .toSet()
            .toList()
          ..sort(),
      );
    }
  }

  void _syncCourseLessonCount() {
    if (!Get.isRegistered<HomeController>() ||
        course['id'] == null ||
        totalLessons == 0) {
      return;
    }

    final homeController = Get.find<HomeController>();

    final index = homeController.enrolledCourses.indexWhere(
      (item) => _sameId(item['id'], course['id']),
    );

    if (index == -1) return;

    final enrolledCourse = Map<String, dynamic>.from(
      homeController.enrolledCourses[index],
    );

    final savedIndexes = enrolledCourse['completed_lesson_indexes'];

    final validIndexes = savedIndexes is List
        ? savedIndexes
              .whereType<num>()
              .map((item) => item.toInt())
              .where((item) => item >= 0 && item < totalLessons)
              .toSet()
              .toList()
        : <int>[];

    validIndexes.sort();

    final completed = validIndexes.length;

    enrolledCourse['completed_lesson_indexes'] = validIndexes;
    enrolledCourse['completed_lessons'] = completed;
    enrolledCourse['total_lessons'] = totalLessons;
    enrolledCourse['completedLessons'] = completed;
    enrolledCourse['totalLessons'] = totalLessons;
    enrolledCourse['progress'] = (completed / totalLessons).clamp(0.0, 1.0);

    enrolledCourse['is_completed'] =
        completed >= totalLessons && enrolledCourse['quiz_passed'] == true;

    // Update RxList after the first frame.
    homeController.enrolledCourses[index] = Map<String, dynamic>.from(
      enrolledCourse,
    );

    completedLessons.assignAll(validIndexes);
  }

  void _loadDemoLessons() {
    lessons.assignAll([
      {
        'id': 1,
        'title': 'Introduction to the Course',
        'duration': '08:20',
        'video_url': demoVideoUrl,
      },
      {
        'id': 2,
        'title': 'Understanding the Basics',
        'duration': '12:45',
        'video_url': demoVideoUrl,
      },
      {
        'id': 3,
        'title': 'Setting Up Your Environment',
        'duration': '10:15',
        'video_url': demoVideoUrl,
      },
      {
        'id': 4,
        'title': 'Practical Implementation',
        'duration': '14:20',
        'video_url': demoVideoUrl,
      },
    ]);
  }

  Future<void> initializeVideo() async {
    if (_isClosing) return;

    if (lessons.isEmpty) {
      isLoading.value = false;
      hasError.value = true;
      return;
    }

    isLoading.value = true;
    hasError.value = false;

    isPlaying.value = false;
    videoPosition.value = 0;
    videoDuration.value = 0;

    final oldController = videoController;
    videoController = null;

    if (oldController != null) {
      oldController.removeListener(_videoListener);
      await oldController.dispose();
    }

    if (_isClosing) return;

    final url = currentLesson['video_url']?.toString() ?? '';

    if (url.isEmpty) {
      isLoading.value = false;
      hasError.value = true;
      debugPrint('VIDEO ERROR: Video URL is empty.');
      return;
    }

    final newController = VideoPlayerController.networkUrl(Uri.parse(url));

    videoController = newController;

    try {
      await newController.initialize();

      if (_isClosing || videoController != newController) {
        await newController.dispose();
        return;
      }

      await newController.setLooping(false);

      if (_isClosing || videoController != newController) {
        await newController.dispose();
        return;
      }

      newController.addListener(_videoListener);

      videoDuration.value = newController.value.duration.inMilliseconds
          .toDouble();

      isLoading.value = false;
      hasError.value = false;

      debugPrint('VIDEO INITIALIZED SUCCESSFULLY: $url');
    } catch (e, stackTrace) {
      debugPrint('VIDEO INITIALIZATION ERROR: $e');
      debugPrint('VIDEO STACK TRACE: $stackTrace');

      if (videoController == newController) {
        videoController = null;
        isLoading.value = false;
        hasError.value = true;
      }

      newController.removeListener(_videoListener);

      await newController.dispose();
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

    if (player == null || !player.value.isInitialized) return;

    if (player.value.isPlaying) {
      await player.pause();
    } else {
      await player.play();
    }
  }

  Future<void> seekVideo(double milliseconds) async {
    final player = videoController;

    if (player == null || !player.value.isInitialized) return;

    await player.seekTo(Duration(milliseconds: milliseconds.round()));
  }

  Future<void> playLesson(int index) async {
    if (index < 0 || index >= lessons.length) return;

    currentLessonIndex.value = index;

    await initializeVideo();
  }

  Future<void> nextLesson() async {
    if (currentLessonIndex.value < lessons.length - 1) {
      currentLessonIndex.value++;

      await initializeVideo();
    }
  }

  Future<void> previousLesson() async {
    if (currentLessonIndex.value > 0) {
      currentLessonIndex.value--;

      await initializeVideo();
    }
  }

  void markAsCompleted() {
    final index = currentLessonIndex.value;

    if (lessons.isEmpty || isCurrentLessonCompleted) return;

    completedLessons.add(index);
    completedLessons.sort();

    if (Get.isRegistered<HomeController>() && course['id'] != null) {
      final homeController = Get.find<HomeController>();

      homeController.markLessonCompleted(
        courseId: course['id'],
        lessonIndex: index,
        totalLessons: totalLessons,
      );
    }

    Get.snackbar(
      'Lesson Completed',
      'Great work! Your lesson progress has been updated.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void startQuiz() {
    if (!canStartQuiz) {
      Get.snackbar(
        'Quiz Locked',
        'Please complete all course lessons before starting the quiz.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Quiz navigation is handled by LessonPlayerScreen.
  }

  String formatDuration(double milliseconds) {
    final seconds = (milliseconds / 1000).floor();
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void onClose() {
    _isClosing = true;

    final player = videoController;
    videoController = null;

    if (player != null) {
      player.removeListener(_videoListener);
      player.dispose();
    }

    super.onClose();
  }
}
