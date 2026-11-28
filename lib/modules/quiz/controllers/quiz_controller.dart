import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_services.dart';

class QuizController extends GetxController {
  final ApiServices apiServices = ApiServices();

  final RxInt currentQuestionIndex = 0.obs;
  final RxBool isLoading = false.obs;
  final RxBool isStarting = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxBool isSubmitted = false.obs;

  final RxList<Map<String, dynamic>> questions = <Map<String, dynamic>>[].obs;

  // Actual selected option IDs, not option indexes.
  final RxList<int?> selectedAnswers = <int?>[].obs;

  final RxInt quizId = 0.obs;
  final RxInt sectionId = 0.obs;
  final RxInt attemptId = 0.obs;

  final RxInt timeLimitMinutes = 0.obs;
  final RxInt remainingSeconds = 0.obs;

  final RxInt totalMarks = 0.obs;
  final RxInt passingPercentage = 50.obs;

  final RxString quizTitle = ''.obs;
  final RxString quizDescription = ''.obs;
  final RxString courseTitle = ''.obs;
  final RxString instructorName = ''.obs;

  Timer? _timer;

  int get totalQuestions => questions.length;

  int get answeredQuestions =>
      selectedAnswers.where((answer) => answer != null).length;

  double get progress => totalQuestions == 0
      ? 0
      : (currentQuestionIndex.value + 1) / totalQuestions;

  Map<String, dynamic> get currentQuestion =>
      questions[currentQuestionIndex.value];

  String get formattedTime {
    final minutes = remainingSeconds.value ~/ 60;
    final seconds = remainingSeconds.value % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args is Map) {
      sectionId.value = int.tryParse(args['section_id']?.toString() ?? '') ?? 0;

      courseTitle.value = args['course_title']?.toString() ?? '';
      instructorName.value = args['instructor_name']?.toString() ?? '';
    }

    if (sectionId.value > 0) {
      fetchQuiz();
    } else {
      Get.snackbar('Error', 'Section information is missing.');
    }
  }

  Future<void> fetchQuiz() async {
    try {
      isLoading.value = true;

      final response = await apiServices.getMethod(
        ApiEndpoints.sectionQuizUrl(sectionId.value),
        true,
      );

      final decoded = jsonDecode(response);

      if (decoded['success'] != true) {
        throw Exception(decoded['message'] ?? 'Unable to fetch quiz.');
      }

      final data = Map<String, dynamic>.from(decoded['data']);

      quizId.value = int.parse(data['id'].toString());
      quizTitle.value = data['title']?.toString() ?? '';
      quizDescription.value = data['description']?.toString() ?? '';

      timeLimitMinutes.value =
          int.tryParse(data['time_limit_minutes']?.toString() ?? '') ?? 0;

      passingPercentage.value =
          int.tryParse(data['passing_percentage']?.toString() ?? '50') ?? 50;

      totalMarks.value =
          int.tryParse(data['total_marks']?.toString() ?? '0') ?? 0;

      final questionList = List<Map<String, dynamic>>.from(
        (data['questions'] as List).map(
          (question) => Map<String, dynamic>.from(question),
        ),
      );

      questions.assignAll(questionList);

      selectedAnswers.assignAll(List<int?>.filled(questionList.length, null));

      await startAttempt();
    } catch (e) {
      Get.snackbar('Quiz Error', e.toString().replaceFirst('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> startAttempt() async {
    try {
      isStarting.value = true;

      final response = await apiServices.postMethod(
        ApiEndpoints.startQuizUrl(quizId.value),
        {},
        true,
      );

      final decoded = jsonDecode(response);

      if (decoded['success'] != true) {
        throw Exception(decoded['message'] ?? 'Unable to start quiz.');
      }

      final data = Map<String, dynamic>.from(decoded['data']);

      attemptId.value = int.parse(data['attempt_id'].toString());

      final startedTimeLimit =
          int.tryParse(data['time_limit_minutes']?.toString() ?? '') ??
          timeLimitMinutes.value;

      remainingSeconds.value = startedTimeLimit * 60;

      if (startedTimeLimit > 0) {
        _startTimer();
      }
    } catch (e) {
      Get.snackbar(
        'Unable to Start',
        e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      isStarting.value = false;
    }
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        timer.cancel();
        submitQuiz();
      }
    });
  }

  void selectAnswer(int optionId) {
    if (isSubmitted.value || isSubmitting.value) return;

    selectedAnswers[currentQuestionIndex.value] = optionId;
  }

  bool isOptionSelected(int optionId) {
    return selectedAnswers[currentQuestionIndex.value] == optionId;
  }

  void nextQuestion() {
    if (currentQuestionIndex.value < totalQuestions - 1) {
      currentQuestionIndex.value++;
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
    }
  }

  Future<void> submitQuiz() async {
    if (isSubmitting.value || isSubmitted.value) return;

    if (answeredQuestions != totalQuestions) {
      Get.snackbar(
        'Incomplete Quiz',
        'Please answer all questions before submitting.',
      );
      return;
    }

    if (attemptId.value == 0) {
      Get.snackbar('Error', 'Quiz attempt has not started.');
      return;
    }

    try {
      isSubmitting.value = true;
      _timer?.cancel();

      final answers = <Map<String, dynamic>>[];

      for (int i = 0; i < questions.length; i++) {
        answers.add({
          'question_id': questions[i]['id'],
          'option_id': selectedAnswers[i],
        });
      }

      final response = await apiServices.postMethod(
        ApiEndpoints.submitQuizUrl(attemptId.value),
        {'answers': answers},
        true,
      );

      final decoded = jsonDecode(response);

      if (decoded['success'] != true) {
        throw Exception(decoded['message'] ?? 'Unable to submit quiz.');
      }

      final result = Map<String, dynamic>.from(decoded['data']);

      isSubmitted.value = true;

      Get.offNamed(
        AppRoutes.quizResult,
        arguments: {
          ...result,
          'attempt_id': attemptId.value,
          'quiz_id': quizId.value,
          'section_id': sectionId.value,
          'course_title': courseTitle.value,
          'instructor_name': instructorName.value,
          'passing_percentage': passingPercentage.value,
        },
      );
    } catch (e) {
      Get.snackbar(
        'Submission Error',
        e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> retakeQuiz() async {
    _timer?.cancel();

    currentQuestionIndex.value = 0;
    isSubmitted.value = false;
    attemptId.value = 0;

    selectedAnswers.assignAll(List<int?>.filled(totalQuestions, null));

    await startAttempt();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
