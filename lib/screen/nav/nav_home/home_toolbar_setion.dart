import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shanya_scans/screen/cart/cart_list_screen.dart';
import 'package:shanya_scans/ui_helper/responsive_helper.dart';
import 'package:shanya_scans/ui_helper/app_colors.dart';
import 'package:shanya_scans/ui_helper/app_text_styles.dart';
import 'package:provider/provider.dart';

import '../../../bottom_navigation_screen.dart';
import '../../../ui_helper/storage_helper.dart';
import '../../../util/config.dart';
import '../../cart/controller/cart_list_api_provider.dart';

class HomeToolbarSection extends StatefulWidget {
  @override
  State<HomeToolbarSection> createState() => _HomeToolbarSectionState();
}

class _HomeToolbarSectionState extends State<HomeToolbarSection> {
  int currentIndex = 0;
  // This controller seems unused. Consider removing it if not needed to keep the code clean.
  final CarouselSliderController _controller = CarouselSliderController();

  String userName = StorageHelper().getUserName();
  String userAddress = "Fetching location...";

  bool _hasLocationAttemptFailed = false;
  final ConfigUtils _configUtils = ConfigUtils();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Initiate the full location request flow when the widget is built
      _requestLocationAndGetAddress();
      // Listen to location service status changes from ConfigUtils for reactivity
      _configUtils.locationServiceStatusNotifier.addListener(_onLocationServiceStatusChanged);
    });
  }

  @override
  void dispose() {
    _configUtils.locationServiceStatusNotifier.removeListener(_onLocationServiceStatusChanged);
    super.dispose();
  }

  /// Listener for changes in the location service status reported by ConfigUtils.
  /// If the status becomes true (enabled) and a previous attempt failed, it retries.
  void _onLocationServiceStatusChanged() {
    if (!mounted) return; // Ensure widget is still mounted
    if (_configUtils.locationServiceStatusNotifier.value == true && _hasLocationAttemptFailed) {
      print("Location service/permission status changed to enabled. Retrying location fetch.");
      _requestLocationAndGetAddress(); // Call the unified method
    }
  }

  /// This is the consolidated method to check for stored address,
  /// handle app-specific disclosure, and then trigger system location checks.
  Future<void> _requestLocationAndGetAddress() async {
    final storageHelper = StorageHelper();
    String? storedAddress = storageHelper.getUserLiveAddress();

    if (storedAddress != null && storedAddress.isNotEmpty) {
      setState(() {
        userAddress = storedAddress;
        _hasLocationAttemptFailed = false;
      });
      return; // If address found, no need to proceed with fetching
    }

    // If no stored address, proceed with the full location flow
    bool alreadyAcceptedDisclosure = storageHelper.isUserLocationDisclosureAccepted();

    // 1. Show app-specific disclosure dialog if not already accepted
    if (!alreadyAcceptedDisclosure) {
      bool accepted = await _showLocationDisclosureDialog(context);
      if (!accepted) {
        setState(() {
          userAddress = "Location access required. Tap to retry."; // More specific message
          _hasLocationAttemptFailed = true;
        });
        return; // User denied app's disclosure, stop here.
      }
      await storageHelper.setUserLocationDisclosureAccepted(true);
    }

    // 2. Now that app-specific disclosure is handled,
    // let ConfigUtils handle system permissions and service check, and fetch location.
    setState(() {
      userAddress = "Fetching location...";
      _hasLocationAttemptFailed = false;
    });

    Map<String, dynamic> locationData = await _configUtils.getSingleLocation();

    if (locationData.isNotEmpty && locationData.containsKey("address")) {
      String address = locationData["address"];
      storageHelper.setUserLiveAddress(address); // Store fetched address
      setState(() {
        userAddress = address;
        _hasLocationAttemptFailed = false;
      });
    } else {
      print("❌ Failed to get location via ConfigUtils.");
      setState(() {
        userAddress = "Location not available. Tap to retry.";
        _hasLocationAttemptFailed = true;
      });
    }
  }

  /// Shows the app-specific location disclosure dialog.
  /// Returns true if the user accepts, false otherwise.
  Future<bool> _showLocationDisclosureDialog(BuildContext context) async {
    bool userAccepted = false;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text("Location Permission Required"),
          content: const Text(
              "We use your device’s location to display your current address and improve your service experience. This data is used only while the app is open and will not be shared with third parties."
          ),
          actions: [
            TextButton(
              onPressed: () {
                userAccepted = false;
                Navigator.of(ctx).pop();
              },
              child: const Text("Deny"),
            ),
            ElevatedButton(
              onPressed: () {
                userAccepted = true;
                Navigator.of(ctx).pop();
              },
              child: const Text("Accept"),
            ),
          ],
        );
      },
    );
    return userAccepted;
  }

  /// Attempts to get location again when the "Tap to retry" message is shown.
  void _attemptGetLocation() async {
    if (!mounted) return;
    // Only proceed if it's currently in a failed state
    if (!_hasLocationAttemptFailed) {
      return;
    }
    await _requestLocationAndGetAddress(); // Use the consolidated method for retry
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: Padding(
        padding: ResponsiveHelper.padding(context, 3, 0.5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Hello, ${userName}",
                                style: AppTextStyles.heading1(
                                  context,
                                  overrideStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: ResponsiveHelper.fontSize(context, 14)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.location_pin,
                              size: 18,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  // Only allow tap to retry if a previous attempt failed
                                  if (_hasLocationAttemptFailed) {
                                    _attemptGetLocation();
                                  }
                                },
                                child: Text(
                                  userAddress,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.heading1(context,
                                      overrideStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: ResponsiveHelper.fontSize(context, 10))),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  CartListScreen(),
                          ),
                        );
                      },
                      child: Consumer<CartProvider>(
                        builder: (context, cartProvider, child) {
                          return Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  color: Colors.white,
                                  Icons.shopping_cart_checkout_outlined,
                                  size: ResponsiveHelper.iconSize(context, 24),
                                ),
                              ),
                              if (cartProvider.cartItems.isNotEmpty)
                                Positioned(
                                  right: 2,
                                  top: -5,
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      cartProvider.cartItems.length.toString(),
                                      style: const TextStyle(color: Colors.white, fontSize: 10),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            ResponsiveHelper.sizeBoxHeightSpace(context, 1.5),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BottomNavigationScreen(initialPageIndex: 1),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: ResponsiveHelper.containerWidth(context, 10),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(width: 0.4, color: AppColors.txtLightGreyColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 1.0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BottomNavigationScreen(initialPageIndex: 1),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 0),
                                child: DefaultTextStyle(
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: ResponsiveHelper.fontSize(context, 14),
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                  ),
                                  child: AnimatedTextKit(
                                    repeatForever: true,
                                    isRepeatingAnimation: true,
                                    pause: Duration.zero,
                                    animatedTexts: [
                                      RotateAnimatedText(
                                          transitionHeight: 30.0,
                                          duration: const Duration(milliseconds: 2000),
                                          'Search for CBC, X-ray, etc.'),
                                      RotateAnimatedText(
                                          transitionHeight: 30.0,
                                          duration: const Duration(milliseconds: 2000),
                                          'Find Lab Tests, MRI, CT Scan...'),
                                      RotateAnimatedText(
                                          transitionHeight: 30.0,
                                          duration: const Duration(milliseconds: 2000),
                                          'Search Your Health Test Here...'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ResponsiveHelper.sizeBoxHeightSpace(context, 0.5),
          ],
        ),
      ),
    );
  }
}