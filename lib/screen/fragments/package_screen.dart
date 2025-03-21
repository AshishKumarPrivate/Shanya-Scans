import 'package:flutter/material.dart';
import 'package:healthians/screen/nav/nav_package/cell_nav_package_list_item.dart';
import 'package:healthians/screen/nav/nav_package/nav_package_detail.dart';
import 'package:provider/provider.dart';

import '../../base_widgets/common/nav_common_app_bar.dart';
import '../../base_widgets/common/rate_list_service_shimmer.dart';
import '../../ui_helper/app_colors.dart';
import '../../base_widgets/common/common_app_bar.dart';
import '../nav/nav_lab/nav_pathalogy_test_detail.dart';
import '../packages/controller/health_package_list_api_provider.dart';
import '../packages/widget/home_health_pacakge_tab_list_shimmer.dart';

class HealthPackageScreen extends StatefulWidget {
  HealthPackageScreen({super.key});

  @override
  State<HealthPackageScreen> createState() => _HealthPackageScreenState();
}

class _HealthPackageScreenState extends State<HealthPackageScreen> {
  final List<Map<String, String>> items = [
    {'image': 'assets/images/fullbody.png', 'title': 'Digital PET CT'},
    {'image': 'assets/images/fullbody.png', 'title': 'Thyroid'},
    {'image': 'assets/images/fullbody.png', 'title': 'Diabetes'},
    {'image': 'assets/images/img.png', 'title': 'Hair & Skin'},
    {'image': 'assets/images/img.png', 'title': 'Full Body Checkups'},
    {'image': 'assets/images/img.png', 'title': 'Women Care'},
    {'image': 'assets/images/img.png', 'title': 'Heart'},
    {'image': 'assets/images/img.png', 'title': 'Bone Health'},
  ];

  final List<Map<String, dynamic>> itemsList = [
    {
      'title': 'Comprehensive Full Body Checkup with Vitamin D B12',
      'price': '1199',
      'oldPrice': '2199',
      'tests': 'Includes 92 tests',
      'discount': '45% OFF',
      'fasting': 'Fasting required',
      'reportTime': 'Reports in 15 Hrs',
    },
    {
      'title': 'Senior Citizen Health Checkup',
      'price': '999',
      'oldPrice': '1949',
      'tests': 'Includes 87 tests',
      'discount': '49% OFF',
      'fasting': 'Fasting not required',
      'reportTime': 'Reports in 24 Hrs',
    },
    {
      'title': 'Women’s Master Checkup',
      'price': '1299',
      'oldPrice': '2299',
      'tests': 'Includes 93 tests',
      'discount': '43% OFF',
      'fasting': 'Fasting required',
      'reportTime': 'Reports in 12 Hrs',
    },
    {
      'title': 'Women’s Master Checkup',
      'price': '1299',
      'oldPrice': '2299',
      'tests': 'Includes 93 tests',
      'discount': '43% OFF',
      'fasting': 'Fasting required',
      'reportTime': 'Reports in 12 Hrs',
    },
  ];

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
                child: Padding(
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
                            child: Text(provider.errorMessage,
                                style: TextStyle(color: Colors.red)));
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
