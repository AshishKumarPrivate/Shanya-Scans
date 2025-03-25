import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:healthians/screen/nav/nav_home/home_ending_setion.dart';
import 'package:healthians/screen/nav/nav_home/home_first_service_setion.dart';
import 'package:healthians/screen/nav/nav_home/home_google_reviews_setion.dart';
import 'package:healthians/screen/nav/nav_home/home_slider_setion.dart';
import 'package:healthians/screen/nav/nav_home/home_stats_setion.dart';
import 'package:healthians/screen/nav/nav_home/home_toolbar_setion.dart';
import 'package:healthians/ui_helper/app_colors.dart';
import 'package:healthians/ui_helper/responsive_helper.dart';
import 'package:healthians/ui_helper/app_text_styles.dart';
import 'package:healthians/ui_helper/storage_helper.dart';
import 'package:provider/provider.dart';

import '../../base_widgets/common/custom_offer_dialog_popup.dart';
import '../nav/nav_home/frquently_pathalogy_test/controller/frequently_pathalogy_test_provider.dart';
import '../nav/nav_home/health_concern/controller/health_concern_provider.dart';
import '../nav/nav_home/home_checkups_organs_setion.dart';
import '../nav/nav_home/home_contact_setion.dart';
import '../nav/nav_home/home_lab_test_setion.dart';
import '../nav/nav_home/home_health_concern_setion.dart';
import '../nav/nav_home/home_health_packages_setion.dart';
import '../nav/nav_home/home_radiology_setion.dart';
import '../nav/nav_home/home_services_setion.dart';
import '../nav/nav_home/home_slider_2_setion.dart';
import '../cart/cart_list_screen.dart';
import '../nav/nav_home/slider/controller/home_banner_api_provider.dart';
import '../service/controller/service_scans_provider.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) onTabChange;

  HomeScreen({required this.onTabChange, Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> items = [
    {'image': 'assets/images/fullbody.png', 'title': 'Fever'},
    {'image': 'assets/images/img.png', 'title': 'Thyroid'},
    {'image': 'assets/images/thyroid.png', 'title': 'Diabetes'},
    {'image': 'assets/images/img.png', 'title': 'Hair & Skin'},
    {'image': 'assets/images/img.png', 'title': 'Full Body Checkups'},
    {'image': 'assets/images/img.png', 'title': 'Women Care'},
    {'image': 'assets/images/img.png', 'title': 'Heart'},
    {'image': 'assets/images/img.png', 'title': 'Bone Health'},
  ];

  final List<String> imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];

  @override
  void initState() {
    super.initState();
    _checkAndShowDialog();
    Provider.of<ServiceApiProvider>(context, listen: false).loadCachedPackages();
    Provider.of<HomeBannerApiProvider>(context, listen: false)
        .loadCachedBanners();
    Provider.of<HealthConcernApiProvider>(context, listen: false)
        .getHealthConcernTagList(context);
    Provider.of<FrequentlyPathalogyTagApiProvider>(context, listen: false)
        .loadCachedFrequentlyHomeLabTest();
    Provider.of<HealthConcernApiProvider>(context, listen: false)
        .getHealthConcernTagList(context);
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
    await Provider.of<ServiceApiProvider>(context, listen: false).fetchScansList();
    await Provider.of<HomeBannerApiProvider>(context, listen: false) .loadCachedBanners();
    await Provider.of<HealthConcernApiProvider>(context, listen: false).getHealthConcernTagList(context);
    await Provider.of<FrequentlyPathalogyTagApiProvider>(context, listen: false).loadCachedFrequentlyHomeLabTest();
    await Provider.of<HealthConcernApiProvider>(context, listen: false)
        .getHealthConcernTagList(context);


    print("refresh data is loaded");

  }

  @override
  Widget build(BuildContext context) {
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
                          HomeFirstServiceSection(
                              onTabChange: widget.onTabChange),
                          HomeSliderSection(),
                          HomeContactSection(),
                          // SizedBox(height: 10),
                          HomeServicesSection(
                            sectionHeading: "Our Best Radiology Service",
                          ),
                          // SizedBox(height: 15),
                          // Grid Title
                          HomeSlider2Section(),
                          HealthConcernSetion(),
                          HomeLabTestSection(
                            sectionHeading: "Frequently Lab Test",
                          ),
                          HomeHealthPackageSection(),
                          // HomeCheckupsVitalSection(),
                          // HomeRadiologySection(),
                          // HorizontalAutoScrollingList(),
                          // HomeStatsSection(),
                          // HomeGoogleReviewSection(sectionHeading: "What Ours Patients Say",),
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
