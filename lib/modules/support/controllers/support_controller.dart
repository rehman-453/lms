import 'package:get/get.dart';

class SupportController extends GetxController {
  final RxList<int> expandedQuestions = <int>[].obs;

  final List<Map<String, String>> faqs = [
    {
      'category': 'Account & Login',
      'question': 'How can I reset my password?',
      'answer': 'Open the login screen, select Forgot Password, enter your registered email and follow the password reset process.',
    },
    {
      'category': 'Account & Login',
      'question': 'How can I update my profile?',
      'answer': 'Go to Profile, select Personal Information or Edit Profile, update your details and save your changes.',
    },
    {
      'category': 'Courses & Lessons',
      'question': 'How can I enroll in a course?',
      'answer': 'Open the Courses section, select your preferred course and tap the Enroll button.',
    },
    {
      'category': 'Courses & Lessons',
      'question': 'Can I resume a lesson later?',
      'answer': 'Yes. Open your enrolled course and continue from the lesson where you left off, provided your progress has been saved.',
    },
    {
      'category': 'Courses & Lessons',
      'question': 'How can I track my learning progress?',
      'answer': 'Open the Progress tab to view your completed lessons, course progress and learning activity.',
    },
    {
      'category': 'Certificates',
      'question': 'When will I receive my certificate?',
      'answer': 'Certificates are generally available after completing the required course activities and assessments. Availability depends on course requirements.',
    },
    {
      'category': 'Certificates',
      'question': 'Where can I view my certificates?',
      'answer': 'Open Profile and select My Certificates to view your available certificates.',
    },
  ];

  final List<String> categories = [
    'All',
    'Account & Login',
    'Courses & Lessons',
    'Certificates',
  ];

  final RxString selectedCategory = 'All'.obs;

  List<Map<String, String>> get filteredFaqs {
    if (selectedCategory.value == 'All') {
      return faqs;
    }

    return faqs
        .where((faq) => faq['category'] == selectedCategory.value)
        .toList();
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
    expandedQuestions.clear();
  }

  void toggleQuestion(int index) {
    if (expandedQuestions.contains(index)) {
      expandedQuestions.remove(index);
    } else {
      expandedQuestions.add(index);
    }
  }

  bool isExpanded(int index) {
    return expandedQuestions.contains(index);
  }

  void contactSupport() {
    Get.snackbar(
      'Contact Support',
      'Support email integration will be available soon.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
