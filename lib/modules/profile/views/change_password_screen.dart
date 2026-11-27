import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lms/core/widgets/custom_text_field.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../controllers/change_password_controller.dart';

class ChangePasswordScreen extends GetView<ChangePasswordController> {
  const ChangePasswordScreen({super.key});

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
        title: Text('Change Password', style: AppTextStyles.heading(size: 22)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.lightBlue,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.lock_reset_rounded,
                      color: AppColors.primary,
                      size: 30,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Secure Your Account',
                            style: AppTextStyles.heading(size: 16),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Choose a strong password that you do not use on other websites.',
                            style: AppTextStyles.body(
                              size: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              _label('Current Password'),
              Obx(
                () => _passwordField(
                  textController: controller.currentPasswordController,
                  hint: 'Enter current password',
                  isVisible: controller.isCurrentPasswordVisible.value,
                  onVisibilityChanged: (value) =>
                      controller.isCurrentPasswordVisible.value = value,
                  validator: controller.validateCurrentPassword,
                ),
              ),

              const SizedBox(height: 22),

              _label('New Password'),
              Obx(
                () => _passwordField(
                  textController: controller.newPasswordController,
                  hint: 'Enter new password',
                  isVisible: controller.isNewPasswordVisible.value,
                  onVisibilityChanged: (value) =>
                      controller.isNewPasswordVisible.value = value,
                  validator: controller.validateNewPassword,
                ),
              ),

              const SizedBox(height: 22),

              _label('Confirm New Password'),
              Obx(
                () => _passwordField(
                  textController: controller.confirmPasswordController,
                  hint: 'Confirm new password',
                  isVisible: controller.isConfirmPasswordVisible.value,
                  onVisibilityChanged: (value) =>
                      controller.isConfirmPasswordVisible.value = value,
                  validator: controller.validateConfirmPassword,
                ),
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.changePassword,
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
                            'Update Password',
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
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Text(
        text,
        style: AppTextStyles.body(
          color: AppColors.textPrimary,
          weight: FontWeight.w600,
        ),
      ),
    );
  }


Widget _passwordField({
  required TextEditingController textController,
  required String hint,
  required bool isVisible,
  required ValueChanged<bool> onVisibilityChanged,
  required String? Function(String?) validator,
}) {
  return CustomTextField(
    textFieldController: textController,
    hintText: hint,

    isObscure: !isVisible,
    validator: validator,

    showBorder: true,
    fillColor: AppColors.white,
    borderColor: AppColors.border,

    fontSize: 14,

    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 17,
    ),

    prefixIcon: const Icon(
      Icons.lock_outline,
      color: AppColors.textSecondary,
      size: 21,
    ),

    suffixIcon: IconButton(
      onPressed: () => onVisibilityChanged(!isVisible),
      icon: Icon(
        isVisible
            ? Icons.visibility_off_outlined
            : Icons.visibility_outlined,
        color: AppColors.textSecondary,
      ),
    ),

    textInputAction: TextInputAction.next,
  );
}

  // Widget _passwordField({
  //   required TextEditingController textController,
  //   required String hint,
  //   required bool isVisible,
  //   required ValueChanged<bool> onVisibilityChanged,
  //   required String? Function(String?) validator,
  // }) {
  //   return TextFormField(
  //     controller: textController,
  //     obscureText: !isVisible,
  //     validator: validator,
  //     style: AppTextStyles.body(
  //       color: AppColors.textPrimary,
  //       weight: FontWeight.w500,
  //     ),
  //     decoration: InputDecoration(
  //       hintText: hint,
  //       prefixIcon: const Icon(
  //         Icons.lock_outline,
  //         color: AppColors.textSecondary,
  //         size: 21,
  //       ),
  //       suffixIcon: IconButton(
  //         onPressed: () => onVisibilityChanged(!isVisible),
  //         icon: Icon(
  //           isVisible
  //               ? Icons.visibility_off_outlined
  //               : Icons.visibility_outlined,
  //           color: AppColors.textSecondary,
  //         ),
  //       ),
  //       filled: true,
  //       fillColor: AppColors.white,
  //       contentPadding: const EdgeInsets.symmetric(
  //         horizontal: 16,
  //         vertical: 17,
  //       ),
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(14),
  //         borderSide: const BorderSide(color: AppColors.border),
  //       ),
  //       enabledBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(14),
  //         borderSide: const BorderSide(color: AppColors.border),
  //       ),
  //       focusedBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(14),
  //         borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
  //       ),
  //       errorBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(14),
  //         borderSide: const BorderSide(color: AppColors.error),
  //       ),
  //     ),
  //   );
  // }
}
