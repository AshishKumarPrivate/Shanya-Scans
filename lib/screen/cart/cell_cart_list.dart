import 'package:flutter/material.dart';
import 'package:shanya_scans/screen/cart/widget/BottomSheetWithCartPatientList.dart';
import 'package:shanya_scans/ui_helper/responsive_helper.dart';

import '../../base_widgets/custom_rounded_container.dart';
import '../../ui_helper/app_colors.dart';
import '../../ui_helper/app_text_styles.dart';

class CellCartListItem extends StatefulWidget {
  const CellCartListItem({super.key});

  @override
  State<CellCartListItem> createState() => _CellCartListItemState();
}

class _CellCartListItemState extends State<CellCartListItem> {
  int selectedPatientCount = 0;
  String selectedPrice = "1299";

  @override
  Widget build(BuildContext context) {
    return CustomRoundedContainer(
      borderRadius: 10.0,
      borderColor: AppColors.txtLightGreyColor,
      borderWidth: 0.4,
      elevation: 0,
      margin: EdgeInsets.all(8),
      backgroundColor: Colors.white,
      // padding: EdgeInsets.all(10.0),
      // margin: EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Comprehensive Full Body Checkup Test with Vitamin D and B12',
                    style:AppTextStyles.heading1(context,
                        overrideStyle: TextStyle(
                          color: Colors.black,
                            fontSize: ResponsiveHelper.fontSize(
                                context, 12))),
                  ),
                ),
                Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "20% OFF",
                          style: AppTextStyles.bodyText1(
                            context,
                            overrideStyle: TextStyle(
                                color: AppColors.pinkColor,
                                fontSize: ResponsiveHelper.fontSize(context, 12)),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "\u20B91499}",
                          // style: AppTextStyles.heading2.copyWith(
                          //   fontSize: 12,
                          //   color: Colors.grey,
                          //   decoration: TextDecoration.lineThrough,
                          // ),
                          style: AppTextStyles.bodyText1(
                            context,
                            overrideStyle: TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                              fontSize: ResponsiveHelper.fontSize(context, 12,),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "\u20B9${selectedPrice}",
                      style:AppTextStyles.heading1(context,
                          overrideStyle: TextStyle(
                            color: AppColors.primary,
                              fontSize: ResponsiveHelper.fontSize(
                                  context, 16))),
                    ),
                  ],
                ),
                SizedBox(
                  // width: 200,
                  height: 30,
                  child: CustomRoundedContainer(
                    onTap: () async {
                      // Show the dialog and wait for the selected item
                      showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        isScrollControlled: true,
                        builder: (context) => BottomSheetWithList(
                            selectedIndex: selectedPatientCount,
                            onSelected: (int selected, price) {
                              setState(() {
                                selectedPatientCount =
                                    selected + 1; // Update count
                                selectedPrice = price; // Update count
                              });
                            }),
                      );
                    },
                    borderRadius: 5,
                    borderColor: AppColors.txtLightGreyColor,
                    borderWidth: 0.4,
                    elevation: 0,
                    backgroundColor: Colors.white,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          selectedPatientCount != 0
                              ? '$selectedPatientCount'
                              : '1',
                          style:AppTextStyles.bodyText1(context,
                              overrideStyle: TextStyle(
                                color: Colors.black,
                                  fontSize: ResponsiveHelper.fontSize(
                                      context, 12))),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Patient",
                          style: AppTextStyles.bodyText1(context,
                              overrideStyle: TextStyle(
                                color: Colors.black,
                                  fontSize: ResponsiveHelper.fontSize(
                                      context, 12))),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(Icons.keyboard_arrow_down,
                            size: 18, color: Colors.black),
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(
              color: AppColors.txtLightGreyColor.withValues(alpha: 0.2),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.timer, size: 18, color: Colors.grey),
                    SizedBox(width: 5),
                    Text(
                      "Fasting required 4-5 hours",
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 18, color: Colors.grey),
                    SizedBox(width: 5),
                    Text(
                      "Reports within 24 hrs",
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
