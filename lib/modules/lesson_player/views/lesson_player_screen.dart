import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../controllers/lesson_player_controller.dart';

class LessonPlayerScreen extends GetView<LessonPlayerController> {
  const LessonPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildVideoPlayer()),
            SliverToBoxAdapter(child: _buildLessonInfo()),
            SliverToBoxAdapter(child: _buildLessonActions()),
            SliverToBoxAdapter(child: _buildProgress()),
            SliverToBoxAdapter(child: _buildCurriculum()),
            SliverToBoxAdapter(child: _buildStartQuizButton()),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 20, 15),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          Expanded(
            child: Text(
              'Lesson Player',
              textAlign: TextAlign.center,
              style: AppTextStyles.heading(size: 17),
            ),
          ),
          const SizedBox(width: 45),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return Obx(() {
      final loading = controller.isLoading.value;
      final error = controller.hasError.value;
      final player = controller.videoController;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: 220,
        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(18),
        ),
        clipBehavior: Clip.antiAlias,
        child: loading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : error || player == null || !player.value.isInitialized
            ? _buildVideoError()
            : Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: AspectRatio(
                      aspectRatio: player.value.aspectRatio,
                      child: VideoPlayer(player),
                    ),
                  ),
                  Obx(
                    () => IconButton(
                      onPressed: controller.togglePlayPause,
                      iconSize: 58,
                      icon: Icon(
                        controller.isPlaying.value
                            ? Icons.pause_circle_filled_rounded
                            : Icons.play_circle_fill_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12,
                    right: 12,
                    bottom: 8,
                    child: _buildVideoControls(),
                  ),
                ],
              ),
      );
    });
  }

  Widget _buildVideoError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.play_circle_outline_rounded,
              color: Colors.white,
              size: 42,
            ),
            const SizedBox(height: 10),
            const Text(
              'Video could not be loaded',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: controller.initializeVideo,
              child: const Text(
                'Try Again',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoControls() {
    return Obx(() {
      final position = controller.videoPosition.value;
      final duration = controller.videoDuration.value;

      final maxDuration = duration > 0 ? duration : 1.0;
      final currentPosition = position.clamp(0.0, maxDuration);

      return Column(
        children: [
          SliderTheme(
            data: SliderTheme.of(Get.context!).copyWith(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
            ),
            child: Slider(
              value: currentPosition,
              min: 0,
              max: maxDuration,
              activeColor: AppColors.primary,
              inactiveColor: Colors.white38,
              onChanged: controller.seekVideo,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.formatDuration(position),
                style: AppTextStyles.body(size: 10, color: Colors.white),
              ),
              Text(
                controller.formatDuration(duration),
                style: AppTextStyles.body(size: 10, color: Colors.white),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildLessonInfo() {
    return Obx(() {
      final lesson = controller.currentLesson;

      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.course['title']?.toString() ?? 'My Course',
              style: AppTextStyles.body(size: 12),
            ),
            const SizedBox(height: 8),
            Text(
              lesson['title']?.toString() ?? 'Lesson',
              style: AppTextStyles.heading(size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              'Lesson ${controller.currentLessonIndex.value + 1} '
              'of ${controller.totalLessons}',
              style: AppTextStyles.body(size: 12),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildLessonActions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: controller.previousLesson,
              icon: const Icon(Icons.skip_previous_rounded),
              label: const Text('Previous'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: controller.nextLesson,
              icon: const Icon(Icons.skip_next_rounded),
              label: const Text('Next Lesson'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 13),
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

  Widget _buildProgress() {
    return Obx(() {
      final progress = controller.progress;
      final completed = controller.isCurrentLessonCompleted;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Course Progress',
                    style: AppTextStyles.heading(size: 14),
                  ),
                ),
                Text(
                  '${(progress * 100).round()}%',
                  style: AppTextStyles.heading(
                    size: 14,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: AppColors.lightBlue,
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '${controller.completedCount} of '
              '${controller.totalLessons} lessons completed',
              style: AppTextStyles.body(size: 12),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: completed ? null : controller.markAsCompleted,
                icon: Icon(
                  completed
                      ? Icons.check_circle_rounded
                      : Icons.check_circle_outline_rounded,
                ),
                label: Text(
                  completed ? 'Lesson Completed' : 'Mark as Completed',
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.success,
                  disabledForegroundColor: AppColors.success,
                  side: const BorderSide(color: AppColors.success),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildCurriculum() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Course Content',
                  style: AppTextStyles.heading(size: 18),
                ),
              ),
              Text(
                '${controller.totalLessons} lessons',
                style: AppTextStyles.body(size: 12),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Obx(() {
            return Column(
              children: List.generate(controller.lessons.length, (index) {
                final lesson = controller.lessons[index];
                final selected = controller.currentLessonIndex.value == index;
                final completed = controller.completedLessons.contains(index);

                return InkWell(
                  onTap: () => controller.playLesson(index),
                  borderRadius: BorderRadius.circular(13),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.lightBlue : AppColors.white,
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(
                        color: selected ? AppColors.primary : AppColors.border,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          completed
                              ? Icons.check_circle_rounded
                              : selected
                              ? Icons.play_circle_fill_rounded
                              : Icons.play_circle_outline_rounded,
                          color: completed
                              ? AppColors.success
                              : AppColors.primary,
                          size: 23,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lesson['title']?.toString() ?? 'Lesson',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.body(
                                  size: 13,
                                  weight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                lesson['duration']?.toString() ?? '',
                                style: AppTextStyles.body(size: 11),
                              ),
                            ],
                          ),
                        ),
                        if (selected)
                          const Icon(
                            Icons.equalizer_rounded,
                            color: AppColors.primary,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                );
              }),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStartQuizButton() {
    return Obx(() {
      final allLessonsCompleted =
          controller.totalLessons > 0 &&
          controller.completedCount >= controller.totalLessons;

      return Container(
        margin: const EdgeInsets.fromLTRB(20, 25, 20, 0),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: AppColors.lightBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.quiz_rounded,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Test Your Knowledge',
                        style: AppTextStyles.heading(size: 15),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        allLessonsCompleted
                            ? 'Complete the quiz to finish your course.'
                            : 'Complete all lessons to unlock the quiz.',
                        style: AppTextStyles.body(size: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: allLessonsCompleted
                    ? () {
                        Get.toNamed(
                          AppRoutes.quiz,
                          arguments: {
                            'course_id': controller.course['id'],
                            'course_title': controller.course['title'],
                            'instructor_name': controller.course['instructor'],
                          },
                        );
                      }
                    : null,
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(
                  allLessonsCompleted ? 'Start Quiz' : 'Quiz Locked',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.primary.withValues(
                    alpha: 0.35,
                  ),
                  foregroundColor: Colors.white,
                  disabledForegroundColor: Colors.white,
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
    });
  }
}
