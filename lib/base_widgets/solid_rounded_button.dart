import 'package:flutter/material.dart';
import 'package:shanya_scans/ui_helper/responsive_helper.dart';

class SolidRoundedButton extends StatelessWidget {
  final String text;
  final Color color;
  final double borderRadius;
  final double heightPercentage;
  final double widthPercentage;
  final VoidCallback onPressed;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry padding;
  final Icon? icon;

  const SolidRoundedButton({
    Key? key,
    this.text = '',
    this.color = Colors.blue,
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

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
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
              ) ??
                  TextStyle(
                    fontSize: ResponsiveHelper.fontSize(context, 12),
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ]
        ],
      ),
    );
  }
}
