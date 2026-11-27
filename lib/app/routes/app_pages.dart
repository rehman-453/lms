import 'package:get/get.dart';
import 'package:lms/modules/home/bindings/home_binding.dart';
import 'package:lms/modules/home/views/bottom_nav_screen.dart';
import 'package:lms/modules/home/views/home_screen.dart';
import 'package:lms/modules/notifications/views/notifications_screen.dart';
import 'package:lms/modules/profile/bindings/profile_binding.dart';
import 'package:lms/modules/profile/views/profile_screen.dart';

import 'app_routes.dart';

import '../../modules/splash/views/splash_screen.dart';
import '../../modules/onboarding/views/onboarding_screen.dart';

import '../../modules/auth/views/login_screen.dart';
import '../../modules/auth/views/signup_screen.dart';

import '../../modules/auth/bindings/login_binding.dart';
import '../../modules/auth/bindings/signup_binding.dart';

import '../../modules/auth/views/forgot_password_screen.dart';
import '../../modules/auth/bindings/forgot_password_binding.dart';

import '../../modules/auth/views/reset_password_screen.dart';
import '../../modules/auth/bindings/reset_password_binding.dart';

import '../../modules/course_details/bindings/course_details_binding.dart';
import '../../modules/course_details/views/course_details_screen.dart';

import '../../modules/lesson_player/bindings/lesson_player_binding.dart';
import '../../modules/lesson_player/views/lesson_player_screen.dart';

import '../../modules/quiz/bindings/quiz_binding.dart';
import '../../modules/quiz/views/quiz_screen.dart';
import '../../modules/quiz/views/quiz_result_screen.dart';

import '../../modules/certificates/bindings/certificates_binding.dart';
import '../../modules/certificates/views/certificates_screen.dart';

import '../../modules/settings/bindings/settings_binding.dart';
import '../../modules/settings/views/settings_screen.dart';

import '../../modules/profile/bindings/edit_profile_binding.dart';
import '../../modules/profile/views/edit_profile_screen.dart';

import '../../modules/profile/bindings/change_password_binding.dart';
import '../../modules/profile/views/change_password_screen.dart';

import '../../modules/support/bindings/support_binding.dart';
import '../../modules/support/views/support_screen.dart';

import '../../modules/notifications/bindings/notification_preferences_binding.dart';
import '../../modules/notifications/views/notification_preferences_screen.dart';

import '../../modules/about/bindings/about_binding.dart';
import '../../modules/about/views/about_screen.dart';
import '../../modules/about/views/privacy_policy_screen.dart';
import '../../modules/about/views/terms_conditions_screen.dart';

import '../../modules/my_learning/bindings/my_learning_binding.dart';
import '../../modules/my_learning/views/my_learning_screen.dart';

import '../../modules/course_completion/bindings/course_completion_binding.dart';
import '../../modules/course_completion/views/course_completion_screen.dart';

import '../../modules/course_feedback/bindings/course_feedback_binding.dart';
import '../../modules/course_feedback/views/course_feedback_screen.dart';

import '../../modules/notifications/bindings/notifications_binding.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),

    GetPage(name: AppRoutes.onboarding, page: () => const OnboardingScreen()),

    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),

    GetPage(
      name: AppRoutes.register,
      page: () => const SignupScreen(),
      binding: SignupBinding(),
    ),

    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
      binding: ForgotPasswordBinding(),
    ),

    GetPage(
      name: AppRoutes.resetPassword,
      page: () => const ResetPasswordScreen(),
      binding: ResetPasswordBinding(),
    ),

    GetPage(
      name: AppRoutes.bottomnav,
      page: () => const BottomNavScreen(),
      binding: HomeBinding(),
    ),

    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),

    GetPage(
      name: AppRoutes.courseDetails,
      page: () => const CourseDetailsScreen(),
      binding: CourseDetailsBinding(),
    ),

    GetPage(
      name: AppRoutes.lessonPlayer,
      page: () => const LessonPlayerScreen(),
      binding: LessonPlayerBinding(),
    ),

    GetPage(
      name: AppRoutes.quiz,
      page: () => const QuizScreen(),
      binding: QuizBinding(),
    ),

    GetPage(
      name: AppRoutes.quizResult,
      page: () => const QuizResultScreen(),
      binding: QuizBinding(),
    ),

    GetPage(
      name: AppRoutes.certificates,
      page: () => const CertificatesScreen(),
      binding: CertificatesBinding(),
    ),

    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsScreen(),
      binding: SettingsBinding(),
    ),

    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfileScreen(),
      binding: EditProfileBinding(),
    ),

    GetPage(
      name: AppRoutes.changePassword,
      page: () => const ChangePasswordScreen(),
      binding: ChangePasswordBinding(),
    ),

    GetPage(
      name: AppRoutes.support,
      page: () => const SupportScreen(),
      binding: SupportBinding(),
    ),

    GetPage(
      name: AppRoutes.notificationPreferences,
      page: () => const NotificationPreferencesScreen(),
      binding: NotificationPreferencesBinding(),
    ),

    GetPage(
      name: AppRoutes.about,
      page: () => const AboutScreen(),
      binding: AboutBinding(),
    ),
    GetPage(
      name: AppRoutes.privacyPolicy,
      page: () => const PrivacyPolicyScreen(),
    ),
    GetPage(
      name: AppRoutes.termsConditions,
      page: () => const TermsConditionsScreen(),
    ),

    GetPage(
      name: AppRoutes.myLearning,
      page: () => const MyLearningScreen(),
      binding: MyLearningBinding(),
    ),

    GetPage(
      name: AppRoutes.courseCompletion,
      page: () => const CourseCompletionScreen(),
      binding: CourseCompletionBinding(),
    ),

    GetPage(
      name: AppRoutes.courseFeedback,
      page: () => const CourseFeedbackScreen(),
      binding: CourseFeedbackBinding(),
    ),

    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsScreen(),
      binding: NotificationsBinding(),
    ),

    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
    ),
  ];
}
