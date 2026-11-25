import 'package:get/get.dart';
import 'package:lms/modules/home/controllers/home_tutorial_controller.dart';

import '../controllers/home_controller.dart';
import '../../progress/controllers/progress_controller.dart';

import 'package:lms/modules/favorites/controllers/favorites_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);

    Get.lazyPut<HomeTutorialController>(
      () => HomeTutorialController(),
      fenix: true,
    );

    Get.lazyPut<ProgressController>(() => ProgressController(), fenix: true);

    Get.lazyPut<FavoritesController>(() => FavoritesController(), fenix: true);
  }
}
