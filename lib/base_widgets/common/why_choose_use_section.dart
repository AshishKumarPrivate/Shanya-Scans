import 'package:flutter/material.dart';
import '../../ui_helper/app_colors.dart';
import '../../ui_helper/app_text_styles.dart';
import '../../ui_helper/responsive_helper.dart';
import '../custom_rounded_container.dart';

class WhyChooseSection extends StatelessWidget {
  final List<WhyChooseItem> items;

  const WhyChooseSection({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveHelper.padding(context, 4, 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Why Choose Shanya Scans?",
            maxLines: 2,
            style: AppTextStyles.heading1(
              context,
              overrideStyle: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: ResponsiveHelper.fontSize(context, 16),
              ),
            ),
          ),
          ResponsiveHelper.sizeBoxHeightSpace(context, 1.5),
          ...items.map((item) => _buildWhyChooseItem(context, item)).toList(),
        ],
      ),
    );
  }

  Widget _buildWhyChooseItem(BuildContext context, WhyChooseItem item) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomRoundedContainer(
                borderRadius: 10.0,
                borderColor: Colors.white,
                borderWidth: 0.0,
                elevation: 5.0,
                backgroundColor: Colors.white,
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Icon(
                      item.icon,
                      color: AppColors.pinkColor,
                      size: 30,
                    ),
                    ResponsiveHelper.sizeboxWidthlSpace(context, 1),
                    Flexible(
                      child: Text(
                        item.title,
                        maxLines: 2,
                        style: AppTextStyles.heading1(
                          context,
                          overrideStyle: TextStyle(
                            color: AppColors.txtGreyColor,
                            fontSize: ResponsiveHelper.fontSize(context, 12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                onTap: item.onTap,
              ),
            ),
          ],
        ),
        ResponsiveHelper.sizeBoxHeightSpace(context, 1),
      ],
    );
  }
}

class WhyChooseItem {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  WhyChooseItem({required this.icon, required this.title, this.onTap});
}
