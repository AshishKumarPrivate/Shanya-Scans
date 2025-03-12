import 'package:flutter/material.dart';
import '../../base_widgets/custom_rounded_container.dart';
import '../../base_widgets/custom_text_field.dart';
import '../../base_widgets/gender_selection_screen.dart';
import '../../base_widgets/solid_rounded_button.dart';
import '../../ui_helper/app_colors.dart';
import '../../ui_helper/app_text_styles.dart';
import '../../ui_helper/responsive_helper.dart';

class ServiceDetailUserForm extends StatefulWidget {
  final Function(String gender) onGenderSelected;
  final VoidCallback onSubmit;
  final TextEditingController nameController;
  final TextEditingController mobileController;
  final TextEditingController whatsappController;
  final TextEditingController emailController;
  final TextEditingController cityController;
  final TextEditingController addressController;
  final TextEditingController ageController;
  final String packageName;

  const ServiceDetailUserForm({
    Key? key,
    required this.onGenderSelected,
    required this.onSubmit,
    required this.nameController,
    required this.mobileController,
    required this.whatsappController,
    required this.emailController,
    required this.cityController,
    required this.addressController,
    required this.ageController,
    required this.packageName,
  }) : super(key: key);

  @override
  _ServiceDetailUserFormState createState() => _ServiceDetailUserFormState();
}

class _ServiceDetailUserFormState extends State<ServiceDetailUserForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Container(
        color: AppColors.whiteColor,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel(context, "Selected Test"),
              _buildInfoContainer(widget.packageName),

              _buildLabel(context, "Full Name"),
              _buildTextField(widget.nameController, "Enter your name"),

              _buildLabel(context, "Mobile"),
              _buildTextField(widget.mobileController, "Enter your mobile",
                  keyboardType: TextInputType.number),

              _buildLabel(context, "Gender"),
              const SizedBox(height: 10),
              GenderSelectionScreen(onGenderSelected: widget.onGenderSelected),

              _buildLabel(context, "Age"),
              _buildTextField(widget.ageController, "Enter your age",
                  keyboardType: TextInputType.number),

              _buildLabel(context, "WhatsApp Number"),
              _buildTextField(
                  widget.whatsappController, "Enter your WhatsApp number",
                  keyboardType: TextInputType.number),

              _buildLabel(context, "Email"),
              _buildTextField(widget.emailController, "Enter your email",
                  keyboardType: TextInputType.emailAddress),

              _buildLabel(context, "City"),
              _buildTextField(widget.cityController, "Enter your city"),

              _buildLabel(context, "Address"),
              _buildTextField(widget.addressController, "Enter your address",
                  isMultiLine: true),

              const SizedBox(height: 20),
              // ***************** instruction tabs  start ******************
              Container(
                height: 400,
                color: AppColors.lightYellowColor,
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                width: double.infinity,
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(height: 15),
                      DefaultTabController(
                        length: 2,
                        child: Column(
                          children: [
                            // Text(
                            //     'Instructions in English'),
                            // SizedBox(height: 10,),
                            Container(
                              color: Colors.white,
                              // Background color for the tab bar
                              child: TabBar(
                                dividerColor: Colors.transparent,
                                indicator: BoxDecoration(
                                  color: AppColors.primary,
                                  // Background color for selected tab
                                  borderRadius: BorderRadius.circular(
                                      50), // Optional rounded corners
                                ),
                                indicatorPadding: EdgeInsets.zero,
                                labelColor: Colors.white,
                                // Text color for selected tab
                                unselectedLabelColor: AppColors.txtGreyColor,
                                // Text color for unselected tabs
                                tabs: [
                                  Container(
                                    width: double.infinity,
                                    height: 30,
                                    // Adjust tab height here
                                    alignment: Alignment.center,
                                    child: Text('English'),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    // height: 30,
                                    // Adjust tab height here
                                    alignment: Alignment.center,
                                    child: Text('Hindi'),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            SizedBox(
                              height: 300,
                              // Change the height of the TabBarView here
                              child: TabBarView(
                                children: [
                                  Container(
                                    child: buildInstructions(type: "eng"),
                                    color: Colors.white,
                                  ),
                                  Container(
                                    child: buildInstructions(type: "hindi"),
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                    ],
                  ),
                ),
              ),

              // ***************** instruction tabs  end ******************
              const SizedBox(height: 20),
              SolidRoundedButton(
                text: 'Submit',
                color: AppColors.primary,
                borderRadius: 10.0,
                onPressed: widget.onSubmit,
                textStyle: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: AppTextStyles.bodyText1(
          context,
          overrideStyle: TextStyle(
              color: Colors.black,
              fontSize: ResponsiveHelper.fontSize(context, 14)),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      {TextInputType keyboardType = TextInputType.text,
      bool isMultiLine = false}) {
    return CustomRoundedContainer(
      borderRadius: 5.0,
      borderColor: Colors.black,
      borderWidth: 0.1,
      elevation: 3.0,
      backgroundColor: Colors.white,
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTransparentTextField(
            controller: controller,
            hintText: hintText,
            keyboardType: keyboardType,
            multiLines: isMultiLine,
            maxLines: isMultiLine ? 5 : 1,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoContainer(String text) {
    return CustomRoundedContainer(
      borderRadius: 5.0,
      borderColor: AppColors.txtGreyColor,
      borderWidth: 0,
      elevation: 1,
      backgroundColor: AppColors.txtLightGreyColor.withOpacity(0.02),
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: double.infinity,
        child: Text(
          text,
          style: AppTextStyles.bodyText1(
            context,
            overrideStyle:
                TextStyle(fontSize: ResponsiveHelper.fontSize(context, 14)),
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
