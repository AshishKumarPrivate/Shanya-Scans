import 'package:flutter/material.dart';
import 'package:healthians/screen/checkout/CheckoutScreen.dart';
import 'package:healthians/screen/nav/nav_lab/model/PathalogyTestListModel.dart';
import 'package:healthians/ui_helper/responsive_helper.dart';
import 'package:healthians/ui_helper/app_text_styles.dart';
import 'package:healthians/base_widgets/custom_rounded_container.dart';
import 'package:provider/provider.dart';
import 'package:html/parser.dart'; // Import required package
import '../../base_widgets/common/custom_app_bar.dart';
import '../../base_widgets/custom_text_field.dart';
import '../../base_widgets/gender_selection_screen.dart';
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

  // Boolean to show the test list container
  bool _isTestListVisible = true;

  final List<Map<String, String>> _tests = [
    {"test": "2 D ECHO", "price": "1800"},
    {"test": "TMT TEST", "price": "2000"},
    {"test": "ECG", "price": "300"},
    {"test": "ECHO (below 6 yrs)", "price": "2500"},
    {"test": "NCV ALL FOUR LIMBS", "price": "5500"},
    {"test": "EEG", "price": "2100"},
    {"test": "TIFFA (TWINS)", "price": "4500"},
    {"test": "Karyotype+Qfpcr", "price": "14000"},
    {"test": "FETAL ECHO TWINS", "price": "6000"},
    {"test": "Single reduction", "price": "14000"},
    {"test": "Microarray 750k", "price": "23000"},
    {"test": "REDUCTION", "price": "20000"},
    {"test": "TWINS REDUCATION", "price": "16000"},
    {"test": "dIAGNOSTIC TAPPING", "price": "3000"},
  ];

  List<Map<String, dynamic>> getTotalTests() {
    List<Map<String, dynamic>> selectedTestsList = [];

    if (_selectedTests.isEmpty) {
      print("No tests selected.");
      return selectedTestsList;
    }

    for (Data test in _selectedTests) {
      selectedTestsList.add({
        "name": test.testDetailName ?? "Unknown Test",
        "price": test.testPrice ?? 0,
      });
    }

    print("Selected Tests: $selectedTestsList");
    return selectedTestsList;
  }


  // List of tests after filtering
  List<Map<String, String>> _filteredTests = [];
  // Selected tests
  List<Data> _selectedTests = [];

  // Controller for the search text field
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // Clear old data and fetch new service details
      Provider.of<PathalogyTestApiProvider>(context, listen: false)
          .loadCachedNavPathalogyTests(context);
    });

    // Listen to search input
    _searchController.addListener(() {
      Provider.of<PathalogyTestApiProvider>(context, listen: false)
          .filterPathologyTestList(_searchController.text);
    });
  }

  void _filterTests() {
    setState(() {
      if (_searchController.text.isEmpty) {
        _filteredTests = List.from(_tests);
      } else {
        _filteredTests = _tests
            .where((test) =>
                test["test"]!
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase()) ||
                test["price"]!.contains(_searchController.text))
            .toList();
      }
    });
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
  void _toggleSelection(Data test) {
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
    for (Data test in _selectedTests) {
      total += (test.testPrice ?? 0).toDouble(); // Directly access price
    }

    return total;
  }


  // Remove the selected test
  void _removeSelectedTest(Data test) {
    setState(() {
      _selectedTests.remove(test);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PathalogyTestApiProvider>(context);
    final tests = provider.filteredPathalogyTest;


    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AppBar
              CustomAppBar(
                activityName: "Home Collections",
                isCartScreen: true,
                backgroundColor: AppColors.primary,
              ), // Main Content
              Expanded(
                child: Container(
                  color: AppColors.whiteColor,
                  child: SingleChildScrollView(
                    // padding: EdgeInsets.all(10.0),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
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
                                            // controller: mobileController,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      print("Container tapped!");
                                    },
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),

                                  SizedBox(height: 20),

                                  // Show test list if the flag is true
                                  if (_isTestListVisible)
                                    Container(
                                      height: 260,
                                      child: Consumer<PathalogyTestApiProvider>(
                                          builder: (context, provider, child) {
                                        // Check if the loading state is true
                                        if (provider.isLoading &&
                                            provider.filteredPathalogyTest
                                                .isEmpty) {
                                          return loadingIndicator(); // Show shimmer effect while loading
                                        }
                                        // Check if there was an error
                                        if (provider.errorMessage.isNotEmpty) {
                                          return _buildErrorWidget(); // Show error widget if there's an error
                                        }
                                        // Check if the data is null or empty
                                        if (provider.pathalogyTestListModel
                                                    ?.data ==
                                                null ||
                                            provider.pathalogyTestListModel!
                                                .data!.isEmpty) {
                                          return _buildEmptyListWidget(); // Show empty list widget if data is null or empty
                                        }
                                        // If data is loaded, display the rate list
                                        return _buildPathalogyList(
                                            provider.filteredPathalogyTest,
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
                            SolidRoundedButton(
                              text: 'Proceed to Payment',
                              color: AppColors.primary,
                              borderRadius: 10.0,
                              onPressed: () async {
                                /// Function to extract plain text from an HTML string
                                String extractPlainText(
                                    String htmlString) {
                                  var document =
                                  parse(htmlString);
                                  return document
                                      .body?.text ??
                                      "";
                                }

                                var htmlContent = " " "<p class=\"ql-align-justify\">Pathology tests are essential diagnostic tools that analyze blood, urine, tissues, and other body fluids to detect diseases, monitor health conditions, and assess overall well-being. These tests help in identifying infections, organ function abnormalities, nutritional deficiencies, and chronic diseases like diabetes and thyroid disorders.</p>" " ";
                                final extractedText =extractPlainText(htmlContent);

                                List<OrderItem> orderItems =
                                _selectedTests.map((testItem) {
                                  return OrderItem(
                                    id: testItem.sId ?? "", // Use actual ID from cart item
                                    name: testItem.testDetailName ?? "",
                                    orderType: "home collection",
                                    category: testItem.testDetailName ?? "",
                                    price: double.parse( testItem.testPrice.toString()),
                                    imageUrl:OrderItem.defaultImage,
                                    packageDetail: extractedText, // Extract text from HTML
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
      ),
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
          "assets/images/img_error.png",
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildPathalogyList(
      List<Data> pathalogyTestList, PathalogyTestApiProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ListView.builder(
        itemCount:
        provider.filteredPathalogyTest.length + (provider.isFetchingMore ? 1 : 0),
        itemBuilder: (context, index) {
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
    );
  }


  Widget _buildSelectedTestsList() {
    List<Data> selectedTests = _selectedTests; // Use your actual selected tests list

    return Column(
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
            padding: const EdgeInsets.all(8.0),
            child: Text("No tests selected"),
          ),
        ...selectedTests.map((test) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
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
          SolidRoundedButton(
            text: 'Proceed to Payment',
            color: AppColors.primary,
            borderRadius: 10.0,
            onPressed: () {
              print('Proceed to payment button clicked!');
            },
            textStyle: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
