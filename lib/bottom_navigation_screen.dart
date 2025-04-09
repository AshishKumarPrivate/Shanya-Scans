import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shanya_scans/screen/fragments/package_screen.dart';
import 'package:shanya_scans/screen/fragments/home_screen.dart';
import 'package:shanya_scans/screen/fragments/profile_screen.dart';
import 'package:shanya_scans/screen/fragments/scan_screen.dart';
import 'package:shanya_scans/screen/fragments/nav_pathalogy_teest_screen.dart';
import 'package:shanya_scans/ui_helper/responsive_helper.dart';
import 'package:shanya_scans/ui_helper/app_colors.dart';


class BottomNavigationScreen extends StatefulWidget {
  final int initialPageIndex;

  const BottomNavigationScreen({super.key, this.initialPageIndex = 0});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int pageIndex = 0;
  bool _showAppBar = true;
  bool _showSearchAndFilter = true;
  DateTime? lastBackPressedTime;

  final List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    pageIndex = widget.initialPageIndex;
    pages.addAll([
      HomeScreen(onTabChange: _onTabTapped),
      PathalogyNavSection(),
      ScanScreen(),
      HealthPackageScreen(),
      ProfileScreen(),
    ]);

    // **Set Initial Status Bar Color**
    _updateStatusBarColor(pageIndex);
  }

  void _onTabTapped(int index) {
    setState(() {
      pageIndex = index;
      // _updateStatusBarColor(index);
    });
  }

  /// **Function to Change Status Bar Color Based on Selected Page**
  void _updateStatusBarColor(int index) {
    Color statusBarColor;

    switch (index) {
      case 0: // Home Screen
        statusBarColor = AppColors.primary;
        break;
      case 1: // Labs Screen
        statusBarColor = AppColors.primary;
        break;
      case 2: // Scan Screen

        final Color scanStatusBarColor = Color(0xFFFFE8E2);
        statusBarColor =AppColors.primary;
        break;
      case 3: // Packages Screen
        statusBarColor =AppColors.primary;
        break;
      case 4: // Profile Screen
        statusBarColor = AppColors.primary;
        break;
      default:
        statusBarColor =AppColors.primary;
    }

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: statusBarColor,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final currentTime = DateTime.now();

        if (lastBackPressedTime == null ||
            currentTime.difference(lastBackPressedTime!) > const Duration(seconds: 2)) {
          lastBackPressedTime = currentTime;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Press back again to exit the app"),
              duration: Duration(seconds: 2),
            ),
          );

          return false; // Prevent immediate exit
        }

        SystemNavigator.pop(); // Close the app

        return false;
      },


      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Expanded(child: pages[pageIndex]),
          ],
        ),
        bottomNavigationBar: buildMyNavBar(context),
      ),
    );
  }

  Container buildMyNavBar(BuildContext context) {
    return Container(
      height: ResponsiveHelper.containerWidth(context, 18),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: ResponsiveHelper.padding(context, 0.2, 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildNavItem(
              selectedImage: "assets/images/navicon/nav_home_fill.png",
              unselectedImage: "assets/images/navicon/nav_home.png",
              label: "Home",
              index: 0,
            ),
            buildNavItem(
              selectedImage: "assets/images/navicon/nav_lab_fill.png",
              unselectedImage: "assets/images/navicon/nav_lab.png",
              label: "Labs",
              index: 1,
            ),
            buildNavItem(
              selectedImage: "assets/images/navicon/nav_scan_fill.png",
              unselectedImage: "assets/images/navicon/nav_scan.png",
              label: "Scan",
              index: 2,
            ),
            buildNavItem(
              selectedImage: "assets/images/navicon/nav_package_fill.png",
              unselectedImage: "assets/images/navicon/nav_package.png",
              label: "Packages",
              index: 3,
            ),
            buildNavItem(
              selectedImage: "assets/images/navicon/nav_profile_fill.png",
              unselectedImage: "assets/images/navicon/nav_profile.png",
              label: "Profile",
              index: 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNavItem({
    required String selectedImage,
    required String unselectedImage,
    required String label,
    required int index,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            pageIndex = index;
            _updateStatusBarColor(index);
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              pageIndex == index ? selectedImage : unselectedImage,
              height: ResponsiveHelper.containerWidth(context, 6),
              width: ResponsiveHelper.containerWidth(context, 6),
              color: pageIndex == index ? AppColors.primary : AppColors.txtGreyColor,
            ),
            SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: pageIndex == index ? AppColors.primary : AppColors.txtGreyColor,
                fontSize: ResponsiveHelper.fontSize(context, 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
