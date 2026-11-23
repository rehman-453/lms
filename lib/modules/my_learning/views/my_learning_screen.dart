import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../controllers/my_learning_controller.dart';

class MyLearningScreen extends GetView<MyLearningController> {
  const MyLearningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('My Learning', style: AppTextStyles.heading(size: 21)),
        centerTitle: false,
      ),
      body: Obx(() {
        final courses = controller.filteredCourses;

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildSummary(),
            const SizedBox(height: 24),
            _buildFilters(),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Enrolled Courses',
                  style: AppTextStyles.heading(size: 18),
                ),
                Text(
                  '${courses.length} courses',
                  style: AppTextStyles.body(size: 12),
                ),
              ],
            ),

            const SizedBox(height: 14),

            if (courses.isEmpty)
              _buildEmptyState()
            else
              ...courses.map(
                (course) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _buildCourseCard(course),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Learning Journey',
              style: AppTextStyles.heading(size: 19, color: Colors.white),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                _summaryItem('${controller.totalCourses}', 'Enrolled'),
                const SizedBox(width: 20),
                _summaryItem('${controller.inProgressCourses}', 'In Progress'),
                const SizedBox(width: 20),
                _summaryItem('${controller.completedCourses}', 'Completed'),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget _summaryItem(String value, String label) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: AppTextStyles.heading(size: 25, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.body(
              size: 11,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: controller.filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 9),
        itemBuilder: (context, index) {
          final filter = controller.filters[index];

          return Obx(() {
            final isSelected = controller.selectedFilter.value == filter;

            return GestureDetector(
              onTap: () => controller.selectFilter(filter),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
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
                  filter,
                  style: AppTextStyles.body(
                    size: 12,
                    weight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildCourseCard(Map<String, dynamic> course) {
    // Supports both snake_case and camelCase keys.
    final progress = _readDouble(course, 'progress').clamp(0.0, 1.0);

    final completed = _readInt(
      course,
      'completed_lessons',
      fallbackKey: 'completedLessons',
    );

    final total = _readInt(
      course,
      'total_lessons',
      fallbackKey: 'totalLessons',
    );

    final remaining = (total - completed).clamp(0, total);

    final title =
        course['title']?.toString() ??
        course['name']?.toString() ??
        'Untitled Course';

    final instructor =
        course['instructor']?.toString() ??
        course['instructor_name']?.toString() ??
        'Instructor';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: AppColors.lightBlue,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: AppColors.primary,
                  size: 27,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.heading(size: 14),
                    ),
                    const SizedBox(height: 5),
                    Text(instructor, style: AppTextStyles.body(size: 12)),
                  ],
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: AppTextStyles.heading(
                  size: 15,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: AppColors.lightBlue,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$completed of $total lessons completed',
                style: AppTextStyles.body(size: 11),
              ),
              Text('$remaining remaining', style: AppTextStyles.body(size: 11)),
            ],
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: () => controller.continueLearning(course),
              icon: const Icon(Icons.play_arrow_rounded, size: 20),
              label: Text(
                progress >= 1 ? 'Review Course' : 'Continue Learning',
                style: AppTextStyles.body(
                  size: 13,
                  weight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _readInt(Map<String, dynamic> data, String key, {String? fallbackKey}) {
    final value = data[key] ?? (fallbackKey != null ? data[fallbackKey] : null);

    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  double _readDouble(Map<String, dynamic> data, String key) {
    final value = data[key];

    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 45),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.menu_book_outlined,
            size: 55,
            color: AppColors.primary,
          ),
          const SizedBox(height: 15),
          Text('No Courses Found', style: AppTextStyles.heading(size: 17)),
          const SizedBox(height: 7),
          Text(
            'Your courses will appear here once you enroll.',
            textAlign: TextAlign.center,
            style: AppTextStyles.body(size: 13),
          ),
        ],
      ),
    );
  }
}
