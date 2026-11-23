import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../controllers/course_details_controller.dart';

class CourseDetailsScreen extends GetView<CourseDetailsController> {
  const CourseDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (controller.course.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Course Details')),
        body: Center(
          child: Text(
            'Course information is unavailable.',
            style: AppTextStyles.body(size: 14),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildTopBar()),
            SliverToBoxAdapter(child: _buildCourseHeader()),
            SliverToBoxAdapter(child: _buildCourseStats()),
            SliverToBoxAdapter(child: _buildAboutSection()),
            SliverToBoxAdapter(child: _buildOutcomesSection()),
            SliverToBoxAdapter(child: _buildCurriculumSection()),
            SliverToBoxAdapter(child: _buildInstructorSection()),
            const SliverToBoxAdapter(child: SizedBox(height: 110)),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // Top navigation bar
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 16, 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          Expanded(
            child: Text(
              'Course Details',
              textAlign: TextAlign.center,
              style: AppTextStyles.heading(size: 17),
            ),
          ),
          Obx(() {
            final favorite = controller.isFavorite;

            return IconButton(
              onPressed: controller.toggleFavorite,
              icon: Icon(
                favorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: favorite ? AppColors.error : AppColors.textPrimary,
              ),
            );
          }),
        ],
      ),
    );
  }

  // Course header
  Widget _buildCourseHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 185,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: 25,
                  bottom: 15,
                  child: Icon(
                    _getCourseIcon(controller.course['icon']),
                    size: 125,
                    color: Colors.white.withValues(alpha: 0.17),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          controller.category,
                          style: AppTextStyles.body(
                            size: 11,
                            weight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            controller.courseTitle,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.heading(
                              size: 22,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              const Icon(
                Icons.star_rounded,
                color: AppColors.warning,
                size: 20,
              ),
              const SizedBox(width: 5),
              Text(
                controller.rating,
                style: AppTextStyles.body(
                  size: 13,
                  weight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Text('Course rating', style: AppTextStyles.body(size: 12)),
              const Spacer(),
              Text(
                controller.price,
                style: AppTextStyles.heading(
                  size: 16,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Course stats
  Widget _buildCourseStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildStat(
                Icons.play_lesson_outlined,
                '${controller.totalLessons}',
                'Lessons',
              ),
            ),
            _buildVerticalDivider(),
            Expanded(
              child: _buildStat(
                Icons.access_time_rounded,
                controller.duration,
                'Duration',
              ),
            ),
            _buildVerticalDivider(),
            Expanded(
              child: _buildStat(
                Icons.signal_cellular_alt_rounded,
                'All',
                'Levels',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(height: 8),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.heading(size: 14),
        ),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.body(size: 11)),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(width: 1, height: 48, color: AppColors.border);
  }

  // About course
  Widget _buildAboutSection() {
    return _buildSection(
      title: 'About This Course',
      child: Text(
        'Learn ${controller.courseTitle} through structured lessons '
        'and practical examples. This course is designed to help you '
        'understand important concepts and build useful skills.',
        style: AppTextStyles.body(size: 13),
      ),
    );
  }

  // Learning outcomes
  Widget _buildOutcomesSection() {
    return _buildSection(
      title: 'What You Will Learn',
      child: Column(
        children: controller.learningOutcomes.map((outcome) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: 19,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    outcome['title'].toString(),
                    style: AppTextStyles.body(
                      size: 13,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // Curriculum
  Widget _buildCurriculumSection() {
    return _buildSection(
      title: 'Course Curriculum',
      trailing: Text(
        '${controller.curriculum.length} sections',
        style: AppTextStyles.body(
          size: 12,
          color: AppColors.primary,
          weight: FontWeight.w600,
        ),
      ),
      child: Obx(() {
        final enrolled = controller.isEnrolled.value;

        return Column(
          children: List.generate(controller.curriculum.length, (index) {
            final section = controller.curriculum[index];
            final lessons = section['lessons'] as List<Map<String, dynamic>>;
            final isExpanded = controller.expandedSections.contains(index);

            return Container(
              margin: const EdgeInsets.only(bottom: 11),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => controller.toggleSection(index),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  section['title'].toString(),
                                  style: AppTextStyles.body(
                                    size: 13,
                                    weight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '${lessons.length} lessons',
                                  style: AppTextStyles.body(size: 11),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isExpanded) ...[
                    const Divider(height: 1, color: AppColors.border),
                    ...List.generate(lessons.length, (lessonIndex) {
                      final lesson = lessons[lessonIndex];

                      return InkWell(
                        onTap: () {
                          if (!enrolled) {
                            Get.snackbar(
                              'Enrollment Required',
                              'Please enroll in this course to access lessons.',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            return;
                          }

                          controller.openLesson(lesson);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                enrolled
                                    ? Icons.play_circle_outline_rounded
                                    : Icons.lock_outline_rounded,
                                size: 20,
                                color: enrolled
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 11),
                              Expanded(
                                child: Text(
                                  lesson['title'].toString(),
                                  style: AppTextStyles.body(
                                    size: 12,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              Text(
                                lesson['duration'].toString(),
                                style: AppTextStyles.body(size: 11),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ],
              ),
            );
          }),
        );
      }),
    );
  }

  // Instructor
  Widget _buildInstructorSection() {
    return _buildSection(
      title: 'Your Instructor',
      child: Row(
        children: [
          CircleAvatar(
            radius: 27,
            backgroundColor: AppColors.lightBlue,
            child: Text(
              controller.instructor.isNotEmpty
                  ? controller.instructor[0].toUpperCase()
                  : 'I',
              style: AppTextStyles.heading(size: 20, color: AppColors.primary),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.instructor,
                  style: AppTextStyles.body(
                    size: 14,
                    weight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text('Course Instructor', style: AppTextStyles.body(size: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Reusable section layout
  Widget _buildSection({
    required String title,
    required Widget child,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title, style: AppTextStyles.heading(size: 17)),
              ),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }

  // Bottom enrollment button
  Widget _buildBottomBar() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Obx(() {
          final enrolled = controller.isEnrolled.value;

          return SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: enrolled ? null : controller.enrollNow,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.success,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                enrolled ? 'Enrolled' : 'Enroll Now',
                style: AppTextStyles.body(
                  size: 14,
                  weight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

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
