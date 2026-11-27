import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lms/core/widgets/custom_text_field.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../home/controllers/home_controller.dart';

class CoursesScreen extends GetView<HomeController> {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.fetchAllCourses();
            await controller.fetchCategories();
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverToBoxAdapter(child: _buildSearchField()),
              SliverToBoxAdapter(child: _buildCategories()),
              SliverToBoxAdapter(child: _buildSectionHeader()),
              Obx(() {
                // ALL COURSES API DATA
                final courses = controller.filteredAllCourses;

                // LOADING STATE
                if (controller.isAllCoursesLoading.value) {
                  return const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                // ERROR STATE
                if (controller.allCoursesError.value.isNotEmpty &&
                    controller.allCourses.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildErrorState(),
                  );
                }

                // EMPTY STATE
                if (courses.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildEmptyState(),
                  );
                }

                // COURSES LIST
                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return _buildCourseCard(courses[index]);
                    }, childCount: courses.length),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // HEADER
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Explore Courses', style: AppTextStyles.heading(size: 26)),
          const SizedBox(height: 6),
          Text(
            'Discover courses and learn new skills.',
            style: AppTextStyles.body(size: 14),
          ),
        ],
      ),
    );
  }

  // SEARCH FIELD
  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CustomTextField(
        hintText: 'Search courses or instructors...',

        onChanged: controller.updateSearch,

        showBorder: true,
        fillColor: AppColors.white,

        fontSize: 13,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),

        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppColors.textSecondary,
        ),

        suffixIcon: Obx(() {
          if (controller.searchQuery.value.isEmpty) {
            return const SizedBox.shrink();
          }

          return IconButton(
            onPressed: controller.clearSearch,
            icon: const Icon(
              Icons.close_rounded,
              color: AppColors.textSecondary,
            ),
          );
        }),

        borderColor: AppColors.border,
        textInputAction: TextInputAction.search,
      ),
    );
  }

  // CATEGORY FILTERS
  Widget _buildCategories() {
    return Padding(
      padding: const EdgeInsets.only(top: 22),
      child: SizedBox(
        height: 42,
        child: Obx(() {
          final categories = controller.categories;

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 9),
            itemBuilder: (context, index) {
              final categoryName = index == 0
                  ? 'All'
                  : categories[index - 1].name;

              return Obx(() {
                final isSelected =
                    controller.selectedCategory.value == categoryName;

                return GestureDetector(
                  onTap: () => controller.selectCategory(categoryName),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 19),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                    ),
                    child: Text(
                      categoryName,
                      style: AppTextStyles.body(
                        size: 12,
                        weight: FontWeight.w600,
                        color: isSelected
                            ? AppColors.white
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              });
            },
          );
        }),
      ),
    );
  }

  // SECTION HEADER
  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 15),
      child: Row(
        children: [
          Expanded(
            child: Text('All Courses', style: AppTextStyles.heading(size: 18)),
          ),
          Obx(() {
            return Text(
              '${controller.filteredAllCourses.length} courses',
              style: AppTextStyles.body(size: 12),
            );
          }),
        ],
      ),
    );
  }

  // COURSE CARD
  Widget _buildCourseCard(Map<String, dynamic> course) {
    final int courseId = course['id'] as int;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: AppColors.lightBlue,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  _getCourseIcon(course['icon']),
                  color: AppColors.primary,
                  size: 29,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course['title'].toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.heading(size: 14),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'By ${course['instructor']}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body(size: 12),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      course['category'].toString(),
                      style: AppTextStyles.body(
                        size: 11,
                        weight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() {
                final isFavorite = controller.isFavorite(courseId);
                final isLoading = controller.favoriteLoadingIds.contains(
                  courseId,
                );

                return IconButton(
                  onPressed: isLoading
                      ? null
                      : () => controller.toggleFavorite(course),
                  visualDensity: VisualDensity.compact,
                  constraints: const BoxConstraints(
                    minWidth: 35,
                    minHeight: 35,
                  ),
                  padding: EdgeInsets.zero,
                  icon: isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: isFavorite
                              ? AppColors.error
                              : AppColors.textSecondary,
                          size: 23,
                        ),
                );
              }),
            ],
          ),

          const SizedBox(height: 15),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 13),

          Wrap(
            spacing: 16,
            runSpacing: 9,
            children: [
              _buildInfo(
                Icons.star_rounded,
                course['rating'] != null
                    ? double.parse(course['rating'].toString())
                          .toStringAsFixed(1)
                    : 'No rating',
                AppColors.warning,
              ),
              _buildInfo(
                Icons.play_circle_outline_rounded,
                '${course['lessons_count'] ?? 0} lessons',
                AppColors.textSecondary,
              ),
              _buildInfo(
                Icons.access_time_rounded,
                '${course['duration_minutes'] ?? 0} mins',
                AppColors.textSecondary,
              ),
            ],
          ),

          // Wrap(
          //   spacing: 16,
          //   runSpacing: 9,
          //   children: [
          //     _buildInfo(
          //       Icons.star_rounded,
          //       '${course['rating']}',
          //       AppColors.warning,
          //     ),
          //     _buildInfo(
          //       Icons.play_circle_outline_rounded,
          //       '${course['lessons']} lessons',
          //       AppColors.textSecondary,
          //     ),
          //     _buildInfo(
          //       Icons.access_time_rounded,
          //       course['duration'].toString(),
          //       AppColors.textSecondary,
          //     ),
          //   ],
          // ),
          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(
                child: Text(
                  course['price'].toString(),
                  style: AppTextStyles.heading(
                    size: 16,
                    color: AppColors.success,
                  ),
                ),
              ),
              SizedBox(
                height: 38,
                child: ElevatedButton(
                  onPressed: () => controller.openCourse(course),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 17),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'View Details',
                    style: AppTextStyles.body(
                      size: 12,
                      weight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // COURSE INFORMATION
  Widget _buildInfo(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 5),
        Text(label, style: AppTextStyles.body(size: 11)),
      ],
    );
  }

  // EMPTY STATE
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 95,
              height: 95,
              decoration: const BoxDecoration(
                color: AppColors.lightBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 43,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text('No Courses Found', style: AppTextStyles.heading(size: 19)),
            const SizedBox(height: 8),
            Text(
              'Try searching with a different keyword or category.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body(size: 13),
            ),
            const SizedBox(height: 18),
            TextButton(
              onPressed: () {
                controller.clearSearch();
                controller.selectCategory('All');
              },
              child: const Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }

  // ERROR STATE
  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 55,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'Unable to Load Courses',
              style: AppTextStyles.heading(size: 18),
            ),
            const SizedBox(height: 8),
            Text(
              controller.allCoursesError.value,
              textAlign: TextAlign.center,
              style: AppTextStyles.body(size: 13),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: controller.fetchAllCourses,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  // COURSE ICONS
  IconData _getCourseIcon(String? icon) {
    switch (icon) {
      case 'code':
        return Icons.code_rounded;
      case 'design':
        return Icons.palette_outlined;
      case 'api':
        return Icons.api_rounded;
      case 'marketing':
        return Icons.campaign_outlined;
      case 'business':
        return Icons.business_center_outlined;
      default:
        return Icons.menu_book_rounded;
    }
  }
}
