import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lms/core/widgets/custom_text_field.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileScreen extends GetView<EditProfileController> {
  const EditProfileScreen({super.key});

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
        title: Text('Edit Profile', style: AppTextStyles.heading(size: 22)),
      ),
      body: Obx(() {
        if (controller.isFetchingProfile.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Image
                Center(
                  child: Column(
                    children: [
                      Obx(() {
                        final localImage = controller.profileImage.value;
                        final networkImage =
                            controller.existingProfileImageUrl.value;

                        ImageProvider? imageProvider;

                        if (localImage != null) {
                          imageProvider = FileImage(localImage);
                        } else if (networkImage.isNotEmpty) {
                          imageProvider = NetworkImage(networkImage);
                        }

                        return Stack(
                          children: [
                            GestureDetector(
                              onTap: controller.pickProfileImage,
                              child: CircleAvatar(
                                radius: 52,
                                backgroundColor: AppColors.lightBlue,
                                backgroundImage: imageProvider,
                                child: imageProvider == null
                                    ? const Icon(
                                        Icons.person,
                                        size: 55,
                                        color: AppColors.primary,
                                      )
                                    : null,
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: GestureDetector(
                                onTap: controller.pickProfileImage,
                                child: Container(
                                  height: 34,
                                  width: 34,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),

                      const SizedBox(height: 12),

                      GestureDetector(
                        onTap: controller.pickProfileImage,
                        child: Text(
                          'Change Profile Photo',
                          style: AppTextStyles.body(
                            color: AppColors.primary,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ),

                      // Remove Photo
                      Obx(() {
                        final hasLocalImage =
                            controller.profileImage.value != null;

                        final hasExistingImage =
                            controller.existingProfileImageUrl.value.isNotEmpty;

                        if (!hasLocalImage && !hasExistingImage) {
                          return const SizedBox.shrink();
                        }

                        return TextButton.icon(
                          onPressed: controller.removeProfileImage,
                          icon: const Icon(
                            Icons.delete_outline,
                            color: AppColors.error,
                            size: 18,
                          ),
                          label: Text(
                            'Remove Photo',
                            style: AppTextStyles.body(
                              color: AppColors.error,
                              weight: FontWeight.w600,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Full Name
                _label('Full Name'),
                _textField(
                  controller: controller.nameController,
                  hint: 'Enter your full name',
                  icon: Icons.person_outline,
                  validator: controller.validateName,
                ),

                const SizedBox(height: 20),

                // Email
                _label('Email Address'),
                _textField(
                  controller: controller.emailController,
                  hint: 'Enter your email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: controller.validateEmail,
                ),

                const SizedBox(height: 20),

                // Phone
                _label('Phone Number'),
                _textField(
                  controller: controller.phoneController,
                  hint: 'Enter your phone number',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: controller.validatePhone,
                ),

                const SizedBox(height: 20),

                // Student ID
                _label('Student ID'),
                _textField(
                  controller: controller.studentIdController,
                  hint: 'Student ID',
                  icon: Icons.badge_outlined,
                  readOnly: true,
                ),

                const SizedBox(height: 32),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: AppColors.primary.withValues(
                          alpha: 0.6,
                        ),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Save Changes',
                              style: AppTextStyles.body(
                                color: Colors.white,
                                weight: FontWeight.bold,
                                size: 15,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: AppTextStyles.body(
          color: AppColors.textPrimary,
          weight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
  }) {
    return CustomTextField(
      textFieldController: controller,
      hintText: hint,
      validator: validator,
      keyboardType: keyboardType,
      readOnly: readOnly,
      showBorder: true,
      fillColor: AppColors.white,
      borderColor: AppColors.border,
      fontSize: 14,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 21),
      textInputAction: TextInputAction.next,
    );
  }
}
