import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../controllers/login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth >= 600;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 32 : 24,
                vertical: 24,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),

                      // Logo
                      _buildLogo(),

                      const SizedBox(height: 40),

                      // Welcome heading
                      Text(
                        'Welcome back! 👋',
                        style: AppTextStyles.heading(
                          size: isTablet ? 32 : 28,
                          weight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        'Sign in to continue your learning journey.',
                        style: AppTextStyles.body(
                          size: 15,
                          color: AppColors.textSecondary,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Login Form
                      Form(
                        key: controller.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Email Label
                            _buildLabel('Email Address'),

                            const SizedBox(height: 10),

                            // Email Field
                            TextFormField(
                              controller: controller.emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.email],
                              validator: controller.validateEmail,
                              decoration: _inputDecoration(
                                hint: 'Enter your email address',
                                prefixIcon: Icons.email_outlined,
                              ),
                            ),

                            const SizedBox(height: 22),

                            // Password Label
                            _buildLabel('Password'),

                            const SizedBox(height: 10),

                            // Password Field
                            Obx(
                              () => TextFormField(
                                controller: controller.passwordController,
                                obscureText:
                                    !controller.isPasswordVisible.value,
                                textInputAction: TextInputAction.done,
                                autofillHints: const [AutofillHints.password],
                                validator: controller.validatePassword,
                                onFieldSubmitted: (_) => controller.login(),
                                decoration: _inputDecoration(
                                  hint: 'Enter your password',
                                  prefixIcon: Icons.lock_outline_rounded,
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
                            ),

                            const SizedBox(height: 12),

                            // Remember me + Forgot password
                            Row(
                              children: [
                                Obx(
                                  () => Checkbox(
                                    value: controller.rememberMe.value,
                                    onChanged: controller.toggleRememberMe,
                                    activeColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    side: const BorderSide(
                                      color: AppColors.border,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Remember me',
                                  style: AppTextStyles.body(
                                    size: 13,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: controller.forgotPassword,
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    'Forgot Password?',
                                    style: AppTextStyles.body(
                                      size: 13,
                                      weight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Login Button
                            Obx(
                              () => SizedBox(
                                height: 56,
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: controller.isLoading.value
                                      ? null
                                      : controller.login,
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
                                            strokeWidth: 2.5,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Login',
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

                            // Divider
                            // _buildDivider(),
                            // const SizedBox(height: 24),

                            // Google Login Button
                            // SizedBox(
                            //   height: 54,
                            //   width: double.infinity,
                            //   child: OutlinedButton(
                            //     onPressed: controller.googleLogin,
                            //     style: OutlinedButton.styleFrom(
                            //       backgroundColor: AppColors.white,
                            //       side: const BorderSide(
                            //         color: AppColors.border,
                            //       ),
                            //       shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(16),
                            //       ),
                            //     ),
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       children: [
                            //         const Icon(
                            //           Icons.g_mobiledata_rounded,
                            //           color: Colors.red,
                            //           size: 28,
                            //         ),
                            //         const SizedBox(width: 10),
                            //         Text(
                            //           'Continue with Google',
                            //           style: AppTextStyles.body(
                            //             size: 15,
                            //             weight: FontWeight.w700,
                            //             color: AppColors.textPrimary,
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            // const SizedBox(height: 32),

                            // Register link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    "Don't have an account? ",
                                    style: AppTextStyles.body(size: 14),
                                  ),
                                ),
                                TextButton(
                                  onPressed: controller.goToRegister,
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    'Sign Up',
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

                      // Footer
                      Center(
                        child: Text(
                          'By continuing, you agree to our Terms & Privacy Policy.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.body(
                            size: 11,
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

  // ─────────────────────────────────────────────
  // Logo
  // ─────────────────────────────────────────────

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
              'Flutter LMS',
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

  // ─────────────────────────────────────────────
  // Field Label
  // ─────────────────────────────────────────────

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

  // ─────────────────────────────────────────────
  // Input Decoration
  // ─────────────────────────────────────────────

  InputDecoration _inputDecoration({
    required String hint,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.body(size: 14, color: AppColors.textSecondary),
      prefixIcon: Icon(prefixIcon, size: 20, color: AppColors.textSecondary),
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

  // ─────────────────────────────────────────────
  // Divider
  // ─────────────────────────────────────────────

  // Widget _buildDivider() {
  //   return Row(
  //     children: [
  //       const Expanded(child: Divider(color: AppColors.border, thickness: 1)),
  //       Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 16),
  //         child: Text(
  //           'OR',
  //           style: AppTextStyles.body(
  //             size: 12,
  //             weight: FontWeight.w700,
  //             color: AppColors.textSecondary,
  //           ),
  //         ),
  //       ),
  //       const Expanded(child: Divider(color: AppColors.border, thickness: 1)),
  //     ],
  //   );
  // }
}
