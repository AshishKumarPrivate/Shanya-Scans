import 'package:flutter/material.dart';
import '../../ui_helper/app_colors.dart';
import '../../ui_helper/app_text_styles.dart';
import '../../ui_helper/responsive_helper.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final IconData icon;
  final Color? iconColor;
  final int? maxLength;
  final String hintText;
  final String title;
  final String errorMessage;
  final TextInputType keyboardType;
  final double? elevation;
  final double? borderWidth;
  final Color? borderColor;
  final Color? shadowColor;
  final bool enableShadow; // New optional parameter
  final bool isPassword;
  final FormFieldValidator<String>? validator;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.icon,
    this.iconColor,
    this.maxLength,
    required this.hintText,
    required this.title,
    required this.errorMessage,
    this.keyboardType = TextInputType.text,
    this.elevation,
    this.borderWidth,
    this.borderColor,
    this.shadowColor,
    this.enableShadow = true, // Default value set to true
    this.isPassword = false,
    this.validator,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {

  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormField<String>(
          validator: (value) {
            if (widget.validator != null) {
              return widget.validator!(widget.controller.text);
            }
            if (widget.controller.text.isEmpty) {
              return widget.errorMessage;
            }
            return null;
          },
          builder: (FormFieldState<String> fieldState) {
            bool isFocused = widget.focusNode.hasFocus;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: ResponsiveHelper.padding(context, 2, 0.52),
                  child: Text(
                    widget.title,
                    style: AppTextStyles.heading2(
                      context,
                      overrideStyle: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(context, 14),
                      ),
                    ),
                  ),
                ),
                Material(
                  elevation: widget.elevation ?? 0,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: widget.enableShadow
                          ? [
                        BoxShadow(
                          color: isFocused
                              ? widget.shadowColor ?? AppColors.primary.withAlpha(70)

                              : Colors.black12,
                          blurRadius: isFocused ? 0 : 0,
                          offset: const Offset(0, 3),
                        ),
                      ]
                          : [], // No shadow if enableShadow is false
                      border: Border.all(
                        color: isFocused
                            ? (widget.borderColor ?? AppColors.primary)
                            : Colors.transparent,
                        width: widget.borderWidth ?? 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: ResponsiveHelper.padding(context, 2, 0.02),
                          child: Center(
                            child: Icon(
                              widget.icon,
                              size: ResponsiveHelper.fontSize(context, 20),
                              color: isFocused
                                  ? (widget.iconColor ?? AppColors.primary)
                                  : AppColors.txtLightGreyColor,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: TextFormField(
                              controller: widget.controller,
                              focusNode: widget.focusNode,
                              keyboardType: widget.keyboardType,
                              maxLength: widget.maxLength,
                              obscureText: widget.isPassword ? _obscureText : false,
                              decoration: InputDecoration(
                                counterText: "",
                                hintText: widget.hintText,
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(vertical: 14), // better vertical padding
                                suffixIcon: widget.isPassword
                                    ? IconButton(
                                  icon: Icon(
                                    _obscureText ? Icons.visibility_off : Icons.visibility,
                                    color: AppColors.txtLightGreyColor,
                                  ),
                                  onPressed: _toggleVisibility,
                                )
                                    : null,
                              ),
                              style: TextStyle(
                                fontSize: ResponsiveHelper.fontSize(context, 14),
                              ),
                              onChanged: (value) {
                                fieldState.didChange(value);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                  ),
                ),
                if (fieldState.hasError)
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: Text(
                      fieldState.errorText!,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: ResponsiveHelper.fontSize(context, 12),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
