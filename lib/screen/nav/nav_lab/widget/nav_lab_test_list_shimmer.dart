import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../ui_helper/responsive_helper.dart';

class NavLabTestListShimmer extends StatelessWidget {
  final int itemCount;

  NavLabTestListShimmer({this.itemCount = 10}); // Default: 6 items
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ResponsiveHelper.containerWidth(context, 7),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 20, // Display 5 skeletons while loading
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: double.infinity,
                padding: ResponsiveHelper.padding(context, 3, 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),

              ),
            ),
          );
        },
      ),
    );;
  }
}
