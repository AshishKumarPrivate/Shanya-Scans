import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:healthians/screen/checkout/checkout_text_fields.dart';
import 'package:healthians/screen/order/controller/order_provider.dart';
import 'package:healthians/screen/order/model/OrderItem.dart';
import 'package:healthians/ui_helper/app_colors.dart';
import 'package:healthians/ui_helper/storage_helper.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../base_widgets/custom_rounded_container.dart';
import '../../base_widgets/loading_indicator.dart';
import '../../base_widgets/solid_rounded_button.dart';
import '../../ui_helper/app_text_styles.dart';
import '../../ui_helper/responsive_helper.dart';
import '../../util/date_formate.dart';
import '../cart/cart_list_screen.dart';
import 'controller/checkout_api_provider.dart';

class CheckoutScreen extends StatefulWidget {
  final categoryName, name, price;

  // final Data rateListData; // Accepts the clicked service item

  CheckoutScreen(
      {required this.categoryName, required this.name, required this.price});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  TextEditingController phoneController = TextEditingController(
      text: StorageHelper().getPhoneNumber().isEmpty
          ? ""
          : StorageHelper().getPhoneNumber());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController localityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController postalController = TextEditingController();
  final TextEditingController cityAddressController =
      TextEditingController(text: "Lucknow");

  final _formKey = GlobalKey<FormState>(); // Add this at the class level

  String? selectedBookingFor = "Self";
  String? selectedGender = "Male";
  String? selectedCity;
  String? selectedAddressType = "Home";

  /// Date Selection
  DateTime? selectedDate = DateTime.now();
  TimeOfDay? selectedTime;

  /// Date Selection
  String? selectedDateString;
  String? selectedTimeString;

  bool showBookingFor = false;
  bool showGender = false;
  bool showCities = false;

  final List<String> bookingForOptions = ['Self', 'Other'];
  final List<String> gender = ['Male', 'Female', 'Other'];
  final List<String> cities = ['City A', 'City B', 'City C'];

  bool isBookingExpanded = false;
  int _currentStep = 0;

  // intialize Razer payment

  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<CartProvider>(context, listen: false).loadCartItems();
    // });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderApiProvider>(context, listen: false)
          .loadSingleTestScanItem();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CheckoutProvider>(context, listen: false).loadCheckoutItems();
    });

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  // &&&&&&&&&&&&&&&&&&&& Razer Payment &&&&&&&&&&&&&&&&&&

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment Successful: ${response.paymentId}");
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment Successful: ${response.paymentId}")));

    // Call the API after successful payment
    // Provider.of<OrderApiProvider>(context, listen: false).createOrder(
    //   context,
    //   widget.name,
    //   selectedDateString.toString(),
    //   selectedTimeString.toString(),
    //   widget.categoryName,
    //   widget.price,
    //   StorageHelper().getEmail(),
    //   fullNameController.text.toString(),
    //   ageController.text.toString(),
    //   phoneController.text.toString(),
    //   "",
    //   selectedGender.toString(),
    //   cityAddressController.text.toString(),
    // );
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

  void openRazorpayPayment() {
    var options = {
      "key": "YOUR_RAZORPAY_KEY",
      // Replace with your Razorpay key
      "amount": 1 * 100,
      // Convert price to paise
      // "amount": double.parse(widget.rateListData.testPrice.toString()) * 100, // Convert price to paise
      "currency": "INR",
      "name": "Your App Name",
      "description": "Test Payment",
      "prefill": {
        "email": StorageHelper().getEmail(),
        "contact": phoneController.text.toString()
      },
      "theme": {"color": "#000000"},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print("Error opening Razorpay: $e");
    }
  }

  // &&&&&&&&&&&&&&&&&&&& Razer Payment &&&&&&&&&&&&&&&&&&

  void defaultStatusBarColor() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.primary,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  void dispose() {
    defaultStatusBarColor();
    _razorpay.clear(); // Cleanup Razorpay instance
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldExit = await _showExitDialog(context);
        return shouldExit; // Allow exit only if the user confirms
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true, // Prevents button from moving
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () =>
                _showExitDialog(context), // Show exit confirmation dialog
            // onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            "Checkout",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          // actions: [
          //   IconButton(
          //     icon:
          //         const Icon(Icons.shopping_cart_outlined, color: Colors.white),
          //     onPressed: () {},
          //   ),
          // ],
        ),
        body: SafeArea(
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: ResponsiveHelper.containerHeight(context, 10),
                  // color: Colors.green,
                  child: EasyStepper(
                    activeStep: _currentStep,
                    stepShape: StepShape.circle,
                    activeStepBorderColor: AppColors.primary,
                    finishedStepBorderColor: AppColors.primary,
                    finishedStepBackgroundColor: AppColors.primary,
                    activeStepTextColor: Colors.black,
                    finishedStepTextColor: Colors.white,
                    stepRadius: 20,
                    showLoadingAnimation: false,
                    steps: [
                      EasyStep(title: "Booking", icon: Icon(Icons.list_alt)),
                      EasyStep(
                          title: "Shipping", icon: Icon(Icons.local_shipping)),
                      EasyStep(title: "Payment", icon: Icon(Icons.payment)),
                      EasyStep(title: "Review", icon: Icon(Icons.receipt)),
                    ],
                    onStepReached: (index) =>
                        setState(() => _currentStep = index),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    // Hide keyboard on tap
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.manual,
                      child: getStepContent(),
                    ),
                  ),
                ),
                buildNavigationButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    bool exitConfirmed = false;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0), // Rounded corners
          ),
          backgroundColor: Colors.white,
          // Dialog background color
          title: Text(
            "Exit Checkout",
            style: AppTextStyles.heading1(context,
                overrideStyle: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(context, 16))),
          ),

          content: Text(
            "Are you sure you want to leave the checkout page?",
            style: AppTextStyles.heading2(context,
                overrideStyle: TextStyle(
                    color: AppColors.txtGreyColor,
                    fontSize: ResponsiveHelper.fontSize(context, 12))),
          ),
          actions: [
            TextButton(
              onPressed: () {
                exitConfirmed = false;
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                exitConfirmed = true;
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Closes just the checkout page
              },
              child: const Text("Exit", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
    return exitConfirmed;
  }

  Widget getStepContent() {
    switch (_currentStep) {
      case 0:
        return buildBookingForm();
      case 1:
        return buildShippingForm();
      case 2:
        return buildPaymentForm();
      case 3:
        return buildReviewForm();
      default:
        return buildBookingForm();
    }
  }

  Widget buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentStep > 0)
            TextButton(
              onPressed: () {
                setState(() {
                  _currentStep -= 1;
                });
              },
              child: const Text("Back", style: TextStyle(color: Colors.black)),
            ),

          //
          Consumer<OrderApiProvider>(builder: (context, provider, child) {
            // Check if the loading state is true
            if (provider.isLoading) {
              return loadingIndicator(); // Show shimmer effect while loading
            }
            // Check if there was an error
            // if (provider.errorMessage.isNotEmpty) {
            //   return Center(
            //     child: SizedBox(
            //       width:
            //       ResponsiveHelper.containerWidth(context, 50),
            //       height:
            //       ResponsiveHelper.containerWidth(context, 50),
            //       child: Image.asset(
            //         "assets/images/img_error.jpg",
            //         fit: BoxFit.cover,
            //       ),
            //     ),
            //   ); // Show error widget if there's an error
            // }

            // Check if the data is null or empty
            // if (provider.createOrderModelResponse?.data == null) {
            //   return  Center(
            //     child: SizedBox(
            //       width: ResponsiveHelper.containerWidth(
            //           context, 50),
            //       height: ResponsiveHelper.containerWidth(
            //           context, 50),
            //       child: Image.asset(
            //         "assets/images/img_error.jpg",
            //         fit: BoxFit.cover,
            //       ),
            //     ),
            //   ); // Show empty list widget if data is null or empty
            // }
            // If data is loaded, display the rate list

            return AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              opacity: MediaQuery.of(context).viewInsets.bottom > 0 ? 0.0 : 1.0,
              // Hide button when keyboard appears, show when hidden
              child: AnimatedPadding(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom > 0
                      ? MediaQuery.of(context).viewInsets.bottom + 0
                      : 0,
                  // Moves button above keyboard smoothly when opened
                ),
                child: SizedBox(
                  width: ResponsiveHelper.containerWidth(context, 30),
                  child: SolidRoundedButton(
                    text: _currentStep == 3 ? "Finish" : "Next",
                    color: Colors.black,
                    borderRadius: 10.0,
                    onPressed: () async {
                      if (_currentStep < 3) {
                        setState(() {
                          _currentStep += 1;
                        });
                      } else {
                        print("Finish button clicked");

                        // Provider.of<CheckoutProvider>(context, listen: false)
                        //     .createOrder(
                        //   context,
                        //   widget.name.toString(),
                        //   selectedDateString.toString(),
                        //   selectedTimeString.toString(),
                        //   widget.categoryName.toString(),
                        //   widget.price.toString(),
                        //   StorageHelper().getEmail(),
                        //   fullNameController.text.toString(),
                        //   ageController.text.toString(),
                        //   phoneController.text.toString(),
                        //   phoneController.text.toString(),
                        //   selectedGender.toString(),
                        //   cityAddressController.text.toString(),
                        // );
                      }
                    },
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            );

            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.black,
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            //     shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(8)),
            //   ),
            //   onPressed: () {
            //     if (_currentStep < 3) {
            //       setState(() {
            //         _currentStep += 1;
            //       });
            //     } else {
            //       print("finish button clicked");
            //       // Perform checkout action
            //       // action on finish button click to create order
            //       Provider.of<OrderApiProvider>(context, listen: false)
            //           .createOrder(
            //               context,
            //               widget.name.toString(),
            //               selectedDateString.toString(),
            //               selectedTimeString.toString(),
            //               widget.categoryName,
            //               widget.price.toString(),
            //               StorageHelper().getEmail(),
            //               fullNameController.text.toString(),
            //               ageController.text.toString(),
            //               phoneController.text.toString(),
            //               "",
            //               selectedGender.toString(),
            //               cityAddressController.text.toString());
            //     }
            //   },
            //   child: InkWell(
            //     onTap: () {},
            //     child: Text(
            //       _currentStep == 3 ? "Finish" : "Next",
            //       style: TextStyle(color: Colors.white),
            //     ),
            //   ),
            // );
          }),

          ////
        ],
      ),
    );
  }

  Widget buildBookingForm() {
    print("Booking for=> ${selectedBookingFor}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildExpandableList(
            "Booking For",
            bookingForOptions,
            selectedBookingFor,
            (value) {
              setState(() {
                selectedBookingFor = value;
                showBookingFor = false;
              });
            },
            showBookingFor,
            () {
              setState(() => showBookingFor = !showBookingFor);
            }),

        // buildTextField("Name", "Enter name", fullNameController,
        //     isRequired: true),

        CheckoutTextField(
          label: "Name",
          hint: "Enter name",
          controller: fullNameController,
          isRequired: true,
        ),

        // buildTextField("Age", "Enter age", ageController,
        //     keyboardType: TextInputType.number, isRequired: true),

        CheckoutTextField(
          label: "Age",
          hint: "Enter age",
          controller: ageController,
          isRequired: true,
          keyboardType: TextInputType.number,
        ),

        buildExpandableList(
            "Select Gender",
            gender,
            selectedGender,
            (value) {
              setState(() {
                selectedGender = value;
                showGender = false;
              });
            },
            showGender,
            () {
              setState(() => showGender = !showGender);
            }),
        buildPhoneField(),
      ],
    );
  }

  Widget buildShippingForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // buildDropdown("Select Province", provinces, selectedProvince, (value) => setState(() => selectedProvince = value)),
        // buildDropdown("Select City", cities, selectedCity, (value) => setState(() => selectedCity = value)),

        buildBookingDate(),

        /// **Booking Time Selection**
        buildDateTimePicker(
          title: "Select Booking Time",
          selectedValue: selectedTime != null
              ? "${selectedTime!.hourOfPeriod}:${selectedTime!.minute.toString().padLeft(2, '0')} ${selectedTime!.period == DayPeriod.am ? "AM" : "PM"}"
              : "Select Booking Time",
          icon: Icons.access_time,
          onTap: _selectTime,
        ),
        // buildTextField("Locality*", "Enter locality", localityController),

        // CheckoutTextField(
        //   label: "Locality",
        //   hint: "Enter locality",
        //   controller: localityController,
        // ),

        // buildTextField("Postal Code*", "Enter postal code", postalController,
        //     keyboardType: TextInputType.number),

        CheckoutTextField(
            label: "Postal Code*",
            hint: "Enter postal code",
            controller: postalController,
            keyboardType: TextInputType.number),

        // buildTextField("House No / Flat No / Landmark*",
        //     "House No / Flat No / Landmark", addressController),

        CheckoutTextField(
          label: "House No / Flat No / Landmark*",
          hint: "House No / Flat No / Landmark",
          controller: addressController,
        ),

        // buildTextField( "City , Address*", "City , Address", cityAddressController),

        CheckoutTextField(
          label: "City",
          hint: "City",
          controller: cityAddressController,
        ),

        AddressTypeSelector(
          addressTypes: ["Home", "Work", "Other"],
          selectedAddressType: selectedAddressType,
          onSelected: (value) {
            setState(() {
              selectedAddressType = value;
            });
          },
        ),
      ],
    );
  }

  /// **Date/Time Picker Widget**
  Widget buildDateTimePicker({
    required String title,
    required String selectedValue,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(selectedValue,
                      style: const TextStyle(color: Colors.black54)),
                  Icon(icon, color: Colors.black54),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBookingDate() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Select Booking Date",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 5),
          GestureDetector(
            onTap: _selectDate,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${DateUtil.formatDate(
                      date: "${selectedDate}",
                      currentFormat: "yyyy-MM-dd",
                      desiredFormat: "dd-MM-yy",
                    )}", // ✅ Formatted date
                    // DateFormat("dd-MM-yy").format(selectedDate), // ✅ Formatted date
                    style: const TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                  const Icon(Icons.calendar_today, color: Colors.black54),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// **Date Picker Function**

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // ✅ Default today’s date
      firstDate: DateTime.now(), // ✅ Prevents past date selection
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  /// **Time Picker Function**
  void _selectTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
        print("selected booking time=>${selectedTime}");
        selectedTimeString =
            "${selectedTime!.hourOfPeriod}:${selectedTime!.minute.toString().padLeft(2, '0')} ${selectedTime!.period == DayPeriod.am ? "AM" : "PM"}";
      });
    }
  }

  Widget buildExpandableList(
    String title,
    List<String> items,
    String? selectedValue,
    Function(String) onSelect,
    bool isExpanded,
    Function() toggleExpand,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          GestureDetector(
            onTap: toggleExpand,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(selectedValue ?? title,
                      style: TextStyle(color: Colors.black54)),
                  Icon(
                      isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Column(
              children: items
                  .map((item) => ListTile(
                        title: Text(item),
                        onTap: () {
                          onSelect(item);
                          print(
                              "selected Expandlable listt item => ${selectedBookingFor}");
                        },
                      ))
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget buildPaymentForm() {
    return PaymentSelectionWidget();
  }

  Widget buildReviewForm() {
    final checkoutProvider = Provider.of<CheckoutProvider>(context);
    return Column(
      children: [
        Consumer<CheckoutProvider>(
          builder: (context, checkoutItemsProvider, child) {
            if (checkoutItemsProvider.isCheckoutEmpty) {
              // ✅ If cart is empty, show empty cart message
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.remove_shopping_cart,
                        size: 80, color: Colors.grey),
                    SizedBox(height: 20),
                    Text(
                      "Your Cart is Empty",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ],
                ),
              );
            }
            // ✅ Calculate dynamic cart total
            double cartTotal = checkoutItemsProvider.checkoutItems
                .fold(0, (sum, item) => sum + ((item.price) * item.quantity));
            double discount = 399.00;
            double orderTotal = cartTotal - discount;

            return Stack(
              children: [
                // 🟢 Cart Content (Scrollable)
                SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 0),
                  // Space for fixed button
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🟢 Cart Items List
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: checkoutItemsProvider.checkoutItems.length,
                        itemBuilder: (context, index) {
                          final orserItem =
                              checkoutItemsProvider.checkoutItems[index];
                          return Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: AppColors.lightBlueColor!,
                                      width: 5)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 🟢 Image Section
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    color: AppColors.lightBrown_color,
                                    width: ResponsiveHelper.containerWidth(
                                        context, 20),
                                    height: ResponsiveHelper.containerWidth(
                                        context, 20),
                                    child: Padding(
                                      padding: orserItem.imageUrl ==
                                              OrderItem.defaultImage
                                          ? EdgeInsets.all(8.0)
                                          : EdgeInsets.all(0.0),
                                      child: orserItem.imageUrl
                                              .startsWith("http")
                                          ? Image.network(
                                              orserItem.imageUrl,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Image.asset(
                                                  OrderItem.defaultImage,
                                                  // Show default image if network fails
                                                  fit: BoxFit.cover,
                                                );
                                              },
                                            )
                                          : Image.asset(
                                              orserItem
                                                  .imageUrl, // Local asset image
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                ),

                                SizedBox(width: 10),

                                // 🟢 Details Section (Title + HTML + Price + Quantity Selector)
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        orserItem.name,
                                        maxLines: 2,
                                        style: AppTextStyles.heading1(
                                          context,
                                          overrideStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: ResponsiveHelper.fontSize(
                                                context, 12),
                                          ),
                                        ),
                                      ),

                                      // 🟢 HTML Content - Completely Removing All Spacing
                                      Html(
                                        data: orserItem.packageDetail,
                                        shrinkWrap: true,
                                        style: {
                                          "body": Style(
                                              margin: Margins.zero,
                                              maxLines: 2,
                                              padding: HtmlPaddings.zero),
                                          "p": Style(
                                            textAlign: TextAlign.start,
                                            alignment: Alignment.topLeft,
                                            maxLines: 2,
                                            color: AppColors.txtGreyColor,
                                            fontSize: FontSize(
                                                ResponsiveHelper.fontSize(
                                                    context, 10)),
                                            margin: Margins.zero,
                                            padding: HtmlPaddings.zero,
                                            lineHeight: LineHeight(1.4),
                                          ),
                                          "pre": Style(
                                              margin: Margins.zero,
                                              padding: HtmlPaddings.zero,
                                              lineHeight: LineHeight(1)),
                                          "div": Style(
                                              margin: Margins.zero,
                                              padding: HtmlPaddings.zero),
                                          "span": Style(
                                              margin: Margins.zero,
                                              padding: HtmlPaddings.zero),
                                          "ul": Style(
                                              margin: Margins.zero,
                                              padding: HtmlPaddings.zero),
                                          "li": Style(
                                              margin: Margins.zero,
                                              padding: HtmlPaddings.zero),
                                        },
                                      ),

                                      ResponsiveHelper.sizeBoxHeightSpace(
                                          context, 0.5),

                                      // 🟢 Price + Quantity Controls in Row
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        // Moves quantity to the end
                                        children: [
                                          // 🟢 Price Text (Left side)
                                          Text(
                                            "₹${orserItem.price}",
                                            style: AppTextStyles.heading1(
                                              context,
                                              overrideStyle: TextStyle(
                                                color: AppColors.primary,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),

                                          /// &&&&&&&&&& Quantity design &&&&&&&&&&&&&&&&

                                          // 🟢 Quantity Control (Moved to end)
                                          Container(
                                            height: 20,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  // onPressed: () => (){},
                                                  onPressed: () =>
                                                      checkoutItemsProvider
                                                          .decreaseQuantity(
                                                              context,
                                                              orserItem.id),
                                                  icon: Icon(Icons.remove,
                                                      color: Colors.black,
                                                      size: 16),
                                                  padding: EdgeInsets.zero,
                                                  constraints: BoxConstraints(
                                                      minWidth: 28,
                                                      minHeight: 28),
                                                  style: IconButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        2)),
                                                    backgroundColor: AppColors
                                                        .lightYellowColor,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 6),
                                                  child: Text(
                                                    // "1",
                                                    "${orserItem.quantity}",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () =>
                                                      checkoutItemsProvider
                                                          .increaseQuantity(
                                                              context,
                                                              orserItem.id),
                                                  icon: Icon(Icons.add,
                                                      color: Colors.black,
                                                      size: 16),
                                                  padding: EdgeInsets.zero,
                                                  constraints: BoxConstraints(
                                                      minWidth: 28,
                                                      minHeight: 28),
                                                  style: IconButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        2)),
                                                    backgroundColor: AppColors
                                                        .lightYellowColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          /// &&&&&&&&&& Quantity design &&&&&&&&&&&&&&&&
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                /// &&&&&&&&&& Delete item &&&&&&&&&&&&&&&&
                                // 🟢 Delete Button
                                Column(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.delete_outline,
                                          color: Colors.red),
                                      onPressed: () {
                                        checkoutItemsProvider.removeFromCart(
                                            context, orserItem.id);
                                      },
                                    ),
                                  ],
                                ),

                                /// &&&&&&&&&& Delete item &&&&&&&&&&&&&&&&
                              ],
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 16),
                      // 🟢 Cart Summary
                      Container(
                        // color: AppColors.lightBlueColor,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: CustomRoundedContainer(
                          borderRadius: 0,
                          borderColor: Colors.transparent,
                          borderWidth: 0,
                          elevation: 0,
                          backgroundColor: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SummaryRow(
                                    label: 'Cart Value', value: '₹$cartTotal'),
                                SummaryRow(
                                    label: 'Coupon Discount',
                                    value: '-₹$discount'),
                                SummaryRow(
                                    label: 'Sample Collection Charges',
                                    value: '₹250.00 Free'),
                                Divider(),
                                SummaryRow(
                                    label: 'Amount Payable',
                                    value: '₹$orderTotal',
                                    isBold: true),
                                SizedBox(height: 8),
                                Text(
                                  'Total Savings of ₹${cartTotal - orderTotal} on this order',
                                  style: AppTextStyles.heading2(
                                    context,
                                    overrideStyle: TextStyle(
                                      color: Colors.green,
                                      fontSize: ResponsiveHelper.fontSize(
                                          context, 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget buildTextField(
    String label,
    String hint,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    bool isRequired = false,
  }) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              validator: isRequired
                  ? (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "$label is required";
                      }
                      return null;
                    }
                  : null,
              decoration: InputDecoration(
                hintText: hint,
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPhoneField() {
    return CheckoutTextField(
        label: "Phone Number*",
        hint: "nter phone number",
        controller: phoneController,
        keyboardType: TextInputType.number,
        isRequired: true);

    // buildTextField(
    //   "Phone Number*", "Enter phone number", phoneController,
    //   keyboardType: TextInputType.number, isRequired: true);
  }

  Widget buildDropdown(String hint, List<String> items, String? selectedValue,
      Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(hint, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Container(
            width: double.infinity, // Ensures dropdown width matches parent
            decoration: BoxDecoration(
              color: Colors.grey.shade100, // Background color
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.transparent,
                // Keeps background color from Container
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              hint: Text(hint),
              value: selectedValue,
              onChanged: onChanged,
              items: items
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      ))
                  .toList(),
              dropdownColor: Colors.white, // Background color of dropdown list
            ),
          ),
        ],
      ),
    );
  }
}

class AddressTypeSelector extends StatefulWidget {
  final List<String> addressTypes;
  final String? selectedAddressType;
  final ValueChanged<String> onSelected;

  const AddressTypeSelector({
    Key? key,
    required this.addressTypes,
    this.selectedAddressType,
    required this.onSelected,
  }) : super(key: key);

  @override
  _AddressTypeSelectorState createState() => _AddressTypeSelectorState();
}

class _AddressTypeSelectorState extends State<AddressTypeSelector> {
  String? _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.selectedAddressType ?? widget.addressTypes.first;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select Address Type",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10, // Spacing between chips
            children: widget.addressTypes.map((type) {
              return ChoiceChip(
                label: Text(type),
                selected: _selectedType == type,
                selectedColor: Colors.blue.shade100,
                backgroundColor: Colors.grey.shade200,
                labelStyle: TextStyle(
                  color: _selectedType == type ? Colors.blue : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onSelected: (isSelected) {
                  if (isSelected) {
                    setState(() {
                      _selectedType = type;
                    });
                    widget.onSelected(type);
                  }
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class PaymentSelectionWidget extends StatefulWidget {
  @override
  _PaymentSelectionWidgetState createState() => _PaymentSelectionWidgetState();
}

class _PaymentSelectionWidgetState extends State<PaymentSelectionWidget> {
  String selectedPayment = "razorpay"; // Default selected payment method

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select Payment Method",
            style: AppTextStyles.heading1(
              context,
              overrideStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: ResponsiveHelper.fontSize(context, 14),
              ),
            ),
          ),
          SizedBox(height: 10),

          // ✅ Razorpay Payment Option
          _buildPaymentOption(
            title: "Pay with Razorpay",
            subtitle: "Pay securely using Razorpay",
            image: "assets/images/razorpayicon.png",
            value: "razorpay",
          ),

          // ✅ Cash on Delivery (COD) Option
          _buildPaymentOption(
            title: "Cash on Delivery",
            subtitle: "Pay cash upon receiving the order",
            image: "assets/images/codimage.png",
            value: "cod",
          ),
        ],
      ),
    );
  }

  /// 🔹 **Reusable Payment Option Builder**
  Widget _buildPaymentOption({
    required String title,
    required String subtitle,
    required String image,
    required String value,
  }) {
    bool isSelected = selectedPayment == value;

    print("selected payment mehtod=>${selectedPayment}");
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPayment = value;
          // print("selected payment mehtod=>${selectedPayment}");
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: EdgeInsets.symmetric(vertical: 6),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 1 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.blue.shade200,
                blurRadius: 5,
                spreadRadius: 1,
              ),
          ],
        ),
        child: Row(
          children: [
            // ✅ Payment Icon
            Image.asset(image, width: 40, height: 40),
            SizedBox(width: 12),

            // ✅ Payment Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.heading1(
                      context,
                      overrideStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: ResponsiveHelper.fontSize(context, 14),
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption(
                      context,
                      overrideStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: ResponsiveHelper.fontSize(context, 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ✅ Selection Indicator
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? Colors.blue : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
