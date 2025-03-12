import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:healthians/screen/nav/nav_home/frquently_pathalogy_test/controller/frequently_pathalogy_test_provider.dart';
import 'package:healthians/ui_helper/responsive_helper.dart';
import 'package:healthians/ui_helper/app_colors.dart';
import 'package:healthians/ui_helper/app_text_styles.dart';
import 'package:provider/provider.dart';

import '../../../base_widgets/common/frequently_lab_test_shimmer.dart';
import '../nav_lab/nav_pathalogy_test_detail.dart';

class HomeLabTestSection extends StatefulWidget {
  final String? sectionHeading;

  HomeLabTestSection({required this.sectionHeading});

  @override
  State<HomeLabTestSection> createState() => _HomeLabTestSectionState();
}

class _HomeLabTestSectionState extends State<HomeLabTestSection> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(() {
      Provider.of<FrequentlyPathalogyTagApiProvider>(context, listen: false)
          .loadCachedFrequentlyHomeLabTest();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FrequentlyPathalogyTagApiProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.frequentlyPathalogyTagListModel== null) {
          return FrequentlyLabTestShimmer();
        } else if (provider.errorMessage.isNotEmpty) {
          return Center(
              child: Text(provider.errorMessage,
                  style: TextStyle(color: Colors.red)));
        }

        final pathologyTestList =
            provider.frequentlyPathalogyTagListModel?.data ?? [];

        if (pathologyTestList.isEmpty) {
          return Center(child: Text("No health concerns available"));
        }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          width: double.infinity,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFffff),
                  Color(0xFFffff),
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                stops: [0.4, 0.7],
                tileMode: TileMode.repeated,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    widget.sectionHeading ?? "",
                    style: AppTextStyles.heading1(
                      context,
                      overrideStyle: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(context, 14)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CarouselSlider(
                  items: pathologyTestList.map((item) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewDetailPathalogyTestScreen(
                              patahlogyTestName: item.labTagName.toString(),
                              pathalogyTestSlug: item.labSlugName.toString(),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: ResponsiveHelper.containerWidth(
                                        context, 17),
                                    // height: ResponsiveHelper.containerWidth(
                                    //     context, 17),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.whiteColor
                                              .withAlpha(150),
                                          blurRadius: 10,
                                          spreadRadius: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      item.icon!.secureUrl.toString(),
                                      width: double.infinity,
                                      height: ResponsiveHelper.containerWidth(
                                          context, 30),
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(Icons.broken_image,
                                            color: Colors.grey);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // ResponsiveHelper.sizeBoxHeightSpace(context, 0.5),
                            // Text(
                            //   item.labTagName ?? "",
                            //   style: AppTextStyles.heading1(
                            //     context,
                            //     overrideStyle: TextStyle(
                            //         fontSize:
                            //         ResponsiveHelper.fontSize(context, 12)),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  carouselController: _controller,
                  options: CarouselOptions(
                    enableInfiniteScroll: false,
                    viewportFraction: 0.33,
                    height: ResponsiveHelper.containerWidth(context, 30),
                    enlargeCenterPage: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 2),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                        if (_current == pathologyTestList.length - 2) {
                          Future.delayed(Duration(milliseconds: 600), () {
                            _controller.animateToPage(
                              1,
                              duration: Duration(milliseconds: 600),
                              curve: Curves.easeInOut,
                            );

                            setState(() {
                              _current = 1;
                            });
                          });
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
    );
  }
}
