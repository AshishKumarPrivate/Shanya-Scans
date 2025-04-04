import 'package:flutter/material.dart';
import 'package:healthians/ui_helper/app_colors.dart';

Widget loadingIndicator ({Color? color}) {
  return Center(child: SizedBox(width: 30,height: 30,  child: CircularProgressIndicator(color: color??AppColors.primary,)));
}