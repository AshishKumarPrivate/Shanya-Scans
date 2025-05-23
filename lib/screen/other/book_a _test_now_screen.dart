import 'package:flutter/material.dart';
import 'package:shanya_scans/screen/checkout/CheckoutScreen.dart';
import 'package:shanya_scans/screen/nav/nav_lab/model/PathalogyTestListModel.dart';
import 'package:shanya_scans/ui_helper/responsive_helper.dart';
import 'package:shanya_scans/ui_helper/app_text_styles.dart';
import 'package:shanya_scans/base_widgets/custom_rounded_container.dart';
import 'package:provider/provider.dart';
import 'package:html/parser.dart'; // Import required package
import 'package:shanya_scans/util/image_loader_util.dart';
import '../../base_widgets/common/custom_app_bar.dart';
import '../../base_widgets/custom_text_field.dart';
import '../../base_widgets/loading_indicator.dart';
import '../../base_widgets/solid_rounded_button.dart';
import '../../ui_helper/app_colors.dart';
import '../checkout/controller/checkout_api_provider.dart';
import '../nav/nav_lab/controller/pathalogy_test_provider.dart';
import '../order/model/OrderItem.dart';

class BookATestNowScreen extends StatefulWidget {
  final String name;

  BookATestNowScreen({required this.name});

  @override
  State<BookATestNowScreen> createState() => _BookATestNowScreenState();
}

class _BookATestNowScreenState extends State<BookATestNowScreen> {
  bool isFormVisible = false;

  final ScrollController _scrollController = ScrollController();
  // Boolean to show the test list container
  bool _isTestListVisible = true;
  // List of tests after filtering
  List<Map<String, String>> _filteredTests = [];
  // Selected tests
  List<Allpathology> _selectedTests = [];

  // Controller for the search text field
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> getTotalTests() {
    List<Map<String, dynamic>> selectedTestsList = [];

    if (_selectedTests.isEmpty) {
      print("No tests selected.");
      return selectedTestsList;
    }

    for (Allpathology test in _selectedTests) {
      selectedTestsList.add({
        "name": test.testDetailName ?? "Unknown Test",
        "price": test.testPrice ?? 0,
      });
    }

    print("Selected Tests: $selectedTestsList");
    return selectedTestsList;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // Clear old data and fetch new service details
      Provider.of<PathalogyTestApiProvider>(context, listen: false)
          .loadCachedNavPathalogyTests(context, forceReload: true);
    });

    if (_scrollController.hasClients || !_scrollController.hasListeners) {
      _scrollController.addListener(() {
        final provider = Provider.of<PathalogyTestApiProvider>(context, listen: false);
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 ) {
          provider.getPathalogyTestList(context, loadMore: true);
        }
      });
    }


  }

  // Toggle the visibility of the test list
  void _toggleTestList() {
    setState(() {
      _isTestListVisible = !_isTestListVisible;
    });
  }

  // Handle the selection or deselection of a test
  // void _toggleSelection(String test) {
  //   setState(() {
  //     if (_selectedTests.contains(test)) {
  //       _selectedTests.remove(test); // Deselect if already selected
  //     } else {
  //       _selectedTests.add(test); // Add to selected tests
  //     }
  //   });
  // }
  // Toggle selection function
  void _toggleSelection(Allpathology test) {
    setState(() {
      if (_selectedTests.contains(test)) {
        _selectedTests.remove(test);
      } else {
        _selectedTests.add(test);
      }
    });
  }

  double getTotalPrice() {
    double total = 0.0;
    for (Allpathology test in _selectedTests) {
      total += (test.testPrice ?? 0).toDouble(); // Directly access price
    }

    return total;
  }


  // Remove the selected test
  void _removeSelectedTest(Allpathology test) {
    setState(() {
      _selectedTests.remove(test);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PathalogyTestApiProvider>(context);
    final tests = provider.filteredPathalogyTests;


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60), // Adjust height as needed
        child:  CustomAppBar(
          activityName: "Home Collections",
          isCartScreen: true,
          backgroundColor: AppColors.primary,
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AppBar
            // CustomAppBar(
            //   activityName: "Home Collections",
            //   isCartScreen: true,
            //   backgroundColor: AppColors.primary,
            // ), // Main Content
            Expanded(
              child: Container(
                color: AppColors.whiteColor,
                child: SingleChildScrollView(
                  // padding: EdgeInsets.all(10.0),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
                    child: Container(
                      color: AppColors.whiteColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Package Title
                          SizedBox(height: 15),
                          Text(
                            'Book Home Collection',
                            style: AppTextStyles.heading1(context,
                                overrideStyle: TextStyle(
                                    fontSize: ResponsiveHelper.fontSize(
                                        context, 16))),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '(Applicable for pathology test only)',
                            style: AppTextStyles.bodyText1(
                              context,
                              overrideStyle: AppTextStyles.heading2(context,
                                  overrideStyle: TextStyle(
                                      color: AppColors.txtLightGreyColor,
                                      fontSize: ResponsiveHelper.fontSize(
                                          context, 12))),
                            ),
                          ),
                          SizedBox(height: 15),
                          InkWell(
                            onTap: () {
                              setState(() {
                                isFormVisible = false;
                              });
                            },
                            child: Text(
                              'Step 1: Search and Select Tests',
                              style: AppTextStyles.heading1(context,
                                  overrideStyle: TextStyle(
                                      color: isFormVisible
                                          ? AppColors.txtGreyColor
                                          : AppColors.primary,
                                      fontSize: ResponsiveHelper.fontSize(
                                          context, 12))),
                            ),
                          ),
                          SizedBox(height: 8),
                          InkWell(
                            onTap: () {
                              setState(() {
                                isFormVisible = true;
                              });
                            },
                            child: Visibility(
                              visible: isFormVisible ? true : false,
                              child: Text(
                                'Step 2: Fill Booking Details',
                                style: AppTextStyles.heading1(context,
                                    overrideStyle: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: ResponsiveHelper.fontSize(
                                            context, 12))),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Visibility(
                            visible: isFormVisible ? false : true,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0),
                                  child: Text(
                                    "Search for tests",
                                    style: AppTextStyles.heading2(
                                      context,
                                      overrideStyle: TextStyle(
                                          fontSize: ResponsiveHelper.fontSize(
                                              context, 14)),
                                    ),
                                  ),
                                ),
                                CustomRoundedContainer(
                                  borderRadius: 5.0,
                                  borderColor: Colors.black,
                                  borderWidth: 0.1,
                                  elevation: 3.0,
                                  backgroundColor: Colors.white,
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: _toggleTestList,
                                        child: CustomTransparentTextField(
                                          controller: _searchController,
                                          hintText:
                                              "Enter tests eg CBC, Fever profile etc",
                                          keyboardType: TextInputType.name,
                                          onChanged: (query) {
                                            Provider.of<PathalogyTestApiProvider>(context, listen: false)
                                                .filterPathologyTestList(query);
                                          },

                                          // controller: mobileController,
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    print("Container tapped!");
                                  },
                                ),
                                SizedBox(height: 10),
                                // Show test list if the flag is true
                                if (_isTestListVisible)
                                  Container(
                                    height: 260,
                                    child: Consumer<PathalogyTestApiProvider>(
                                        builder: (context, provider, child) {
                                      // Check if the loading state is true
                                      if (provider.isLoading &&
                                          provider.filteredPathalogyTests
                                              .isEmpty) {
                                        return loadingIndicator(); // Show shimmer effect while loading
                                      }
                                      // Check if there was an error
                                      if (provider.errorMessage.isNotEmpty) {
                                        return _buildErrorWidget(); // Show error widget if there's an error
                                      }
                                      // Check if the data is null or empty
                                      // if (provider.pathalogyTestListModel
                                      //             ?.Allpathology ==
                                      //         null ||
                                      //     provider.pathalogyTestListModel!
                                      //         .Allpathology!.isEmpty) {
                                      //   return _buildEmptyListWidget(); // Show empty list widget if data is null or empty
                                      // }
                                      // If data is loaded, display the rate list
                                      return _buildPathalogyList(
                                          provider.filteredPathalogyTests,
                                          provider);
                                    }),
                                  ),
                                SizedBox(height: 20),

                                // Display the selected tests below with the remove option
                                if (_selectedTests.isNotEmpty)
                                  _buildSelectedTestsList(),
                              ],
                            ),
                          ),
                          // &&&&&&&&&&&&&&&&&&&&& Form for book a test now  start here  &&&&&&&&&&
                          Visibility(
                            visible: isFormVisible ? true : false,
                            child: _buildTestSelectionForm(),
                          ),
                          // &&&&&&&&&&&&&&&&&&&&& Form for book a test now  end here  &&&&&&&&&&
                          SizedBox(
                            height: 15,
                          ),

                          // ***************** SOLID ROUNDED SUBMIT BUTTON START HERE ******************
                        if(_selectedTests.length!=0)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: SolidRoundedButton(
                              text: 'Proceed to Payment',
                              color: AppColors.primary,
                              borderRadius: 10.0,
                              onPressed: () async {
                                /// Function to extract plain text from an HTML string
                                /// Function to extract plain text from an HTML string
                                String extractPlainText(
                                    String htmlString) {
                                  var document = parse(htmlString);
                                  return document.body?.text ?? "";
                                }

                                List<OrderItem> orderItems =
                                _selectedTests.map((testItem) {
                                  return OrderItem(
                                    id: testItem.sId ?? "", // Use actual ID from cart item
                                    name: testItem.testDetailName ?? "",
                                    orderType: "home collection",
                                    category: testItem.testDetailName ?? "",
                                    price: double.parse( testItem.testPrice.toString()),
                                    imageUrl:OrderItem.defaultImage,
                                    packageDetail: extractPlainText(testItem.testRequirement1.toString()), // Extract text from HTML
                                    quantity: 1,
                                  );
                                }).toList();

                                // ✅ Add all orderItems to CheckoutProvider before navigating
                                Provider.of<CheckoutProvider>(context, listen: false).addMultipleToCheckout( context, orderItems);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CheckoutScreen(),
                                  ),
                                );

                              },
                              textStyle: TextStyle(
                                  color: Colors.white, fontSize: 18),
                              // icon: Icon(Icons.touch_app, color: Colors.white),
                            ),
                          ),

                          SizedBox(
                            height: 15,
                          ),
                          // ***************** SOLID ROUNDED SUBMIT BUTTON END HERE ******************
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Footer Section
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    print("ErrorWidget");
    return Center(
      child: SizedBox(
        width: ResponsiveHelper.containerWidth(context, 50),
        height: ResponsiveHelper.containerWidth(context, 50),
        child: ImageLoaderUtil.assetImage(
          "assets/images/img_error.jpg",
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
        child: ImageLoaderUtil.assetImage(
          "assets/images/img_error.png",
        ),
      ),
    );
  }

  Widget _buildPathalogyList(
      List<Allpathology> pathalogyTestList, PathalogyTestApiProvider provider) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: Scrollbar(
          thumbVisibility: true, // Ensures the scrollbar is always visible when scrolling
          child: ListView.builder(
            controller: _scrollController, // Attach scroll controller
            itemCount:provider.filteredPathalogyTests.length + (provider.isFetchingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == provider.filteredPathalogyTests.length) {
                return loadingIndicator(); // Show loader
              }
              final test = pathalogyTestList[index];
          
              return ListTile(
                title: Text(
                  "${test.testDetailName ?? ''}  -  ₹${test.testPrice ?? 0}",
                  style: AppTextStyles.heading1(context,
                      overrideStyle: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(context, 12))),
                ),
          
                // FIXED: Now checks if the test object exists in `_selectedTests`
                trailing: Checkbox(
                  value: _selectedTests.contains(test), // Compare full object, not name
                  onChanged: (bool? value) {
                    _toggleSelection(test);
                  },
                ),
                onTap: () {
                  _toggleSelection(test);
                },
              );
            },
          ),
        ),
      ),
    );
  }


  Widget _buildSelectedTestsList() {
    List<Allpathology> selectedTests = _selectedTests; // Use your actual selected tests list

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Selected Tests:",
            style: AppTextStyles.heading1(
              context,
              overrideStyle: TextStyle(fontSize: ResponsiveHelper.fontSize(context, 12)),
            ),
          ),
          if (selectedTests.isEmpty)
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text("No tests selected"),
            ),
          ...selectedTests.map((test) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      test.testDetailName ?? "",
                      style: AppTextStyles.bodyText1(
                        context,
                        overrideStyle: TextStyle(
                          color: Colors.black,
                          fontSize: ResponsiveHelper.fontSize(context, 12),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "₹${test.testPrice?.toStringAsFixed(2) ?? '0.00'}",
                    style: AppTextStyles.bodyText1(
                      context,
                      overrideStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontSize: ResponsiveHelper.fontSize(context, 12),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      _removeSelectedTest(test); // Remove test from selected list
                    },
                  ),
                ],
              ),
            );
          }).toList(),
          Divider(thickness: 1),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Price:",
                  style: AppTextStyles.heading1(
                    context,
                    overrideStyle: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(context, 14),
                    ),
                  ),
                ),
                Text(
                  "₹${getTotalPrice().toStringAsFixed(2)}",
                  style: AppTextStyles.heading1(
                    context,
                    overrideStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontSize: ResponsiveHelper.fontSize(context, 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildTestSelectionForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Selected Test",
            style: AppTextStyles.heading1(
              context,
              overrideStyle:
                  TextStyle(fontSize: ResponsiveHelper.fontSize(context, 14)),
            ),
          ),
          ..._selectedTests.map((test) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 0),
              child: Column(
                children: [
                  Text(
                    "$test",
                    style: AppTextStyles.bodyText1(
                      context,
                      overrideStyle: TextStyle(
                        color: Colors.black,
                        fontSize: ResponsiveHelper.fontSize(context, 12),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          }).toList(),
          Text(
            "Total Price: ₹${getTotalPrice().toStringAsFixed(2)}",
            style: AppTextStyles.heading1(
              context,
              overrideStyle: TextStyle(
                color: AppColors.primary,
                fontSize: ResponsiveHelper.fontSize(context, 14),
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
