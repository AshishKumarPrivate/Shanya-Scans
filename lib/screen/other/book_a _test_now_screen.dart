import 'package:flutter/material.dart';
import 'package:healthians/ui_helper/responsive_helper.dart';
import 'package:healthians/ui_helper/app_text_styles.dart';
import 'package:healthians/base_widgets/custom_rounded_container.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../base_widgets/common/common_app_bar.dart';
import '../../base_widgets/custom_text_field.dart';
import '../../base_widgets/gender_selection_screen.dart';
import '../../base_widgets/solid_rounded_button.dart';
import '../../ui_helper/app_colors.dart';

class BookATestNowScreen extends StatefulWidget {
  final String name;

  BookATestNowScreen({required this.name});

  @override
  State<BookATestNowScreen> createState() => _BookATestNowScreenState();
}

class _BookATestNowScreenState extends State<BookATestNowScreen> {
  String _selectedGender = ''; // Variable to store the selected gender
  bool isFormVisible = false;
  late Razorpay _razorpay;

  // Default text
  void _handleGenderSelected(String gender) {
    setState(() {
      _selectedGender = gender;
    });
    print(
        "Selected Gender: $_selectedGender"); // Print the selected gender value
  }

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

  // List of tests after filtering
  List<Map<String, String>> _filteredTests = [];

  // Selected tests
  List<String> _selectedTests = [];

  // Controller for the search text field
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredTests = List.from(_tests);
    _searchController.addListener(() {
      _filterTests();
    });

    // Razer Payment
    _razorpay = Razorpay();
    // Event listeners
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
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
  void _toggleSelection(String test) {
    setState(() {
      if (_selectedTests.contains(test)) {
        _selectedTests.remove(test); // Deselect if already selected
      } else {
        _selectedTests.add(test); // Add to selected tests
      }
    });
  }

  double getTotalPrice() {
    double total = 0;
    for (String test in _selectedTests) {
      final selectedTest = _tests.firstWhere((item) => item["test"] == test);
      total += double.parse(selectedTest["price"]!);
    }
    return total;
  }

  // Remove the selected test
  void _removeSelectedTest(String test) {
    setState(() {
      _selectedTests.remove(test);
    });
  }

  // &&&&&&& handle the Razer Payment &&&&&&&&&&&&&&&

  void _openRazorpay() {
    double enteredAmount =
        double.tryParse(getTotalPrice().toStringAsFixed(2)) ?? 0;
    // double enteredAmount = double.tryParse(_amountController.text) ?? 0;

    if (enteredAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid amount")),
      );
      return;
    }

    var options = {
      'key': 'rzp_test_TImsVHuxPCqPb4', // Replace with your Razorpay Key ID
      'amount': (1 * 100).toInt(), // Convert to paise
      // 'amount': (enteredAmount * 100).toInt(), // Convert to paise
      'name': 'Test Payment',
      'description': 'Purchase Description',
      'prefill': {
        'contact': '9161066154',
        'email': 'ashishkumarrawat.cmw@gmail.com'
      },
      'method': {
        'upi': true, // Enable UPI
      },
      'upi': {
        'flow': 'collect', // Use 'collect' for a manual flow
      },
      // 'external': {
      //   'wallets': ['paytm'] // Allow external wallets like Paytm
      // }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print("Error: $e");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment Successful: ${response.paymentId}");
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment Successful: ${response.paymentId}")));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment Failed: ${response.message}");
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment Failed: ${response.message}")));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet: ${response.walletName}");
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("External Wallet Selected: ${response.walletName}")));
  }

  @override
  void dispose() {
    _razorpay.clear(); // Clean up the Razorpay instance
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AppBar
              CommonAppBar(aciviyName: widget.name),
              // Main Content
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
                                      child: ListView.builder(
                                        itemCount: _filteredTests.length,
                                        itemBuilder: (context, index) {
                                          final test = _filteredTests[index];
                                          return ListTile(
                                            title: Text(
                                              "${test["test"]!}  -  ₹${test["price"]!}",
                                              style: AppTextStyles.heading1(
                                                  context,
                                                  overrideStyle: TextStyle(
                                                      fontSize: ResponsiveHelper
                                                          .fontSize(
                                                              context, 12))),
                                            ),

                                            // Access the "test" field from the map
                                            trailing: Checkbox(
                                              value: _selectedTests
                                                  .contains(test["test"]!),
                                              onChanged: (bool? value) {
                                                _toggleSelection(test["test"]!);
                                              },
                                            ),
                                            onTap: () {
                                              _toggleSelection(test["test"]!);
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  SizedBox(height: 20),

                                  // Display the selected tests below with the remove option
                                  if (_selectedTests.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Selected Tests :",
                                            style: AppTextStyles.heading1(
                                                context,
                                                overrideStyle: TextStyle(
                                                    fontSize: ResponsiveHelper
                                                        .fontSize(
                                                            context, 12))),
                                          ),
                                          ..._selectedTests.map((test) {
                                            final selectedTest =
                                                _tests.firstWhere((item) =>
                                                    item["test"] == test);
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "${test}",
                                                    style: AppTextStyles.bodyText1(
                                                        context,
                                                        overrideStyle: TextStyle(
                                                            color: Colors.black,
                                                            fontSize:
                                                                ResponsiveHelper
                                                                    .fontSize(
                                                                        context,
                                                                        12))),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                        Icons.delete_outline,
                                                        color: Colors.red),
                                                    onPressed: () {
                                                      _removeSelectedTest(
                                                          test); // Remove test from selected list
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),

                                          // Total Price
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Total Price: ₹${getTotalPrice().toStringAsFixed(2)}",
                                                  style: AppTextStyles.heading1(
                                                      context,
                                                      overrideStyle: TextStyle(
                                                          color: AppColors
                                                              .primary,
                                                          fontSize:
                                                              ResponsiveHelper
                                                                  .fontSize(
                                                                      context,
                                                                      14))),
                                                ),
                                                // Optionally, you can show a button to proceed with booking
                                              ],
                                            ),
                                          ),

                                          ResponsiveHelper.sizeBoxHeightSpace(
                                              context, 3),
                                          SolidRoundedButton(
                                            text: 'Fill Booking Detail',
                                            color: AppColors.primary,
                                            borderRadius: 10.0,
                                            onPressed: () {
                                              setState(() {
                                                isFormVisible = true;
                                              });
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //       builder: (context) =>
                                              //           BottomNavigationScreen()),
                                              // );
                                            },
                                            textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    ResponsiveHelper.fontSize(
                                                        context, 14)),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),

                            // &&&&&&&&&&&&&&&&&&&&& Form for book a test now  start here  &&&&&&&&&&
                            Visibility(
                              visible: isFormVisible ? true : false,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Text(
                                        "Selected Test",
                                        style: AppTextStyles.heading1(
                                          context,
                                          overrideStyle: TextStyle(
                                              fontSize:
                                                  ResponsiveHelper.fontSize(
                                                      context, 14)),
                                        ),
                                      ),
                                    ),
                                    // &&&&&&&&&&& selected test list of form &&&&&&&&

                                    ..._selectedTests.map((test) {
                                      final selectedTest = _tests.firstWhere(
                                          (item) => item["test"] == test);
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${test}",
                                              style: AppTextStyles.bodyText1(
                                                  context,
                                                  overrideStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: ResponsiveHelper
                                                          .fontSize(
                                                              context, 12))),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                      );
                                    }).toList(),

                                    // SizedBox(height: 10,),
                                    Text(
                                      "Total Price:  ₹${getTotalPrice().toStringAsFixed(2)}",
                                      style: AppTextStyles.heading1(context,
                                          overrideStyle: TextStyle(
                                              color: AppColors.primary,
                                              fontSize:
                                                  ResponsiveHelper.fontSize(
                                                      context, 14))),
                                    ),

                                    // &&&&&&&&&&& selected test list of form &&&&&&&&
                                    SizedBox(
                                      height: 10,
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Text(
                                        "Full Name",
                                        style: AppTextStyles.bodyText1(
                                          context,
                                          overrideStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                                  ResponsiveHelper.fontSize(
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
                                          CustomTransparentTextField(
                                            hintText: "Enter your name",
                                            keyboardType: TextInputType.name,
                                            // controller: mobileController,
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
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Text(
                                        "Mobile",
                                        style: AppTextStyles.bodyText1(
                                          context,
                                          overrideStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                                  ResponsiveHelper.fontSize(
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
                                          CustomTransparentTextField(
                                            hintText: "Enter your mobile",
                                            keyboardType: TextInputType.number,
                                            // controller: mobileController,
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
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Text(
                                        "Gender",
                                        style: AppTextStyles.bodyText1(
                                          context,
                                          overrideStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                                  ResponsiveHelper.fontSize(
                                                      context, 14)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    GenderSelectionScreen(
                                      onGenderSelected:
                                          _handleGenderSelected, // Pass the callback here
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Text(
                                        "Age",
                                        style: AppTextStyles.bodyText1(
                                          context,
                                          overrideStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                                  ResponsiveHelper.fontSize(
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
                                          CustomTransparentTextField(
                                            // maxLength: 2,
                                            hintText: "Enter your age",
                                            keyboardType: TextInputType.number,

                                            // controller: mobileController,
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
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Text(
                                        "Whatsapp Number",
                                        style: AppTextStyles.bodyText1(
                                          context,
                                          overrideStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                                  ResponsiveHelper.fontSize(
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
                                          CustomTransparentTextField(
                                            hintText:
                                                "Enter your whatsapp number",
                                            keyboardType: TextInputType.name,
                                            // controller: mobileController,
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
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Text(
                                        "Email",
                                        style: AppTextStyles.bodyText1(
                                          context,
                                          overrideStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                                  ResponsiveHelper.fontSize(
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
                                          CustomTransparentTextField(
                                            hintText: "Enter your email",
                                            keyboardType: TextInputType.name,
                                            // controller: mobileController,
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
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Text(
                                        "City",
                                        style: AppTextStyles.bodyText1(
                                          context,
                                          overrideStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                                  ResponsiveHelper.fontSize(
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
                                          CustomTransparentTextField(
                                            hintText: "Enter your city",
                                            keyboardType: TextInputType.name,
                                            // controller: mobileController,
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
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Text(
                                        "Address",
                                        style: AppTextStyles.bodyText1(
                                          context,
                                          overrideStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                                  ResponsiveHelper.fontSize(
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
                                          CustomTransparentTextField(
                                            multiLines: true,
                                            maxLines: 5,
                                            hintText: "Enter your address",
                                            keyboardType: TextInputType.name,
                                            // controller: mobileController,
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        print("Container tapped!");
                                      },
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),

                                    // ***************** SOLID ROUNDED SUBMIT BUTTON START HERE ******************
                                    SolidRoundedButton(
                                      text: 'Proceed to Payment',
                                      color: AppColors.primary,
                                      borderRadius: 10.0,
                                      onPressed: () async {
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //       builder: (context) => CartListScreen()),
                                        // );

                                        onPressed:
                                        _openRazorpay();
                                        print(
                                            'Proceed to payment button clicked!');
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
                            // &&&&&&&&&&&&&&&&&&&&& Form for book a test now  end here  &&&&&&&&&&

                            SizedBox(
                              height: 15,
                            ),
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
}

class buildInstructions extends StatelessWidget {
  String type;

  buildInstructions({required this.type});

  @override
  Widget build(BuildContext context) {
    final testCategories = [
      {
        'title': 'Fasting: 4-6 hours prior to the scan',
        'hindiTitle':
            'इस स्कैन से पहले 4-6 घंटे उपवास करना आवश्यक है ताकि सही परिणाम प्राप्त हो सकें।',
        'count': 12,
      },
      {
        'title': 'Duration of the scan: 30-60 minutes',
        'hindiTitle':
            'सादा पानी पीना अनुमत है, लेकिन अन्य किसी तरल पदार्थ का सेवन न करें।',
        'count': 11,
      },
      {
        'title':
            'Radioactive Injection: To create detailed images during the scan',
        'hindiTitle':
            'चीनी युक्त खाद्य पदार्थों और पेय पदार्थों से बचें, क्योंकि इससे स्कैन के परिणामों में विघटन हो सकता है।',
        'count': 21
      },
      {
        'title':
            'Post-scan: You may resume your normal activities after the scan, but drink plenty of fluids to help eliminate the radioactive material from your body.',
        'hindiTitle':
            'यदि आप मधुमेह से ग्रस्त हैं, तो कृपया अपने डॉक्टर से परामर्श करें कि क्या आपको स्कैन से पहले अपनी इंसुलिन या मधुमेह दवाओं को बंद करना होगा।',
        'count': 24
      },
      {
        'title':
            'Radioactive Injection: To create detailed images during the scan',
        'hindiTitle':
            'स्कैन के दिन किसी प्रकार की शारीरिक मेहनत या शारीरिक गतिविधियों से बचें, क्योंकि यह परिणामों को प्रभावित कर सकता है।',
        'count': 21
      },
      {
        'title':
            'Post-scan: You may resume your normal activities after the scan, but drink plenty of fluids to help eliminate the radioactive material from your body.',
        'hindiTitle':
            'आपको रेडियोधर्मी पदार्थ का इंजेक्शन दिया जाएगा, जो सुरक्षित होता है और स्कैन के दौरान स्पष्ट चित्र बनाने में मदद करता है।',
        'count': 24
      },
      {
        'title':
            'Radioactive Injection: To create detailed images during the scan',
        'hindiTitle':
            'कृपया टेकनीशियन को सूचित करें यदि आप गर्भवती हैं या स्तनपान करवा रही हैं, क्योंकि स्कैन में रेडिएशन शामिल होता है।',
        'count': 21
      }
    ];

    return Container(
      height: 150, // Set fixed height for the container
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   "Instructions",
            //   style: AppTextStyles.heading1.copyWith(
            //     fontSize: 14,
            //   ),
            // ),
            SizedBox(height: 10),
            Expanded(
              // Makes the ListView scrollable within the fixed height
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: testCategories.length,
                itemBuilder: (context, index) {
                  final category = testCategories[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            '\u2022', // Unicode for bullet point
                            style: TextStyle(
                              fontSize: 30,
                              height: 0.4, // Align bullet vertically with text
                              color: Colors.black, // Bullet color
                            ),
                          ),
                        ),
                        SizedBox(width: 8), // Space between bullet and text
                        Expanded(
                          child: Text(
                            "${type == "eng" ? category['title']! : category['hindiTitle']!}",
                            // "${category['title']!}",

                            // style: AppTextStyles.bodyText1.copyWith(
                            //     fontSize: 12,
                            //     color: Colors.black,
                            //     letterSpacing: 1),
                            style: AppTextStyles.bodyText1(
                              context,
                              overrideStyle: AppTextStyles.bodyText1(context,
                                  overrideStyle: TextStyle(
                                      color: Colors.black,
                                      letterSpacing: 1,
                                      fontSize: ResponsiveHelper.fontSize(
                                          context, 12))),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
