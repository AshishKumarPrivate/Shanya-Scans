import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../ui_helper/responsive_helper.dart';

class HomePackageTabListShimmer extends StatelessWidget {
  final int itemCount;

  HomePackageTabListShimmer({this.itemCount = 10}); // Default: 6 items
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ResponsiveHelper.containerWidth(context, 7),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5, // Display 5 skeletons while loading
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 16 : 8,
              right: index == 4 ? 16 : 0,
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                padding: ResponsiveHelper.padding(context, 3, 0.6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: SizedBox(
                  width: 80,
                  height: 30,
                ),
              ),
            ),
          );
        },
      ),
    );;
  }
}
