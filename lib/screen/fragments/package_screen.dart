import 'package:flutter/material.dart';
import 'package:shanya_scans/screen/nav/nav_package/cell_nav_package_list_item.dart';
import 'package:shanya_scans/screen/nav/nav_package/nav_package_detail.dart';
import 'package:provider/provider.dart';
import 'package:shanya_scans/util/image_loader_util.dart';

import '../../base_widgets/common/nav_common_app_bar.dart';
import '../../base_widgets/common/rate_list_service_shimmer.dart';
import '../../ui_helper/app_colors.dart';
import '../../ui_helper/responsive_helper.dart';
import '../packages/controller/health_package_list_api_provider.dart';
import '../splash/controller/network_provider_controller.dart';

class HealthPackageScreen extends StatefulWidget {
  HealthPackageScreen({super.key});

  @override
  State<HealthPackageScreen> createState() => _HealthPackageScreenState();
}

class _HealthPackageScreenState extends State<HealthPackageScreen> {

  bool _isInternetAvailable = true;
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<HealthPacakgeListApiProvider>(context, listen: false)
          .getBottomNavPackageList( context); // Provider.of<HealthPacakgeListApiProvider>(context, listen: false).getPackageListByTab(context, selectedTabIndex.toString());
    });
  }

  Future<void> _refreshData() async {
    await  Provider.of<HealthPacakgeListApiProvider>(context, listen: false)
        .refreshBottomNavPackageList( context);
    print("refresh data is loaded");

  }

  @override
  Widget build(BuildContext context) {
    _isInternetAvailable = Provider.of<NetworkProvider>(context).isConnected;
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
          child: Column(
            children: [
              // Header Row
              // CommonAppBar(
              //   aciviyName: "Health Packages",
              //   isNavigation: true,
              // ),
              NavCommonAppBar(
                aciviyName: "Health Packages",
                isNavigation: true,
                searchBarVisible: true,
                backgroundColor: AppColors.primary, // ✅ Change Background Color
                onSearchChanged: (query) {
                  Provider.of<HealthPacakgeListApiProvider>(context, listen: false)
                      .filterPackages(query);
                },
                // backgroundColor: AppColors.primary,
              ),
              // SizedBox(height: 15),
              // ListView takes the full screen height
              Expanded(
                child: _isInternetAvailable
                    ? Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
                  child: Consumer<HealthPacakgeListApiProvider>(
                    builder: (context, provider, child) {
                      if (provider.isLoading) {
                        return RateListServiceShimmer(
                          borderWidth: 0,
                          elevation: 1,
                        );
                      }
                      if (provider.errorMessage.isNotEmpty) {
                        return Center(
                          child: SizedBox(
                            width: ResponsiveHelper.containerWidth( context, 50),
                            height: ResponsiveHelper.containerWidth(context, 50),
                            child: ImageLoaderUtil.assetImage("assets/images/img_error.jpg"),


                          ),
                        );
                      }
                      // final packageList =
                      //     provider.navPackageListlModel?.data ?? [];
                      // Set the default selectedTabIndex and selectedTabId only when the data is first loaded
                      final packageList = provider.filteredPackages;
                      return RefreshIndicator(
                        onRefresh: _refreshData,
                        child: ListView.builder(
                          itemCount: packageList.length,
                          itemBuilder: (context, index) {
                            final item = packageList[index];
                            return CellNavPackageListItem(
                              item: item,
                              borderRadius: 10.0,
                              borderColor: AppColors.txtLightGreyColor,
                              borderWidth: 0.3,
                              elevation: 1,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.all(0.0),
                              onTap: () {
                                // FocusScope.of(context).unfocus();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ViewDetailBottomNavPackageScreen(
                                      packagetName: item.packageName.toString(),
                                      packageSlug: item.slug.toString(),
                                    ),
                                  ),
                                );
                                FocusScope.of(context).unfocus();
                                print("Container tapped: ${item.packageName}");
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                )
                    : Center(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.wifi_off, size: 80, color: Colors.grey),
                        SizedBox(height: 20),
                        Text("No internet connection",
                            style: TextStyle(fontSize: 18)),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            Provider.of<NetworkProvider>(context,
                                listen: false)
                                .checkConnection(context, showSnackBar: true);
                          },
                          child: Text("Retry"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
