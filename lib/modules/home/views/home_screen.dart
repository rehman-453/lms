import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../controllers/home_controller.dart';
import '../controllers/home_tutorial_controller.dart';

import '../../courses/views/courses_screen.dart';
import '../../favorites/views/favorites_screen.dart';
import '../../progress/views/progress_screen.dart';
import '../../profile/views/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeController controller;
  late final HomeTutorialController tutorialController;

  final ScrollController _homeScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    controller = Get.find<HomeController>();
    tutorialController = Get.find<HomeTutorialController>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      // Start the tutorial from the top of the Home screen.
      if (_homeScrollController.hasClients) {
        _homeScrollController.jumpTo(0);
      }

      await tutorialController.showTutorial(context);
    });
  }

  @override
  void dispose() {
    _homeScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Obx(() {
          final selectedIndex = controller.selectedIndex.value;

          return IndexedStack(
            index: selectedIndex,
            children: [
              _buildHomeContent(context),
              const CoursesScreen(),
              const FavoritesScreen(),
              const ProgressScreen(),
              const ProfileScreen(),
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
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // HOME CONTENT
  // --------------------------------------------------

  Widget _buildHomeContent(BuildContext context) {
    return CustomScrollView(
      controller: _homeScrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),

                _buildSearchBar(),
                const SizedBox(height: 24),

                _buildWelcomeCard(),
                const SizedBox(height: 24),

                _buildStats(),
                const SizedBox(height: 28),

                _buildSectionHeader(
                  title: 'Continue Learning',
                  action: 'See All',
                  onTap: controller.openAllCourses,
                ),
                const SizedBox(height: 14),

                _buildContinueLearning(),
                const SizedBox(height: 28),

                _buildSectionHeader(
                  title: 'Explore Categories',
                  action: 'See All',
                  onTap: controller.openAllCourses,
                ),
                const SizedBox(height: 14),

                _buildCategories(),
                const SizedBox(height: 28),

                _buildSectionHeader(
                  title: 'Popular Courses',
                  action: 'See All',
                  onTap: controller.openAllCourses,
                ),
                const SizedBox(height: 14),

                _buildPopularCourses(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------
  // HEADER
  // --------------------------------------------------

  Widget _buildHeader() {
    return Container(
      key: tutorialController.welcomeKey,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Good to see you,',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Obx(
                  () => Text(
                    '${controller.studentName.value} 👋',
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _iconButton(
            icon: Icons.notifications_none_rounded,
            onTap: controller.openNotifications,
          ),
          const SizedBox(width: 10),
          Obx(() {
            final name = controller.studentName.value;

            return CircleAvatar(
              radius: 23,
              backgroundColor: AppColors.lightBlue,
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : 'S',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // SEARCH BAR
  // --------------------------------------------------

  Widget _buildSearchBar() {
    return Container(
      key: tutorialController.searchKey,
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search_rounded,
            color: AppColors.textSecondary,
            size: 23,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              onChanged: controller.updateSearch,
              decoration: const InputDecoration(
                hintText: 'Search courses, topics...',
                hintStyle: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),
          const Icon(Icons.tune_rounded, color: AppColors.primary, size: 22),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // WELCOME BANNER
  // --------------------------------------------------

  Widget _buildWelcomeCard() {
    return Container(
      key: tutorialController.bannerKey,
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              height: 130,
              width: 130,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'YOUR LEARNING JOURNEY',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 17),
              const Text(
                'Keep Learning,\nKeep Growing!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  height: 1.3,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 9),
              Text(
                'Explore new skills and achieve your goals.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 19),
              ElevatedButton(
                onPressed: controller.openAllCourses,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Explore Courses',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 7),
                    Icon(Icons.arrow_forward_rounded, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // STATS
  // --------------------------------------------------

  Widget _buildStats() {
    return Obx(() {
      final stats = controller.dashboardStats;

      if (controller.isDashboardLoading.value && stats == null) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (controller.dashboardError.value.isNotEmpty && stats == null) {
        return _emptyState(
          icon: Icons.cloud_off_outlined,
          title: 'Unable to load dashboard',
          subtitle: controller.dashboardError.value,
        );
      }

      final enrolledCount = stats?.totalEnrolledCourses ?? 0;
      final completedCount = stats?.completedCourses ?? 0;
      final inProgressCount = stats?.inProgressCourses ?? 0;

      return Row(
        children: [
          Expanded(
            child: _statCard(
              icon: Icons.menu_book_rounded,
              title: 'Enrolled',
              value: '$enrolledCount',
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _statCard(
              icon: Icons.check_circle_outline_rounded,
              title: 'Completed',
              value: '$completedCount',
              color: AppColors.success,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _statCard(
              icon: Icons.play_circle_outline_rounded,
              title: 'In Progress',
              value: '$inProgressCount',
              color: AppColors.primary,
            ),
          ),
        ],
      );
    });
  }

  Widget _statCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 21),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // SECTION HEADER
  // --------------------------------------------------

  Widget _buildSectionHeader({
    required String title,
    required String action,
    required VoidCallback onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            action,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------
  // CONTINUE LEARNING
  // --------------------------------------------------

  Widget _buildContinueLearning() {
    return Obx(() {
      final courses = controller.recentCourses;

      if (controller.isDashboardLoading.value && courses.isEmpty) {
        return const SizedBox(
          height: 120,
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (courses.isEmpty) {
        return Container(
          key: tutorialController.continueLearningKey,
          child: _emptyState(
            icon: Icons.school_outlined,
            title: 'No courses in progress',
            subtitle: 'Enroll in a course to start learning.',
          ),
        );
      }

      return Container(
        key: tutorialController.continueLearningKey,
        child: SizedBox(
          height: 165,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: courses.length,
            separatorBuilder: (_, __) => const SizedBox(width: 13),
            itemBuilder: (context, index) {
              final apiCourse = courses[index];

              final progress = (apiCourse.progress.completionPercentage / 100)
                  .clamp(0.0, 1.0);

              final course = {
                'id': apiCourse.course.id,
                'title': apiCourse.course.title,
                'instructor': apiCourse.course.instructor?.name ?? 'Instructor',
                'progress': progress,
              };

              return GestureDetector(
                onTap: () => controller.openCourse(course),
                child: Container(
                  width: 245,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(17),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 39,
                            width: 39,
                            decoration: BoxDecoration(
                              color: AppColors.lightBlue,
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: const Icon(
                              Icons.play_circle_outline_rounded,
                              color: AppColors.primary,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${double.parse(apiCourse.progress.completionPercentage.toString()).toStringAsFixed(2).replaceAll(RegExp(r'\.?0+$'), '')}%',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        apiCourse.course.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        apiCourse.course.instructor?.name ?? 'Instructor',
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,
                          backgroundColor: AppColors.lightBlue,
                          valueColor: const AlwaysStoppedAnimation(
                            AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }

  // --------------------------------------------------
  // CATEGORIES
  // --------------------------------------------------

  Widget _buildCategories() {
    return Obx(() {
      final categories = [
        'All',
        ...controller.categories.map((category) => category.name),
      ];

      final selectedCategory = controller.selectedCategory.value;

      return Container(
        key: tutorialController.categoriesKey,
        child: SizedBox(
          height: 42,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 9),
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = selectedCategory == category;

              return GestureDetector(
                onTap: () => controller.selectCategory(category),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 17,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }

  // --------------------------------------------------
  // POPULAR COURSES
  // --------------------------------------------------

  Widget _buildPopularCourses() {
    return Obx(() {
      final search = controller.searchQuery.value;
      final category = controller.selectedCategory.value;

      // LOADING STATE
      if (controller.isCoursesLoading.value) {
        return Container(
          key: tutorialController.popularCoursesKey,
          height: 180,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(),
        );
      }

      // ERROR STATE
      if (controller.coursesError.value.isNotEmpty) {
        return Container(
          key: tutorialController.popularCoursesKey,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Icon(Icons.wifi_off_rounded, size: 40, color: Colors.grey),
              const SizedBox(height: 10),
              const Text('Unable to load courses'),
              const SizedBox(height: 10),
              Text(controller.coursesError.value, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: controller.fetchPopularCourses,
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      final courses = controller.filteredCourses;

      // EMPTY STATE
      if (courses.isEmpty) {
        return Container(
          key: tutorialController.popularCoursesKey,
          child: _emptyState(
            icon: Icons.search_off_rounded,
            title: 'No courses found',
            subtitle: search.isNotEmpty || category != 'All'
                ? 'Try changing your search or category.'
                : 'Courses will appear here soon.',
          ),
        );
      }

      // COURSE LIST
      return Container(
        key: tutorialController.popularCoursesKey,
        child: Column(
          children: courses.map((course) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 13),
              child: _buildCourseCard(course),
            );
          }).toList(),
        ),
      );
    });
  }

  Widget _buildCourseCard(Map<String, dynamic> course) {
    return GestureDetector(
      onTap: () => controller.openCourse(course),
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              height: 75,
              width: 75,
              decoration: BoxDecoration(
                color: AppColors.lightBlue,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                _courseIcon(course['category']?.toString() ?? ''),
                color: AppColors.primary,
                size: 32,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course['category']?.toString() ?? 'General',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    course['title']?.toString() ?? 'Untitled Course',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    course['instructor']?.toString() ?? 'Instructor',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: AppColors.warning,
                        size: 14,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${course['rating'] ?? '4.8'}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 9),
                      const Icon(
                        Icons.access_time_rounded,
                        color: AppColors.textSecondary,
                        size: 13,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        course['duration']?.toString() ?? '6 hours',
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 5),
            Obx(() {
              final courseId = (course['id'] as num).toInt();
              final isFavorite = controller.favoriteCourseIds.contains(
                courseId,
              );

              return GestureDetector(
                onTap: () => controller.toggleFavorite(course),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Icon(
                    isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: isFavorite
                        ? AppColors.error
                        : AppColors.textSecondary,
                    size: 21,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // HELPERS
  // --------------------------------------------------

  Widget _iconButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 43,
        width: 43,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: 21),
      ),
    );
  }

  Widget _emptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, size: 35, color: AppColors.textSecondary),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  IconData _courseIcon(String category) {
    switch (category.toLowerCase()) {
      case 'development':
      case 'programming':
        return Icons.code_rounded;
      case 'design':
      case 'ui/ux':
        return Icons.palette_outlined;
      case 'business':
        return Icons.business_center_outlined;
      case 'marketing':
        return Icons.campaign_outlined;
      case 'data science':
        return Icons.analytics_outlined;
      default:
        return Icons.school_outlined;
    }
  }
}
