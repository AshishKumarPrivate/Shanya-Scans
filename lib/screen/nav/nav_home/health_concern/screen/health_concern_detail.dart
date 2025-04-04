import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:healthians/base_widgets/InstructionCard.dart';
import 'package:healthians/base_widgets/common/health_concern_detail_page_shimmer.dart';
import 'package:healthians/base_widgets/common/why_choose_use_section.dart';
import 'package:healthians/base_widgets/custom_rounded_container.dart';
import 'package:healthians/screen/nav/nav_home/health_concern/controller/health_concern_provider.dart';
import 'package:healthians/ui_helper/app_colors.dart';
import 'package:healthians/ui_helper/app_text_styles.dart';
import 'package:healthians/ui_helper/responsive_helper.dart';
import 'package:html/parser.dart'; // Import required package
import 'package:provider/provider.dart';

import '../../../../../base_widgets/common/common_app_bar.dart';
import '../../../../../base_widgets/expandable_text_widget.dart';
import '../../../../../util/phone_call_open.dart';
import '../../../../checkout/CheckoutScreen.dart';
import '../../../../checkout/controller/checkout_api_provider.dart';
import '../../../../order/model/OrderItem.dart';

class ViewDetailHealthConcernScreen extends StatefulWidget {
  final String packageName, packageSlug;

  ViewDetailHealthConcernScreen(
      {required this.packageName, required this.packageSlug});

  @override
  State<ViewDetailHealthConcernScreen> createState() =>
      _ViewDetailHealthConcernScreenState();
}

class _ViewDetailHealthConcernScreenState
    extends State<ViewDetailHealthConcernScreen> {
  bool isEnglish = true;

  @override
  void initState() {
    print("healthconcernslug =>${widget.packageSlug}");
    Future.microtask(() {
      // Clear old data and fetch new service details
      Provider.of<HealthConcernApiProvider>(context, listen: false)
          .getHealthConcernListDetail(context, widget.packageSlug);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("slugnameforlabtest ${widget.packageSlug}");
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        bottom: false,
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AppBar
                CommonAppBar(
                  aciviyName: widget.packageName,
                  backgroundColor: AppColors.primary,
                ),
                // Main Content
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                    child: SingleChildScrollView(
                      // padding: EdgeInsets.all(10.0),
                      child: Consumer<HealthConcernApiProvider>(
                        builder: (context, provider, child) {
                          if (provider.isLoading) {
                            return HealthConcernDetailShimmer();
                          } else if (provider.errorMessage.isNotEmpty) {
                            return Center(
                                child: Text(provider.errorMessage,
                                    style: TextStyle(color: Colors.red)));
                          }

                          final healthConcernModel =
                              provider.healthConcernDetailModel?.data!;
                          print(
                              "HealthDetail data ${healthConcernModel!.instructionHindi}");
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ResponsiveHelper.sizeBoxHeightSpace(context, 1.5),
                              Padding(
                                padding:
                                    ResponsiveHelper.padding(context, 4, 0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),

                                    // gradient: LinearGradient(
                                    //   colors: [Color(0xFF4FC3F7), Color(0xFF00838F)],
                                    //   begin: Alignment.topLeft,
                                    //   end: Alignment.bottomRight,
                                    // ),

                                    // gradient: LinearGradient(
                                    //   colors: [Color(0xFF2196F3), Color(0xFFBBDEFB)],
                                    //   begin: Alignment.topCenter,
                                    //   end: Alignment.bottomCenter,
                                    // ),

                                    // gradient: LinearGradient(
                                    //   colors: [Color(0xFF57C1EB), Color(0xFF246FA8)],
                                    //   begin: Alignment.topLeft,
                                    //   end: Alignment.bottomRight,
                                    // ),

                                    // gradient: LinearGradient(
                                    //   colors: [Color(0xFF1CD8D2), Color(0xFF93EDC7)],
                                    //   begin: Alignment.topCenter,
                                    //   end: Alignment.bottomCenter,
                                    // ),

                                    // gradient: LinearGradient(
                                    //   colors: [Color(0xFFFF512F), Color(0xFFDD2476)],
                                    //   begin: Alignment.topLeft,
                                    //   end: Alignment.bottomRight,
                                    // ),

                                    // gradient: LinearGradient(
                                    //   colors: [Color(0xFFFF9A9E), Color(0xFFFAD0C4)],
                                    //   begin: Alignment.topCenter,
                                    //   end: Alignment.bottomCenter,
                                    // ),
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF58a9c7),
                                        Color(0xFF58a9c7)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          // Ensure text doesn't overflow
                                          children: [
                                            Expanded(
                                              // Ensures text wraps properly
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${healthConcernModel.packageName}",
                                                    style:
                                                        AppTextStyles.heading1(
                                                      context,
                                                      overrideStyle: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            ResponsiveHelper
                                                                .fontSize(
                                                                    context,
                                                                    16),
                                                      ),
                                                    ),
                                                  ),
                                                  // Added spacing to prevent text overlap
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 5.0,
                                                            top: 2.0),
                                                    child: Text(
                                                      "Shanya Scans & Theranostics – Uttar Pradesh’s No. 1 Diagnostic Centre in Lucknow for Accurate & Reliable Testing!",
                                                      style: AppTextStyles
                                                          .heading1(
                                                        context,
                                                        overrideStyle:
                                                            TextStyle(
                                                          color: Colors.white
                                                              .withAlpha(500),
                                                          fontSize:
                                                              ResponsiveHelper
                                                                  .fontSize(
                                                                      context,
                                                                      10),
                                                        ),
                                                      ),
                                                      maxLines: 3,
                                                      // Prevents overflow
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      // Adds "..." if text is too long
                                                      softWrap:
                                                          true, // Ensures wrapping
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                // Text(
                                                //   "\u20B9${healthConcernModel.packageRate}/-",
                                                //   // "\u20B9${widget.pathalogyTestSlug}",
                                                //   style: AppTextStyles.heading1(
                                                //       context,
                                                //       overrideStyle: TextStyle(
                                                //           color: AppColors
                                                //               .whiteColor,
                                                //           fontSize:
                                                //               ResponsiveHelper
                                                //                   .fontSize(
                                                //                       context,
                                                //                       16))),
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
                                                                color: AppColors.whiteColor,
                                                                fontSize: ResponsiveHelper.fontSize(context, 16),
                                                              ),
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: "${healthConcernModel.packageRate}", // Price Amount
                                                            style: AppTextStyles.heading1(
                                                              context,
                                                              overrideStyle: TextStyle(
                                                                color: AppColors.whiteColor,
                                                                fontSize: ResponsiveHelper.fontSize(context, 16),
                                                              ),
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: " /-", // Smaller "/-" Sign
                                                            style: AppTextStyles.heading1(
                                                              context,
                                                              overrideStyle: TextStyle(
                                                                color: AppColors.whiteColor,
                                                                fontSize: ResponsiveHelper.fontSize(context, 12), // Smaller font size
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),








                                                InkWell(
                                                  onTap: () {
                                                    //  &&&&&&&&&&&&& go to the checkout page &&&&&&&&&&&&&&&&

                                                    /// Function to extract plain text from an HTML string
                                                    String extractPlainText(
                                                        String htmlString) {
                                                      var document =
                                                          parse(htmlString);
                                                      return document
                                                              .body?.text ??
                                                          "";
                                                    }

                                                    final extractedText =
                                                        extractPlainText(
                                                            healthConcernModel
                                                                .packageOverview
                                                                .toString());

                                                    OrderItem orderItem = OrderItem(
                                                        id: healthConcernModel.sId ??
                                                            "",
                                                        name: healthConcernModel
                                                            .packageName
                                                            .toString(),
                                                        orderType: "package",
                                                        category:healthConcernModel
                                                                .packageName
                                                                .toString(),
                                                        price: double.parse(
                                                            healthConcernModel
                                                                .packageRate
                                                                .toString()),
                                                        imageUrl: OrderItem
                                                            .defaultImage,
                                                        packageDetail:
                                                            extractedText,
                                                        quantity: 1);

                                                    // WidgetsBinding.instance
                                                    //     .addPostFrameCallback(
                                                    //         (_) {
                                                    //       Provider.of<
                                                    //           OrderApiProvider>(
                                                    //           context,
                                                    //           listen: false)
                                                    //           .addToOrderReview(
                                                    //           context, orderItem);
                                                    //     });

                                                    WidgetsBinding.instance
                                                        .addPostFrameCallback(
                                                            (_) {
                                                      Provider.of<CheckoutProvider>(
                                                              context,
                                                              listen: false)
                                                          .addToCheckout(
                                                              context,
                                                              orderItem);
                                                    });

                                                    // Provider.of<OrderApiProvider>(context, listen: false).notiFylistener();

                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            CheckoutScreen(),
                                                      ),
                                                    );

                                                    // Navigator.push(
                                                    //   context,
                                                    //   MaterialPageRoute(
                                                    //     builder: (context) =>
                                                    //         CheckoutScreen(
                                                    //           categoryName:
                                                    //           widget.packageName,
                                                    //           name:healthConcernModel
                                                    //               .packageName,
                                                    //           price:
                                                    //           healthConcernModel
                                                    //               .packageRate,
                                                    //         ),
                                                    //   ),
                                                    // );

                                                    //  &&&&&&&&&&&&& go to the checkout page &&&&&&&&&&&&&&&&
                                                  },
                                                  child: CustomRoundedContainer(
                                                    borderRadius: 5,
                                                    borderColor: Colors.white,
                                                    borderWidth: 1,
                                                    elevation: 2,
                                                    backgroundColor:
                                                        AppColors.whiteColor,
                                                    child: Padding(
                                                      padding: ResponsiveHelper
                                                          .padding(
                                                              context, 3, 0.2),
                                                      child: Text(
                                                        "Book Now",
                                                        // "\u20B9${widget.pathalogyTestSlug}",
                                                        style: AppTextStyles.heading2(
                                                            context,
                                                            overrideStyle: TextStyle(
                                                                fontSize: ResponsiveHelper
                                                                    .fontSize(
                                                                        context,
                                                                        12))),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ExpandableTextWidget(
                                      text: healthConcernModel.packageOverview
                                          .toString(),
                                      // text:  "Pathology tests are essential diagnostic tools that analyze blood, urine, tissues, and other body fluids to detect diseases, monitor health conditions, and assess overall well-being. These tests help in identifying infections, organ function abnormalities, nutritional deficiencies, and chronic diseases like diabetes and thyroid disorders.",
                                    ),
                                  ],
                                ),
                              ),

                              // &&&&&&&&&&&&&&&&&&&&&& Required Parameter  section &&&&&&&&&&&&&&&
                              ResponsiveHelper.sizeBoxHeightSpace(context, 0.5),
                              Padding(
                                padding:
                                    ResponsiveHelper.padding(context, 0, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Wrap(
                                      spacing: 1, // Horizontal spacing
                                      runSpacing:
                                          10, // Vertical spacing when items wrap
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2 -
                                              20,
                                          child: CustomRoundedContainer(
                                            borderRadius: 10.0,
                                            borderColor: Colors.black,
                                            borderWidth: 0.1,
                                            elevation: 3.0,
                                            backgroundColor: Colors.white,
                                            padding: EdgeInsets.all(10.0),
                                            child: Row(
                                              // crossAxisAlignment: CrossAxisAlignment.center,
                                              // mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "assets/images/img_pathalogytestparamter.png",
                                                  width: ResponsiveHelper
                                                      .containerWidth(
                                                          context, 6),
                                                  height: ResponsiveHelper
                                                      .containerWidth(
                                                          context, 6),
                                                ),
                                                ResponsiveHelper
                                                    .sizeboxWidthlSpace(
                                                        context, 2),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Parameter Included",
                                                      style: AppTextStyles.bodyText1(
                                                          context,
                                                          overrideStyle: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize:
                                                                  ResponsiveHelper
                                                                      .fontSize(
                                                                          context,
                                                                          10))),
                                                    ),
                                                    Text(
                                                      healthConcernModel
                                                          .parameterInclude
                                                          .toString(),
                                                      // "On Type",
                                                      style: AppTextStyles.heading1(
                                                          context,
                                                          overrideStyle: TextStyle(
                                                              color: AppColors
                                                                  .primary,
                                                              fontSize:
                                                                  ResponsiveHelper
                                                                      .fontSize(
                                                                          context,
                                                                          12))),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                            onTap: () {
                                              print("Container tapped!");
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2 -
                                              20,
                                          child: CustomRoundedContainer(
                                            borderRadius: 10.0,
                                            borderColor: Colors.black,
                                            borderWidth: 0.1,
                                            elevation: 3.0,
                                            backgroundColor: Colors.white,
                                            padding: EdgeInsets.all(10.0),
                                            child: Row(
                                              // crossAxisAlignment: CrossAxisAlignment.center,
                                              // mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "assets/images/img_pathalogytestparamter.png",
                                                  width: ResponsiveHelper
                                                      .containerWidth(
                                                          context, 6),
                                                  height: ResponsiveHelper
                                                      .containerWidth(
                                                          context, 6),
                                                ),
                                                ResponsiveHelper
                                                    .sizeboxWidthlSpace(
                                                        context, 2),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Wrap(children: [
                                                      Text(
                                                        "Home Collection",
                                                        style: AppTextStyles.bodyText1(
                                                            context,
                                                            overrideStyle: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                fontSize: ResponsiveHelper
                                                                    .fontSize(
                                                                        context,
                                                                        10))),
                                                      ),
                                                    ]),
                                                    Text(
                                                      "Required",
                                                      style: AppTextStyles.heading1(
                                                          context,
                                                          overrideStyle: TextStyle(
                                                              color: AppColors
                                                                  .primary,
                                                              fontSize:
                                                                  ResponsiveHelper
                                                                      .fontSize(
                                                                          context,
                                                                          12))),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                            onTap: () {
                                              print("Container tapped!");
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              ResponsiveHelper.sizeBoxHeightSpace(context, 2.5),
                              Padding(
                                padding:
                                    ResponsiveHelper.padding(context, 0, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Wrap(
                                      spacing: 1, // Horizontal spacing
                                      runSpacing:
                                          10, // Vertical spacing when items wrap
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2 -
                                              20,
                                          child: CustomRoundedContainer(
                                            borderRadius: 10.0,
                                            borderColor: Colors.black,
                                            borderWidth: 0.1,
                                            elevation: 3.0,
                                            backgroundColor: Colors.white,
                                            padding: EdgeInsets.all(10.0),
                                            child: Row(
                                              // crossAxisAlignment: CrossAxisAlignment.center,
                                              // mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "assets/images/img_pathalogytestparamter.png",
                                                  width: ResponsiveHelper
                                                      .containerWidth(
                                                          context, 6),
                                                  height: ResponsiveHelper
                                                      .containerWidth(
                                                          context, 6),
                                                ),
                                                ResponsiveHelper
                                                    .sizeboxWidthlSpace(
                                                        context, 2),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Consultation",
                                                      style: AppTextStyles.bodyText1(
                                                          context,
                                                          overrideStyle: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize:
                                                                  ResponsiveHelper
                                                                      .fontSize(
                                                                          context,
                                                                          10))),
                                                    ),
                                                    Text(
                                                      "Available",
                                                      style: AppTextStyles.heading1(
                                                          context,
                                                          overrideStyle: TextStyle(
                                                              color: AppColors
                                                                  .primary,
                                                              fontSize:
                                                                  ResponsiveHelper
                                                                      .fontSize(
                                                                          context,
                                                                          12))),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                            onTap: () {
                                              print("Container tapped!");
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2 -
                                              20,
                                          child: CustomRoundedContainer(
                                            borderRadius: 10.0,
                                            borderColor: Colors.black,
                                            borderWidth: 0.1,
                                            elevation: 3.0,
                                            backgroundColor: Colors.white,
                                            padding: EdgeInsets.all(10.0),
                                            child: Row(
                                              // crossAxisAlignment: CrossAxisAlignment.center,
                                              // mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "assets/images/img_pathalogytestparamter.png",
                                                  width: ResponsiveHelper
                                                      .containerWidth(
                                                          context, 6),
                                                  height: ResponsiveHelper
                                                      .containerWidth(
                                                          context, 6),
                                                ),
                                                ResponsiveHelper
                                                    .sizeboxWidthlSpace(
                                                        context, 2),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Wrap(children: [
                                                      Text(
                                                        "Test booked so far",
                                                        style: AppTextStyles.bodyText1(
                                                            context,
                                                            overrideStyle: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                fontSize: ResponsiveHelper
                                                                    .fontSize(
                                                                        context,
                                                                        10))),
                                                      ),
                                                    ]),
                                                    Text(
                                                      "5820+",
                                                      style: AppTextStyles.heading1(
                                                          context,
                                                          overrideStyle: TextStyle(
                                                              color: AppColors
                                                                  .primary,
                                                              fontSize:
                                                                  ResponsiveHelper
                                                                      .fontSize(
                                                                          context,
                                                                          12))),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                            onTap: () {
                                              print("Container tapped!");
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              ResponsiveHelper.sizeBoxHeightSpace(context, 1.5),
                              // &&&&&&&&&&&&&&&&&&&&&& Required Parameter  section &&&&&&&&&&&&&&&

                              // &&&&&&&&&&&&&&&&&&&&&& Parametes section  &&&&&&&&&&&&&&&
                              Padding(
                                padding:
                                    ResponsiveHelper.padding(context, 3, 0),
                                // child: _buildExpandableTestSections(HealthConernData: healthConcernModel,),
                                child: _buildExpandableTestSections(
                                  sid: healthConcernModel.sId.toString(),
                                  serviceName: widget.packageName,
                                  packageName:
                                      healthConcernModel.packageName.toString(),
                                  packageOverView: healthConcernModel
                                      .packageOverview
                                      .toString(),
                                  packageRate:
                                      healthConcernModel.packageRate.toString(),
                                  serviceCategory: healthConcernModel
                                      .packageCategory
                                      .toString(),
                                ),
                              ),

                              // &&&&&&&&&&&&&&&&&&&&&& Parametes section  &&&&&&&&&&&&&&&

                              ResponsiveHelper.sizeBoxHeightSpace(context, 1),

                              _buildParameterTestSections(
                                parameters:healthConcernModel.packageParamterDetails.toString(),
                              ),
                              ResponsiveHelper.sizeBoxHeightSpace(context, 1),

                              // ***************** Why Choose Use  start  ******************
                              ResponsiveHelper.sizeBoxHeightSpace(context, 1),
                              WhyChooseSection(
                                items: [
                                  WhyChooseItem(
                                    icon: Icons.supervised_user_circle,
                                    title: "Center of Excellence",
                                    onTap: () => print("Center of Excellence tapped!"),
                                  ),
                                  WhyChooseItem(
                                    icon: Icons.currency_rupee,
                                    title: "Affordable Pricing of Each Scan",
                                    onTap: () => print("Affordable Pricing tapped!"),
                                  ),
                                  WhyChooseItem(
                                    icon: Icons.security_outlined,
                                    title: "ISO and NABH Certified Scan Centers",
                                    onTap: () => print("ISO Certified tapped!"),
                                  ),
                                  WhyChooseItem(
                                    icon: Icons.check_circle,
                                    title: "100% Reliable and Accurate Reports",
                                    onTap: () => print("Reliable Reports tapped!"),
                                  ),
                                ],
                              ),
                              // ***************** Why Choose Use  end ******************

                              // ***************** instruction tabs  start ******************
                              InstructionCard(
                                // isEnglish: isEnglish,
                                instructionEnglish: healthConcernModel
                                    .instructionEnglish
                                    .toString(),
                                instructionHindi: healthConcernModel
                                    .instructionHindi
                                    .toString(),
                              ),
                              // ***************** instruction tabs  end ******************
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _buildExpandableTestSections extends StatelessWidget {
  String serviceName,
      serviceCategory,
      sid,
      packageOverView,
      packageName,
      packageRate;

  // _buildExpandableTestSections({required this.serviceData});

  _buildExpandableTestSections({
    required this.serviceName,
    required this.serviceCategory,
    required this.sid,
    required this.packageOverView,
    required this.packageName,
    required this.packageRate,
  });

  @override
  Widget build(BuildContext context) {
    final testCategories = [
      {'title': '*Serum Electrolytes profile(03)', 'count': 12},
      {'title': '*Iron Studies(03', 'count': 11},
      {'title': '*LIVER Function Test(11', 'count': 21},
      {'title': '*Thyroid Profile(03', 'count': 24},
      {'title': '*Kidney Profile(07)', 'count': 1},
      {'title': '*CBC(28)', 'count': 1},
    ];

    return Container(
      color: Color(0xffF3F4F6),
      alignment: Alignment.topCenter, // Ensures it wraps content
      child: Stack(
        children: [
          Positioned.fill(
            // Ensures image covers full width & height of Stack
            child: Image.asset(
              "assets/images/pattern7.png",
              fit: BoxFit.cover, // Covers full Stack width and height
            ),
          ),
          Padding(
            padding: ResponsiveHelper.padding(context, 2.5, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Wraps content height
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsiveHelper.sizeBoxHeightSpace(context, 2),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: CustomRoundedContainer(
                            borderRadius: 10.0,
                            borderColor: Colors.white,
                            borderWidth: 0.0,
                            elevation: 5.0,
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.watch_later, color: Colors.red),
                                SizedBox(height: 3),
                                Text(
                                  "Report Time",
                                  style: AppTextStyles.heading1(
                                    context,
                                    overrideStyle: TextStyle(
                                      color: AppColors.txtLightGreyColor,
                                      fontSize: ResponsiveHelper.fontSize(
                                          context, 10),
                                    ),
                                  ),
                                ),
                                Text(
                                  "24-hr to 4 days",
                                  style: AppTextStyles.heading1(
                                    context,
                                    overrideStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: ResponsiveHelper.fontSize(
                                          context, 12),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            onTap: () {
                              print("Container tapped!");
                            },
                          ),
                        ),
                        ResponsiveHelper.sizeboxWidthlSpace(context, 5),
                        Expanded(
                          child: CustomRoundedContainer(
                            borderRadius: 10.0,
                            borderColor: Colors.white,
                            borderWidth: 0.0,
                            elevation: 5.0,
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/test.png",
                                  width: 24,
                                  height: 24,
                                  color: Colors.blue,
                                ),
                                SizedBox(height: 3),
                                Text(
                                  "Fasting",
                                  style: AppTextStyles.heading1(
                                    context,
                                    overrideStyle: TextStyle(
                                      color: AppColors.txtLightGreyColor,
                                      fontSize: ResponsiveHelper.fontSize(
                                          context, 10),
                                    ),
                                  ),
                                ),
                                Text(
                                  "Consult your doctor",
                                  style: AppTextStyles.heading1(
                                    context,
                                    overrideStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: ResponsiveHelper.fontSize(
                                          context, 12),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            onTap: () {
                              print("Container tapped!");
                            },
                          ),
                        ),
                      ],
                    ),
                    ResponsiveHelper.sizeBoxHeightSpace(context, 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: CustomRoundedContainer(
                            borderRadius: 10.0,
                            borderColor: Colors.white,
                            borderWidth: 0.0,
                            elevation: 5.0,
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.supervised_user_circle,
                                    color: Colors.green),
                                SizedBox(height: 3),
                                SizedBox(height: 3),
                                Text(
                                  "Recommended for",
                                  style: AppTextStyles.heading1(
                                    context,
                                    overrideStyle: TextStyle(
                                      color: AppColors.txtLightGreyColor,
                                      fontSize: ResponsiveHelper.fontSize(
                                          context, 10),
                                    ),
                                  ),
                                ),
                                Text(
                                  "Male, Female",
                                  style: AppTextStyles.heading1(
                                    context,
                                    overrideStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: ResponsiveHelper.fontSize(
                                          context, 12),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            onTap: () {
                              print("Container tapped!");
                            },
                          ),
                        ),
                        ResponsiveHelper.sizeboxWidthlSpace(context, 5),
                        Expanded(
                          child: CustomRoundedContainer(
                            borderRadius: 10.0,
                            borderColor: Colors.white,
                            borderWidth: 0.0,
                            elevation: 5.0,
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.calendar_month,
                                    color: AppColors.primary),
                                SizedBox(height: 3),
                                Text(
                                  "Age",
                                  style: AppTextStyles.heading1(
                                    context,
                                    overrideStyle: TextStyle(
                                      color: AppColors.txtLightGreyColor,
                                      fontSize: ResponsiveHelper.fontSize(
                                          context, 10),
                                    ),
                                  ),
                                ),
                                Text(
                                  "All Ages",
                                  style: AppTextStyles.heading1(
                                    context,
                                    overrideStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: ResponsiveHelper.fontSize(
                                          context, 12),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            onTap: () {
                              print("Container tapped!");
                            },
                          ),
                        ),
                      ],
                    ),
                    ResponsiveHelper.sizeBoxHeightSpace(context, 2),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            child: CustomRoundedContainer(
                              borderRadius: 20,
                              borderColor: Colors.white,
                              borderWidth: 0,
                              elevation: 2,
                              backgroundColor: Colors.white,
                              child: Padding(
                                padding:
                                    ResponsiveHelper.padding(context, 5, 1.05),
                                child: InkWell(
                                  onTap: () {
                                    makePhoneCall(context);
                                  },
                                  child: Text(
                                    "Call Us",
                                    style: AppTextStyles.heading2(
                                      context,
                                      overrideStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: ResponsiveHelper.fontSize(
                                            context, 12),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          ResponsiveHelper.sizeboxWidthlSpace(context, 5),
                          InkWell(
                            onTap: () {
                              //  &&&&&&&&&&&&& go to the checkout page &&&&&&&&&&&&&&&&

                              /// Function to extract plain text from an HTML string
                              String extractPlainText(String htmlString) {
                                var document = parse(htmlString);
                                return document.body?.text ?? "";
                              }

                              final extractedText =
                                  extractPlainText(packageOverView.toString());

                              OrderItem orderItem = OrderItem(
                                  id: sid ?? "",
                                  name: packageName.toString(),
                                  category: packageName,
                                  orderType: "package",
                                  price: double.parse(packageRate.toString()),
                                  imageUrl: OrderItem.defaultImage,
                                  packageDetail: extractedText,
                                  quantity: 1);

                              // WidgetsBinding.instance.addPostFrameCallback((_) {
                              //   Provider.of<OrderApiProvider>(context,
                              //       listen: false)
                              //       .addToOrderReview(context, orderItem);
                              // });

                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                Provider.of<CheckoutProvider>(context,
                                        listen: false)
                                    .addToCheckout(context, orderItem);
                              });

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CheckoutScreen(),
                                ),
                              );

                              // Provider.of<OrderApiProvider>(context, listen: false).notiFylistener();

                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) =>
                              //         CheckoutScreen(
                              //           categoryName: serviceName,
                              //           name: packageName,
                              //           price: packageRate,
                              //         ),
                              //   ),
                              // );

                              //  &&&&&&&&&&&&& go to the checkout page &&&&&&&&&&&&&&&&
                            },
                            child: CustomRoundedContainer(
                              borderRadius: 20,
                              borderColor: Colors.white,
                              borderWidth: 0,
                              elevation: 2,
                              backgroundColor: Colors.red,
                              child: Padding(
                                padding:
                                    ResponsiveHelper.padding(context, 4, 1),
                                child: Text(
                                  "Book Now",
                                  style: AppTextStyles.heading2(
                                    context,
                                    overrideStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: ResponsiveHelper.fontSize(
                                          context, 12),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ResponsiveHelper.sizeBoxHeightSpace(context, 2),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

extension on ExtensionContext {
  get tree => null;
}

class _buildParameterTestSections extends StatelessWidget {
  String parameters;

  _buildParameterTestSections({required this.parameters});

  @override
  Widget build(BuildContext context) {
    final testCategories = [
      {'title': '*Serum Electrolytes profile(03)', 'count': 12},
      {'title': '*Iron Studies(03', 'count': 11},
      {'title': '*LIVER Function Test(11', 'count': 21},
      {'title': '*Thyroid Profile(03', 'count': 24},
      {'title': '*Kidney Profile(07)', 'count': 1},
      {'title': '*CBC(28)', 'count': 1},
    ];

    List<String> paramtersString = parameters
        .replaceAll(RegExp(r'<[^>]*>'), '') // Remove HTML tags
        .split(',')
        .map((e) => e.trim()) // Trim extra spaces
        .where((e) => e.isNotEmpty) // Remove empty values
        .toList();

    return Container(
      color: Colors.white,
      child: Padding(
        padding: ResponsiveHelper.padding(context, 4, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ResponsiveHelper.sizeBoxHeightSpace(context, 1),
            Text(
              "Parameters",
              style: AppTextStyles.heading1(context,
                  overrideStyle: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(context, 14))),
            ),
            ResponsiveHelper.sizeBoxHeightSpace(context, 1.5),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: paramtersString.length,
              itemBuilder: (context, index) {
                final category = paramtersString[index];
                return Card(
                  color: AppColors.primary,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 0.0,
                    vertical: 8.0,
                  ),
                  shape: RoundedRectangleBorder(
                    // side: BorderSide(
                    //     color: AppColors.txtLightGreyColor, width: 0.2),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 2,
                  // Elevation for shadow effect
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 10),
                        child: Text(
                          '${category} ',
                          // '${category['title']} (${category['count']})',
                          style: AppTextStyles.heading1(context,
                              overrideStyle: TextStyle(
                                  fontSize:
                                      ResponsiveHelper.fontSize(context, 12))),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
