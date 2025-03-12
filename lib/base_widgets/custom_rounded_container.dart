import 'package:flutter/material.dart';

class CustomRoundedContainer extends StatelessWidget {
  final double borderRadius;
  final Color borderColor;
  final double borderWidth;
  final double elevation;
  final Color backgroundColor;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final GestureTapCallback? onTap;

  const CustomRoundedContainer({
    Key? key,
    required this.borderRadius,
    required this.borderColor,
    required this.borderWidth,
    required this.elevation,
    required this.backgroundColor,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            if (elevation > 0)
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: elevation,
                offset: Offset(0, elevation / 2),
              ),
          ],
          border: Border.all(
            color: borderColor,
            width: borderWidth,
          ),
        ),
        child: Padding(
          padding: padding ?? EdgeInsets.all(.0),
          child: child,
        ),
      ),
    );
  }
}
