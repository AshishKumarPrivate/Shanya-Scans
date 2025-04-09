import 'package:flutter/material.dart';
import 'package:shanya_scans/base_widgets/custom_rounded_container.dart';
import 'package:shanya_scans/screen/nav/nav_lab/controller/pathalogy_test_provider.dart';
import 'package:shanya_scans/ui_helper/app_colors.dart';
import 'package:shanya_scans/ui_helper/app_text_styles.dart';
import 'package:shanya_scans/ui_helper/responsive_helper.dart';
import 'package:html/parser.dart'; // Import required package
import 'package:provider/provider.dart';

import '../../../base_widgets/InstructionCard.dart';
import '../../../base_widgets/common/common_app_bar.dart';
import '../../../base_widgets/common/frequently_lab_test_detail_shimmer.dart';
import '../../../base_widgets/common/why_choose_use_section.dart';
import '../../../base_widgets/expandable_text_widget.dart';
import '../../../util/StringUtils.dart';
import '../../../util/phone_call_open.dart';
import '../../checkout/CheckoutScreen.dart';
import '../../checkout/controller/checkout_api_provider.dart';
import '../../order/model/OrderItem.dart';

class ViewDetailPathalogyTestScreen extends StatefulWidget {
  final String patahlogyTestName, pathalogyTestSlug;

  ViewDetailPathalogyTestScreen(
      {required this.patahlogyTestName, required this.pathalogyTestSlug});

  @override
  State<ViewDetailPathalogyTestScreen> createState() =>
      _ViewDetailPathalogyTestScreenState();
}

class _ViewDetailPathalogyTestScreenState
    extends State<ViewDetailPathalogyTestScreen> {
  bool isEnglish = false;
  @override
  void initState() {
    Future.microtask(() {
      // Clear old data and fetch new service details
      Provider.of<PathalogyTestApiProvider>(context, listen: false)
          .getPathalogyTestDetail(context, widget.pathalogyTestSlug);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("slugnameforlabtest ${widget.pathalogyTestSlug}");
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AppBar
                CommonAppBar(
                  aciviyName: "Pathology Test",
                  backgroundColor: AppColors.primary,
                ),
                // Main Content
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                    child: SingleChildScrollView(
                      // padding: EdgeInsets.all(10.0),
                      child: Consumer<PathalogyTestApiProvider>(
                        builder: (context, provider, child) {
                          if (provider.isLoading) {
                            return FrequentlyLabTestDetailShimmer();
                          } else if (provider.errorMessage.isNotEmpty) {
                            return Center(
                                child: Text(provider.errorMessage,
                                    style: TextStyle(color: Colors.red)));
                          }

                          final pathologyTestList =
                              provider.pathalogyTestListDetailModel?.data;

                          if (pathologyTestList == null) {
                            return Center(
                                child: Text("No health concerns available"));
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ResponsiveHelper.sizeBoxHeightSpace(context, 1.5),
                              Padding(
                                padding: ResponsiveHelper.padding(context, 4, 0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.primary, // Even Lighter Blue
                                        AppColors.primary,
                                      ],
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight,
                                      stops: [0.4, 0.7],
                                      tileMode: TileMode.repeated,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          StringUtils.toUpperCase(pathologyTestList.testDetailName.toString()),
                                          // widget.patahlogyTestName,
                                          style: AppTextStyles.heading1(
                                            context,
                                            overrideStyle: TextStyle(
                                              color: Colors.white,
                                              fontWeight:
                                              FontWeight.bold,
                                              fontSize: ResponsiveHelper
                                                  .fontSize(
                                                  context, 14),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 5,),
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

                                                  // Added spacing to prevent text overlap
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 5.0, top: 2.0),
                                                    child: Text(
                                                      "Shanya Scans & Theranostics – Uttar Pradesh’s No. 1 Diagnostic Centre in Lucknow for Accurate & Reliable Testing!",
                                                      style:
                                                          AppTextStyles.heading2(
                                                        context,
                                                        overrideStyle: TextStyle(
                                                          color: Colors.white,
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
                                                //   "\u20B9${pathologyTestList.testPrice}/-",
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
                                                            text: "${pathologyTestList.testPrice}", // Price Amount
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
                                                            pathologyTestList
                                                                .testDetails1
                                                                .toString());
                                                    // set order type
                                                    StringUtils.setOrderType(
                                                        "pathology");

                                                    OrderItem orderItem = OrderItem(
                                                        id: pathologyTestList
                                                                .sId ??
                                                            "",
                                                        name: pathologyTestList
                                                            .testDetailName
                                                            .toString(),
                                                        orderType: "pathology",
                                                        category:
                                                            pathologyTestList
                                                                .category
                                                                .toString(),
                                                        price: double
                                                            .parse(
                                                                pathologyTestList
                                                                    .testPrice
                                                                    .toString()),
                                                        imageUrl:
                                                            OrderItem
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
                                                              context, orderItem);
                                                    });

                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            CheckoutScreen(),
                                                      ),
                                                    );

                                                    // Provider.of<OrderApiProvider>(context, listen: false).notiFylistener();

                                                    // Navigator.push(
                                                    //   context,
                                                    //   MaterialPageRoute(
                                                    //     builder: (context) =>
                                                    //         CheckoutScreen(
                                                    //       categoryName: widget
                                                    //           .patahlogyTestName,
                                                    //       name: pathologyTestList
                                                    //           .testDetailName,
                                                    //       price: pathologyTestList
                                                    //           .testPrice,
                                                    //     ),
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
                                                                fontSize:
                                                                    ResponsiveHelper
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ExpandableTextWidget(
                                      text: pathologyTestList.testRequirement1
                                          .toString(),
                                      // "Pathology tests are essential diagnostic tools that analyze blood, urine, tissues, and other body fluids to detect diseases, monitor health conditions, and assess overall well-being. These tests help in identifying infections, organ function abnormalities, nutritional deficiencies, and chronic diseases like diabetes and thyroid disorders.",
                                    ),
                                  ],
                                ),
                              ),

                              // &&&&&&&&&&&&&&&&&&&&&& Required Parameter  section &&&&&&&&&&&&&&&
                              ResponsiveHelper.sizeBoxHeightSpace(context, 0.5),
                              Padding(
                                padding: ResponsiveHelper.padding(context, 0, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Wrap(
                                      spacing: 1, // Horizontal spacing
                                      runSpacing:
                                          10, // Vertical spacing when items wrap
                                      children: [
                                        SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width /
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
                                                      .containerWidth(context, 6),
                                                  height: ResponsiveHelper
                                                      .containerWidth(context, 6),
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
                                                              color: Colors.black,
                                                              fontSize:
                                                                  ResponsiveHelper
                                                                      .fontSize(
                                                                          context,
                                                                          10))),
                                                    ),
                                                    Text(
                                                      pathologyTestList
                                                          .paramterInclude
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
                                          width:
                                              MediaQuery.of(context).size.width /
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
                                                      .containerWidth(context, 6),
                                                  height: ResponsiveHelper
                                                      .containerWidth(context, 6),
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
                                                                color:
                                                                    Colors.black,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                fontSize:
                                                                    ResponsiveHelper
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
                                padding: ResponsiveHelper.padding(context, 0, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Wrap(
                                      spacing: 1, // Horizontal spacing
                                      runSpacing:
                                          10, // Vertical spacing when items wrap
                                      children: [
                                        SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width /
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
                                                      .containerWidth(context, 6),
                                                  height: ResponsiveHelper
                                                      .containerWidth(context, 6),
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
                                                              color: Colors.black,
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
                                          width:
                                              MediaQuery.of(context).size.width /
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
                                                      .containerWidth(context, 6),
                                                  height: ResponsiveHelper
                                                      .containerWidth(context, 6),
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
                                                                color:
                                                                    Colors.black,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                fontSize:
                                                                    ResponsiveHelper
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

                              // ResponsiveHelper.sizeBoxHeightSpace(context, 3.5),

                              // &&&&&&&&&&&&&&&&&&&&&& Parametes section  &&&&&&&&&&&&&&&
                              Padding(
                                padding: ResponsiveHelper.padding(context, 3, 0),
                                child: _buildExpandableTestSections(
                                  sid: pathologyTestList.sId.toString(),
                                  pathalogyTestCategory: widget.patahlogyTestName,
                                  pathalogyTestName:
                                      pathologyTestList.testDetailName.toString(),
                                  pathalogyTestDetail: pathologyTestList
                                      .testRequirement1
                                      .toString(),
                                  pathalogyTestPrice:
                                      pathologyTestList.testPrice.toString(),
                                ),
                              ),

                              // &&&&&&&&&&&&&&&&&&&&&& Parametes section  &&&&&&&&&&&&&&&

                              ResponsiveHelper.sizeBoxHeightSpace(context, 1),

                              // ***************** Why Choose Use  start  ******************
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
                                instructionEnglish:
                                    pathologyTestList.testDetails1.toString(),
                                instructionHindi:
                                    pathologyTestList.testDetails2.toString(),
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
  String sid,
      pathalogyTestCategory,
      pathalogyTestName,
      pathalogyTestDetail,
      pathalogyTestPrice;

  _buildExpandableTestSections(
      {required this.sid,
      required this.pathalogyTestCategory,
      required this.pathalogyTestName,
      required this.pathalogyTestDetail,
      required this.pathalogyTestPrice});

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
                                Icon(Icons.watch_later, color: AppColors.primary),
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
                                  color: AppColors.primary,
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
                                    color: AppColors.primary),
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
                                    PhoneCallHelper.makePhoneCall(context);
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

                              final extractedText = extractPlainText(
                                  pathalogyTestDetail.toString());

                              // set order type
                              StringUtils.setOrderType("pathology");
                              OrderItem orderItem = OrderItem(
                                  id: sid ?? "",
                                  name: pathalogyTestName.toString(),
                                  category: pathalogyTestCategory.toString(),
                                  orderType: "pathology",
                                  price: double.parse(
                                      pathalogyTestPrice.toString()),
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

                              // Provider.of<OrderApiProvider>(context, listen: false).notiFylistener();

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CheckoutScreen(),
                                ),
                              );

                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => CheckoutScreen(
                              //       categoryName: pathalogyTestCategory,
                              //       name: pathalogyTestName,
                              //       price: pathalogyTestPrice,
                              //     ),
                              //   ),
                              // );

                              //  &&&&&&&&&&&&& go to the checkout page &&&&&&&&&&&&&&&&
                            },
                            child: CustomRoundedContainer(
                              borderRadius: 20,
                              borderColor: Colors.white,
                              borderWidth: 0,
                              elevation: 2,
                              backgroundColor: AppColors.primary,
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

class buildInstructions extends StatelessWidget {
  String type, instructions;

  buildInstructions({required this.type, required this.instructions});

  @override
  Widget build(BuildContext context) {
    print("instructinos => ${instructions}");

    return Container(
      // height: 10, // Set fixed height for the container
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   "Instructions",
            //   style: AppTextStyles.heading1.copyWith(
            //     fontSize: 14,
            //   ),
            // ),
            // SizedBox(height: 10),
            Expanded(
              // Makes the ListView scrollable within the fixed height
              child: SingleChildScrollView(
                child: ExpandableTextWidget(
                  text: "${instructions.toString()}",
                  // "Pathology tests are essential diagnostic tools that analyze blood, urine, tissues, and other body fluids to detect diseases, monitor health conditions, and assess overall well-being. These tests help in identifying infections, organ function abnormalities, nutritional deficiencies, and chronic diseases like diabetes and thyroid disorders.",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
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
