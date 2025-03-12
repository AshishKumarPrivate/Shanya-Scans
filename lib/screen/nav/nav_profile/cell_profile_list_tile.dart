import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healthians/ui_helper/app_colors.dart';

class ProfileListTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final IconData? leadingIcon;
  final String? leadingAssetImage;
  final Color? leadingIconColor;
  final double borderRadius;
  final Color backgroundColor;
  final TextStyle? titleStyle;
  final double iconSize;
  final double assetImageSize;

  const ProfileListTile({
    Key? key,
    required this.title,
    required this.onTap,
    this.leadingIcon,
    this.leadingAssetImage,
    this.leadingIconColor,
    this.borderRadius = 5.0,
    this.backgroundColor = const Color(0xFFF8F8FB),
    this.titleStyle,
    this.iconSize = 24.0,
    this.assetImageSize = 24.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      ),
      child: ListTile(
        leading: leadingAssetImage != null
            ? SvgPicture.asset(
          leadingAssetImage!,
          width: assetImageSize,
          height: assetImageSize,
          colorFilter: ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
        )
            : (leadingIcon != null
            ? Icon(
          leadingIcon,
          color: leadingIconColor ?? Colors.black,
          size: iconSize,
        )
            : null),
        title: Text(
          title,
          style: titleStyle ??
              const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        onTap: onTap,
      ),
    );
  }
}
