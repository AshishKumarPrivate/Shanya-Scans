import 'package:flutter/material.dart';
import 'package:healthians/ui_helper/app_colors.dart';
import 'package:healthians/ui_helper/app_text_styles.dart';

class DefaultCommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String activityName;
  final VoidCallback? onBack;
  final Color backgroundColor; // ✅ New Parameter Added

  const DefaultCommonAppBar({
    Key? key,
    required this.activityName,
    this.onBack,
    this.backgroundColor = const Color(0xFF58a9c7), // Default color white
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      title: Text(activityName,style: AppTextStyles.heading2(context,overrideStyle: new TextStyle(fontSize: 16,color: Colors.white)),),
      leading: IconButton(
        icon: Icon(Icons.arrow_back,color: Colors.white,),
        onPressed: onBack ?? () => Navigator.pop(context),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
