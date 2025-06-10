import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shanya_scans/ui_helper/responsive_helper.dart';
import 'package:shanya_scans/ui_helper/app_colors.dart';
import 'package:shanya_scans/ui_helper/app_text_styles.dart';
import '../../../ui_helper/storage_helper.dart';
import '../../../util/config.dart';
import 'delivery_boy_profile_screen.dart';

class DeliveryBoyHomeToolbarSection extends StatefulWidget {
  @override
  State<DeliveryBoyHomeToolbarSection> createState() => _DeliveryBoyHomeToolbarSectionState();
}

class _DeliveryBoyHomeToolbarSectionState extends State<DeliveryBoyHomeToolbarSection> {
  int currentIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  String deliveryBoyName = StorageHelper().getDeliveryBoyName(); // Fetch stored email
  String deliveryBoyAddress = "Lucknow,Uttar Pradesh";
  bool _hasLocationAttemptFailed = false;

  bool _isRequestingPermission = false; // Add this flag
  final ConfigUtils _configUtils = ConfigUtils();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _attemptGetLocation();
    });
  }

  // @override
  // void dispose() {
  //   // WidgetsBinding.instance.removeObserver(this);
  //   _configUtils.dispose(); // Dispose ConfigUtils when the widget is disposed
  //   super.dispose();
  // }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // When the app resumes (e.g., from background after opening settings),
      // re-attempt to get location.
      if (_hasLocationAttemptFailed || deliveryBoyAddress.contains("Tap to retry")) {
        _attemptGetLocation();
      }    }
  }

  void _attemptGetLocation() async {
    // Check if the widget is still mounted before performing UI updates
    if (!mounted) return;
    if (_hasLocationAttemptFailed && !deliveryBoyAddress.contains("Tap to retry")) {
      return;
    }


    setState(() {
      deliveryBoyAddress = "Fetching location..."; // 위치를 다시 가져오는 중임을 나타냄
      _hasLocationAttemptFailed = false; // 새로운 시도이므로 실패 플래그 초기화
    });
    // Start listening to the location stream immediately to update UI
    _configUtils.locationStream.listen((locationData) {
      if (mounted) {
        setState(() {
          deliveryBoyAddress = locationData["address"] ?? "Address Not Found";
          _hasLocationAttemptFailed = false;
        });
        StorageHelper().setDeliveryBoyLiveAddress(deliveryBoyAddress);
      }
    });

    // Start tracking in the background. `startTracking()` will handle permissions/service.
    // No need to check `_isRequestingPermission` here, `ConfigUtils` handles its own dialog state.
    bool success = await _configUtils.startTracking();

    if (!success) {
      // If startTracking was not successful (e.g., permission denied or service off),
      // you might want to show a persistent message or a retry button.
      if (mounted) {
        setState(() {
          // Keep a message that indicates location is not available
          deliveryBoyAddress = "Location not available. Tap to retry.";
          _hasLocationAttemptFailed = true;
        });
      }
      // You could also add a listener to the location stream from ConfigUtils
      // and update the address when a location becomes available later.
    }
  }



  void getUserAddress() async {
    if (_isRequestingPermission) return;  // Prevent multiple calls
    _isRequestingPermission = true;

    // final ConfigUtils _configUtils = ConfigUtils();
    _configUtils.startTracking();
    try {
      Map<String, dynamic> locationData = await _configUtils.locationStream.first;
      String latitude = locationData["latitude"].toString();
      String longitude = locationData["longitude"].toString();
      String address = locationData["address"];

      StorageHelper().setDeliveryBoyLiveAddress(address);
      if (mounted) {
        setState(() {
          deliveryBoyAddress = address;
        });
      }
    } catch (e) {
      // Handle errors if any, e.g. permission denied or timeout
    } finally {
      _isRequestingPermission = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.deliveryPrimary,
      padding: ResponsiveHelper.padding(context, 3, 0.5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Hello, ${deliveryBoyName}",
                            style: AppTextStyles.heading1(
                              context,
                              overrideStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize:
                                      ResponsiveHelper.fontSize(context, 14)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_pin,
                          size: 18,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child:InkWell( // Make the address tap-able to retry
                            onTap: () {
                              if (deliveryBoyAddress == "Location not available. Tap to retry.") {
                                _attemptGetLocation(); // Retry if location is off
                              }
                            },
                            child: Text(
                              deliveryBoyAddress,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.heading1(context,
                                  overrideStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          ResponsiveHelper.fontSize(context, 10))),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                // color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.only(right: 0.0,top: 8,left: 8),
                  child:InkWell(
                    onTap: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => DeliveryBoyProfileScreen()),
                      );
                    },
                    child: SvgPicture.asset(
                      "assets/svg/profile_icon.svg",
                      width: 30,
                      height: 30,
                      colorFilter: ColorFilter.mode(AppColors.whiteColor, BlendMode.srcIn),
                    ),
                  ),
                ),
              ),
            ],
          ),
          ResponsiveHelper.sizeBoxHeightSpace(context, 1.5),
          // Search Bar
          // 888888888888888888888 search bar in toolbar &&&&&&&&&&&&&&&&&&&&&&&&&&
          // Center(
          //   child: GestureDetector(
          //     onTap: () {
          //       // Navigator.pushReplacement(
          //       //   context,
          //       //   MaterialPageRoute(
          //       //     builder: (context) =>
          //       //         BottomNavigationScreen(initialPageIndex: 1),
          //       //   ),
          //       // );
          //     },
          //     child: Container(
          //       width: double.infinity,
          //       height: ResponsiveHelper.containerWidth(context, 10),
          //       // Fixed height
          //       padding: EdgeInsets.symmetric(horizontal: 10),
          //       decoration: BoxDecoration(
          //         color: Colors.white,
          //         borderRadius: BorderRadius.circular(10.0),
          //         border: Border.all(
          //             width: 0.4, color: AppColors.txtLightGreyColor),
          //         boxShadow: [
          //           BoxShadow(
          //             color: Colors.grey.withOpacity(0.3),
          //             blurRadius: 1.0,
          //             offset: Offset(0, 2),
          //           ),
          //         ],
          //       ),
          //       child: Row(
          //         children: [
          //           Icon(Icons.search, color: Colors.grey),
          //           SizedBox(width: 10), // Space between icon and text
          //           Expanded(
          //             child: GestureDetector(
          //               onTap: () {
          //                 Navigator.pushReplacement(
          //                   context,
          //                   MaterialPageRoute(
          //                     builder: (context) =>
          //                         BottomNavigationScreen(initialPageIndex: 1),
          //                   ),
          //                 );
          //               },
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.start,
          //                 children: [
          //                   Padding(
          //                     padding: EdgeInsets.only(top: 0),
          //                     // Adjust for alignment
          //                     child: DefaultTextStyle(
          //                       style: TextStyle(
          //                         color: Colors.grey,
          //                         fontSize:
          //                             ResponsiveHelper.fontSize(context, 14),
          //                         fontWeight: FontWeight.bold,
          //                         height: 1.2, // Maintain line height
          //                       ),
          //                       child: AnimatedTextKit(
          //                         repeatForever: true,
          //                         isRepeatingAnimation: true,
          //                         pause: Duration(milliseconds: 0), // No delay between animations
          //                         animatedTexts: [
          //                           RotateAnimatedText( transitionHeight: 30.0,
          //                               duration: Duration(milliseconds: 2000), // faster
          //                               'Search for CBC, X-ray, etc.'),
          //                           RotateAnimatedText( transitionHeight: 30.0,
          //                               duration: Duration(milliseconds: 2000), // faster
          //                               'Find Lab Tests, MRI, CT Scan...'),
          //                           RotateAnimatedText( transitionHeight: 30.0,
          //                               duration: Duration(milliseconds: 2000), // faster
          //                               'Search Your Health Test Here...'),
          //                         ],
          //                       ),
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ),
          //           // Icon(Icons.keyboard_voice, color: Colors.grey),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // ResponsiveHelper.sizeBoxHeightSpace(context, 0.5),
        ],
      ),
    );
  }
}
