import 'package:flutter/material.dart';
import 'package:shanya_scans/base_widgets/common/nav_common_app_bar.dart';
import 'package:shanya_scans/screen/nav/nav_lab/cell_nav_pathalogy_test_list_item.dart';
import 'package:shanya_scans/ui_helper/app_colors.dart';
import 'package:provider/provider.dart';

import '../nav/nav_lab/controller/pathalogy_test_provider.dart';
import '../splash/controller/network_provider_controller.dart';

class PathalogyNavSection extends StatefulWidget {
  PathalogyNavSection({super.key});

  @override
  State<PathalogyNavSection> createState() => _PathalogyNavSectionState();
}

class _PathalogyNavSectionState extends State<PathalogyNavSection> {


  bool _isInternetAvailable = true;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    _isInternetAvailable = Provider.of<NetworkProvider>(context).isConnected;
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
                child: _isInternetAvailable
                    ? Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                  child: CellNavLabListItem( ),
                )
                    : Center(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.wifi_off, size: 80, color: Colors.grey),
                        SizedBox(height: 20),
                        Text("No internet connection",
                            style: TextStyle(fontSize: 18)),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            Provider.of<NetworkProvider>(context,
                                listen: false)
                                .checkConnection(context, showSnackBar: true);
                          },
                          child: Text("Retry"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
