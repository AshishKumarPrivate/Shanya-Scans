import 'package:flutter/material.dart';
import 'package:shanya_scans/base_widgets/loading_indicator.dart';
import 'package:shanya_scans/screen/nav/nav_lab/controller/pathalogy_test_provider.dart';
import 'package:shanya_scans/screen/nav/nav_lab/model/PathalogyTestListModel.dart';
import 'package:shanya_scans/screen/nav/nav_lab/nav_pathalogy_test_detail.dart';
import 'package:shanya_scans/ui_helper/responsive_helper.dart';
import 'package:provider/provider.dart';
import 'package:shanya_scans/util/StringUtils.dart';

import '../../../ui_helper/app_colors.dart';
import '../../../ui_helper/app_text_styles.dart';
import '../../splash/controller/network_provider_controller.dart';

class CellNavLabListItem extends StatefulWidget {


  @override
  State<CellNavLabListItem> createState() => _CellNavLabListItemState();
}

class _CellNavLabListItemState extends State<CellNavLabListItem> {
  final double circleRadius = 60.0;
  final ScrollController _scrollController = ScrollController();

  bool _isInternetAvailable = true;

  Future<void> _initializeNetworkAndLoadData() async {
    final networkProvider =
    Provider.of<NetworkProvider>(context, listen: false);
    networkProvider.initializeConnectivityListener(context);
    await networkProvider.checkConnection(context, showSnackBar: false);
    final isConnected = networkProvider.isConnected;
    if (isConnected) {
      _loadCachedData();
    }
    setState(() {
      _isInternetAvailable = isConnected;
    });
  }

  void _loadCachedData() {
    Provider.of<PathalogyTestApiProvider>(context, listen: false)
        .loadCachedNavPathalogyTests(context, forceReload: false);
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // Provider.of<PathalogyTestApiProvider>(context, listen: false)
      //     .loadCachedNavPathalogyTests(context, forceReload: true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initializeNetworkAndLoadData();
      });
    });
    // Scroll listener for pagination
    _scrollController.addListener(() {
      final provider = Provider.of<PathalogyTestApiProvider>(context, listen: false);
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200 ) {
        provider.getPathalogyTestList(context, loadMore: true);
      }
    });
  }

  Future<void> _refreshData() async {
    await  Provider.of<PathalogyTestApiProvider>(context, listen: false)
        .refreshgetPathalogyTestList(context);

    print("refresh data is loaded");

  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Consumer<PathalogyTestApiProvider>(
          builder: (context, provider, child) {
        // Check if the loading state is true
        if (provider.isLoading && provider.filteredPathalogyTests.isEmpty) {
          return loadingIndicator(); // Show shimmer effect while loading
        }

        // Check if there was an error
        if (provider.errorMessage.isNotEmpty) {
          return _buildErrorWidget(); // Show error widget if there's an error
        }

        // Check if the data is null or empty
        if (provider.filteredPathalogyTests.isEmpty) {
          return _buildEmptyListWidget(); // Show empty list widget if data is null or empty
        }

        // If data is loaded, display the rate list
        return _buildPathalogyList(provider.filteredPathalogyTests, provider);
      }),
    );
  }

  Widget _buildErrorWidget() {
    print("ErrorWidget");
    return Center(
      child: SizedBox(
        width: ResponsiveHelper.containerWidth(context, 50),
        height: ResponsiveHelper.containerWidth(context, 50),
        child: Image.asset(
          "assets/images/img_error.jpg",
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildEmptyListWidget() {
    print("EmptyList");
    return Center(
      child: SizedBox(
        width: ResponsiveHelper.containerWidth(context, 50),
        height: ResponsiveHelper.containerWidth(context, 50),
        child: Image.asset(
          "assets/images/img_error.jpg",
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildPathalogyList(
      List<Allpathology> pathalogyTestList, PathalogyTestApiProvider provider) {
    print("BuildRateList ");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child:  _isInternetAvailable
          ? RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView.builder(
          controller: _scrollController, // Attach scroll controller
          scrollDirection: Axis.vertical,
          itemCount: provider.filteredPathalogyTests.length +
              (provider.isFetchingMore ? 1 : 0),
          // itemCount: pathalogyTestList.length,
          itemBuilder: (context, index) {
            if (index == provider.filteredPathalogyTests.length) {
              return  loadingIndicator(); // Show loader
            }
            final item = provider.filteredPathalogyTests[index];
            EdgeInsets itemPadding = EdgeInsets.only(
              top: index == 0 ? 8.0 : 0.0,
              // Extra padding for first item
              bottom: index == pathalogyTestList.length - 1 ? 8.0 : 0.0,
              // Extra padding for last item
              left: 0.0,
              right: 0.0,
            );
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewDetailPathalogyTestScreen(
                      patahlogyTestName: item.testDetailName.toString(),
                      pathalogyTestSlug: item.slug.toString(),
                    ),
                  ),
                );
                print(
                    "Test naem => ${item.testDetailName}  Test Slug => ${item.slug} ");
              },
              splashColor: AppColors.whiteColor,
              highlightColor: AppColors.whiteColor,
              child: Padding(
                padding: itemPadding,
                child: Card(
                  color: AppColors.primary,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 0.0,
                    vertical: 8.0,
                  ),
                  shape: RoundedRectangleBorder(
                      // side: BorderSide(
                      //     color: AppColors.txtLightGreyColor, width: 0.2),
                      borderRadius: BorderRadius.circular(5.0),
                      side:
                          BorderSide(color: AppColors.txtGreyColor, width: 0.12)),
                  elevation: 0,
                  // Elevation for shadow effect
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            // color: AppColors.pinkColor,
                            colors: [Color(0xFFF9F7F4), Color(0xFFF1FBFC)],
                            // Lighter shades
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            stops: [0.4, 0.7],
                            tileMode: TileMode.repeated,
                          ),
                          // image: DecorationImage(
                          //     fit: BoxFit.fill,
                          //     image: AssetImage("assets/images/pattern7.png")),
                          // color: AppColors.lightYellowColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 15),
                        child: Text(
                          StringUtils.toUpperCase(item.testDetailName.toString()),
                          // '${category['title']} (${category['count']})',
                          style: AppTextStyles.heading1(context,
                              overrideStyle: TextStyle(
                                  fontSize:
                                      ResponsiveHelper.fontSize(context, 12))),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
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

    );
  }
}
