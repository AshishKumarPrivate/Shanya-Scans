import 'package:flutter/material.dart';
import 'package:healthians/screen/other/service_detail_user_form.dart';
import 'package:healthians/ui_helper/responsive_helper.dart';
import 'package:healthians/ui_helper/app_text_styles.dart';
import '../../base_widgets/common/common_app_bar.dart';
import '../../base_widgets/expandable_text_widget.dart';
import '../../ui_helper/app_colors.dart';

class ServicesDetailListDetailBuyNowScreen extends StatefulWidget {
  final String productName;

  ServicesDetailListDetailBuyNowScreen({required this.productName});

  @override
  State<ServicesDetailListDetailBuyNowScreen> createState() =>
      _ServicesDetailListDetailBuyNowScreenState();
}

class _ServicesDetailListDetailBuyNowScreenState
    extends State<ServicesDetailListDetailBuyNowScreen> {
  final List<Map<String, dynamic>> itemsList = [
    {
      'title': 'Comprehensive Full Body Checkup with Vitamin D B12',
      'price': '1199',
      'oldPrice': '2199',
      'tests': 'Includes 92 tests',
      'discount': '45% OFF',
      'fasting': 'Fasting required',
      'reportTime': 'Reports in 15 Hrs',
    },
    {
      'title': 'Senior Citizen Health Checkup',
      'price': '999',
      'oldPrice': '1949',
      'tests': 'Includes 87 tests',
      'discount': '49% OFF',
      'fasting': 'Fasting not required',
      'reportTime': 'Reports in 24 Hrs',
    },
    {
      'title': 'Women’s Master Checkup',
      'price': '1299',
      'oldPrice': '2299',
      'tests': 'Includes 93 tests',
      'discount': '43% OFF',
      'fasting': 'Fasting required',
      'reportTime': 'Reports in 12 Hrs',
    },
  ];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  String selectedGender = "";

  void _handleGenderSelected(String gender) {
    setState(() {
      selectedGender = gender;
    });
  }

  void _handleSubmit() {
    print("Name: ${nameController.text}");
    print("Mobile: ${mobileController.text}");
    print("WhatsApp: ${whatsappController.text}");
    print("Email: ${emailController.text}");
    print("City: ${cityController.text}");
    print("Address: ${addressController.text}");
    print("Age: ${ageController.text}");
    print("Gender: $selectedGender");

    // Perform submission logic here
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
              CommonAppBar(aciviyName: widget.productName,
                backgroundColor: AppColors.primary,),
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
                              '${widget.productName}',
                              style: AppTextStyles.heading1(context,
                                  overrideStyle: TextStyle(
                                      fontSize: ResponsiveHelper.fontSize(
                                          context, 16))),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '69 Tests Included',
                              style: AppTextStyles.bodyText1(
                                context,
                                overrideStyle: AppTextStyles.bodyText1(context,
                                    overrideStyle: TextStyle(
                                        color: AppColors.txtLightGreyColor,
                                        fontSize: ResponsiveHelper.fontSize(
                                            context, 12))),
                              ),
                            ),

                            // Details Row
                            // SizedBox(height: 15),
                            // CustomRoundedContainer(
                            //   borderRadius: 5,
                            //   borderColor:
                            //       AppColors.txtLightGreyColor.withOpacity(0.06),
                            //   borderWidth: 1,
                            //   elevation: 0,
                            //   backgroundColor: Colors.white,
                            //   child: Row(
                            //     // mainAxisAlignment: MainAxisAlignment.start,
                            //     // crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Column(
                            //         crossAxisAlignment: CrossAxisAlignment.start,
                            //         children: [
                            //           _buildDetailItem(
                            //               'No fasting required', Icons.cancel),
                            //           SizedBox(
                            //             height: 8,
                            //           ),
                            //           _buildDetailItem(
                            //               'Reports within 96 hrs', Icons.access_time),
                            //         ],
                            //       ),
                            //       SizedBox(
                            //         width: 100,
                            //       ),
                            //       Column(
                            //         crossAxisAlignment: CrossAxisAlignment.start,
                            //         children: [
                            //           _buildDetailItem(
                            //               'For Male, Female', Icons.person),
                            //           SizedBox(
                            //             height: 8,
                            //           ),
                            //           _buildDetailItem('Age: 5-99 yrs.', Icons.group),
                            //         ],
                            //       )
                            //     ],
                            //   ),
                            // ),
                            SizedBox(height: 15),

                            // Price Section
                            Row(
                              children: [
                                Text(
                                  '₹672',
                                  style: AppTextStyles.heading1(context,
                                      overrideStyle: TextStyle(
                                          fontSize: ResponsiveHelper.fontSize(
                                              context, 20))),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '₹1599',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 16),
                            // Description Section
                            Text(
                              'Description',
                              style: AppTextStyles.heading1(context,
                                  overrideStyle: TextStyle(
                                      fontSize: ResponsiveHelper.fontSize(
                                          context, 14))),
                            ),
                            SizedBox(height: 8),
                            ExpandableTextWidget(
                              text:
                                  "Healthians' brings forth a detailed health checkup to ensure you lead a healthy life. The package includes a series of testsHealthians' brings forth a detailed health checkup to ensure you lead a healthy life. The package includes a series of tests...",
                            ),
                            SizedBox(height: 16),

                            // Call or Chat Section
                            // Container(
                            //   padding: EdgeInsets.all(16),
                            //   decoration: BoxDecoration(
                            //     color: Colors.green.shade100,
                            //     borderRadius: BorderRadius.circular(8),
                            //   ),
                            //   child: Row(
                            //     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //     // crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Container(
                            //         child: Column(
                            //           crossAxisAlignment: CrossAxisAlignment.start,
                            //           children: [
                            //             Text(
                            //               'Call or chat with a Health Expert',
                            //               style: AppTextStyles.heading2.copyWith(
                            //                 color: Colors.black,
                            //                 fontSize: 12,
                            //               ),
                            //             ),
                            //             SizedBox(height: 4),
                            //             Text(
                            //               'Need help? Talk to our health experts!',
                            //               style: AppTextStyles.bodyText1.copyWith(
                            //                 color: Colors.black,
                            //                 fontSize: 12,
                            //               ),
                            //             ),
                            //             SizedBox(height: 10),
                            //             SizedBox(
                            //               // width: 100,
                            //               // height: 25,
                            //               child: CustomRoundedContainer(
                            //                 padding: EdgeInsets.symmetric(
                            //                     vertical: 2, horizontal: 10),
                            //                 borderRadius: 5,
                            //                 borderColor: Colors.transparent,
                            //                 borderWidth: 1,
                            //                 elevation: 0,
                            //                 backgroundColor: AppColors.primary,
                            //                 child: Row(
                            //                   crossAxisAlignment:
                            //                       CrossAxisAlignment.center,
                            //                   children: [
                            //                     Image.asset(
                            //                       "assets/images/whatsapp.png",
                            //                       width: 15,
                            //                       height: 15,
                            //                       color: Colors.white,
                            //                     ),
                            //                     SizedBox(
                            //                       width: 5,
                            //                     ),
                            //                     InkWell(
                            //                       onTap: () async {
                            //                         // await whatsapp();
                            //                         print("open Whatsapp");
                            //                       },
                            //                       child: Text(
                            //                         'Chat With Us',
                            //                         style: TextStyle(
                            //                             fontWeight: FontWeight.bold,
                            //                             color: Colors.white,
                            //                             fontSize: 12,
                            //                             letterSpacing: 1),
                            //                       ),
                            //                     ),
                            //                   ],
                            //                 ),
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //       Visibility(
                            //         visible: false,
                            //         child: Column(
                            //           mainAxisAlignment: MainAxisAlignment.end,
                            //           // crossAxisAlignment: CrossAxisAlignment.start,
                            //           children: [
                            //             Container(
                            //               color: Colors.black,
                            //               child: Image.asset(
                            //                 "assets/images/user.png",
                            //                 width: 50,
                            //                 height: 50,
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       )
                            //     ],
                            //   ),
                            // ),
                            //
                            // SizedBox(height: 15),
                            buildTestInformation(),
                            // SizedBox(
                            //   height: 15,
                            // ),

                            // form for submit patient report
                            ServiceDetailUserForm(
                              packageName: widget.productName,
                              nameController: nameController,
                              mobileController: mobileController,
                              whatsappController: whatsappController,
                              emailController: emailController,
                              cityController: cityController,
                              addressController: addressController,
                              ageController: ageController,
                              onGenderSelected: _handleGenderSelected,
                              onSubmit: _handleSubmit,
                            ),

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

class buildTestInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final testCategories = [
      {'title': 'Fasting: 4-6 hours prior to the scan', 'count': 12},
      {'title': 'Duration of the scan: 30-60 minutes', 'count': 11},
      {
        'title':
            'Radioactive Injection: To create detailed images during the scan',
        'count': 21
      },
      {
        'title':
            'Post-scan: You may resume your normal activities after the scan, but drink plenty of fluids to help eliminate the radioactive material from your body.',
        'count': 24
      },
      // {'title': 'Random Blood Sugar', 'count': 1},
    ];

    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Test Information",
              style: AppTextStyles.heading1(context,
                  overrideStyle: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(context, 14))),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Scrollbar(
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
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
                                height: 0.4,
                                // Align bullet vertically with text
                                color: Colors.black, // Bullet color
                              ),
                            ),
                          ),
                          SizedBox(width: 8), // Space between bullet and text
                          Expanded(
                            child: Text(
                              " ${category['title']!}",
                              style: AppTextStyles.bodyText1(
                                context,
                                overrideStyle: AppTextStyles.bodyText1(context,
                                    overrideStyle: TextStyle(
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
            ),
          ],
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
