import 'package:flutter/material.dart';
import 'package:shanya_scans/ui_helper/responsive_helper.dart';

class OutlinedRoundedButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final double heightPercentage;
  final double widthPercentage;
  final VoidCallback onPressed;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry padding;
  final Icon? icon;

  const OutlinedRoundedButton({
    Key? key,
    this.text = '',
    this.color = Colors.transparent, // Transparent fill
    this.borderColor = Colors.blue, // Default border color
    this.borderWidth = 2.0, // Default border width
    this.borderRadius = 30.0,
    this.heightPercentage = 5.0,
    this.widthPercentage = 100.0,
    required this.onPressed,
    this.textStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final double responsiveHeight = (heightPercentage / 100) * screenHeight;
    final double responsiveWidth = (widthPercentage / 100) * screenWidth;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: borderColor, // Icon & text color
        side: BorderSide(color: borderColor, width: borderWidth), // Border style
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: padding,
        minimumSize: Size(responsiveWidth, responsiveHeight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) icon!,
          if (text.isNotEmpty) ...[
            SizedBox(width: icon != null ? 8.0 : 0),
            Text(
              text,
              style: textStyle?.copyWith(
                fontSize: ResponsiveHelper.fontSize(context, 12),
                color: borderColor, // Match text color with border
              ) ??
                  TextStyle(
                    fontSize: ResponsiveHelper.fontSize(context, 12),
                    color: borderColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ]
        ],
      ),
    );
  }
}
