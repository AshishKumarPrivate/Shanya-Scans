import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shanya_scans/bottom_navigation_screen.dart';
import 'package:shanya_scans/screen/nav/nav_home/slider/controller/home_banner_api_provider.dart';
import 'package:shanya_scans/ui_helper/responsive_helper.dart';
import 'package:provider/provider.dart';
import 'package:shanya_scans/util/image_loader_util.dart';
import 'package:shimmer/shimmer.dart';

class HomeSlider1Section extends StatefulWidget {
  final double? bannerImageHeight;

  HomeSlider1Section({this.bannerImageHeight, Key? key}) : super(key: key);

  @override
  State<HomeSlider1Section> createState() => _HomeSlider1SectionState();
}

class _HomeSlider1SectionState extends State<HomeSlider1Section> {
  int currentIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController(); // Use CarouselController

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(() {
      Provider.of<HomeBannerApiProvider>(context, listen: false)
          .loadCachedBanners();
    });
  }

  void _navigateToBottomNav(int index) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BottomNavigationScreen(initialPageIndex: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;

    double bannerImageHeight = widget.bannerImageHeight ??
        (isTablet
            ? MediaQuery.of(context).size.height * 0.25 // For tablets
            : MediaQuery.of(context).size.height * 0.18); // For mobile

    // Adjust viewportFraction for better tablet spacing
    double viewportFraction = isTablet ? 0.95 : 0.89; // Smaller fraction for wider items on tablet

    return Consumer<HomeBannerApiProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.homeBanner1ListModel == null) {
          return HomeSliderShimmer(bannerHeight: bannerImageHeight); // Pass height to shimmer
        } else if (provider.errorMessage.isNotEmpty) {
          return Center(
            child: SizedBox(
              width: ResponsiveHelper.containerWidth(context, 50),
              height: ResponsiveHelper.containerWidth(context, 50),
              child: Image.asset(
                "assets/images/img_error.jpg",
                fit: BoxFit.cover,
              ),
            ),
          );
        }

        final homeBannerList = provider.homeBanner1ListModel?.data ?? [];

        if (homeBannerList.isEmpty) {
          return Center(
            child: SizedBox(
              width: ResponsiveHelper.containerWidth(context, 50),
              height: ResponsiveHelper.containerWidth(context, 50),
              child: Image.asset(
                "assets/images/img_error.jpg",
                fit: BoxFit.cover,
              ),
            ),
          );
        }

        return Container(
          // No horizontal padding on this container to allow CarouselSlider to control it
          width: double.infinity,
          height: bannerImageHeight, // Ensure the parent container respects the height
          child: Column(
            children: [
              // No ResponsiveHelper.sizeBoxHeightSpace(context, 1) here to avoid extra top padding that could push content
              Expanded( // Ensure CarouselSlider takes available space
                child: CarouselSlider(
                  items: homeBannerList.map((item) {
                    return Container(

                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      // No explicit width/margin here, let CarouselSlider handle it
                      child: GestureDetector(
                        onTap: () {
                          int targetIndex = int.tryParse(item.index.toString()) ?? 0;
                          print("click banner1 index= $targetIndex");
                          if (targetIndex >= 0 && targetIndex <= 4) {
                            _navigateToBottomNav(targetIndex);
                          }
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: LayoutBuilder( // Use LayoutBuilder to get constraints
                            builder: (BuildContext context, BoxConstraints constraints) {
                              return ImageLoaderUtil.cacheNetworkImage(
                                item.photo!.secureUrl.toString(),
                                width: constraints.maxWidth, // Image takes full width of its parent
                                height: constraints.maxHeight, // Image takes full height of its parent
                                fit: BoxFit.fill, // Ensure the image fills the allocated space
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  carouselController: _controller,
                  options: CarouselOptions(
                    autoPlay: true,
                    viewportFraction: viewportFraction, // Use the adjusted viewportFraction
                    height: bannerImageHeight, // This height is crucial for the slider itself
                    enlargeCenterPage: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                  ),
                ),
              ),
              // Indicator dots (optional, but good for UX)
              // This is a common pattern for indicators, add if you need them
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: homeBannerList.asMap().entries.map((entry) {
              //     return GestureDetector(
              //       onTap: () => _controller.animateToPage(entry.key),
              //       child: Container(
              //         width: 8.0,
              //         height: 8.0,
              //         margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              //         decoration: BoxDecoration(
              //             shape: BoxShape.circle,
              //             color: (Theme.of(context).brightness == Brightness.dark
              //                 ? Colors.white
              //                 : Colors.black)
              //                 .withOpacity(currentIndex == entry.key ? 0.9 : 0.4)),
              //       ),
              //     );
              //   }).toList(),
              // ),
              ResponsiveHelper.sizeBoxHeightSpace(context, 1),
            ],
          ),
        );
      },
    );
  }
}

class HomeSliderShimmer extends StatelessWidget {
  final double? bannerHeight; // Added to make shimmer height responsive too

  HomeSliderShimmer({this.bannerHeight});

  @override
  Widget build(BuildContext context) {
    double shimmerHeight = bannerHeight ?? (MediaQuery.of(context).size.width > 600
        ? MediaQuery.of(context).size.height * 0.25
        : MediaQuery.of(context).size.height * 0.18);

    return Container(
      // Keep horizontal padding consistent with how the CarouselSlider is displayed
      width: double.infinity,
      height: shimmerHeight, // Use the responsive height for the shimmer container
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0), // Match carousel item margin
          decoration: BoxDecoration(
            color: Colors.grey[300], // Shimmer color
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}