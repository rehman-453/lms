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

  // Student Profile
  static const String studentProfileUrl = '$baseUrl/auth/student/profile';

  // // Categories
  // static const String categoriesUrl = '$baseUrl/categories';

  // static String categoryDetailsUrl(int id) => '$categoriesUrl/$id';
}
