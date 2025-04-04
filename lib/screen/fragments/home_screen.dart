
import 'package:flutter/material.dart';
import 'package:healthians/screen/nav/nav_home/home_ending_setion.dart';
import 'package:healthians/screen/nav/nav_home/home_first_service_setion.dart';
import 'package:healthians/screen/nav/nav_home/home_slider_setion.dart';
import 'package:healthians/screen/nav/nav_home/home_toolbar_setion.dart';
import 'package:healthians/ui_helper/app_colors.dart';
import 'package:healthians/ui_helper/storage_helper.dart';
import 'package:provider/provider.dart';

import '../../base_widgets/common/custom_offer_dialog_popup.dart';
import '../nav/nav_home/frquently_pathalogy_test/controller/frequently_pathalogy_test_provider.dart';
import '../nav/nav_home/health_concern/controller/health_concern_provider.dart';
import '../nav/nav_home/home_contact_setion.dart';
import '../nav/nav_home/home_lab_test_setion.dart';
import '../nav/nav_home/home_health_concern_setion.dart';
import '../nav/nav_home/home_health_packages_setion.dart';
import '../nav/nav_home/home_services_setion.dart';
import '../nav/nav_home/home_slider_2_setion.dart';
import '../nav/nav_home/slider/controller/home_banner_api_provider.dart';
import '../service/controller/service_scans_provider.dart';
import '../splash/controller/network_provider_controller.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) onTabChange;

  HomeScreen({required this.onTabChange, Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    // _checkAndShowDialog();
    WidgetsBinding.instance.addPostFrameCallback((_) {

      Provider.of<ServiceApiProvider>(context, listen: false).loadCachedPackages();
      Provider.of<HomeBannerApiProvider>(context, listen: false)
          .loadCachedBanners();
      Provider.of<HealthConcernApiProvider>(context, listen: false)
          .getHealthConcernTagList(context);
      Provider.of<FrequentlyPathalogyTagApiProvider>(context, listen: false)
          .loadCachedFrequentlyHomeLabTest();
      Provider.of<HealthConcernApiProvider>(context, listen: false)
          .getHealthConcernTagList(context);
    });

    // Provider.of<ServiceApiProvider>(context, listen: false).loadCachedPackages();
    // Provider.of<HomeBannerApiProvider>(context, listen: false)
    //     .loadCachedBanners();
    // Provider.of<HealthConcernApiProvider>(context, listen: false)
    //     .getHealthConcernTagList(context);
    // Provider.of<FrequentlyPathalogyTagApiProvider>(context, listen: false)
    //     .loadCachedFrequentlyHomeLabTest();
    // Provider.of<HealthConcernApiProvider>(context, listen: false)
    //     .getHealthConcernTagList(context);
  }

  Future<void> _checkAndShowDialog() async {
    bool isDialogShown = StorageHelper().getDialogShown();
    if (!isDialogShown) {
      if (mounted) {
        await Future.delayed(
            Duration(milliseconds: 500)); // Delay to allow UI rendering
        showSpecialOfferDialog(
            context); // Show dialog only if it hasn't been shown
        StorageHelper().setDialogShown(true); // Mark dialog as shown
      }
    }
    // await Future.delayed(Duration(milliseconds: 500)); // Small delay
    // showSpecialOfferDialog(context); // Show dialog only if it hasn't been shown
  }

  Future<void> _refreshData() async {
    await Provider.of<HomeBannerApiProvider>(context, listen: false) .getHomeBanner1List();
    await Provider.of<ServiceApiProvider>(context, listen: false).fetchScansList();
    await Provider.of<HealthConcernApiProvider>(context, listen: false).getHealthConcernTagList(context);
    await Provider.of<FrequentlyPathalogyTagApiProvider>(context, listen: false).getFrequentlyLabTestList();
    await Provider.of<HealthConcernApiProvider>(context, listen: false) .getHealthConcernTagList(context);


    print("refresh data is loaded");

  }
  // Method to check the network connection using NetworkProvider
  Future<void> _checkConnection() async {
    // Access the network provider to check connectivity
    bool isConnected = Provider.of<NetworkProvider>(context, listen: false).isConnected;
    if (!isConnected) {
      // Show a message to the user that the internet is not connected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No internet connection. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // _checkConnection();
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Container(
          color: Colors.pink,
          // padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeToolbarSection(),
              // Banner Section
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshData,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HomeFirstServiceSection(onTabChange: widget.onTabChange),
                          HomeSlider1Section(),
                          HomeContactSection(),
                          HomeServicesSection( sectionHeading: "Our Best Radiology Service",),
                          HomeSlider2Section(),
                          HealthConcernSetion(),
                          HomeLabTestSection(sectionHeading: "Frequently Lab Test",),
                          HomeHealthPackageSection(),
                          HomeEndingSection()
                        ],
                      ),
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
