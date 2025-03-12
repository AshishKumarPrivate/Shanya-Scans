import 'package:flutter/material.dart';
import 'package:healthians/ui_helper/responsive_helper.dart';
import '../../../ui_helper/app_colors.dart';
import '../../../ui_helper/app_text_styles.dart';

class HomeCheckupsVitalSection extends StatelessWidget {
  final List<Map<String, String>> items = [
    {'image': 'assets/images/organs/heart.png', 'title': 'Heart'},
    {'image': 'assets/images/organs/joint.png', 'title': 'Bone'},
    {'image': 'assets/images/organs/thyroid.png', 'title': 'Thyroid'},
    {'image': 'assets/images/organs/lungs.png', 'title': 'Lungs'},
    {'image': 'assets/images/organs/fullbody.png', 'title': 'Full Body'},
    {'image': 'assets/images/organs/kidney.png', 'title': 'Kidney'},
    {'image': 'assets/images/organs/liver.png', 'title': 'Liver'},
    {'image': 'assets/images/organs/jointpain.png', 'title': 'Joint Pain'},
  ];

  @override
  Widget build(BuildContext context) {
    // Number of columns in the grid
    const int columns = 4;
    // Aspect ratio of each grid item
    const double childAspectRatio = 0.8;

    // Calculate the height of each grid item
    double gridItemWidth = MediaQuery
        .of(context)
        .size
        .width / columns;
    double gridItemHeight = gridItemWidth / childAspectRatio;

    // Calculate the total number of rows needed
    int rows = (items.length / columns).ceil();

    // Calculate the total height of the grid
    double gridHeight = rows * gridItemHeight;

    return Container(
      color: AppColors.whiteColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0),
                child: Text(
                  "Checkups based on Organs",
                  style: AppTextStyles.heading1(context,
                      overrideStyle: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(context, 14))),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                color: Colors.white,
                height: gridHeight, // Dynamically set height
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns, // 4 columns
                    crossAxisSpacing: 0.0, // Space between items horizontally
                    mainAxisSpacing: 1.0, // Space between items vertically
                    childAspectRatio: childAspectRatio, // Aspect ratio
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Container(
                      // color: AppColors.pinkColor.withOpacity(0.05),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          // colors: [
                          //   AppColors.pinkColor.withOpacity(0.5),
                          //   AppColors.lightBrown_color
                          // ],

                          colors: [Color(0xFFF1FBFC), Color(0xFFF9F7F4)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),

                      margin: const EdgeInsets.all(3.0),
                      child: Column(
                        children: [
                          Expanded(
                            // Ensures the image doesn't exceed boundaries
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Shadow effect
                                Container(
                                  width: ResponsiveHelper.containerWidth(
                                      context, 12),
                                  // Adjust size slightly bigger than the image
                                  height: ResponsiveHelper.containerWidth(
                                      context, 12),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.whiteColor,
                                        // White shadow effect
                                        blurRadius: 10,
                                        spreadRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                                // Elliptical image
                                ClipRRect(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(150)),
                                  child: Image.asset(
                                    width: ResponsiveHelper.containerWidth(
                                        context, 10),
                                    height: ResponsiveHelper.containerWidth(
                                        context, 10),
                                    item['image']!,
                                    fit: BoxFit.contain, // Scale image to fit
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Text(
                              item['title']!,
                              style: AppTextStyles.bodyText1(context,
                                  overrideStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: ResponsiveHelper.fontSize(
                                          context, 12))),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
