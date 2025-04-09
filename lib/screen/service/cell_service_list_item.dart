import 'package:flutter/material.dart';
import 'package:shanya_scans/base_widgets/common/rate_list_service_shimmer.dart';
import 'package:shanya_scans/screen/service/model/ServiceDetailRateListModel.dart';
import 'package:shanya_scans/screen/service/screen/rate_list__detail.dart';
import 'package:shanya_scans/ui_helper/responsive_helper.dart';
import 'package:shanya_scans/base_widgets/solid_rounded_button.dart';
import 'package:shanya_scans/util/StringUtils.dart';
import 'package:provider/provider.dart';
import 'package:shanya_scans/util/image_loader_util.dart';

import '../../../ui_helper/app_colors.dart';
import '../../../ui_helper/app_text_styles.dart';
import 'controller/service_scans_provider.dart';

class CellServiceListItem extends StatefulWidget {
  final String serviceSlug;
  final String serviceName;
  final double borderRadius;
  final double elevation;
  final Color backgroundColor;
  final Color borderColor; // Stroke color
  final double borderWidth; // Stroke width
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final GestureTapCallback? onTap;

  const CellServiceListItem({
    Key? key,
    required this.serviceSlug,
    required this.serviceName,
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
  State<CellServiceListItem> createState() => _CellServiceListItemState();
}

class _CellServiceListItemState extends State<CellServiceListItem> {
  @override
  void initState() {
    Future.microtask(() {
      // Clear old data and fetch new service details
      Provider.of<ServiceApiProvider>(context, listen: false)
          .getServiceDetailRateList(context, widget.serviceSlug);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.pinkColor,
      child: Container(
        color: Colors.white,
        child:
            Consumer<ServiceApiProvider>(builder: (context, provider, child) {
          // Check if the loading state is true
          if (provider.isLoading) {
            return RateListServiceShimmer(
              borderWidth: 0,
              elevation: 1,
            ); // Show shimmer effect while loading
          }

          // Check if there was an error
          if (provider.errorMessage.isNotEmpty) {
            return _buildErrorWidget(); // Show error widget if there's an error
          }

          // Check if the data is null or empty
          if (provider.homeDerviceRateListModel?.data == null ||
              provider.homeDerviceRateListModel!.data!.isEmpty) {
            return _buildEmptyListWidget(); // Show empty list widget if data is null or empty
          }

          // If data is loaded, display the rate list
          return _buildRateList(provider.homeDerviceRateListModel!.data!);
        }),
      ),
    );
  }

  Widget _buildErrorWidget() {
    print("ErrorWidget");
    return Center(
      child: SizedBox(
        width: ResponsiveHelper.containerWidth(context, 50),
        height: ResponsiveHelper.containerWidth(context, 50),
        child: ImageLoaderUtil.assetImage(
          "assets/images/img_error.jpg",
        ),
      ),
    );
  }

  Widget _buildEmptyListWidget() {
    print("EmptyList");
    return Center(
      child: SizedBox(
        width: ResponsiveHelper.containerWidth(context, 50),
        height: ResponsiveHelper.containerWidth(context, 50),
        child:ImageLoaderUtil.assetImage(
          "assets/images/img_error.jpg",
        ),
      ),
    );
  }

  Widget _buildRateList(List<Data> servicesRateList) {
    print("BuildRateList ");
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: servicesRateList.length,
      itemBuilder: (context, index) {
        final rateListItem = servicesRateList[index];

        return Card(
          elevation: widget.elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            side: BorderSide(
              color: widget.borderColor,
              width: widget.borderWidth,
            ),
          ),
          margin: widget.margin,
          color: widget.backgroundColor,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            splashColor: AppColors.primary.withOpacity(0.2),
            highlightColor: AppColors.primary.withOpacity(0.1),
            child: Padding(
              padding: widget.padding ?? const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    StringUtils.toUpperCase(
                            rateListItem.testDetailName.toString()) ??
                        "N/A",
                    // Add null safety here
                    style: AppTextStyles.heading1(
                      context,
                      overrideStyle: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(context, 14),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Parameter Include ${rateListItem.paramterInclude ?? "No details"}",
                    // Add null safety
                    style: AppTextStyles.bodyText1(
                      context,
                      overrideStyle: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(context, 12),
                      ),
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
                              /// Rupee Symbol and Amount with spacing
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "\u20B9 ",
                                      // Rupee Symbol with space
                                      style: AppTextStyles.heading1(
                                        context,
                                        overrideStyle: TextStyle(
                                          color: AppColors.primary,
                                          fontSize: ResponsiveHelper.fontSize(
                                              context, 16),
                                        ),
                                      ),
                                    ),
                                    TextSpan(
                                      text: rateListItem.testPrice.toString(),
                                      // Price Amount
                                      style: AppTextStyles.heading1(
                                        context,
                                        overrideStyle: TextStyle(
                                          color: AppColors.primary,
                                          fontSize: ResponsiveHelper.fontSize(
                                              context, 16),
                                        ),
                                      ),
                                    ),
                                    TextSpan(
                                      text: " /-", // Smaller "/-" Sign
                                      style: AppTextStyles.heading1(
                                        context,
                                        overrideStyle: TextStyle(
                                          color: AppColors.primary,
                                          fontSize: ResponsiveHelper.fontSize(
                                              context, 12), // Smaller font size
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
                      SizedBox(
                        width: 100,
                        height: 30,
                        child: SolidRoundedButton(
                          text: 'Buy Now',
                          color: AppColors.primary,
                          borderRadius: 10.0,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RateListDetailScreen(
                                  serviceSlug: widget.serviceSlug,
                                  serviceName: widget.serviceName,
                                  packageName: StringUtils.toUpperCase(
                                      rateListItem.testDetailName ?? "N/A"),
                                  // packageName:  rateListItem.testDetailName ?? "N/A",
                                  packageSlug: rateListItem.slug ?? "N/A",
                                  serviceData: rateListItem, // Pass the object
                                ),
                              ),
                            );
                          },
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Divider(
                    color: AppColors.txtLightGreyColor.withOpacity(0.2),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.timer, size: 18, color: Colors.grey),
                            SizedBox(width: 2),
                            Flexible(
                              child: Text(
                                rateListItem.fasting ?? "N/A",
                                style: AppTextStyles.heading2(
                                  context,
                                  overrideStyle: TextStyle(
                                    fontSize: ResponsiveHelper.fontSize(context, 10),
                                  ),
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          // Align to the end
                          children: [
                            Icon(Icons.access_time,
                                size: 18, color: Colors.grey),
                            SizedBox(width: 2),
                            Flexible(
                              child: Text(
                                rateListItem.reportTime ?? "N/A",
                                // "${rateListItem.reportTime}",
                                style: AppTextStyles.heading2(
                                  context,
                                  overrideStyle: TextStyle(
                                    fontSize:
                                        ResponsiveHelper.fontSize(context, 10),
                                  ),
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                softWrap: true,
                                textAlign:
                                    TextAlign.start, // Align text to the right
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
