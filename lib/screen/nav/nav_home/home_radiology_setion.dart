import 'package:flutter/material.dart';
import 'package:healthians/ui_helper/responsive_helper.dart';

import '../../../ui_helper/app_text_styles.dart';

class HomeRadiologySection extends StatelessWidget {
  final List<Map<String, String>> items = [
    {
      'image': 'assets/images/digitalpetct.png',
      'title': 'PET CT Scan',
      'color': '0xFFFFE8E2',
      'lightColor': '0xFFF1FBFC'
    },
    {
      'image': 'assets/images/digitalgamma.png',
      'title': 'Digital Gamma',
      'color': '0xFFFFF4C0',
      'lightColor': '0xFFF9F7F4'
    },
    // {
    //   'image': 'assets/images/radiology/mri.jpg',
    //   'title': 'Tesla MRI',
    //   'color': '0xFFFFC4EA',
    //   'lightColor': '0xFFFFE9F5'
    // },
    {
      'image': 'assets/images/ct_scan.png',
      'title': '128 Slice CT Scan',
      'color': '0xFFC0FFD5',
      'lightColor': '0xFFEBFFF8'
    },
    {
      'image': 'assets/images/mammography.png',
      'title': 'Mammography',
      'color': '0xFFD1F9FB',
      'lightColor': '0xFFF1FBFC'
    },
    {
      'image': 'assets/images/theranostics.png',
      'title': 'Theranostics',
      'color': '0xFFF1FBFC',
      'lightColor': '0xFFF9E9FF'
    },
    {
      'image': 'assets/images/ultrasound_service.png',
      'title': 'ULTRASOUND',
      'color': '0xFFFFE9F5',
      'lightColor': '0xFFEBFFF8'
    },
    {
      'image': 'assets/images/cardioimaging.png',
      'title': 'Cardio Imaging',
      'color': '0xFFFBD2FD',
      'lightColor': '0xFFF9F7F4'
    },
    {
      'image': 'assets/images/neuro.png',
      'title': 'Neuro Imaging',
      'color': '0xffE8EFD3',
      'lightColor': '0xFFF9E9FF'
    },
    {
      'image': 'assets/images/xray_service.png',
      'title': 'X-RAY',
      'color': '0xFFFFE8E2',
      'lightColor': '0xFFF1FBFC'
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Define the new item height
    final double itemWidth = ResponsiveHelper.containerWidth(context, 30);
    final double itemHeight = ResponsiveHelper.containerWidth(context, 30);
    final double totalHeight = itemHeight;

    return Container(
      // color: Colors.black,
      decoration: BoxDecoration(
        // color: Colors.white,
        gradient: const LinearGradient(
          // color: AppColors.pinkColor,
          colors: [Color(0xFFFFE8E2), Color(0xFFF9F7F4)],
          // Lighter shades
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          stops: [0.4, 0.7],
          tileMode: TileMode.repeated,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 2.0),
            child: Text(
              "Radiology Test",
              style: AppTextStyles.heading1(context,
                  overrideStyle: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(context, 14))),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            // color: Colors.white,
            height: totalHeight * 1.08, // Adjusted height
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final itemColor = Color(
                      int.parse(item['color']!)); // Parse the color string
                  final lightColor = Color(
                      int.parse(item['lightColor']!)); // Parse the color string

                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 15 : 5.0,
                      right: index == items.length - 1 ? 15 : 5.0,
                    ),
                    child: Center(
                      child: Container(
                        width: itemWidth,
                        height: itemHeight, // Increased item height
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 5,
                              offset: Offset(0, 3), // Subtle shadow
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Image Section
                            Visibility(
                              visible: true,
                              child: Flexible(
                                flex: 2, // Increased image section height
                                child: Container(
                                  width: ResponsiveHelper.containerWidth(context, 12),
                                  height: ResponsiveHelper.containerWidth(context, 12),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(item['image']!),
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(
                                        50,
                                      ),
                                      topRight: Radius.circular(
                                        50,
                                      ),
                                      bottomLeft: Radius.circular(
                                        50,
                                      ),
                                      bottomRight: Radius.circular(
                                        50,
                                      ),
                                    ),
                                    color: itemColor,
                                  ),
                                ),
                              ),
                            ),
                            // Title Section
                            SizedBox(
                              height: 10,
                            ),
                            Flexible(
                              flex: 1,
                              child: Center(
                                child: Text(
                                  item['title']!,
                                  style: AppTextStyles.bodyText1(context,
                                      overrideStyle: TextStyle(
                                          color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                          fontSize: ResponsiveHelper.fontSize(
                                              context, 10))),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(
            height: 20,
          )
          // SizedBox(height: 15),
        ],
      ),
    );
  }
}
