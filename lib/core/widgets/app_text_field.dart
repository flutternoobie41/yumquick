import 'package:flutter/material.dart';
import 'package:yum_quick/app/theme/app_colors.dart';
import 'package:yum_quick/app/theme/app_dimens.dart';
import 'package:yum_quick/app/theme/app_text_styles.dart';

/// Labelled input in the design's style: label above, Yellow 2 fill,
/// rounded corners, and a show/hide toggle for passwords.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.hintText,
    this.validator,
    this.obscureText = false,
    this.enabled = true,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.onFieldSubmitted,
  });

  final String label;
  final TextEditingController? controller;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final bool enabled;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscured = widget.obscureText;

  static const _radius = BorderRadius.all(Radius.circular(AppRadius.field));
  static const _inputStyle = TextStyle(
    fontFamily: AppTextStyles.fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.text2,
  );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: textTheme.titleMedium),
        const SizedBox(height: 10),
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          obscureText: _obscured,
          enabled: widget.enabled,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          autofillHints: widget.autofillHints,
          onFieldSubmitted: widget.onFieldSubmitted,
          style: _inputStyle,
          cursorColor: AppColors.orangeBase,
          decoration: InputDecoration(
            hintText: widget.hintText,
            // "Font" at 50% opacity, so hints read lighter than input.
            hintStyle: _inputStyle.copyWith(color: const Color(0x80391713)),
            filled: true,
            fillColor: AppColors.yellow2,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: const OutlineInputBorder(
              borderRadius: _radius,
              borderSide: BorderSide.none,
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: _radius,
              borderSide: BorderSide(color: AppColors.orangeBase, width: 1.5),
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: _radius,
              borderSide: BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderRadius: _radius,
              borderSide: BorderSide(color: AppColors.error, width: 1.5),
            ),
            suffixIcon: widget.obscureText
                ? IconButton(
                    tooltip: _obscured ? 'Show password' : 'Hide password',
                    onPressed: () => setState(() => _obscured = !_obscured),
                    icon: Icon(
                      _obscured
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.orangeBase,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}