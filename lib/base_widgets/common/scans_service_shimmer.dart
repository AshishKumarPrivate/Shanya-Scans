import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../ui_helper/app_colors.dart';
import '../../ui_helper/responsive_helper.dart';

class ScansServiceShimmer extends StatelessWidget {
  final int itemCount;

  ScansServiceShimmer({this.itemCount = 10}); // Default: 6 items

  @override
  Widget build(BuildContext context) {
    final double radius = ResponsiveHelper.containerWidth(context, 13);
    final double circleRadius = radius;
    final double screenWidth = MediaQuery.of(context).size.width;

    // Responsive column calculation using ResponsiveText helper
    int columns;
    if (ResponsiveHelper.isDesktop(context)) {
      columns = 3; // Desktop: 6 columns
    } else if (ResponsiveHelper.isTablet(context)) {
      columns = 2; // Tablet: 4 columns
      if (screenWidth > 1300 && screenWidth < 1880) {
        columns = 2; // Tablet: 4 columns
      }
      // columns = screenWidth >1300 && screenWidth <1880  ? 3 : ResponsiveText.isDesktop(context) ?  2  : 6        ;
    } else {
      // Mobile: further adjust based on screen width
      columns = screenWidth > 300 && screenWidth < 600
          ? 3
          : ResponsiveHelper.isDesktop(context)
              ? 2
              : 6;
    }

    // Responsive childAspectRatio adjustment
    double childAspectRatio = ResponsiveHelper.isMobile(context) ? 0.92 : 1.1;

    return SizedBox(
      height: ResponsiveHelper.containerHeight(context, 40),
      width: ResponsiveHelper.containerHeight(context, 100),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[200]!,
        highlightColor: Colors.grey[100]!,
        child: GridView.builder(
          scrollDirection: Axis.vertical,
          gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 columns
            crossAxisSpacing: 8.0, // Space between columns
            mainAxisSpacing:
            0.0, // Removed spacing between rows
          ),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 25),
                  child: Container(
                    width: screenWidth * 0.5,
                    height: screenWidth * 0.18,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white, width: 0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
