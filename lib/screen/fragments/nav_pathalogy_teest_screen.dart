import 'package:flutter/material.dart';
import 'package:healthians/base_widgets/common/nav_common_app_bar.dart';
import 'package:healthians/screen/nav/nav_lab/cell_nav_pathalogy_test_list_item.dart';
import 'package:healthians/ui_helper/app_colors.dart';
import 'package:provider/provider.dart';

import '../nav/nav_lab/controller/pathalogy_test_provider.dart';

class PathalogyNavSection extends StatefulWidget {
  PathalogyNavSection({super.key});

  @override
  State<PathalogyNavSection> createState() => _PathalogyNavSectionState();
}

class _PathalogyNavSectionState extends State<PathalogyNavSection> {


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
          child: Column(
            children: [
              // Header Row
              NavCommonAppBar(
                aciviyName: "Pathology Test",
                isNavigation: true,
                searchBarVisible: true,
                backgroundColor: AppColors.primary, // ✅ Change Background Color
                onSearchChanged: (query) {
                  Provider.of<PathalogyTestApiProvider>(context, listen: false)
                      .filterPathologyTestList(query);
                },
                // backgroundColor: AppColors.primary,
              ),
              Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                  child: CellNavLabListItem( ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
