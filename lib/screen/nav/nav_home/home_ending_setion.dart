import 'package:flutter/material.dart';
import 'package:shanya_scans/base_widgets/custom_rounded_container.dart';
import '../../../ui_helper/responsive_helper.dart';
import '../../../ui_helper/app_colors.dart';
import '../../../ui_helper/app_text_styles.dart';

class HomeEndingSection extends StatelessWidget {
  late String? sectionHeading;

  HomeEndingSection({
    Key? key,
    this.sectionHeading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double circleRadius = 60.0;
    final screenWidth = MediaQuery.of(context).size.width;
    // Dynamic column count based on screen width
    int columns = screenWidth > 900
        ? 6 // Large Tablets & Desktop
        : screenWidth > 600
            ? 4 // Tablets
            : 3; // Mobile (Default)
    return Container(
      // color: AppColors.lightBlueColor,
      child: Container(
        width: double.infinity,
        color: AppColors.endingGreyColor,
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0,left: 10,right: 10.0,bottom: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Visibility(
                visible: true,
                child: SizedBox(
                  width: ResponsiveHelper.containerWidth(context, 15),
                  height: ResponsiveHelper.containerWidth(context, 15),
                  child: Image.asset("assets/images/badge.png"),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Trusted by 1 Lakh+ customers",
                style: AppTextStyles.heading1(context,
                    overrideStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.txtLightGreyColor,
                      fontSize: ResponsiveHelper.fontSize(context, 12),
                    )),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                "5000+ Certified lab Tests",
                style: AppTextStyles.bodyText1(context,
                    overrideStyle: TextStyle(
                      color: AppColors.txtGreyColor,
                      fontSize: ResponsiveHelper.fontSize(context, 12),
                    )),
              ),
              Divider(
                height: 50,
                thickness: 0.5,
              ),
              Visibility(
                visible: true,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Container(
                          // color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0),
                                child: CustomRoundedContainer(
                                  // onTap: () => openWhatsApp(),
                                  borderRadius: 5,
                                  borderColor: AppColors.whiteColor,
                                  borderWidth: 0,
                                  elevation: 0,
                                  backgroundColor: Colors.transparent,
                                  child: SizedBox(
                                    width: ResponsiveHelper.containerWidth(context, 10),
                                    height: ResponsiveHelper.containerWidth( context, 10),
                                    child: Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Image.asset(
                                        "assets/images/qci_image.png",
                                        fit: BoxFit.cover,
                                        // width: 50,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              ResponsiveHelper.sizeBoxHeightSpace(context, 1),
                              Center(
                                child: Text(
                                  textAlign: TextAlign.center,
                                  "QCI Certified",
                                  style: AppTextStyles.heading1(context,
                                      overrideStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: ResponsiveHelper.fontSize(
                                            context, 8),
                                      )),
                                ),
                              ),
                              const SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          // color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0),
                                child: CustomRoundedContainer(
                                  // onTap: () => openWhatsApp(),
                                  borderRadius: 5,
                                  borderColor: AppColors.whiteColor,
                                  borderWidth: 0,
                                  elevation: 0,
                                  backgroundColor: Colors.transparent,
                                  child: SizedBox(
                                    width: ResponsiveHelper.containerWidth(context, 10),
                                    height: ResponsiveHelper.containerWidth( context, 10),
                                    child: Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Image.asset(
                                        "assets/images/nabhlogo.png",
                                        fit: BoxFit.cover,
                                        // width: 50,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              ResponsiveHelper.sizeBoxHeightSpace(context, 1),
                              Center(
                                child: Text(
                                  textAlign: TextAlign.center,
                                  "NABH Certified",
                                  style: AppTextStyles.heading1(context,
                                      overrideStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: ResponsiveHelper.fontSize(
                                            context, 8),
                                      )),
                                ),
                              ),
                              const SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          // color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0),
                                child: CustomRoundedContainer(
                                  // onTap: () => openWhatsApp(),
                                  borderRadius: 5,
                                  borderColor: AppColors.whiteColor,
                                  borderWidth: 0,
                                  elevation: 0,
                                  backgroundColor: Colors.transparent,
                                  child: SizedBox(
                                    width: ResponsiveHelper.containerWidth(context, 10),
                                    height: ResponsiveHelper.containerWidth( context, 10),
                                    child: Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Image.asset(
                                        "assets/images/janarogya.png",
                                        fit: BoxFit.cover,
                                        // width: 50,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              ResponsiveHelper.sizeBoxHeightSpace(context, 1),
                              Center(
                                child: Text(
                                  textAlign: TextAlign.center,
                                  "PM-JAY",
                                  style: AppTextStyles.heading1(context,
                                      overrideStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: ResponsiveHelper.fontSize(
                                            context, 8),
                                      )),
                                ),
                              ),
                              const SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          // color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0),
                                child: CustomRoundedContainer(
                                  // onTap: () => openWhatsApp(),
                                  borderRadius: 5,
                                  borderColor: AppColors.whiteColor,
                                  borderWidth: 0,
                                  elevation: 0,
                                  backgroundColor: Colors.transparent,
                                  child: SizedBox(
                                    width: ResponsiveHelper.containerWidth(context, 10),
                                    height: ResponsiveHelper.containerWidth( context, 10),
                                    child: Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Image.asset(
                                        "assets/images/emergency.png",
                                        fit: BoxFit.cover,
                                        // width: 50,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              ResponsiveHelper.sizeBoxHeightSpace(context, 1),
                              Center(
                                child: Text(
                                  textAlign: TextAlign.center,
                                  "Service Available",
                                  style: AppTextStyles.heading1(context,
                                      overrideStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: ResponsiveHelper.fontSize(
                                            context, 8),
                                      )),
                                ),
                              ),
                              const SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ),
                    ]),
              ),
              // const SizedBox(height: 15),
              Visibility(visible: true, child: buildEndingInformation()),
              // const SizedBox(height: 15),
              // const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class buildEndingInformation extends StatelessWidget {
  // String type;

  // buildEndingInformation();

  @override
  Widget build(BuildContext context) {
    final testCategories = [
      {
        'title': 'Government approved diagnostic centre',
      },
      {
        'title': 'Regular disinfection of labs',
      },
      {
        'title': 'Daily temperature check of all technicians',
      }
    ];

    return Container(
      height: 150, // Set fixed height for the container
      // color: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "100% Safe & Trusted Labs",
              style: AppTextStyles.heading2(context,
                  overrideStyle: TextStyle(
                    color: Colors.black,
                    fontSize: ResponsiveHelper.fontSize(context, 10),
                  )),
            ),
            SizedBox(height: 10),
            Expanded(
              // Makes the ListView scrollable within the fixed height
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: testCategories.length,
                  itemBuilder: (context, index) {
                    final category = testCategories[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              '\u2022', // Unicode for bullet point
                              style: TextStyle(
                                fontSize: 30,
                                height: 0.4,
                                // Align bullet vertically with text
                                color: Colors.grey, // Bullet color
                              ),
                            ),
                          ),
                          SizedBox(width: 8), // Space between bullet and text
                          Expanded(
                            child: Text(
                              "${category['title']!}",
                              // "${category['title']!}",

                              // style: AppTextStyles.bodyText1.copyWith(
                              //     fontSize: 12,
                              //     color: Colors.black,
                              //     letterSpacing: 1),
                              style: AppTextStyles.bodyText1(
                                context,
                                overrideStyle: AppTextStyles.bodyText1(context,
                                    overrideStyle: TextStyle(
                                        color: Colors.black,
                                        letterSpacing: 1,
                                        fontSize: ResponsiveHelper.fontSize(
                                            context, 10))),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
