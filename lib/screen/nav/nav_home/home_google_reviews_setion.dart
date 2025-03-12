import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:healthians/ui_helper/responsive_helper.dart';
import 'package:healthians/ui_helper/app_text_styles.dart';
import 'package:healthians/base_widgets/custom_rounded_container.dart';

class HomeGoogleReviewSection extends StatefulWidget {
  final String? sectionHeading;

  HomeGoogleReviewSection({Key? key, this.sectionHeading}) : super(key: key);

  @override
  State<HomeGoogleReviewSection> createState() => _HomeGoogleReviewSectionState();
}

class _HomeGoogleReviewSectionState extends State<HomeGoogleReviewSection> {
  int _current = 0;
  final CarouselSliderController _carouselController = CarouselSliderController();

  // List of Google Review URLs
  final List<String> reviewUrls = [
    "https://widget.tagembed.com/2141048",
    "https://widget.tagembed.com/2141049",
    "https://widget.tagembed.com/2141050"
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveHelper.padding(context, 0, 0.8),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
            child: Text(
              widget.sectionHeading ?? "Our Reviews",
              style: AppTextStyles.heading1(
                context,
                overrideStyle: TextStyle(fontSize: ResponsiveHelper.fontSize(context, 14)),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // **Carousel with WebView Widgets**
          CarouselSlider.builder(
            itemCount: reviewUrls.length,
            itemBuilder: (context, index, realIndex) {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: CustomRoundedContainer(
                  borderRadius: 10,
                  borderColor: Colors.grey,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  borderWidth: 0.2,
                  elevation: 2,
                  backgroundColor: Colors.white,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      height: ResponsiveHelper.containerHeight(context, 40.0),
                      width: double.infinity,
                      child: ReviewWebView(url: reviewUrls[index]), // WebView inside slider
                    ),
                  ),
                ),
              );
            },
            carouselController: _carouselController,
            options: CarouselOptions(
              autoPlay: true,
              viewportFraction: 0.85,
              height: ResponsiveHelper.containerHeight(context, 42.0),
              enlargeCenterPage: true,
              enableInfiniteScroll: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
          ),

          // **Dots Indicator**
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(reviewUrls.length, (index) {
              return GestureDetector(
                onTap: () => _carouselController.animateToPage(index),
                child: Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (_current == index ? Colors.black : Colors.grey).withOpacity(0.6),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// **Separate Stateful Widget for WebView**
class ReviewWebView extends StatefulWidget {
  final String url;
  ReviewWebView({required this.url});

  @override
  _ReviewWebViewState createState() => _ReviewWebViewState();
}

class _ReviewWebViewState extends State<ReviewWebView> {
  late WebViewController _controller;
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..loadRequest(Uri.parse(widget.url))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            setState(() {
              isLoading = false;
            });
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (isLoading)
          Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
