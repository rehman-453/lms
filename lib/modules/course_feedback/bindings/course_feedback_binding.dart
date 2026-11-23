import 'package:get/get.dart';

import '../controllers/course_feedback_controller.dart';

class CourseFeedbackBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CourseFeedbackController>(() => CourseFeedbackController());
  }
}
