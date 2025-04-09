
import 'package:flutter/material.dart';
import 'package:shanya_scans/screen/nav/nav_home/home_ending_setion.dart';
import 'package:shanya_scans/screen/nav/nav_home/home_first_service_setion.dart';
import 'package:shanya_scans/screen/nav/nav_home/home_slider_setion.dart';
import 'package:shanya_scans/screen/nav/nav_home/home_toolbar_setion.dart';
import 'package:shanya_scans/ui_helper/app_colors.dart';
import 'package:shanya_scans/ui_helper/storage_helper.dart';
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
  bool _isInternetAvailable = true;

  void _loadCachedData() {
    Provider.of<ServiceApiProvider>(context, listen: false).loadCachedPackages();
    Provider.of<HomeBannerApiProvider>(context, listen: false).loadCachedBanners();
    Provider.of<HealthConcernApiProvider>(context, listen: false).loadCachedHomeHealthConcern();
    Provider.of<FrequentlyPathalogyTagApiProvider>(context, listen: false).loadCachedFrequentlyHomeLabTest();
  }


  Future<void> _initializeNetworkAndLoadData() async {
    final networkProvider = Provider.of<NetworkProvider>(context, listen: false);
    // Initialize connectivity listener
    networkProvider.initializeConnectivityListener(context);
    // Await the async connection check
    await networkProvider.checkConnection(context);
    // Now check the updated connection state
    final isConnected = networkProvider.isConnected;
    if (isConnected) {
      _loadCachedData();
    }
    setState(() {
      _isInternetAvailable = isConnected;
    });
  }

  @override
  void initState() {
    super.initState();
    // _checkAndShowDialog();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeNetworkAndLoadData();
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

  Future<void> _refreshData() async {
    final isConnected = Provider.of<NetworkProvider>(context, listen: false).isConnected;
    if (!isConnected) return;

    await Provider.of<HomeBannerApiProvider>(context, listen: false) .getHomeBanner1List();
    await Provider.of<ServiceApiProvider>(context, listen: false).fetchScansList();
    await Provider.of<HealthConcernApiProvider>(context, listen: false).loadCachedHomeHealthConcern(forceRefresh: true);
    await Provider.of<FrequentlyPathalogyTagApiProvider>(context, listen: false).loadCachedFrequentlyHomeLabTest(forceRefresh: true);


    print("refresh data is loaded");

  }


  @override
  Widget build(BuildContext context) {
    _isInternetAvailable = Provider.of<NetworkProvider>(context).isConnected;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Container(
          // color: Colors.pink,
          // padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeToolbarSection(),
              // Banner Section
              Expanded(
                child:_isInternetAvailable
                    ? RefreshIndicator(
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
                ) :  Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wifi_off, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text("No internet connection", style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Provider.of<NetworkProvider>(context, listen: false).checkConnection(context);
                    },
                    child: Text("Retry"),
                  ),
                ],
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
