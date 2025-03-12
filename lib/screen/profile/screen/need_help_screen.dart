import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../util/dimensions.dart';
import '../controller/need_help_api_provider.dart';
import '../../../base_widgets/custom_text_field.dart';
import '../../../base_widgets/custom_rounded_container.dart';
import '../../../base_widgets/solid_rounded_button.dart';
import '../../../ui_helper/app_colors.dart';
import '../../../ui_helper/app_text_styles.dart';
import '../../../ui_helper/responsive_helper.dart';
import '../../../ui_helper/storage_helper.dart';

class NeedHelpScreen extends StatefulWidget {
  @override
  State<NeedHelpScreen> createState() => _NeedHelpScreenState();
}

class _NeedHelpScreenState extends State<NeedHelpScreen> {
  final TextEditingController messageTextController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final needHelpProvider = context.read<NeedHelpApiProvider>();
      needHelpProvider.sendEnquiry(
        context,
        firstNameController.text.trim(),
        lastNameController.text.trim(),
        subjectController.text.trim(),
        messageTextController.text.trim(),
      );
    }
  }

  String? _validateField(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName is required";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Need Help",style: TextStyle(fontSize: 18),)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsiveHelper.sizeBoxHeightSpace(context, 2),
                Text("We would like to hear something from you",
                    style: AppTextStyles.bodyText2(context)),
                ResponsiveHelper.sizeBoxHeightSpace(context, 2),

                // CustomRoundedContainer(
                //   borderRadius: 10.0,
                //   elevation: 3.0,
                //   backgroundColor: Colors.white,
                //   padding: EdgeInsets.all(10.0),
                //   borderColor: AppColors.txtGreyColor,
                //   borderWidth: 0.2,
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       _buildInfoRow("Name", StorageHelper().getUserName()),
                //       _buildDivider(),
                //       _buildInfoRow("Email", StorageHelper().getEmail()),
                //       _buildDivider(),
                //       _buildInfoRow("Mobile", StorageHelper().getPhoneNumber()),
                //     ],
                //   ),
                // ),
                // ResponsiveHelper.sizeBoxHeightSpace(context, 2),


                _buildInputField("First Name", firstNameController),
                _buildInputField("Last Name", lastNameController),
                _buildInputField("Subject", subjectController),
                _buildInputField("Query Message", messageTextController, isMultiline: true),
                ResponsiveHelper.sizeBoxHeightSpace(context, 2),
                Consumer<NeedHelpApiProvider>(
                  builder: (context, needHelpProvider, child) {
                    return needHelpProvider.isLoading
                        ? Center(child: CircularProgressIndicator())
                        : SolidRoundedButton(
                            text: 'Submit',
                            color: AppColors.primary,
                            borderRadius: 10.0,
                            onPressed: _handleSubmit,
                          );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller,
      {bool isMultiline = false}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyText1(
              context,
              overrideStyle: TextStyle(
                color: Colors.black,
                fontSize:
                    ResponsiveHelper.fontSize(context, Dimensions.fontSize12),
              ),
            ),
          ),
          SizedBox(height: 5),
          FormField<String>(
            validator: (value) {
              if (controller.text.trim().isEmpty) {
                return "$label is required"; // ✅ Show error if blank
              }
              return null;
            },
            builder: (FormFieldState<String> field) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomRoundedContainer(
                    borderRadius: 10.0,
                    borderColor: Colors.black,
                    borderWidth: 0.1,
                    elevation: 3.0,
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.all(10.0),
                    child: CustomTransparentTextField(
                      hintText: "Enter $label",
                      controller: controller,
                      maxLines: isMultiline ? 5 : 1,
                      multiLines: isMultiline,
                      onChanged: (value) {
                        field.didChange(value); // ✅ Update validation on change
                      },
                    ),
                  ),
                  if (field.hasError) ...[
                    SizedBox(height: 5),
                    Text(
                      field.errorText ?? "",
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ],
                ],
              );
            },
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.heading2(
            context,
            overrideStyle: TextStyle(
              color: Colors.black,
              fontSize: ResponsiveHelper.fontSize(
                  context, Dimensions.fontSize12),
            ),
          ),
        ),
        Text(value, style: TextStyle(color: AppColors.primary, fontSize: 14)),
      ],
    );
  }

  Widget _buildDivider() => Divider(color: Colors.grey, thickness: 0.2);
}
