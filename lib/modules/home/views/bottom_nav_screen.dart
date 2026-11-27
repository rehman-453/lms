import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:lms/app/theme/app_colors.dart';
import 'package:lms/modules/courses/views/courses_screen.dart';
import 'package:lms/modules/favorites/views/favorites_screen.dart';
import 'package:lms/modules/home/controllers/home_controller.dart';
import 'package:lms/modules/home/controllers/home_tutorial_controller.dart';
import 'package:lms/modules/home/views/home_screen.dart';
import 'package:lms/modules/profile/views/profile_screen.dart';
import 'package:lms/modules/progress/views/progress_screen.dart';

class BottomNavScreen extends StatelessWidget {
  const BottomNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    final HomeTutorialController tutorialController =
        Get.find<HomeTutorialController>();

    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Obx(() {
          return IndexedStack(
            index: controller.selectedIndex.value,
            children: const [
              HomeScreen(),
              CoursesScreen(),
              FavoritesScreen(),
              ProgressScreen(),
              // ProfileScreen(),
            ],
          );
        }),
      ),

      bottomNavigationBar: Obx(
        () => NavigationBar(
          key: tutorialController.bottomNavigationKey,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: controller.changeTab,
          backgroundColor: AppColors.white,
          indicatorColor: AppColors.lightBlue,
          elevation: 8,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(Icons.menu_book_rounded),
              label: 'Courses',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_border_rounded),
              selectedIcon: Icon(Icons.favorite_rounded),
              label: 'Favorites',
            ),
            NavigationDestination(
              icon: Icon(Icons.bar_chart_outlined),
              selectedIcon: Icon(Icons.bar_chart_rounded),
              label: 'Progress',
            ),
            // NavigationDestination(
            //   icon: Icon(Icons.person_outline_rounded),
            //   selectedIcon: Icon(Icons.person_rounded),
            //   label: 'Profile',
            // ),
          ],
        ),
      ),
    );
  }
}
