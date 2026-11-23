import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../controllers/support_controller.dart';

class SupportScreen extends GetView<SupportController> {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
            size: 20,
          ),
        ),
        title: Text('Help & Support', style: AppTextStyles.heading(size: 22)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(),

            const SizedBox(height: 28),

            Text(
              'Frequently Asked Questions',
              style: AppTextStyles.heading(size: 19),
            ),

            const SizedBox(height: 15),

            _buildCategoryFilters(),

            const SizedBox(height: 18),

            _buildFaqList(),

            const SizedBox(height: 28),

            _buildContactCard(),

            const SizedBox(height: 25),

            Center(
              child: Text(
                'Flutter LMS • Version 1.0.0',
                style: AppTextStyles.body(size: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
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
          const Icon(
            Icons.support_agent_rounded,
            color: Colors.white,
            size: 38,
          ),
          const SizedBox(height: 16),
          Text(
            'How can we help you?',
            style: AppTextStyles.heading(size: 20, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'Find answers to common questions and get help with your learning journey.',
            style: AppTextStyles.body(size: 13, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: controller.categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = controller.categories[index];

          return Obx(() {
            final isSelected = controller.selectedCategory.value == category;

            return GestureDetector(
              onTap: () => controller.selectCategory(category),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                ),
                child: Text(
                  category,
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

  Widget _buildFaqList() {
    return Obx(() {
      final faqs = controller.filteredFaqs;

      if (faqs.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(25),
            child: Text('No questions available.'),
          ),
        );
      }

      return Column(
        children: List.generate(faqs.length, (index) {
          final faq = faqs[index];
          final expanded = controller.isExpanded(index);

          return Container(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 5,
                  ),
                  title: Text(
                    faq['question'] ?? '',
                    style: AppTextStyles.body(
                      color: AppColors.textPrimary,
                      weight: FontWeight.w600,
                    ),
                  ),
                  tileColor: Colors.transparent,
                  trailing: Icon(
                    expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.primary,
                  ),
                  onTap: () => controller.toggleQuestion(index),
                ),
                if (expanded)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        faq['answer'] ?? '',
                        style: AppTextStyles.body(
                          size: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
      );
    });
  }

  Widget _buildContactCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.headset_mic_outlined,
            color: AppColors.primary,
            size: 35,
          ),
          const SizedBox(height: 12),
          Text('Still need help?', style: AppTextStyles.heading(size: 17)),
          const SizedBox(height: 7),
          Text(
            'Our support team is here to help you.',
            textAlign: TextAlign.center,
            style: AppTextStyles.body(size: 13),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: controller.contactSupport,
              icon: const Icon(Icons.mail_outline, size: 19),
              label: Text(
                'Contact Support',
                style: AppTextStyles.body(
                  color: Colors.white,
                  weight: FontWeight.bold,
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
}
