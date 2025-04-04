import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../ui_helper/app_colors.dart';

class RateListServiceShimmer extends StatelessWidget {
  final int itemCount;
  final double borderRadius;
  final double elevation;
  final Color borderColor;
  final double borderWidth;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color backgroundColor;

  RateListServiceShimmer({
    this.itemCount = 10,
    this.borderRadius = 10.0,
    this.elevation = 1.0,
    this.borderColor = Colors.grey,
    this.borderWidth = 0.0,
    this.padding = const EdgeInsets.all(10.0),
    this.margin = const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
    this.backgroundColor =
        Colors.white, // Keep card background same as original
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Card(
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(color: borderColor, width: borderWidth),
          ),
          margin: margin,
          color: backgroundColor,
          // Same as the original card
          child: Padding(
            padding: padding ?? EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Shimmer
                _shimmerContainer(height: 20, width: 150),
                SizedBox(height: 5),
                // Description Shimmer
                _shimmerContainer(height: 14, width: 200),
                SizedBox(height: 10),
                // Price and Buy Now Button Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Price Placeholder
                    _shimmerContainer(height: 18, width: 80),
                    // Buy Now Button Placeholder
                    _shimmerContainer(
                      height: 30,
                      width: 100,
                      borderRadius: 10.0,
                    ),
                  ],
                ),

                SizedBox(height: 10),

                Divider(color: AppColors.txtLightGreyColor.withOpacity(0.2)),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Timer Placeholder
                    _iconWithShimmer(width: 50),

                    // Report Time Placeholder
                    _iconWithShimmer( width: 50),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Shimmer Box (for text & buttons)
  Widget _shimmerContainer({
    required double height,
    required double width,
    double borderRadius = 5.0,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      period: Duration(seconds: 2),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey[300]!,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  // Icon with Shimmer Placeholder Text
  Widget _iconWithShimmer({required double width}) {
    return Row(
      children: [
        // Icon(icon, size: 18, color: Colors.grey),
        Container(width: 20,height: 20,color: Colors.grey[300]!,),
        SizedBox(width: 5),
        _shimmerContainer(height: 12, width: width),
      ],
    );
  }
}
