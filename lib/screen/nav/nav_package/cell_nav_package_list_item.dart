import 'package:flutter/material.dart';
import 'package:shanya_scans/screen/packages/model/PackageListByTabIdModel.dart';
import 'package:shanya_scans/ui_helper/responsive_helper.dart';
import 'package:shanya_scans/base_widgets/solid_rounded_button.dart';

import '../../../ui_helper/app_colors.dart';
import '../../../ui_helper/app_text_styles.dart';
import 'nav_package_detail.dart';

class CellNavPackageListItem extends StatelessWidget {
  final Data item;
  final double borderRadius;
  final double elevation;
  final Color backgroundColor;
  final Color borderColor; // New for stroke color
  final double borderWidth; // New for stroke width
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final GestureTapCallback? onTap;

  const CellNavPackageListItem({
    Key? key,
    required this.item,
    required this.borderRadius,
    required this.elevation,
    required this.backgroundColor,
    required this.borderColor,
    required this.borderWidth,
    this.padding,
    this.margin,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(
          color: borderColor,
          width: borderWidth,
        ), // Add stroke with rounded corners
      ),
      margin: margin,
      color: backgroundColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        // Matches the card radius
        splashColor: AppColors.primary.withOpacity(0.2),
        // Ripple color
        highlightColor: AppColors.primary.withOpacity(0.1),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Column(

                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(
                     item.packageName.toString(),
                     style: AppTextStyles.heading1(context,
                         overrideStyle: TextStyle(
                             fontSize: ResponsiveHelper.fontSize(context, 14))),
                   ),
                   SizedBox(height: 5),
                   Text(
                     "${item.parameterInclude.toString()} test included",
                     style: AppTextStyles.bodyText1(
                       context,
                       overrideStyle: AppTextStyles.bodyText1(context,
                           overrideStyle: TextStyle(
                               fontSize: ResponsiveHelper.fontSize(context, 12))),
                     ),
                   ),
                   SizedBox(height: 10),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Row(
                             children: [
                               Text(
                                 "\u20B9${item.packageDiscount}",
                                 //   style: AppTextStyles.heading2.copyWith(
                                 //   fontSize: 12,
                                 //   color: Colors.grey,
                                 //   decoration: TextDecoration.lineThrough,
                                 // ),
                                 style: AppTextStyles.heading1(context,
                                     overrideStyle: TextStyle(
                                         color: Colors.grey,
                                         decoration: TextDecoration.lineThrough,
                                         fontSize: ResponsiveHelper.fontSize(
                                             context, 12))),
                               ),

                               SizedBox(width: 8),

                               // Text(
                               //   "\u20B9${item.packageRate}",
                               //   style: AppTextStyles.heading1(context,
                               //       overrideStyle: TextStyle(
                               //           color: AppColors.primary,
                               //           fontSize: ResponsiveHelper.fontSize(
                               //               context, 14))),
                               // ),

                               Row(
                                 children: [
                                   /// Rupee Symbol and Amount with spacing
                                   RichText(
                                     text: TextSpan(
                                       children: [
                                         TextSpan(
                                           text: "\u20B9 ", // Rupee Symbol with space
                                           style: AppTextStyles.heading1(
                                             context,
                                             overrideStyle: TextStyle(
                                               color: AppColors.primary,
                                               fontSize: ResponsiveHelper.fontSize(context, 14),
                                             ),
                                           ),
                                         ),
                                         TextSpan(
                                           text: item.packageRate.toString(), // Price Amount
                                           style: AppTextStyles.heading1(
                                             context,
                                             overrideStyle: TextStyle(
                                               color: AppColors.primary,
                                               fontSize: ResponsiveHelper.fontSize(context, 14),
                                             ),
                                           ),
                                         ),
                                         TextSpan(
                                           text: " /-", // Smaller "/-" Sign
                                           style: AppTextStyles.heading1(
                                             context,
                                             overrideStyle: TextStyle(
                                               color: AppColors.primary,
                                               fontSize: ResponsiveHelper.fontSize(context, 11), // Smaller font size
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                 ],
                               )







                             ],
                           ),
                           // Text(
                           //   item['discount'],
                           //   style: AppTextStyles.heading1(context,
                           //       overrideStyle: TextStyle(
                           //         color: AppColors.pinkColor,
                           //           fontSize: ResponsiveHelper.fontSize(
                           //               context, 12))),
                           // ),
                         ],
                       ),
                       SizedBox(
                         width: 100,
                         height: 30,
                         child: SolidRoundedButton(
                           text: 'Buy Now',
                           color: AppColors.primary,
                           borderRadius: 10.0,
                           onPressed: () {
                             print('Button clicked: ${item.slug}');
                             Navigator.push(
                               context,
                               MaterialPageRoute(
                                 builder: (context) =>
                                     ViewDetailBottomNavPackageScreen(
                                       packagetName: item.packageName.toString(),
                                       packageSlug: item.slug.toString(),
                                     ),
                               ),
                             );
                           },
                           textStyle: TextStyle(color: Colors.white, fontSize: 14),
                         ),
                       ),
                     ],
                   ),
                   SizedBox(height: 10),
                 ],
               ),
             ),
              // Divider(
              //   color: AppColors.txtLightGreyColor.withValues(alpha: 0.2),
              // ),
              // fasting required ror
              Container(
                padding: ResponsiveHelper.padding(context, 3, 1), // Add padding for spacing
                decoration: BoxDecoration(
                  color: AppColors.lightBlueColor,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.watch_later_outlined, size: 18, color: Colors.black),
                        SizedBox(width: 5),
                        Text(
                          "Fasting Required",
                          style: AppTextStyles.heading2(
                            context,
                            overrideStyle: TextStyle(
                              fontSize: ResponsiveHelper.fontSize(context, 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 18, color: Colors.black),
                        SizedBox(width: 5),
                        Text(
                          "Report within 24 hours",
                          style: AppTextStyles.heading2(
                            context,
                            overrideStyle: TextStyle(
                              fontSize: ResponsiveHelper.fontSize(context, 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
