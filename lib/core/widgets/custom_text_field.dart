import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lms/app/theme/app_colors.dart';
import 'package:lms/app/theme/app_text_styles.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final String? labelText;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final TextEditingController? textFieldController;
  final FocusNode? focusNode;

  final bool isObscure;
  final bool showBorder;
  final bool isNumberInput;
  final bool enabled;
  final bool readOnly;

  final Color? borderColor;
  final Color? fillColor;

  final TextInputType? keyboardType;
  final TextInputAction textInputAction;

  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final VoidCallback? onTap;

  final int? maxLines;
  final int? maxLength;

  final Iterable<String>? autofillHints;

  const CustomTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.textFieldController,
    this.focusNode,
    this.isObscure = false,
    this.showBorder = true,
    this.isNumberInput = false,
    this.enabled = true,
    this.readOnly = false,
    this.borderColor,
    this.fillColor,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.maxLines = 1,
    this.maxLength, this.autofillHints,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textFieldController,
      focusNode: focusNode,
      obscureText: isObscure,
      enabled: enabled,
      readOnly: readOnly,
      autofillHints: autofillHints,

      keyboardType: isNumberInput
          ? TextInputType.number
          : keyboardType ?? TextInputType.text,

      textInputAction: textInputAction,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      onTap: onTap,

      maxLines: isObscure ? 1 : maxLines,
      maxLength: maxLength,

      inputFormatters: isNumberInput
          ? [FilteringTextInputFormatter.digitsOnly]
          : null,

      style: AppTextStyles.body(
        size: 14,
        color: AppColors.textPrimary,
      ),

      decoration: CustomInputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        borderColor: borderColor,
        fillColor: fillColor,
        showBorder: showBorder,
      ),
    );
  }
}

// Separate Input Decoration Widget in Same File

class CustomInputDecoration extends InputDecoration {
  CustomInputDecoration({
    super.hintText,
    super.labelText,
    super.prefixIcon,
    super.suffixIcon,
    Color? borderColor,
    Color? fillColor,
    bool showBorder = true,
  }) : super(
          hintStyle: AppTextStyles.body(
            size: 14,
            color: AppColors.textSecondary,
          ),
          filled: true,
          fillColor: fillColor ?? AppColors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          border: showBorder
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: borderColor ?? AppColors.border,
                  ),
                )
              : InputBorder.none,
          enabledBorder: showBorder
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: borderColor ?? AppColors.border,
                  ),
                )
              : InputBorder.none,
          focusedBorder: showBorder
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                )
              : InputBorder.none,
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: AppColors.error,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: AppColors.error,
              width: 1.5,
            ),
          ),
        );
}





// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:lms/app/theme/app_colors.dart';
// import 'package:lms/app/theme/app_text_styles.dart';

// class CustomTextField extends StatelessWidget {
//     final String? hintText;
//   final Widget? suffixIcon;
//   final VoidCallback? onSuffixTap;
//   final bool? isObscure;
//   final TextEditingController? textFieldController;
//   final bool showBorder;
//   final bool isNumberInput;
//   final Color? borderColor;
//   final Widget? prefixIcon;
//   const CustomTextField({super.key, this.hintText, this.suffixIcon, this.onSuffixTap, this.isObscure, this.textFieldController, required this.showBorder, required this.isNumberInput, this.borderColor, this.prefixIcon});

//    @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//                                 controller: textFieldController,
//                                 obscureText:isObscure ?? false,
//                                 textInputAction: TextInputAction.done,
//                                 autofillHints: const [AutofillHints.password],
//                                 validator: cont,
//                                 onFieldSubmitted: (_) => controller.login(),
//                                 decoration: _inputDecoration(
//                                   hint: hintText,
//                                   prefixIcon: Icons.lock_outline_rounded,
//                                   suffixIcon: IconButton(
//                                     onPressed:
//                                         controller.togglePasswordVisibility,
//                                     icon: Icon(
//                                       controller.isPasswordVisible.value
//                                           ? Icons.visibility_off_outlined
//                                           : Icons.visibility_outlined,
//                                       color: AppColors.textSecondary,
//                                       size: 20,
//                                     ),
//                                   ),
//                                 ),
//                               );
//   }




//   InputDecoration _inputDecoration({
//     required String hint,
//     required IconData prefixIcon,
//     Widget? suffixIcon,
//   }) {
//     return InputDecoration(
//       hintText: hint,
//       hintStyle: AppTextStyles.body(size: 14, color: AppColors.textSecondary),
//       prefixIcon: Icon(prefixIcon, size: 20, color: AppColors.textSecondary),
//       suffixIcon: suffixIcon,
//       filled: true,
//       fillColor: AppColors.white,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(16),
//         borderSide: const BorderSide(color: AppColors.border),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(16),
//         borderSide: const BorderSide(color: AppColors.border),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(16),
//         borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(16),
//         borderSide: const BorderSide(color: AppColors.error),
//       ),
//       focusedErrorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(16),
//         borderSide: const BorderSide(color: AppColors.error, width: 1.5),
//       ),
//     );
//   }
// }