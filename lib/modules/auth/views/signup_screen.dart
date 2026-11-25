import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lms/core/widgets/custom_text_field.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../controllers/signup_controller.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignupController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth >= 600;

            return SingleChildScrollView(
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
                      // Back button
                      IconButton(
                        onPressed: controller.goToLogin,
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: AppColors.textPrimary,
                        ),
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                      ),

                      const SizedBox(height: 16),

                      _buildLogo(),

                      const SizedBox(height: 32),

                      Text(
                        'Create Account',
                        style: AppTextStyles.heading(
                          size: isTablet ? 32 : 28,
                          weight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        'Join us and start your learning journey today.',
                        style: AppTextStyles.body(size: 15),
                      ),

                      const SizedBox(height: 30),

                      Form(
                        key: controller.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Full Name'),
                            const SizedBox(height: 9),

                            CustomTextField(
                              textFieldController: controller.nameController,
                              hintText: 'Enter your full name',
                              textCapitalization: TextCapitalization.words,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              validator: controller.validateName,
                              prefixIcon: const Icon(
                                Icons.person_outline_rounded,
                              ),
                              // decoration: _inputDecoration(
                              //   hint: 'Enter your full name',
                              // ),
                            ),

                            const SizedBox(height: 20),

                            _buildLabel('Email Address'),
                            const SizedBox(height: 9),

                            CustomTextField(
                              textFieldController: controller.emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              hintText: 'Enter your email address',
                              prefixIcon: Icon(Icons.email_outlined),
                              validator: controller.validateEmail,
                              // decoration: _inputDecoration(
                              //   hint: 'Enter your email address',
                              //   prefixIcon: Icons.email_outlined,
                              // ),
                            ),

                            const SizedBox(height: 20),

                            _buildLabel('Password'),
                            const SizedBox(height: 9),

                            Obx(
                              () => CustomTextField(
                                textFieldController:
                                    controller.passwordController,
                                hintText: 'Create a password',
                                isObscure: !controller.isPasswordVisible.value,
                                textInputAction: TextInputAction.next,
                                validator: controller.validatePassword,
                                //  obscureText: null,

                                prefixIcon: const Icon(
                                  Icons.lock_outline_rounded,
                                ),

                                suffixIcon: IconButton(
                                  onPressed:
                                      controller.togglePasswordVisibility,
                                  icon: Icon(
                                    controller.isPasswordVisible.value
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: AppColors.textSecondary,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                            // Obx(
                            //   () => CustomTextField(
                            //     textFieldController: controller.passwordController,
                            //     obscureText:
                            //         !controller.isPasswordVisible.value,
                            //     textInputAction: TextInputAction.next,
                            //     validator: controller.validatePassword,
                            //     decoration: _inputDecoration(
                            //       hint: 'Create a password',
                            //       prefixIcon: Icons.lock_outline_rounded,
                            //       suffixIcon: IconButton(
                            //         onPressed:
                            //             controller.togglePasswordVisibility,
                            //         icon: Icon(
                            //           controller.isPasswordVisible.value
                            //               ? Icons.visibility_off_outlined
                            //               : Icons.visibility_outlined,
                            //           color: AppColors.textSecondary,
                            //           size: 20,
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),

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
                                onFieldSubmitted: (_) => controller.signup(),
                                  hintText: 'Re-enter your password',
                                  prefixIcon: Icon(Icons.lock_outline_rounded),
                                  suffixIcon: IconButton(
                                    onPressed: controller
                                        .toggleConfirmPasswordVisibility,
                                    icon: Icon(
                                      controller.isConfirmPasswordVisible.value
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,)
                                  )
                                // decoration: _inputDecoration(
                                //   hint: 'Re-enter your password',
                                //   prefixIcon: Icons.lock_outline_rounded,
                                //   suffixIcon: IconButton(
                                //     onPressed: controller
                                //         .toggleConfirmPasswordVisibility,
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

                            const SizedBox(height: 16),

                            // Terms and conditions
                            Obx(
                              () => CheckboxListTile(
                                value: controller.agreeToTerms.value,
                                onChanged: controller.toggleTerms,
                                activeColor: AppColors.primary,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                title: Text.rich(
                                  TextSpan(
                                    style: AppTextStyles.body(
                                      size: 13,
                                      color: AppColors.textSecondary,
                                    ),
                                    children: const [
                                      TextSpan(text: 'I agree to the '),
                                      TextSpan(
                                        text: 'Terms & Conditions',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      TextSpan(text: ' and '),
                                      TextSpan(
                                        text: 'Privacy Policy',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Signup button
                            Obx(
                              () => SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: controller.isLoading.value
                                      ? null
                                      : controller.signup,
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
                                              'Create Account',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Icon(
                                              Icons.arrow_forward_rounded,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 28),

                            // Login link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    'Already have an account? ',
                                    style: AppTextStyles.body(size: 14),
                                  ),
                                ),
                                TextButton(
                                  onPressed: controller.goToLogin,
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    'Login',
                                    style: AppTextStyles.body(
                                      size: 14,
                                      weight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      Center(
                        child: Text(
                          'Learn • Practice • Grow',
                          style: AppTextStyles.body(
                            size: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            );
          },
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

  InputDecoration _inputDecoration({
    required String hint,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.body(size: 14, color: AppColors.textSecondary),
      prefixIcon: Icon(prefixIcon, color: AppColors.textSecondary, size: 20),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
    );
  }
}
