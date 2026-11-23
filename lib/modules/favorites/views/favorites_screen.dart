import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../home/controllers/home_controller.dart';

class FavoritesScreen extends GetView<HomeController> {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildDescription()),
            Obx(() {
              final favorites = controller.favoriteCourses;

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
                    final course = favorites[index];
                    return _buildFavoriteCard(course);
                  }, childCount: favorites.length),
                ),
              );
            }),
          ],
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
                '${controller.favoriteCourseIds.length} Saved',
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

  Widget _buildFavoriteCard(Map<String, dynamic> course) {
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
                const SizedBox(height: 5),
                Text(
                  course['instructor'].toString(),
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
                      Icons.star_rounded,
                      '${course['rating']}',
                      AppColors.warning,
                    ),
                    _buildInfo(
                      Icons.play_circle_outline_rounded,
                      '${course['lessons']} lessons',
                      AppColors.textSecondary,
                    ),
                    _buildInfo(
                      Icons.access_time_rounded,
                      course['duration'].toString(),
                      AppColors.textSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 5),
          IconButton(
            onPressed: () => controller.removeFavorite(course),
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
