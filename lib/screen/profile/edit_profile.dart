import 'package:flutter/material.dart';
import 'package:shanya_scans/ui_helper/responsive_helper.dart';
import 'package:shanya_scans/ui_helper/app_text_styles.dart';
import 'package:shanya_scans/base_widgets/custom_rounded_container.dart';
import 'package:shanya_scans/ui_helper/storage_helper.dart';
import 'package:provider/provider.dart';

import '../../base_widgets/custom_text_field.dart';
import '../../base_widgets/loading_indicator.dart';
import '../../base_widgets/solid_rounded_button.dart';
import '../../ui_helper/app_colors.dart';
import '../auth/controller/auth_provider.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // const EditProfileScreen({super.key});
  final TextEditingController nameController =
      TextEditingController(text: "${StorageHelper().getUserName()}");

  // Default text
  final TextEditingController emailController =
      TextEditingController(text: "${StorageHelper().getEmail()}");

  // Default text
  final TextEditingController mobileController =
      TextEditingController(text: "${StorageHelper().getPhoneNumber()}");

  // Default text
  final TextEditingController whatsappNoController =
      TextEditingController(text: "${StorageHelper().getWhatsappNumber()}");

  // Default text
  final TextEditingController ageController = TextEditingController(text: "${StorageHelper().getAge()}");
  String _selectedGender = ''; // Variable to store the selected gender

  // Default text
  void _handleGenderSelected(String gender) {
    setState(() {
      _selectedGender = gender;
    });
    print(
        "Selected Gender: $_selectedGender"); // Print the selected gender value
  }

  // handle the login api here
  void handleSubmit() {
    final editProfileProvider = context.read<AuthApiProvider>();
    editProfileProvider.updateProfile(context,StorageHelper().getUserId(), nameController.text,
        mobileController.text, ageController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Update Profile", // Fixed typo in "Profile"
          style:  AppTextStyles.heading1(context,
              overrideStyle: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(
                      context, 14))),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          tooltip: 'Back',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true, // Ensures the title is centered
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 70,
                    height: 70,
                    child: CircleAvatar(
                      radius: 20, // Image radius
                      backgroundImage: AssetImage('assets/images/user.png'),
                    ),
                  ),
                  SizedBox(width: 10), // Space between avatar and containern
                  Expanded(
                    // Ensures the CustomRoundedContainer takes up remaining space
                    child: CustomRoundedContainer(
                      borderRadius: 10.0,
                      borderColor: Colors.black,
                      borderWidth: 0.1,
                      elevation: 3.0,
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Name",
                            style: AppTextStyles.bodyText1(
                              context,
                              overrideStyle: AppTextStyles.bodyText1(context,
                                  overrideStyle: TextStyle(
                                    color: Colors.black,
                                      fontSize: ResponsiveHelper.fontSize(context, 12))),
                            ),
                          ),
                          Divider(
                            color: Colors.grey, // Line color
                            thickness: 0.2, // Line thickness
                            // Right spacing
                          ),
                          CustomTransparentTextField(
                            hintText: "Enter your Name",
                            keyboardType: TextInputType.name,
                            controller: nameController,
                          ),
                        ],
                      ),
                      onTap: () {
                        print("Container tapped!");
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25), // Space between avatar and container
              CustomRoundedContainer(
                borderRadius: 10.0,
                borderColor: Colors.black,
                borderWidth: 0.1,
                elevation: 3.0,
                backgroundColor: Colors.white,
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Email",
                      style: AppTextStyles.bodyText1(
                        context,
                        overrideStyle: AppTextStyles.bodyText1(context,
                            overrideStyle: TextStyle(
                                color: Colors.black,
                                fontSize: ResponsiveHelper.fontSize(context, 12))),
                      ),
                    ),
                    Divider(
                      color: Colors.grey, // Line color
                      thickness: 0.2, // Line thickness
                      // Right spacing
                    ),
                    CustomTransparentTextField(
                      hintText: "Enter your email",
                      keyboardType: TextInputType.name,
                      controller: emailController,
                      isEnable: false,
                    ),
                  ],
                ),
                onTap: () {
                  print("Container tapped!");
                },
              ),
              SizedBox(height: 25), // Space between avatar and container
              CustomRoundedContainer(
                borderRadius: 10.0,
                borderColor: Colors.black,
                borderWidth: 0.1,
                elevation: 3.0,
                backgroundColor: Colors.white,
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mobile",
                      style: AppTextStyles.bodyText1(
                        context,
                        overrideStyle: AppTextStyles.bodyText1(context,
                            overrideStyle: TextStyle(
                                color: Colors.black,
                                fontSize: ResponsiveHelper.fontSize(context, 12))),
                      ),
                    ),
                    Divider(
                      color: Colors.grey, // Line color
                      thickness: 0.2, // Line thickness
                      // Right spacing
                    ),
                    CustomTransparentTextField(
                      hintText: "Enter your mobile",
                      keyboardType: TextInputType.number,
                      controller: mobileController,
                        maxLength: 10
                    ),
                  ],
                ),
                onTap: () {
                  print("Container tapped!");
                },
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: CustomRoundedContainer(
                      borderRadius: 10.0,
                      borderColor: Colors.black,
                      borderWidth: 0.1,
                      elevation: 3.0,
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Whatsapp No",
                            style: AppTextStyles.bodyText1(
                              context,
                              overrideStyle: AppTextStyles.bodyText1(context,
                                  overrideStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: ResponsiveHelper.fontSize(context, 12))),
                            ),
                          ),
                          Divider(
                            color: Colors.grey, // Line color
                            thickness: 0.2, // Line thickness
                          ),
                          CustomTransparentTextField(
                            hintText: "Whatsapp No",
                            keyboardType: TextInputType.number,
                            controller: whatsappNoController,
                            maxLength: 10,
                          ),
                        ],
                      ),
                      onTap: () {
                        print("Container tapped!");
                      },
                    ),
                  ),
                  SizedBox(width: 25),
                  Flexible(
                    child: CustomRoundedContainer(
                      borderRadius: 10.0,
                      borderColor: Colors.black,
                      borderWidth: 0.1,
                      elevation: 3.0,
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Age",
                            style: AppTextStyles.bodyText1(
                              context,
                              overrideStyle: AppTextStyles.bodyText1(context,
                                  overrideStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: ResponsiveHelper.fontSize(context, 12))),
                            ),
                          ),
                          Divider(
                            color: Colors.grey, // Line color
                            thickness: 0.2, // Line thickness
                          ),
                          CustomTransparentTextField(
                            hintText: "Enter your age",
                            keyboardType: TextInputType.datetime,
                            controller: ageController,
                          ),
                        ],
                      ),
                      onTap: () {
                        print("Container tapped!");
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              // AsteriskTextWidget(text: "Gender"),
              // SizedBox(height: 15),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Flexible(
              //       child: GenderSelectionScreen(
              //         onGenderSelected:
              //             _handleGenderSelected, // Pass the callback here
              //       ),
              //     ),
              //
              //   ],
              // ),
              // SizedBox(height: 25),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Flexible(
              //       child: CustomRoundedContainer(
              //         borderRadius: 10.0,
              //         borderColor: Colors.black,
              //         borderWidth: 0.1,
              //         elevation: 3.0,
              //         backgroundColor: Colors.white,
              //         padding: EdgeInsets.all(10.0),
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               "Height (ft/inch)",
              //               style: AppTextStyles.bodyText1(
              //                 context,
              //                 overrideStyle: AppTextStyles.bodyText1(context,
              //                     overrideStyle: TextStyle(
              //                         fontSize: ResponsiveHelper.fontSize(context, 14))),
              //               ),
              //             ),
              //             Divider(
              //               color: Colors.grey, // Line color
              //               thickness: 0.2, // Line thickness
              //             ),
              //             Text(
              //               "5'09'",
              //               style: AppTextStyles.bodyText1(
              //                 context,
              //                 overrideStyle: AppTextStyles.bodyText1(context,
              //                     overrideStyle: TextStyle(
              //                       color: Colors.black,
              //                         fontSize: ResponsiveHelper.fontSize(context, 14))),
              //               ),
              //             ),
              //           ],
              //         ),
              //         onTap: () {
              //           print("Container tapped!");
              //         },
              //       ),
              //     ),
              //     SizedBox(width: 25),
              //     Flexible(
              //       child: CustomRoundedContainer(
              //         borderRadius: 10.0,
              //         borderColor: Colors.black,
              //         borderWidth: 0.1,
              //         elevation: 3.0,
              //         backgroundColor: Colors.white,
              //         padding: EdgeInsets.all(10.0),
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               "Weight (Kg)",
              //               style: AppTextStyles.bodyText1(
              //                 context,
              //                 overrideStyle: AppTextStyles.bodyText1(context,
              //                     overrideStyle: TextStyle(
              //                         fontSize: ResponsiveHelper.fontSize(context, 14))),
              //               ),
              //             ),
              //             Divider(
              //               color: Colors.grey, // Line color
              //               thickness: 0.2, // Line thickness
              //             ),
              //             Text(
              //               "54",
              //               style: AppTextStyles.bodyText1(
              //                 context,
              //                 overrideStyle: AppTextStyles.bodyText1(context,
              //                     overrideStyle: TextStyle(
              //                       color: Colors.black,
              //                         fontSize: ResponsiveHelper.fontSize(context, 14))),
              //               ),
              //             ),
              //           ],
              //         ),
              //         onTap: () {
              //           print("Container tapped!");
              //         },
              //       ),
              //     ),
              //   ],
              // ),
              //
              // SizedBox(height: 25),

              // ✅ Consumer Wrap kiya hai sirf Button ke upar taaki poora widget rebuild na ho
              Consumer<AuthApiProvider>(
                builder: (context, signUpProvider, child) {
                  print("✅ Consumer call ho rha hai ");
                  return signUpProvider.isLoading
                      ? loadingIndicator() // Show loader
                      :  SolidRoundedButton(
                    text: 'Update Profile',
                    color: AppColors.primary,
                    borderRadius: 10.0,
                    onPressed: () {
                      print('Button clicked!');
                      handleSubmit();
                    },
                    textStyle: TextStyle(color: Colors.white, fontSize: 18),
                    // icon: Icon(Icons.touch_app, color: Colors.white),
                  );
                },
              ),





              // Center(
              //   child: SolidRoundedButton(
              //     text: 'Update Profile',
              //     color: AppColors.primary,
              //     borderRadius: 10.0,
              //     onPressed: () {
              //       print('Button clicked!');
              //     },
              //     textStyle: TextStyle(color: Colors.white, fontSize: 18),
              //     // icon: Icon(Icons.touch_app, color: Colors.white),
              //   ),
              // ),









            ],
          ),
        ),
      ),
    );
  }
}
