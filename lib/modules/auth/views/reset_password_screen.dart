import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lms/core/widgets/custom_text_field.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../controllers/reset_password_controller.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ResetPasswordController>();
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 32 : 24,
            vertical: 20,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: controller.backToVerifyEmail,
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 30),

                  _buildLogo(),

                  const SizedBox(height: 42),

                  Center(
                    child: Container(
                      height: 125,
                      width: 125,
                      decoration: BoxDecoration(
                        color: AppColors.lightBlue,
                        borderRadius: BorderRadius.circular(36),
                      ),
                      child: const Icon(
                        Icons.lock_reset_rounded,
                        size: 68,
                        color: AppColors.primary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  Text(
                    'Reset Password',
                    style: AppTextStyles.heading(
                      size: isTablet ? 32 : 28,
                      weight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Your email has been verified. Create a new '
                    'password for your account.',
                    style: AppTextStyles.body(size: 15),
                  ),

                  const SizedBox(height: 28),

                  Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Email Address'),
                        const SizedBox(height: 9),

                        CustomTextField(
                          textFieldController: controller.emailController,
                          hintText: 'Verified email address',
                          readOnly: true,
                          keyboardType: TextInputType.emailAddress,
                          validator: controller.validateEmail,
                          prefixIcon: Icon(Icons.email_outlined),
                          // decoration: _inputDecoration(
                          //   hint: 'Verified email address',
                          //   prefixIcon: Icons.email_outlined,
                          // ).copyWith(fillColor: AppColors.lightBlue),
                        ),

                        const SizedBox(height: 20),

                        _buildLabel('New Password'),
                        const SizedBox(height: 9),

                        Obx(
                          () => CustomTextField(
                            textFieldController: controller.passwordController,
                            isObscure: !controller.isPasswordVisible.value,
                            textInputAction: TextInputAction.next,
                            validator: controller.validatePassword,
                            hintText: 'Enter new password',
                            prefixIcon: Icon(Icons.lock_outline_rounded),
                            suffixIcon: IconButton(
                              onPressed: controller.togglePasswordVisibility,
                              icon: Icon(
                                controller.isPasswordVisible.value
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.textSecondary,
                                size: 20,
                              ),
                            ),
                            // decoration: _inputDecoration(
                            //   hint: 'Enter new password',
                            //   prefixIcon: Icons.lock_outline_rounded,
                            //   suffixIcon: IconButton(
                            //     onPressed: controller.togglePasswordVisibility,
                            //     icon: Icon(
                            //       controller.isPasswordVisible.value
                            //           ? Icons.visibility_off_outlined
                            //           : Icons.visibility_outlined,
                            //       color: AppColors.textSecondary,
                            //       size: 20,
                            //     ),
                            //   ),
                            // ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        _buildLabel('Confirm Password'),
                        const SizedBox(height: 9),

                        Obx(
                          () => CustomTextField(
                            textFieldController:
                                controller.confirmPasswordController,
                            isObscure:
                                !controller.isConfirmPasswordVisible.value,
                            textInputAction: TextInputAction.done,
                            validator: controller.validateConfirmPassword,
                            onFieldSubmitted: (_) => controller.resetPassword(),
                            hintText: 'Confirm your new password',
                            prefixIcon: Icon(Icons.lock_outline_rounded),
                            suffixIcon: IconButton(
                              onPressed:
                                  controller.toggleConfirmPasswordVisibility,
                              icon: Icon(
                                controller.isConfirmPasswordVisible.value
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.textSecondary,
                                size: 20,
                              ),
                            ),
                            // decoration: _inputDecoration(
                            //   hint: 'Confirm your new password',
                            //   prefixIcon: Icons.lock_outline_rounded,
                            //   suffixIcon: IconButton(
                            //     onPressed:
                            //         controller.toggleConfirmPasswordVisibility,
                            //     icon: Icon(
                            //       controller.isConfirmPasswordVisible.value
                            //           ? Icons.visibility_off_outlined
                            //           : Icons.visibility_outlined,
                            //       color: AppColors.textSecondary,
                            //       size: 20,
                            //     ),
                            //   ),
                            // ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          'Password must contain at least 8 characters.',
                          style: AppTextStyles.body(size: 12),
                        ),

                        const SizedBox(height: 28),

                        Obx(
                          () => SizedBox(
                            height: 56,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: controller.isLoading.value
                                  ? null
                                  : controller.resetPassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: AppColors.primary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: controller.isLoading.value
                                  ? const SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Reset Password',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Icon(
                                          Icons.check_circle_outline_rounded,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  Center(
                    child: TextButton(
                      onPressed: controller.backToVerifyEmail,
                      child: Text(
                        'Back to Email Verification',
                        style: AppTextStyles.body(
                          size: 13,
                          weight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      children: [
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.school_rounded,
            color: Colors.white,
            size: 26,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'LMS',
              style: AppTextStyles.heading(size: 20, weight: FontWeight.bold),
            ),
            Text(
              'LEARN • PRACTICE • GROW',
              style: AppTextStyles.body(
                size: 9,
                weight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.body(
        size: 14,
        weight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }

  // InputDecoration _inputDecoration({
  //   required String hint,
  //   required IconData prefixIcon,
  //   Widget? suffixIcon,
  // }) {
  //   return InputDecoration(
  //     hintText: hint,
  //     hintStyle: AppTextStyles.body(size: 14, color: AppColors.textSecondary),
  //     prefixIcon: Icon(prefixIcon, size: 20, color: AppColors.textSecondary),
  //     suffixIcon: suffixIcon,
  //     filled: true,
  //     fillColor: AppColors.white,
  //     contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
  //     border: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(16),
  //       borderSide: const BorderSide(color: AppColors.border),
  //     ),
  //     enabledBorder: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(16),
  //       borderSide: const BorderSide(color: AppColors.border),
  //     ),
  //     focusedBorder: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(16),
  //       borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
  //     ),
  //     errorBorder: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(16),
  //       borderSide: const BorderSide(color: AppColors.error),
  //     ),
  //     focusedErrorBorder: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(16),
  //       borderSide: const BorderSide(color: AppColors.error, width: 1.5),
  //     ),
  //   );
  // }
}
