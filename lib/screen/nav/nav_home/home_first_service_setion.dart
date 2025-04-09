import 'package:flutter/material.dart';
import 'package:shanya_scans/screen/other/book_a%20_test_now_screen.dart';
import 'package:shanya_scans/ui_helper/responsive_helper.dart';
import '../../../ui_helper/app_text_styles.dart';

class HomeFirstServiceSection extends StatelessWidget {
  final String phoneNumber = "9161066154";

  final List<Map<String, String>> servicesList = [
    {
      'image': "assets/images/labtest.png",
      'title': "Lab Test",
      'color': "0xFFCCEBEC",
      'textColor': "0xFF00B3B0"
    },
    {
      'image': "assets/images/scan.png",
      'title': "Scans",
      'color': "0xFFFFE8E2",
      'textColor': "0xffFD6E87"
    },
    {
      'image': "assets/images/packageicon.png",
      'title': "Packages",
      'color': "0xffE8EFD3",
      'textColor': "0xFF84BE52"
    },
    {
      'image': "assets/images/booktest.png",
      'title': "Book a Test",
      'color': "0xFFFFE9F5",
      'textColor': "0xFFF44791"
    },
  ];

  // final Function() onNavigateToLabTest; // Callback for navigation
  //
  // HomeFirstServiceSection({required this.onNavigateToLabTest});

  final Function(int) onTabChange; // Callback function for navigation

  HomeFirstServiceSection({required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: servicesList.map((service) {
          return Expanded(
            child: InkWell(
              onTap: (){
                if (service['title'] == "Lab Test") {
                  onTabChange(1); // Navigate to Labs tab
                } else if (service['title'] == "Scans") {
                  onTabChange(2); // Navigate to Scans tab
                } else if (service['title'] == "Packages") {
                  onTabChange(3); // Navigate to Packages tab
                } else if (service['title'] == "Book a Test") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookATestNowScreen(
                          name: "Shanya: Book, Relax, Diagnose"),
                    ),
                  );
                }
              },
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Stack(
                      clipBehavior: Clip.none, // Allows the image to overflow
                      alignment: Alignment.center,
                      children: [
                        // Background Container
                        InkWell(
                          onTap: () {
                            if (service['title'] == "Lab Test") {
                              onTabChange(1); // Navigate to Labs tab
                            } else if (service['title'] == "Scans") {
                              onTabChange(2); // Navigate to Scans tab
                            } else if (service['title'] == "Packages") {
                              onTabChange(3); // Navigate to Packages tab
                            } else if (service['title'] == "Book a Test") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookATestNowScreen(
                                      name: "Shanya: Book, Relax, Diagnose"),
                                ),
                              );
                            }
                          },
                          splashColor: Colors.black.withOpacity(0.2),
                          // Ripple effect color
                          borderRadius: BorderRadius.circular(30),
                          // Matches the container shape
                          child: Material(
                            color: Colors.transparent,
                            elevation: 3,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                            child: Container(
                              // width: ResponsiveText.containerWidth(context, 400),
                              height:
                                  ResponsiveHelper.containerWidth(context, 13),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.8),
                                    blurRadius: 15,
                                    spreadRadius: 5,
                                  ),
                                ],
                                color: Color(int.parse(service['color']!)),
                                // color: Colors.amber[50], // Background color
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    service['title']!,
                                    style: AppTextStyles.heading2(context,
                                        overrideStyle: TextStyle(
                                          color: Color(
                                              int.parse(service['textColor']!)),
                                          // Convert hex string to Color
                                          // color: Colors.amber,
                                          fontSize: ResponsiveHelper.fontSize(
                                              context, 12),
                                        )),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Positioned Image at Bottom Center
                        Positioned(
                          bottom: -35,
                          // Moves the image downwards (adjust as needed)
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                // BoxShadow(
                                //   color: Colors.grey.withAlpha(0),
                                //   blurRadius: 0,
                                //   spreadRadius: 0,
                                //   offset: Offset(0,0), // Shadow position
                                // ),
                              ],
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                service['image']!,
                                width: ResponsiveHelper.iconSize(context, 66),
                                height: ResponsiveHelper.iconSize(context, 75),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // const SizedBox(height: 25),
                  // Text(
                  //   service['title']!,
                  //   style: AppTextStyles.heading2(context,
                  //       overrideStyle: TextStyle(
                  //         color: Colors.black,
                  //         fontSize: ResponsiveText.fontSize(context, 12),
                  //       )),
                  // ),

                  ResponsiveHelper.sizeBoxHeightSpace(context, 3),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
