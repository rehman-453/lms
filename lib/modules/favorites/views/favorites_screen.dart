import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../controllers/favorites_controller.dart';
import '../models/favorite_model.dart';

class FavoritesScreen extends GetView<FavoritesController> {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.fetchFavorites,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverToBoxAdapter(child: _buildDescription()),
              Obx(() {
                if (controller.isLoading.value) {
                  return const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (controller.errorMessage.value.isNotEmpty &&
                    controller.favoritesList.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildErrorState(),
                  );
                }

                final favorites = controller.favoritesList;

                if (favorites.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildEmptyState(),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return _buildFavoriteCard(favorites[index]);
                    }, childCount: favorites.length),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
      child: Row(
        children: [
          Expanded(
            child: Text('Favorites', style: AppTextStyles.heading(size: 26)),
          ),
          Obx(() {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.lightBlue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${controller.favoritesList.length} Saved',
                style: AppTextStyles.body(
                  size: 12,
                  weight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Text(
        'Your saved courses are all in one place.',
        style: AppTextStyles.body(size: 14),
      ),
    );
  }

  Widget _buildFavoriteCard(FavoriteModel favorite) {
    final course = favorite.course ?? {};

    final title = course['title']?.toString() ?? 'Untitled Course';

    final instructor =
        course['instructor']?['user']?['name']?.toString() ??
        'Instructor unavailable';

    final category = course['category']?['name']?.toString() ?? 'Course';

    final level = course['level']?.toString() ?? '';

    final durationMinutes =
        int.tryParse(course['duration_minutes']?.toString() ?? '') ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: AppColors.lightBlue,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.menu_book_rounded,
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
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.heading(size: 14),
                ),
                const SizedBox(height: 5),
                Text(
                  instructor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body(size: 12),
                ),
                const SizedBox(height: 9),
                Wrap(
                  spacing: 12,
                  runSpacing: 5,
                  children: [
                    _buildInfo(
                      Icons.category_outlined,
                      category,
                      AppColors.primary,
                    ),
                    if (level.isNotEmpty)
                      _buildInfo(
                        Icons.signal_cellular_alt_rounded,
                        level,
                        AppColors.textSecondary,
                      ),
                    _buildInfo(
                      Icons.access_time_rounded,
                      '$durationMinutes min',
                      AppColors.textSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 5),
          IconButton(
            onPressed: () => _confirmRemove(favorite, title),
            visualDensity: VisualDensity.compact,
            constraints: const BoxConstraints(minWidth: 35, minHeight: 35),
            icon: const Icon(
              Icons.favorite_rounded,
              color: AppColors.error,
              size: 23,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfo(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.body(size: 11)),
      ],
    );
  }

  void _confirmRemove(FavoriteModel favorite, String title) {
    Get.dialog(
      AlertDialog(
        title: const Text('Remove Favorite?'),
        content: Text(
          'Are you sure you want to remove "$title" from favorites?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Get.back();

              final success = await controller.removeFavorite(
                favorite.courseId,
              );

              if (success) {
                Get.snackbar(
                  'Removed',
                  'Course removed from favorites.',
                  snackPosition: SnackPosition.BOTTOM,
                );
              } else {
                Get.snackbar(
                  'Error',
                  controller.errorMessage.value.isNotEmpty
                      ? controller.errorMessage.value
                      : 'Unable to remove favorite course.',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 105,
              height: 105,
              decoration: const BoxDecoration(
                color: AppColors.lightBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 22),
            Text(
              'No Favorites Yet',
              textAlign: TextAlign.center,
              style: AppTextStyles.heading(size: 20),
            ),
            const SizedBox(height: 9),
            Text(
              'Save courses you are interested in and find them here whenever you need them.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body(size: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: AppColors.error,
            ),
            const SizedBox(height: 12),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: AppTextStyles.body(size: 14),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: controller.fetchFavorites,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
