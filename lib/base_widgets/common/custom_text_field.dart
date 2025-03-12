import 'package:flutter/material.dart';
import '../../ui_helper/app_colors.dart';
import '../../ui_helper/app_text_styles.dart';
import '../../ui_helper/responsive_helper.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final IconData icon;
  final String hintText;
  final String title;
  final String errorMessage;
  final TextInputType keyboardType;
  final double? elevation;
  final double? borderWidth;
  final Color? borderColor;
  final bool enableShadow; // New optional parameter

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.icon,
    required this.hintText,
    required this.title,
    required this.errorMessage,
    this.keyboardType = TextInputType.text,
    this.elevation,
    this.borderWidth,
    this.borderColor,
    this.enableShadow = true, // Default value set to true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormField<String>(
          validator: (value) {
            if (controller.text.isEmpty) {
              return errorMessage;
            }
            return null;
          },
          builder: (FormFieldState<String> fieldState) {
            bool isFocused = focusNode.hasFocus;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: ResponsiveHelper.padding(context, 2, 0.52),
                  child: Text(
                    title,
                    style: AppTextStyles.bodyText1(
                      context,
                      overrideStyle: TextStyle(
                        color: Colors.black,
                        fontSize: ResponsiveHelper.fontSize(context, 14),
                      ),
                    ),
                  ),
                ),
                Material(
                  elevation: elevation ?? 0,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: enableShadow
                          ? [
                        BoxShadow(
                          color: isFocused
                              ? AppColors.primary.withAlpha(70)
                              : Colors.black12,
                          blurRadius: isFocused ? 0 : 0,
                          offset: const Offset(0, 3),
                        ),
                      ]
                          : [], // No shadow if enableShadow is false
                      border: Border.all(
                        color: isFocused
                            ? (borderColor ?? AppColors.primary)
                            : Colors.transparent,
                        width: borderWidth ?? 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: ResponsiveHelper.padding(context, 2, 0.02),
                          child: Icon(
                            icon,
                            size: ResponsiveHelper.fontSize(context, 20),
                            color: isFocused
                                ? AppColors.primary
                                : AppColors.txtLightGreyColor,
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: controller,
                            focusNode: focusNode,
                            keyboardType: keyboardType,
                            decoration: InputDecoration(
                              hintText: hintText,
                              border: InputBorder.none,
                              contentPadding:
                              ResponsiveHelper.padding(context, 0, 0.2),
                            ),
                            style: TextStyle(
                                fontSize:
                                ResponsiveHelper.fontSize(context, 14)),
                            onChanged: (value) {
                              fieldState.didChange(value); // Trigger validation
                            },
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
