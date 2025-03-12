import 'package:flutter/material.dart';

class CustomRoundedTextField extends StatefulWidget {
  final double borderRadius;
  final bool enableBorder;
  final Color borderColor;
  final double borderWidth;
  final double elevation;
  final Color backgroundColor;
  final TextEditingController? controller;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool obscureText;
  final int? maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;

  const CustomRoundedTextField({
    Key? key,
    this.borderRadius = 8.0,
    this.enableBorder = false,
    this.borderColor = Colors.grey,
    this.borderWidth = 1.0,
    this.elevation = 0.0,
    this.backgroundColor = Colors.white,
    this.controller,
    this.hintText,
    this.hintStyle,
    this.textStyle,
    this.padding,
    this.margin,
    this.obscureText = false,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType,
    this.onChanged,
    this.onTap,
  }) : super(key: key);

  @override
  _CustomRoundedTextFieldState createState() => _CustomRoundedTextFieldState();
}

class _CustomRoundedTextFieldState extends State<CustomRoundedTextField> {
  bool _hasFocus = false;

  void _handleFocusChange(bool hasFocus) {
    setState(() {
      _hasFocus = hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: [
          if (widget.elevation > 0)
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: widget.elevation,
              offset: Offset(0, widget.elevation / 2),
            ),
        ],
        border: widget.enableBorder || _hasFocus
            ? Border.all(
          color: widget.borderColor,
          width: widget.borderWidth,
        )
            : null,
      ),
      child: Padding(
        padding: widget.padding ?? const EdgeInsets.all(8.0),
        child: Focus(
          onFocusChange: _handleFocusChange,
          child: TextField(
            controller: widget.controller,
            obscureText: widget.obscureText,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            keyboardType: widget.keyboardType,
            onChanged: widget.onChanged,
            onTap: widget.onTap,
            style: widget.textStyle,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: widget.hintStyle,
              border: InputBorder.none,
              counterText: "", // Hides the max length counter
            ),
          ),
        ),
      ),
    );
  }
}
