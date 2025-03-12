import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HealthConcernDetailShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Top Blue Card Shimmer
          SizedBox(height: 10),
          _buildShimmerBox(height: 100, width: double.infinity, borderRadius: 10, color: Colors.blueGrey),
          SizedBox(height: 10),

          // Description Shimmer
          _buildShimmerBox(height: 14, width: 200),
          SizedBox(height: 5),
          _buildShimmerBox(height: 14, width: 250),
          SizedBox(height: 15),

          // Grid Shimmer
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(6, (index) => _buildShimmerGridItem()),
          ),

          SizedBox(height: 15),
          // Call & Book Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildShimmerBox(height: 40, width: 120, borderRadius: 10),
              _buildShimmerBox(height: 40, width: 120, borderRadius: 10),
            ],
          ),
          SizedBox(height: 15),

          // Why Choose Section
          _buildShimmerBox(height: 18, width: 180),
          SizedBox(height: 10),
          Column(
            children: List.generate(4, (index) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildShimmerBox(height: 40, width: double.infinity, borderRadius: 10),
            )),
          ),

          SizedBox(height: 15),
          // Instruction Section
          _buildShimmerBox(height: 40, width: double.infinity, borderRadius: 10, color: Colors.blueGrey),
          SizedBox(height: 10),
          Column(
            children: List.generate(4, (index) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildShimmerBox(height: 14, width: double.infinity),
            )),
          )],
      ),
    );
  }

  Widget _buildShimmerBox({
    double height = 20,
    double width = 100,
    double borderRadius = 5,
    Color color = Colors.grey,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  Widget _buildShimmerGridItem() {
    return Container(
      width: 150,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          _buildShimmerBox(height: 30, width: 30, borderRadius: 30),
          SizedBox(height: 5),
          _buildShimmerBox(height: 20, width: 80),
        ],
      ),
    );
  }
}
