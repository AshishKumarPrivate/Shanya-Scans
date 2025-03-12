import 'package:flutter/material.dart';
import '../../base_widgets/custom_rounded_container.dart';
import '../../base_widgets/custom_text_field.dart';
import '../../base_widgets/gender_selection_screen.dart';
import '../../base_widgets/solid_rounded_button.dart';
import '../../ui_helper/app_colors.dart';
import '../../ui_helper/app_text_styles.dart';
import '../../ui_helper/responsive_helper.dart';

class PathalogyTestUserForm extends StatefulWidget {
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

  const PathalogyTestUserForm({
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
  _PathalogyTestUserFormState createState() => _PathalogyTestUserFormState();
}

class _PathalogyTestUserFormState extends State<PathalogyTestUserForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Container(
        color: AppColors.whiteColor,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel(context, "Selected Test"),
              _buildInfoContainer(widget.packageName),

              _buildLabel(context, "Full Name"),
              _buildTextField(widget.nameController, "Enter your name"),

              _buildLabel(context, "Mobile"),
              _buildTextField(widget.mobileController, "Enter your mobile", keyboardType: TextInputType.number),

              _buildLabel(context, "Gender"),
              const SizedBox(height: 10),
              GenderSelectionScreen(onGenderSelected: widget.onGenderSelected),

              _buildLabel(context, "Age"),
              _buildTextField(widget.ageController, "Enter your age", keyboardType: TextInputType.number),

              _buildLabel(context, "WhatsApp Number"),
              _buildTextField(widget.whatsappController, "Enter your WhatsApp number", keyboardType: TextInputType.number),

              _buildLabel(context, "Email"),
              _buildTextField(widget.emailController, "Enter your email", keyboardType: TextInputType.emailAddress),

              _buildLabel(context, "City"),
              _buildTextField(widget.cityController, "Enter your city"),

              _buildLabel(context, "Address"),
              _buildTextField(widget.addressController, "Enter your address", isMultiLine: true),

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
          overrideStyle: TextStyle(color: Colors.black, fontSize: ResponsiveHelper.fontSize(context, 14)),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, {TextInputType keyboardType = TextInputType.text, bool isMultiLine = false}) {
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
            overrideStyle: TextStyle(fontSize: ResponsiveHelper.fontSize(context, 14)),
          ),
        ),
      ),
    );
  }
}
