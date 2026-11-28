class ApiEndpoints {
  static const String baseUrl =
      'https://dialectologic-bunglingly-lawerence.ngrok-free.dev/api/v1';

  // Authentication
  static const String loginUrl = '$baseUrl/auth/login';
  static const String registerUrl = '$baseUrl/auth/register';
  static const String forgotPasswordUrl = '$baseUrl/auth/forgot-password';
  static const String resetPasswordUrl = '$baseUrl/auth/reset-password';
  static const String logoutUrl = '$baseUrl/auth/logout';
  static const String meUrl = '$baseUrl/auth/me';
  static const String saveFcmTokenUrl = '$baseUrl/fcm-token';
  static const String deleteFcmTokenUrl = '$baseUrl/fcm-token';

  // Student Profile
  static const String studentProfileUrl = '$baseUrl/auth/student/profile';

  // Student Favorites
  static const String studentFavoritesUrl = '$baseUrl/student/favorites';

  static String addCourseFavoriteUrl(int courseId) =>
      '$baseUrl/student/courses/$courseId/favorite';

  static String removeCourseFavoriteUrl(int courseId) =>
      '$baseUrl/student/courses/$courseId/favorite';

  // Student Dashboard
  static const String studentDashboardUrl = '$baseUrl/student/dashboard';

  // Student Enrollments
  static const String studentEnrollmentsUrl = '$baseUrl/student/enrollments';
  static String enrollCourseUrl(int courseId) =>
      '$baseUrl/student/courses/$courseId/enroll';

  // Courses
  static const String coursesUrl = '$baseUrl/courses';
  static const String popularCoursesUrl = '$baseUrl/courses/popular';
  static String courseDetailsUrl(dynamic courseId) =>
      '$baseUrl/courses/$courseId';

  // Categories
  static const String categoriesUrl = '$baseUrl/categories';

  // Lesson Player
  static String enrollmentDetailsUrl(dynamic enrollmentId) =>
      '$baseUrl/student/enrollments/$enrollmentId';

  static String updateLessonProgressUrl(
    dynamic enrollmentId,
    dynamic lessonId,
  ) => '$baseUrl/student/enrollments/$enrollmentId/lessons/$lessonId/progress';

  // Student Quiz
  static String sectionQuizUrl(dynamic sectionId) =>
      '$baseUrl/student/sections/$sectionId/quiz';

  static String startQuizUrl(dynamic quizId) =>
      '$baseUrl/student/quizzes/$quizId/start';

  static String submitQuizUrl(dynamic attemptId) =>
      '$baseUrl/student/quiz-attempts/$attemptId/submit';

  static String quizResultUrl(dynamic attemptId) =>
      '$baseUrl/student/quiz-attempts/$attemptId/result';

  // static String categoryDetailsUrl(int id) => '$categoriesUrl/$id';
}
