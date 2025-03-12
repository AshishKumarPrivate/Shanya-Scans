import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../base_widgets/card_body.dart';
import '../../../ui_helper/responsive_helper.dart';

class HomePackageListShimmer extends StatelessWidget {
  final int itemCount;

  HomePackageListShimmer({this.itemCount = 10}); // Default: 6 items
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: SizedBox(
        height: ResponsiveHelper.containerWidth(context, 70),
        child:  ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(
                left: index == 0 ? 10 : 5.0,
                right: index == itemCount - 1
                    ? 10
                    : 5.0,
              ),
              child: CardBody(
                width: ResponsiveHelper.containerWidth(context, 50),
                height: ResponsiveHelper.containerHeight(context, 200),
                index: 0,
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image placeholder
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: double.infinity,
                          height: ResponsiveHelper.containerWidth(context, 30),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),

                    // Package name placeholder
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 12,
                          width: ResponsiveHelper.containerWidth(context, 30),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),

                    // Parameter info placeholder
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Row(
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 80,
                              height: 10,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),

                    // Report time placeholder
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Row(
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 120,
                              height: 10,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),

                    // Price placeholder
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Row(
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: ResponsiveHelper.containerWidth(context, 10),
                              height: ResponsiveHelper.containerWidth(context, 5),
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10),
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: ResponsiveHelper.containerWidth(context, 10),
                              height: ResponsiveHelper.containerWidth(context, 5),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                   ResponsiveHelper.sizeBoxHeightSpace(context, 2),

                    // Button placeholder
                    Expanded(
                      flex: 10,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: double.infinity,
                          height: 35,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
