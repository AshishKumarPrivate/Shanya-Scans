import 'package:flutter/material.dart';
import 'package:shanya_scans/screen/nav/nav_home/health_concern/controller/health_concern_provider.dart';
import 'package:shanya_scans/screen/order/model/OrderItem.dart';
import 'package:shanya_scans/ui_helper/responsive_helper.dart';
import 'package:provider/provider.dart';
import 'package:shanya_scans/util/image_loader_util.dart';

import '../../../base_widgets/card_body.dart';
import '../../../base_widgets/product_card_bottom.dart';
import '../../../ui_helper/app_colors.dart';
import '../../../ui_helper/app_text_styles.dart';
import '../../cart/controller/cart_list_api_provider.dart';
import '../../packages/controller/health_package_list_api_provider.dart';
import '../../packages/widget/home_health_pacakge_shimmer.dart';
import '../../packages/widget/home_health_pacakge_tab_list_shimmer.dart';
import '../nav_package/nav_package_detail.dart';

class HomeHealthPackageSection extends StatefulWidget {
  @override
  State<HomeHealthPackageSection> createState() =>  _HomeHealthPackageSectionState();
}

class _HomeHealthPackageSectionState extends State<HomeHealthPackageSection> {
  int selectedTabIndex = 0;
  String? selectedTabId; // Store the ID of the selected tab
  bool _isFirstLoad = true; // To prevent infinite loop

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<HealthConcernApiProvider>(context, listen: false)
          .loadCachedHomeHealthConcern();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstLoad) {
      _isFirstLoad = false;
      final provider =
          Provider.of<HealthConcernApiProvider>(context, listen: false);
      final tagList = provider.healthConcernPackageTagListModel?.data ?? [];

      List<dynamic> updatedTagList = [
        {"packageTagName": "Top Selling", "_id": ""}
        // Ensure ID is empty for default selection
      ];
      updatedTagList.addAll(tagList.map((e) => {
            "packageTagName": e.packageTagName,
            "_id": e.sId,
          }));

      if (updatedTagList.isNotEmpty) {
        selectedTabIndex = 0;
        selectedTabId = ""; // Ensure "Top Selling" is selected

        print("Default Selected Tab: $selectedTabId");

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Provider.of<HealthPacakgeListApiProvider>(context, listen: false)
              .getPackageListByTab(context, selectedTabId!);
        });

        // Provider.of<HealthPacakgeListApiProvider>(context, listen: false)
        //     .getPackageListByTab(context, selectedTabId!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SizedBox(height: 15),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Popular Health Packages",
                style: AppTextStyles.heading1(context,
                    overrideStyle: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(context, 14))),
              ),
              Text(
                "Make packages under one roof",
                style: AppTextStyles.bodyText1(context,
                    overrideStyle: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(context, 12))),
              ),
            ],
          ),
        ),
        SizedBox(height: 15),

        Consumer<HealthConcernApiProvider>(
          builder: (context, provider, child) {
            print(
                "API Response: ${provider.healthConcernPackageTagListModel?.data}");

            if (provider.isLoading) {
              return HomePackageTabListShimmer();
            }
            if (provider.errorMessage.isNotEmpty) {
              return Center(
                child: SizedBox(
                  width: ResponsiveHelper.containerWidth( context, 50),
                  height: ResponsiveHelper.containerWidth(context, 50),
                  child: ImageLoaderUtil.assetImage( "assets/images/img_error.jpg")

                ),
              );
            }

            final tagList =
                provider.healthConcernPackageTagListModel?.data ?? [];

            print("Fetched Tags: $tagList");

            List<dynamic> updatedTagList = [
              {"packageTagName": "Top Selling", "_id": ""}
            ];
            updatedTagList.addAll(tagList.map((e) => {
                  "packageTagName": e.packageTagName,
                  "_id": e.sId,
                }));

            print("Updated Tag List: $updatedTagList");

            if (updatedTagList.isEmpty) {
              return Center(child: Text("No health concerns available"));
            }

            return Container(
              height: ResponsiveHelper.containerWidth(context, 7),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: updatedTagList.length,
                itemBuilder: (context, index) {
                  final item = updatedTagList[index];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTabIndex = index;
                        selectedTabId = item['_id'].toString();
                      });

                      Provider.of<HealthPacakgeListApiProvider>(context,
                              listen: false)
                          .getPackageListByTab(context, selectedTabId!);
                    },
                    child: Center(
                      child: Container(
                        padding: ResponsiveHelper.padding(context, 3, 0.6),
                        margin: EdgeInsets.only(
                            left: index == 0 ? 16 : 8,
                            right: index == updatedTagList.length - 1 ? 16 : 0),
                        decoration: BoxDecoration(
                          color: selectedTabIndex == index
                              ? AppColors.primary
                              : AppColors.lightBrown_color.withAlpha(58),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          item['packageTagName'].toString(),
                          style: AppTextStyles.heading2(context,
                              overrideStyle: TextStyle(
                                fontSize: 12,
                                color: selectedTabIndex == index
                                    ? Colors.white
                                    : AppColors.txtGreyColor,
                              )),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
        SizedBox(height: 15),

        Consumer<HealthPacakgeListApiProvider>(
          builder: (context, packageListProvider, child) {
            if (packageListProvider.isLoading) {
              return HomePackageListShimmer(
                itemCount: 5,
              );
            }
            final packageListByTabId =
                packageListProvider.packageListByTabModel?.data ?? [];
            return SizedBox(
              height: ResponsiveHelper.containerWidth(context, 70),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: packageListByTabId.length,
                itemBuilder: (context, index) {
                  final packageListItem = packageListByTabId[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 10 : 5.0,
                      right: index == packageListByTabId.length - 1 ? 10 : 5.0,
                    ),
                    child: CardBody(
                      width: ResponsiveHelper.containerWidth(context, 50),
                      height: ResponsiveHelper.containerHeight(context, 200),
                      index: index,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ViewDetailBottomNavPackageScreen(
                              packageSlug: packageListItem.slug.toString(),
                              packagetName:
                                  packageListItem.packageName.toString(),
                            ),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.network(
                              "${packageListItem.packagePhoto!.secureUrl}",
                              width: double.infinity,
                              height:
                                  ResponsiveHelper.containerWidth(context, 30),
                              fit: BoxFit.cover,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return Image.asset(
                                    'assets/images/placeholder.jpg',
                                    // Your placeholder image path
                                    width: double.infinity,
                                    height: ResponsiveHelper.containerWidth(
                                        context, 30),
                                    fit: BoxFit.cover,
                                  );
                                }
                              },
                              errorBuilder: (BuildContext context, Object error,
                                  StackTrace? stackTrace) {
                                return Image.asset(
                                  'assets/images/placeholder.jpg',
                                  // Your placeholder image path
                                  width: double.infinity,
                                  height: ResponsiveHelper.containerWidth(
                                      context, 30),
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 5),
                            child: Text(
                              "${packageListItem.packageName}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.heading1(context,
                                  overrideStyle: TextStyle(
                                      fontSize: ResponsiveHelper.fontSize(
                                          context, 12))),
                            ),
                          ),
                          Container(
                            height:
                                ResponsiveHelper.containerWidth(context, 10),
                            padding: EdgeInsets.symmetric(horizontal: 5.0),
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/images/test.png",
                                      width: 12,
                                      height: 12,
                                      color: AppColors.primary,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "${packageListItem.parameterInclude} Parameters included",
                                      style: AppTextStyles.heading1(context,
                                          overrideStyle: TextStyle(
                                              color: AppColors.txtGreyColor,
                                              fontSize:
                                                  ResponsiveHelper.fontSize(
                                                      context, 9))),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.timer,
                                      size: 12,
                                      color: AppColors.primary,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "Reports within ${packageListItem.report} hours",
                                      style: AppTextStyles.heading1(context,
                                          overrideStyle: TextStyle(
                                              color: AppColors.txtGreyColor,
                                              fontSize:
                                                  ResponsiveHelper.fontSize(
                                                      context, 9))),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          ResponsiveHelper.sizeBoxHeightSpace(context, 0.5),
                          Container(
                            width: double.infinity,
                            color: AppColors.lightBlueColor,
                            child: Padding(
                              padding:
                                  ResponsiveHelper.padding(context, 3, 0.3),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "\u20B9${packageListItem.packageRate}",
                                        style: TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: AppColors.txtGreyColor,
                                          fontSize: ResponsiveHelper.fontSize(
                                              context, 13),
                                        ),
                                      ),
                                      SizedBox(width: 5),

                                      // Text(
                                      //   '\u20B9${packageListItem.packageRate}',
                                      //   style: AppTextStyles.heading1(context,
                                      //       overrideStyle: TextStyle(
                                      //           fontSize:
                                      //               ResponsiveHelper.fontSize(
                                      //                   context, 12))),
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
                                                      fontSize: ResponsiveHelper.fontSize(context, 12),
                                                    ),
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: packageListItem.packageRate.toString(), // Price Amount
                                                  style: AppTextStyles.heading1(
                                                    context,
                                                    overrideStyle: TextStyle(
                                                      fontSize: ResponsiveHelper.fontSize(context, 12),
                                                    ),
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: " /-", // Smaller "/-" Sign
                                                  style: AppTextStyles.heading1(
                                                    context,
                                                    overrideStyle: TextStyle(
                                                      fontSize: ResponsiveHelper.fontSize(context, 9), // Smaller font size
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
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 10,
                            child: ProductCardBottom(
                              onTap: () {
                                cart.addToCart(
                                  context,
                                  OrderItem(
                                    id: packageListItem.sId.toString(),
                                    name: packageListItem.packageName.toString(),
                                    category: "package",
                                    price: double.parse(
                                        packageListItem.packageRate.toString()),
                                    imageUrl: packageListItem
                                        .packagePhoto!.secureUrl
                                        .toString(),
                                    packageDetail:
                                        packageListItem.packageOverview!
                                          ..toString(),
                                    orderType: "package",
                                  ),
                                );
                                // /// Function to extract plain text from an HTML string
                                // String extractPlainText( String htmlString) {
                                //   var document =  parse(htmlString);
                                //   return document .body?.text ??  "";
                                // }
                                //
                                // final extractedText = extractPlainText( packageListItem .packageOverview.toString());
                                // OrderItem orderItem = OrderItem(
                                //     id: packageListItem.sId ?? "",
                                //     name: packageListItem .packageName.toString(),
                                //     category: packageListItem.packageCategory.toString() ,
                                //     price:  packageListItem.packageRate .toString(),
                                //     imageUrl: OrderItem.defaultImage, packageDetail:
                                //     extractedText,
                                //     quantity: 1);
                                //
                                // WidgetsBinding.instance.addPostFrameCallback( (_) {
                                //       Provider.of< OrderApiProvider>(context, listen: false).addToOrderReview( context, orderItem);
                                //     });

                                ///////////////////////////////////
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
