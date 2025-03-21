import 'package:flutter/material.dart';
import 'package:healthians/screen/nav/nav_home/health_concern/controller/health_concern_provider.dart';
import 'package:healthians/screen/nav/nav_home/health_concern/screen/health_concern_detail.dart';
import 'package:healthians/screen/nav/nav_lab/nav_pathalogy_test_detail.dart';
import 'package:provider/provider.dart';

import '../../../base_widgets/common/scans_service_shimmer.dart';
import '../../../ui_helper/app_colors.dart';
import '../../../ui_helper/app_text_styles.dart';
import '../../../ui_helper/responsive_helper.dart';

class HealthConcernSetion extends StatefulWidget {
  @override
  State<HealthConcernSetion> createState() => _HealthConcernSetionState();
}

class _HealthConcernSetionState extends State<HealthConcernSetion> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<HealthConcernApiProvider>(context, listen: false)
          .getHealthConcernTagList(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = 4;
    final spacing = 8.0;
    final itemWidth = (screenWidth - (crossAxisCount - 1) * spacing) / crossAxisCount;
    final itemHeight = itemWidth * 1.08;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text(
                "Browse By Health Concern",
                style: AppTextStyles.heading1(context,
                    overrideStyle: TextStyle(fontSize: ResponsiveHelper.fontSize(context, 14))),
              ),
              Text(
                "Make packages under one roof",
                style: AppTextStyles.bodyText1(context,
                    overrideStyle: TextStyle(fontSize: ResponsiveHelper.fontSize(context, 12))),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Consumer<HealthConcernApiProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return ScansServiceShimmer();
              }
              else if (provider.errorMessage.isNotEmpty) {
                return Center(
                  child: SizedBox(
                    width: ResponsiveHelper.containerWidth(
                        context, 50),
                    height: ResponsiveHelper.containerWidth(
                        context, 50),
                    child: Image.asset(
                      "assets/images/img_error.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }
              final healthConcernList = provider.healthConcernPackageTagListModel?.data;
              if (healthConcernList == null || healthConcernList.isEmpty) {
                return Center(
                  child: SizedBox(
                    width: ResponsiveHelper.containerWidth(
                        context, 50),
                    height: ResponsiveHelper.containerWidth(
                        context, 50),
                    child: Image.asset(
                      "assets/images/img_error.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: provider.healthConcernPackageTagListModel!.data!.length,
                itemBuilder: (context, index) {
                  final item = provider.healthConcernPackageTagListModel!.data![index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewDetailHealthConcernScreen(
                            packageName:item.packageTagName.toString() ,
                            packageSlug: item.packageSlugName.toString() ,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: ResponsiveHelper.containerWidth(context, 18),
                            height: ResponsiveHelper.containerWidth(context, 18),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.lightBlueColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: ClipOval(
                                child: Image.network(
                                  item.icon?.secureUrl ?? '', // ✅ Null-safe access
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.broken_image, size: 40),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Flexible(
                            child: Text(
                              item.packageTagName.toString(),
                              style: TextStyle(
                                fontSize: ResponsiveHelper.fontSize(context, 11),
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
