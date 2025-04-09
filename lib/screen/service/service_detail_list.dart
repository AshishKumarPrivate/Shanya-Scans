import 'package:flutter/material.dart';
import 'package:shanya_scans/screen/service/cell_service_list_item.dart';
import 'package:shanya_scans/ui_helper/responsive_helper.dart';
import 'package:shanya_scans/ui_helper/app_text_styles.dart';
import 'package:shanya_scans/util/dimensions.dart';
import '../../base_widgets/common/common_app_bar.dart';
import '../../base_widgets/expandable_text_widget.dart';
import '../../ui_helper/app_colors.dart';

class AllServicesDetailListScreen extends StatefulWidget {
  final String serviceName, serviceSlug, serviceDescription,servicePhoto;

  AllServicesDetailListScreen({
    required this.serviceName,
    required this.serviceSlug,
    required this.serviceDescription,
    required this.servicePhoto,
  });

  @override
  State<AllServicesDetailListScreen> createState() =>
      _AllServicesDetailListScreenState();
}

class _AllServicesDetailListScreenState
    extends State<AllServicesDetailListScreen> {
  @override
  void initState() {

    super.initState();
    // Fetch API data when the widget is initialized
    print( " serviceslug ${widget.serviceName} serviceName ${widget.serviceSlug}");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        bottom: false,
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AppBar
              CommonAppBar(
                aciviyName: widget.serviceName,
                backgroundColor: AppColors.primary,
              ),
              // Main Content
              Expanded(
                child: Container(
                  color: AppColors.whiteColor,
                  child: SingleChildScrollView(
                    // padding: EdgeInsets.all(10.0),
                    child: Padding(
                      padding: ResponsiveHelper.padding(context, 2, 0),
                      child: Container(
                        color: AppColors.whiteColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // SizedBox(height: 16),
                            ResponsiveHelper.sizeBoxHeightSpace(context, 0.5),
                            // Description Section
                            // Padding(
                            //   padding: ResponsiveHelper.padding(context, 1, 0),
                            //   child: Text(
                            //     'Description',
                            //     style: AppTextStyles.heading1(context,
                            //         overrideStyle: TextStyle(
                            //             fontSize: ResponsiveHelper.fontSize(
                            //                 context, 14))),
                            //   ),
                            // ),

                            Container(
                              width: double.infinity,
                              height: ResponsiveHelper.containerWidth(context, 50),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  "${widget.servicePhoto}",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            ResponsiveHelper.sizeBoxHeightSpace(context, 0.5),
                            ExpandableTextWidget(
                                text: "${widget.serviceDescription}"
                                // "shanya_scans' brings forth a detailed health checkup to ensure you lead a healthy life. The package includes a series of testsHealthians' brings forth a detailed health checkup to ensure you lead a healthy life. The package includes a series of tests...",
                                ),

                            ResponsiveHelper.sizeBoxHeightSpace(
                                context, Dimensions.sizeBoxVerticalSpace_2),
                            Padding(
                              padding: ResponsiveHelper.padding(context, 1, 0),
                              child: Text(
                                'Related Test',
                                style: AppTextStyles.heading1(context,
                                    overrideStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: ResponsiveHelper.fontSize(
                                            context, 16))),
                              ),
                            ),
                            // Replace the previous container with this code
                            CellServiceListItem(
                              serviceSlug: "${widget.serviceSlug.toString()}",
                              serviceName: "${widget.serviceName.toString()}",
                              borderRadius: 10.0,
                              borderColor: AppColors.txtLightGreyColor,
                              borderWidth: 0.0,
                              elevation: 2,
                              margin: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.all(10.0),
                            ),
                            ResponsiveHelper.sizeBoxHeightSpace(context, 2),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Footer Section
            ],
          ),
        ),
      ),
    );
  }
}
