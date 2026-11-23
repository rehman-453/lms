import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../controllers/certificates_controller.dart';

class CertificatesScreen extends GetView<CertificatesController> {
  const CertificatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildSummary()),
            SliverToBoxAdapter(child: _buildFilters()),
            SliverToBoxAdapter(child: _buildCertificateList()),
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
      child: Row(
        children: [
          InkWell(
            onTap: Get.back,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(Icons.arrow_back_rounded, size: 20),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('My Certificates', style: AppTextStyles.heading(size: 22)),
                const SizedBox(height: 4),
                Text(
                  'Your learning achievements',
                  style: AppTextStyles.body(size: 12),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.workspace_premium_rounded,
            color: AppColors.primary,
            size: 28,
          ),
        ],
      ),
    );
  }

  // Summary Card
  Widget _buildSummary() {
    return Obx(() {
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
        child: Row(
          children: [
            Container(
              height: 58,
              width: 58,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.workspace_premium_rounded,
                color: Colors.white,
                size: 34,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${controller.totalCertificates}',
                    style: AppTextStyles.heading(size: 30, color: Colors.white),
                  ),
                  const Text(
                    'Certificates Earned',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Keep learning and achieve more!',
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  // Filters
  Widget _buildFilters() {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 15),
        child: Row(
          children: controller.filters.map((filter) {
            final selected = controller.selectedFilter.value == filter;

            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () => controller.changeFilter(filter),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : AppColors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: selected ? AppColors.primary : AppColors.border,
                    ),
                  ),
                  child: Text(
                    filter,
                    style: AppTextStyles.body(
                      size: 12,
                      weight: FontWeight.w600,
                      color: selected ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    });
  }

  // Certificate List
  Widget _buildCertificateList() {
    return Obx(() {
      final items = controller.filteredCertificates;

      if (items.isEmpty) {
        return _buildEmptyState();
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: items.map((certificate) {
            return _buildCertificateCard(certificate);
          }).toList(),
        ),
      );
    });
  }

  // Certificate Card
  Widget _buildCertificateCard(Map<String, dynamic> certificate) {
    final color = Color(certificate['color'] as int);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Certificate Preview
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: color.withValues(alpha: 0.25)),
            ),
            child: Column(
              children: [
                Icon(Icons.workspace_premium_rounded, color: color, size: 38),
                const SizedBox(height: 7),
                Text(
                  'CERTIFICATE OF COMPLETION',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body(
                    size: 10,
                    weight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'This certificate is proudly presented to',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body(size: 10),
                ),
                const SizedBox(height: 8),
                Text(
                  'Student Name',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.heading(
                    size: 20,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'For successfully completing',
                  style: AppTextStyles.body(size: 10),
                ),
                const SizedBox(height: 5),
                Text(
                  certificate['title'] as String,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.heading(size: 14, color: color),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _certificateMeta(
                      'ISSUED ON',
                      certificate['issueDate'] as String,
                    ),
                    _certificateMeta('GRADE', certificate['grade'] as String),
                  ],
                ),
              ],
            ),
          ),

          // Certificate Information
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 2, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  certificate['title'] as String,
                  style: AppTextStyles.heading(size: 15),
                ),
                const SizedBox(height: 5),
                Text(
                  certificate['subtitle'] as String,
                  style: AppTextStyles.body(size: 11),
                ),
                const SizedBox(height: 13),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      color: AppColors.textSecondary,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      certificate['issueDate'] as String,
                      style: AppTextStyles.body(size: 11),
                    ),
                    const Spacer(),
                    Text(
                      certificate['grade'] as String,
                      style: AppTextStyles.heading(size: 13, color: color),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          controller.showCertificateDetails(certificate);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11),
                          ),
                        ),
                        child: const Text('View Details'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          controller.downloadCertificate(certificate);
                        },
                        icon: const Icon(Icons.download_rounded, size: 17),
                        label: const Text('Download'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _certificateMeta(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.body(size: 8, weight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.body(
            size: 10,
            weight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  // Empty State
  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 65),
      child: Column(
        children: [
          Container(
            height: 85,
            width: 85,
            decoration: const BoxDecoration(
              color: AppColors.lightBlue,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.workspace_premium_outlined,
              size: 42,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 18),
          Text('No Certificates Yet', style: AppTextStyles.heading(size: 18)),
          const SizedBox(height: 8),
          Text(
            'Complete your courses to earn certificates and showcase your achievements.',
            textAlign: TextAlign.center,
            style: AppTextStyles.body(size: 12),
          ),
        ],
      ),
    );
  }
}
