import 'package:flutter/material.dart';

import '../../ui_helper/app_text_styles.dart';
import '../../ui_helper/responsive_helper.dart';

class CheckoutTextField extends StatelessWidget {
  final String label;
  final String hint;
  final int? maxLength;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isRequired;

  const CheckoutTextField({
    Key? key,
    required this.label,
    required this.hint,
    this.maxLength,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isRequired = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyText1(
              context,
              overrideStyle: TextStyle(
                color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveHelper.fontSize(context, 12)),
            ),
          ),
          const SizedBox(height: 5),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLength: maxLength,
            style: AppTextStyles.bodyText1(
              context,
              overrideStyle: TextStyle(
                color: Colors.black,
                  fontSize: ResponsiveHelper.fontSize(context, 13)),
            ),
            validator: isRequired
                ? (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "$label is required";
                    }
                    return null;
                  }
                : null,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              counterText: "",
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
