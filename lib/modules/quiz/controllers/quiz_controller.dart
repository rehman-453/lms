import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../home/controllers/home_controller.dart';

class QuizController extends GetxController {
  final RxInt currentQuestionIndex = 0.obs;
  final RxInt score = 0.obs;
  final RxBool isSubmitted = false.obs;

  final RxList<int?> selectedAnswers = <int?>[].obs;

  final RxInt courseId = 0.obs;
  final RxString courseTitle = ''.obs;
  final RxString instructorName = ''.obs;

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'What is Flutter?',
      'options': [
        'A programming language',
        'A UI toolkit',
        'A database',
        'An operating system',
      ],
      'correctAnswer': 1,
    },
    {
      'question': 'Which programming language does Flutter use?',
      'options': ['Java', 'Python', 'Dart', 'PHP'],
      'correctAnswer': 2,
    },
    {
      'question': 'Which function is the entry point of a Flutter app?',
      'options': ['startApp()', 'main()', 'runApp()', 'init()'],
      'correctAnswer': 1,
    },
    {
      'question': 'Which widget is used for a scrollable list?',
      'options': ['Container', 'Column', 'ListView', 'Stack'],
      'correctAnswer': 2,
    },
    {
      'question': 'Which package are we using for state management?',
      'options': ['Provider', 'GetX', 'Bloc', 'Redux'],
      'correctAnswer': 1,
    },
  ];

  int get totalQuestions => questions.length;

  int get answeredQuestions =>
      selectedAnswers.where((answer) => answer != null).length;

  double get progress => totalQuestions == 0
      ? 0
      : (currentQuestionIndex.value + 1) / totalQuestions;

  double get percentage =>
      totalQuestions == 0 ? 0 : (score.value / totalQuestions) * 100;

  bool get isPassed => percentage >= 60;

  Map<String, dynamic> get currentQuestion =>
      questions[currentQuestionIndex.value];

  @override
  void onInit() {
    super.onInit();

    selectedAnswers.assignAll(List<int?>.filled(totalQuestions, null));

    final args = Get.arguments;

    if (args is Map) {
      courseId.value = int.tryParse(args['course_id']?.toString() ?? '') ?? 0;

      courseTitle.value = args['course_title']?.toString() ?? '';

      instructorName.value = args['instructor_name']?.toString() ?? '';
    }
  }

  void selectAnswer(int index) {
    if (isSubmitted.value) return;

    selectedAnswers[currentQuestionIndex.value] = index;
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

  void submitQuiz() {
    if (answeredQuestions != totalQuestions) {
      Get.snackbar(
        'Incomplete Quiz',
        'Please answer all questions before submitting.',
      );
      return;
    }

    score.value = 0;

    for (int i = 0; i < totalQuestions; i++) {
      if (selectedAnswers[i] == questions[i]['correctAnswer']) {
        score.value++;
      }
    }

    isSubmitted.value = true;

    if (courseId.value > 0 && Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().saveQuizResult(
        courseId: courseId.value,
        score: score.value,
        totalQuestions: totalQuestions,
      );
    }

    Get.toNamed(
      AppRoutes.quizResult,
      arguments: {
        'score': score.value,
        'total': totalQuestions,
        'percentage': percentage,
        'passed': isPassed,
        'course_id': courseId.value,
        'course_title': courseTitle.value,
        'instructor_name': instructorName.value,
      },
    );
  }

  void retakeQuiz() {
    currentQuestionIndex.value = 0;
    score.value = 0;
    isSubmitted.value = false;

    selectedAnswers.assignAll(List<int?>.filled(totalQuestions, null));

    Get.offNamed(
      AppRoutes.quiz,
      arguments: {
        'course_id': courseId.value,
        'course_title': courseTitle.value,
        'instructor_name': instructorName.value,
      },
    );
  }
}
