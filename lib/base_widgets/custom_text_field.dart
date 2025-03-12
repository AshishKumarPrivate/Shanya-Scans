import 'package:flutter/material.dart';
import '../ui_helper/app_text_styles.dart';
import '../ui_helper/responsive_helper.dart';
import '../util/dimensions.dart';

class CustomTransparentTextField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool isEnable;
  final int? maxLength;
  final int? maxLines;
  final bool multiLines;
  final bool enableBorder;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator; // Optional Validator

  const CustomTransparentTextField({
    Key? key,
    this.label,
    this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.isEnable = true,
    this.maxLength,
    this.maxLines,
    this.multiLines = false,
    this.enableBorder = false,
    this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0, top: 5),
            child: Text(
              label!,
              style: AppTextStyles.bodyText1(
                context,
                overrideStyle: TextStyle(
                  color: Colors.black,
                  fontSize:ResponsiveHelper.fontSize(context, Dimensions.fontSize10),
                ),
              ),
            ),
          ),
        Container(
          width: double.infinity,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            enabled: isEnable,
            onChanged: onChanged,
            maxLength: maxLength,
            maxLines: multiLines ? maxLines : 1,
            validator: validator,
            // Apply Validator if provided
            decoration: InputDecoration(
              hintText: hintText,
              counterText: "", // Hides the counter text
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: ResponsiveHelper.fontSize(context, Dimensions.fontSize12),
              ),
              filled: true,
              fillColor: Colors.transparent,
              contentPadding:  EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              isDense: true,
              border: enableBorder
                  ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(0),
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 0,
                ),
              )
                  : InputBorder.none,
              // No border if enableBorder is false
              enabledBorder: enableBorder
                  ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(0),
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 0,
                ),
              )
                  : InputBorder.none,
              // No border if enableBorder is false
              focusedBorder: enableBorder
                  ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(0),
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 0,
                ),
              )
                  : InputBorder.none,
              // No border if enableBorder is false
              disabledBorder: InputBorder.none, // Removes border when disabled
            ),
            style: AppTextStyles.bodyText1(
              context,
              overrideStyle: TextStyle(
                color: Colors.black,
                fontSize:
                    ResponsiveHelper.fontSize(context, Dimensions.fontSize14),
              ),
            ),
            textAlign: TextAlign.left,
            scrollPhysics: BouncingScrollPhysics(),
            scrollPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}
