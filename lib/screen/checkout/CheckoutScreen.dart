import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shanya_scans/screen/checkout/checkout_text_fields.dart';
import 'package:shanya_scans/screen/order/model/OrderItem.dart';
import 'package:shanya_scans/screen/other/screen/search_screen.dart';
import 'package:shanya_scans/ui_helper/app_colors.dart';
import 'package:shanya_scans/ui_helper/snack_bar.dart';
import 'package:shanya_scans/ui_helper/storage_helper.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shanya_scans/util/StringUtils.dart';
import 'package:shanya_scans/util/image_loader_util.dart';

import '../../base_widgets/custom_rounded_container.dart';
import '../../base_widgets/loading_indicator.dart';
import '../../base_widgets/solid_rounded_button.dart';
import '../../ui_helper/app_text_styles.dart';
import '../../ui_helper/responsive_helper.dart';
import '../../util/date_formate.dart';
import '../cart/cart_list_screen.dart';
import 'controller/checkout_api_provider.dart';

class CheckoutScreen extends StatefulWidget {

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController altPhoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController localityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController postalController = TextEditingController();
  final TextEditingController cityAddressController = TextEditingController(text: "Lucknow");

  final _formKey = GlobalKey<FormState>(); // Add this at the class level

  String? selectedBookingFor = "Self";
  String? selectedGender = "Male";
  String? selectedCity;
  String? selectedAddressType = "Home";

  /// Date Selection
  DateTime? selectedDate = DateTime.now();
  TimeOfDay? selectedTime;

  /// Date Selection
  String? selectedDateString = DateUtil.formatDate(
      date: DateTime.now().toString(),
      currentFormat: "yyyy-MM-dd HH:mm:ss.SSS",
      desiredFormat: "yyyy-MM-dd"); // ✅ Store default date
  // String? selectedTimeString;
  String? selectedTimeString = DateUtil.formatDate(
      date: DateTime.now().toString(),
      currentFormat: "yyyy-MM-dd HH:mm:ss.SSS",
      desiredFormat: "HH:mm" // or any format you need like "hh:mm a"
  );

  bool showBookingFor = false;
  bool showGender = false;
  bool showCities = false;

  final List<String> bookingForOptions = ['Self', 'Other'];
  final List<String> gender = ['Male', 'Female', 'Other'];
  final List<String> cities = ['City A', 'City B', 'City C'];

  bool isBookingExpanded = false;
  int _currentStep = 0;

  String? selectedPlace=StorageHelper().getUserLiveAddress();

  // intialize Razer payment

  // late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.primary,
      statusBarIconBrightness: Brightness.light,
    ));


    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CheckoutProvider>(context, listen: false).loadCheckoutItems();
    });

  }

  void defaultStatusBarColor() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.primary,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  // validate booking forom ////////
  bool validateBookingForm(BuildContext context) {
    final phoneRegex = RegExp(r'^[6-9]\d{9}$'); // Indian 10-digit mobile number

    if (fullNameController.text.isEmpty) {
      showError(context, "Please enter your full name.");
      return false;
    }
    if (ageController.text.isEmpty) {
      showError(context, "Please enter your age.");
      return false;
    }
    if (phoneController.text.isEmpty) {
      showError(context, "Please enter your phone number.");
      return false;
    }
    if (!phoneRegex.hasMatch(phoneController.text)) {
      showError(context, "Enter a valid 10-digit phone number starting with 6-9.");
      return false;
    }
    if (phoneController.text.length != 10) {
      showError(context, "Invalid phone number.");
      return false;
    }
    if (altPhoneController.text.isEmpty) {
      showError(context, "Please enter your alternate number.");
      return false;
    }
    if (!phoneRegex.hasMatch(altPhoneController.text)) {
      showError(context, "Enter a valid 10-digit alternate number.");
      return false;
    }
    if (altPhoneController.text.length != 10) {
      showError(context, "Invalid alternate number.");
      return false;
    }

    // All validations passed
    return true;
  }

  bool validateShippingForm(BuildContext context) {
    if (selectedDateString == null || selectedDateString!.isEmpty) {
      showError(context, "Please select a booking date.");
      return false;
    }
    if (selectedTimeString == null || selectedTimeString!.isEmpty) {
      showError(context, "Please select a time.");
      return false;
    }
    if (cityAddressController.text.isEmpty) {
      showError(context, "Please enter your address.");
      return false;
    }
    // if (selectedGender == null || selectedGender!.isEmpty) {
    //   showError(context, "Please select a gender.");
    //   return false;
    // }

    // if (selectedAddressType == null || selectedAddressType!.isEmpty) {
    //   showError(context, "Please select an address type.");
    //   return false;
    // }

    // All validations passed
    return true;
  }

  void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  // validate   ////////

  @override
  void dispose() {
    defaultStatusBarColor();
    // _razorpay.clear(); // Cleanup Razorpay instance
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
          bottom: false,
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
                    // onStepReached: (index) =>setState(() => _currentStep = index),
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
          Consumer<CheckoutProvider>(builder: (context, provider, child) {
            // Check if the loading state is true
            if (provider.isLoading) {
              return loadingIndicator(); // Show shimmer effect while loading
            }

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
                      color: AppColors.primary,
                      borderRadius: 10.0,
                      onPressed: () async {

                        if (_currentStep < 3) {
                          print("Next  button clicked");
                          if (_currentStep == 0) {
                            if (!validateBookingForm(context)) {
                              print("Validation failed at step 0.");
                              return;
                            }
                          }
                          if (_currentStep == 1) {
                            if (!validateShippingForm(context)) {
                              print("Validation failed at step 1.");
                              return;
                            }
                          }
                          setState(() {
                            _currentStep += 1;
                          });
                        }
                        else {
                          print("Finish button clicked");
                          final checkoutProvider = Provider.of<CheckoutProvider>(context, listen: false);

                          checkoutProvider.saveFormData(
                            selectedDate: selectedDateString.toString(),
                            selectedTime: selectedTimeString.toString(),
                            email: StorageHelper().getEmail(),
                            fullName: fullNameController.text.toString(),
                            age: ageController.text.toString(),
                            phone: phoneController.text.toString(),
                            altPhone: altPhoneController.text.toString(),
                            gender: selectedGender.toString(),
                            cityAddress: cityAddressController.text.toString(),
                            place: selectedPlace.toString(),
                            addressType: selectedAddressType.toString(),
                          );
                          // await checkoutProvider.initRazorpay(context);

                          Provider.of<CheckoutProvider>(context, listen: false)
                              .createOrder(
                            context,
                            selectedDateString.toString(),
                            selectedTimeString.toString(),
                            StorageHelper().getEmail(),
                            fullNameController.text.toString(),
                            ageController.text.toString(),
                            phoneController.text.toString(),
                            altPhoneController.text.toString(),
                            selectedGender.toString(),
                            cityAddressController.text.toString(),
                            selectedPlace.toString(),
                            selectedAddressType.toString(),
                          );
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
          }),
        ],
      ),
    );
  }

  Widget buildBookingForm() {
    print("Booking for=> ${selectedBookingFor}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckoutTextField(
          label: "Name*",
          hint: "Enter name",
          controller: fullNameController,
          isRequired: true,
        ),
        CheckoutTextField(
          label: "Age*",
          hint: "Enter age",
          controller: ageController,
          isRequired: true,
          maxLength: 2,
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
        buildAltPhoneField(),
      ],
    );
  }

  Widget buildShippingForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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

        SizedBox(
          height: 5,
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Choose Location",
                style: AppTextStyles.bodyText1(
                  context,
                  overrideStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveHelper.fontSize(context, 12)),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GoogleMapSearchPlacesApi(),
                    ),
                  );

                  if (result != null) {
                    setState(() {
                      selectedPlace = result;
                    });
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            selectedPlace ?? "Lucknow",
                            style: AppTextStyles.bodyText1(
                              context,
                              overrideStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: ResponsiveHelper.fontSize(context, 13)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(
          height: 5,
        ),
        CheckoutTextField(
          label: "Address*",
          hint: "123 Main Street, City, Country",
          controller: cityAddressController,
        ),

        AddressTypeSelector(
          addressTypes: ["Home", "Work", "Other"],
          selectedAddressType: selectedAddressType,
          onSelected: (value) {
            setState(() {
              selectedAddressType = value;
              print("Address type =>${selectedAddressType.toString()}");
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
          Text(
            title,
            style: AppTextStyles.bodyText1(
              context,
              overrideStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveHelper.fontSize(context, 12)),
            ),
          ),
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
                  Text(
                    selectedValue,
                      style: AppTextStyles.bodyText1(
                        context,
                        overrideStyle: TextStyle(
                            color: Colors.black,
                            fontSize: ResponsiveHelper.fontSize(context, 13)),
                      ),
                  ),
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
    print("selectedDateString: $selectedDateString"); // Debugging output
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select Booking Date",
            style: AppTextStyles.bodyText1(
              context,
              overrideStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveHelper.fontSize(context, 12)),
            ),
          ),
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
                    selectedDateString ?? "Select Date",
                    // ✅ Display formatted date
                    // "${DateUtil.formatDate(
                    //   date: "${selectedDate}",
                    //   currentFormat: "yyyy-MM-dd",
                    //   desiredFormat: "dd-MM-yyyy",
                    // )}", // ✅ Formatted date
                    // DateFormat("dd-MM-yy").format(selectedDate), // ✅ Formatted date

                    style: AppTextStyles.bodyText1(
                      context,
                      overrideStyle: TextStyle(
                          color: Colors.black,
                          fontSize: ResponsiveHelper.fontSize(context, 13)),
                    ),
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
        selectedDateString = DateUtil.formatDate(
            date: picked.toString(),
            currentFormat: "yyyy-MM-dd HH:mm:ss.SSS",
            desiredFormat:
                "yyyy-MM-dd"); // ✅ Store selected date in correct format
        print("selectedDateString: $selectedDateString"); // Debugging output
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
        selectedTimeString = "${selectedTime!.hourOfPeriod}:${selectedTime!.minute.toString().padLeft(2, '0')} ${selectedTime!.period == DayPeriod.am ? "AM" : "PM"}";
        print("selected booking time=>${selectedTime}");
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
          Text(
            title,
            style: AppTextStyles.bodyText1(
              context,
              overrideStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveHelper.fontSize(context, 12)),
            ),
          ),
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
                  Text(
                    selectedValue ?? title,
                    style: AppTextStyles.bodyText1(
                      context,
                      overrideStyle: TextStyle(
                          color: Colors.black,
                          fontSize: ResponsiveHelper.fontSize(context, 13)),
                    ),
                  ),
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
                        title: Text(
                          item,
                          style: AppTextStyles.bodyText1(
                            context,
                            overrideStyle: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    ResponsiveHelper.fontSize(context, 13)),
                          ),
                        ),
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
            double discount = 0.00;
            double orderTotal = cartTotal - discount;
            StorageHelper().setOrderTotalToPrefs(orderTotal);

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
                                      color: AppColors.lightBlueColor,
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
                                        StringUtils.toUpperCase(orserItem.name),
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
                                    value: '₹$discount'),
                                // SummaryRow(
                                //     label: 'Sample Collection Charges',
                                //     value: '₹250.00 Free'),
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
        hint: "Enter phone number",
        controller: phoneController,
        maxLength: 10,
        keyboardType: TextInputType.number,
        isRequired: true);

    // buildTextField(
    //   "Phone Number*", "Enter phone number", phoneController,
    //   keyboardType: TextInputType.number, isRequired: true);
  }

  Widget buildAltPhoneField() {
    return CheckoutTextField(
        label: "Alternate Number",
        hint: "Alternate number",
        controller: altPhoneController,
        maxLength: 10,
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
           Text(            "Select Address Type",

              style: AppTextStyles.bodyText1(
                context,
                overrideStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: ResponsiveHelper.fontSize(context, 12)),
              ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10, // Spacing between chips
            children: widget.addressTypes.map((type) {
              return ChoiceChip(
                label: Text(type),
                selected: _selectedType == type,
                selectedColor: AppColors.primary,
                checkmarkColor: Colors.white,
                labelStyle:AppTextStyles.heading1(
                  context,
                  overrideStyle: TextStyle(
                      color: _selectedType == type ? AppColors.whiteColor : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveHelper.fontSize(context, 12)),
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
          // _buildPaymentOption(
          //   title: "Pay with Razorpay",
          //   subtitle: "Pay securely using Razorpay",
          //   image: "assets/images/razorpayicon.png",
          //   value: "razorpay",
          // ),

          //✅ Cash on Delivery (COD) Option
          _buildPaymentOption(
            title: "Cash on Delivery",
            subtitle: "Pay cash upon receiving the order",
            image: "assets/images/codimage.png",
            value: "razorpay",
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
            ImageLoaderUtil.assetImage(image, width: 40, height: 40),
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
