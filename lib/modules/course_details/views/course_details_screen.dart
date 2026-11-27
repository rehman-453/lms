import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../controllers/course_details_controller.dart';

class CourseDetailsScreen extends GetView<CourseDetailsController> {
  const CourseDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Initial loading
      if (controller.isLoading.value &&
          controller.courseDetails.value == null) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      // API error
      if (controller.errorMessage.value.isNotEmpty &&
          controller.courseDetails.value == null) {
        return Scaffold(
          appBar: AppBar(title: const Text('Course Details')),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: controller.fetchCourseDetails,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      // Course unavailable
      if (controller.course.isEmpty && controller.courseDetails.value == null) {
        return const Scaffold(body: Center(child: Text('Course not found')));
      }

      return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopBar(),
                _buildCourseHeader(),
                _buildCourseStats(),
                _buildAboutSection(),
                _buildOutcomesSection(),
                _buildCurriculumSection(),
                _buildInstructorSection(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomBar(),
      );
    });
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
                    _getCourseIcon(controller.course['icon']?.toString()),
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
                controller.level,
                'Level',
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
      child: Text(controller.description, style: AppTextStyles.body(size: 13)),
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
      trailing: Obx(
        () => Text(
          '${controller.curriculum.length} sections',
          style: AppTextStyles.body(
            size: 12,
            color: AppColors.primary,
            weight: FontWeight.w600,
          ),
        ),
      ),
      child: Obx(() {
        if (controller.isLoading.value &&
            controller.courseDetails.value == null) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final curriculum = controller.curriculum;
        final enrolled = controller.isEnrolled.value;

        if (curriculum.isEmpty) {
          return Text(
            'No curriculum available yet.',
            style: AppTextStyles.body(size: 12),
          );
        }

        return Column(
          children: List.generate(curriculum.length, (index) {
            final section = curriculum[index];

            final lessons =
                section['lessons'] as List<Map<String, dynamic>>? ?? [];

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
                  // Section header
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
                                  section['title']?.toString() ??
                                      'Untitled Section',
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

                  // Lessons list
                  if (isExpanded) ...[
                    const Divider(height: 1, color: AppColors.border),
                    ...List.generate(lessons.length, (lessonIndex) {
                      final lesson = lessons[lessonIndex];

                      final isPreview = lesson['is_preview'] == true;

                      final canAccess = enrolled || isPreview;

                      return InkWell(
                        onTap: () {
                          if (!canAccess) {
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
                                canAccess
                                    ? Icons.play_circle_outline_rounded
                                    : Icons.lock_outline_rounded,
                                size: 20,
                                color: canAccess
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 11),
                              Expanded(
                                child: Text(
                                  lesson['title']?.toString() ??
                                      'Untitled Lesson',
                                  style: AppTextStyles.body(
                                    size: 12,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              if (isPreview && !enrolled) ...[
                                Text(
                                  'Preview',
                                  style: AppTextStyles.body(
                                    size: 10,
                                    color: AppColors.primary,
                                    weight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                              Text(
                                lesson['duration']?.toString() ?? 'N/A',
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 27,
                backgroundColor: AppColors.lightBlue,
                child: Text(
                  controller.instructor.isNotEmpty
                      ? controller.instructor[0].toUpperCase()
                      : 'I',
                  style: AppTextStyles.heading(
                    size: 20,
                    color: AppColors.primary,
                  ),
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
                    Text(
                      controller.instructorQualification.isNotEmpty
                          ? controller.instructorQualification
                          : 'Course Instructor',
                      style: AppTextStyles.body(size: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (controller.instructorSpecialization.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              controller.instructorSpecialization,
              style: AppTextStyles.body(size: 12),
            ),
          ],
          if (controller.instructorBio.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(controller.instructorBio, style: AppTextStyles.body(size: 12)),
          ],
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
              ?trailing,
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

  // Course icon
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
