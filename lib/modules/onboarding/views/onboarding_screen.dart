import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    final size = MediaQuery.sizeOf(context);

    final isTablet = size.width >= 600;

    final imageHeight = isTablet ? size.height * 0.42 : size.height * 0.38;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
                child: TextButton(
                  onPressed: controller.skip,
                  child: Text(
                    'Skip',
                    style: AppTextStyles.body(
                      size: 15,
                      weight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),

            // Slides
            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                children: [
                  OnboardingPage(
                    imageHeight: imageHeight,
                    icon: Icons.menu_book_rounded,
                    title: 'Learn Anywhere,\nAnytime',
                    description:
                        'Access quality courses and build new skills '
                        'from anywhere, at your own pace.',
                    backgroundColor: const Color(0xFFEAF0FF),
                  ),
                  OnboardingPage(
                    imageHeight: imageHeight,
                    icon: Icons.workspace_premium_rounded,
                    title: 'Learn From\nExperts',
                    description:
                        'Explore professionally designed courses '
                        'and learn from experienced instructors.',
                    backgroundColor: const Color(0xFFEDE8FF),
                  ),
                  OnboardingPage(
                    imageHeight: imageHeight,
                    icon: Icons.insights_rounded,
                    title: 'Track Your\nProgress',
                    description:
                        'Stay motivated, track your achievements '
                        'and complete your learning goals.',
                    backgroundColor: const Color(0xFFE1F6EF),
                  ),
                ],
              ),
            ),

            // Bottom section
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 60 : 24,
                vertical: 20,
              ),
              child: Column(
                children: [
                  // Dots
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(controller.totalPages, (index) {
                        final isActive = controller.currentIndex.value == index;

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isActive ? 28 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.primary
                                : const Color(0xFFDCE3F0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Button
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: controller.nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              controller.currentIndex.value ==
                                      controller.totalPages - 1
                                  ? 'Get Started'
                                  : 'Continue',
                              style: AppTextStyles.body(
                                size: 16,
                                weight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Icon(Icons.arrow_forward_rounded),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'Learn • Practice • Grow',
                    style: AppTextStyles.body(
                      size: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final double imageHeight;
  final IconData icon;
  final String title;
  final String description;
  final Color backgroundColor;

  const OnboardingPage({
    super.key,
    required this.imageHeight,
    required this.icon,
    required this.title,
    required this.description,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Available height inside PageView
        final availableHeight = constraints.maxHeight;

        // Responsive illustration size based on actual available space
        final illustrationSize = availableHeight < 400
            ? 150.0
            : screenWidth >= 600
            ? 260.0
            : 220.0;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: availableHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Illustration area
                  SizedBox(
                    height: illustrationSize + 30,
                    width: double.infinity,
                    child: Center(
                      child: SizedBox(
                        height: illustrationSize + 20,
                        width: illustrationSize + 20,
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            // Background circle
                            Container(
                              height: illustrationSize,
                              width: illustrationSize,
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                shape: BoxShape.circle,
                              ),
                            ),

                            // Main icon card
                            Container(
                              height: illustrationSize * 0.58,
                              width: illustrationSize * 0.58,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(28),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.10,
                                    ),
                                    blurRadius: 24,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Icon(
                                icon,
                                size: illustrationSize * 0.35,
                                color: AppColors.primary,
                              ),
                            ),

                            // Top right floating icon
                            Positioned(
                              top: 5,
                              right: 0,
                              child: FloatingIcon(
                                icon: Icons.lightbulb_rounded,
                                color: const Color(0xFFFFB547),
                              ),
                            ),

                            // Bottom left floating icon
                            Positioned(
                              bottom: 0,
                              left: 0,
                              child: FloatingIcon(
                                icon: Icons.play_circle_fill_rounded,
                                color: AppColors.primary,
                              ),
                            ),

                            // Bottom right floating icon
                            Positioned(
                              bottom: 15,
                              right: 0,
                              child: FloatingIcon(
                                icon: Icons.verified_rounded,
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Title
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.heading(
                      size: screenWidth >= 600 ? 30 : 26,
                      weight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body(
                        size: 14,
                        color: AppColors.textSecondary,
                      ).copyWith(height: 1.5),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class FloatingIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const FloatingIcon({super.key, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Icon(icon, size: 25, color: color),
    );
  }
}
