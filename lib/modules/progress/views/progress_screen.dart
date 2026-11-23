import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../controllers/progress_controller.dart';

class ProgressScreen extends GetView<ProgressController> {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildOverview()),
            SliverToBoxAdapter(child: _buildStatistics()),
            SliverToBoxAdapter(child: _buildActivityChart()),
            SliverToBoxAdapter(child: _buildCourseProgress()),
            SliverToBoxAdapter(child: _buildRecentActivity()),
            const SliverToBoxAdapter(child: SizedBox(height: 25)),
          ],
        ),
      ),
    );
  }

  // Header
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('My Progress', style: AppTextStyles.heading(size: 25)),
          const SizedBox(height: 6),
          Text(
            'Track your learning journey and achievements.',
            style: AppTextStyles.body(size: 13),
          ),
        ],
      ),
    );
  }

  // Overall Overview
  Widget _buildOverview() {
    return Obx(() {
      final progress = controller.overallProgress;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Overall Learning Progress',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'All Courses',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$progress%',
                        style: AppTextStyles.heading(
                          size: 38,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${controller.completedLessons} lessons completed',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 92,
                  width: 92,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox.expand(
                        child: CircularProgressIndicator(
                          value: progress / 100,
                          strokeWidth: 9,
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      Text(
                        '$progress%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            const Divider(color: Colors.white24, height: 1),
            const SizedBox(height: 16),
            Row(
              children: [
                _overviewItem('${controller.totalCourses}', 'Enrolled Courses'),
                const Spacer(),
                _overviewItem(
                  '${controller.completedCourses}',
                  'Completed Courses',
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _overviewItem(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }

  // Statistics
  Widget _buildStatistics() {
    return Obx(() {
      final stats = [
        {
          'title': 'Lessons Done',
          'value': '${controller.completedLessons}',
          'icon': Icons.menu_book_rounded,
          'color': const Color(0xFF2F6BFF),
          'background': const Color(0xFFEAF0FF),
        },
        {
          'title': 'Learning Hours',
          'value': controller.totalLearningHours.toStringAsFixed(1),
          'icon': Icons.access_time_rounded,
          'color': const Color(0xFF8B5CF6),
          'background': const Color(0xFFF0EAFE),
        },
        {
          'title': 'Quiz Average',
          'value': '${controller.averageQuizScore.toStringAsFixed(0)}%',
          'icon': Icons.emoji_events_rounded,
          'color': const Color(0xFF20B486),
          'background': const Color(0xFFE4F8F1),
        },
        {
          'title': 'Total Courses',
          'value': '${controller.totalCourses}',
          'icon': Icons.school_rounded,
          'color': const Color(0xFFFFA629),
          'background': const Color(0xFFFFF3DE),
        },
      ];

      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: stats.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.65,
          ),
          itemBuilder: (context, index) {
            final item = stats[index];

            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        // height: 34,
                        width: 34,
                        decoration: BoxDecoration(
                          color: item['background'] as Color,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          item['icon'] as IconData,
                          color: item['color'] as Color,
                          size: 18,
                        ),
                      ),
                      const Spacer(),
                      Flexible(
                        child: Text(
                          item['title'] as String,
                          textAlign: TextAlign.end,
                          style: AppTextStyles.body(size: 10),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item['value'] as String,
                    style: AppTextStyles.heading(size: 21),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }

  // Learning Activity Chart
  Widget _buildActivityChart() {
    return Obx(() {
      return Container(
        margin: const EdgeInsets.fromLTRB(20, 24, 20, 0),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Learning Activity', style: AppTextStyles.heading(size: 16)),
            const SizedBox(height: 5),
            Text('Hours spent learning', style: AppTextStyles.body(size: 12)),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${controller.totalLearningHours.toStringAsFixed(1)} hours',
                    style: AppTextStyles.heading(
                      size: 24,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                _buildPeriodSelector(),
              ],
            ),
            const SizedBox(height: 22),
            SizedBox(
              height: 145,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: controller.weeklyActivity.map((activity) {
                  final hours = activity['hours'] as double;
                  final barHeight = (hours / controller.maxWeeklyHours) * 100;

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            hours.toStringAsFixed(1),
                            style: AppTextStyles.body(size: 9),
                          ),
                          const SizedBox(height: 7),
                          Container(
                            height: barHeight.clamp(8.0, 100.0),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(
                                alpha: hours == controller.maxWeeklyHours
                                    ? 1
                                    : 0.35,
                              ),
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                          const SizedBox(height: 9),
                          Text(
                            activity['day'] as String,
                            style: AppTextStyles.body(size: 10),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(controller.periods.length, (index) {
          return Obx(() {
            final selected = controller.selectedPeriod.value == index;

            return GestureDetector(
              onTap: () => controller.changePeriod(index),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
                decoration: BoxDecoration(
                  color: selected ? AppColors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  controller.periods[index],
                  style: AppTextStyles.body(
                    size: 10,
                    weight: selected ? FontWeight.bold : FontWeight.normal,
                    color: selected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            );
          });
        }),
      ),
    );
  }

  // Course Progress
  Widget _buildCourseProgress() {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Course Progress',
                    style: AppTextStyles.heading(size: 18),
                  ),
                ),
                Text(
                  '${controller.totalCourses} Courses',
                  style: AppTextStyles.body(size: 12),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ...controller.courseProgress.map((course) {
              final progress = course['progress'] as double;
              final color = Color(course['color'] as int);

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            course['title'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.body(
                              size: 14,
                              weight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${(progress * 100).round()}%',
                          style: AppTextStyles.heading(size: 13, color: color),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      course['category'] as String,
                      style: AppTextStyles.body(size: 11),
                    ),
                    const SizedBox(height: 13),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 7,
                        backgroundColor: AppColors.background,
                        valueColor: AlwaysStoppedAnimation(color),
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      '${course['completedLessons']} of '
                      '${course['totalLessons']} lessons completed',
                      style: AppTextStyles.body(size: 11),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      );
    });
  }

  // Recent Activity
  Widget _buildRecentActivity() {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recent Activity', style: AppTextStyles.heading(size: 18)),
            const SizedBox(height: 14),
            ...controller.recentActivities.map((activity) {
              final color = Color(activity['color'] as int);
              final isQuiz = activity['icon'] == 'quiz';

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 43,
                      width: 43,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isQuiz ? Icons.quiz_rounded : Icons.menu_book_rounded,
                        color: color,
                        size: 21,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity['title'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.body(
                              size: 13,
                              weight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            activity['subtitle'] as String,
                            style: AppTextStyles.body(size: 11),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            activity['type'] as String,
                            style: AppTextStyles.body(
                              size: 10,
                              color: color,
                              weight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      activity['time'] as String,
                      style: AppTextStyles.body(size: 9),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      );
    });
  }
}
