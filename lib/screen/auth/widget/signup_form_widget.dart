import 'package:flutter/material.dart';
import 'package:shanya_scans/screen/auth/controller/auth_provider.dart';
import 'package:shanya_scans/screen/auth/login_screen.dart';
import 'package:shanya_scans/base_widgets/loading_indicator.dart';
import 'package:provider/provider.dart';
import '../../../base_widgets/common/custom_text_field.dart';
import '../../../base_widgets/solid_rounded_button.dart';
import '../../../ui_helper/app_colors.dart';
import '../../../ui_helper/app_text_styles.dart';
import '../../../ui_helper/responsive_helper.dart';

class SignUpFormWidget extends StatefulWidget {
  const SignUpFormWidget({super.key});

  @override
  _SignUpFormWidgetState createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>(); // 🔹 Add Form Key for validation

  // handle the login api here
  void handleSubmit() {
    final signUpProvider = context.read<AuthApiProvider>();
    print("🟢 Login Button Clicked");
    if (nameController.text.isEmpty ||
        phoneNumberController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      print("🔴 Validation Failed: Fields are empty");
      return;
    }
    signUpProvider.signUpUser(context, nameController.text, phoneNumberController.text,
        emailController.text, passwordController.text);
  }

  @override
  void initState() {
    super.initState();
    _nameFocusNode.addListener(() => setState(() {}));
    _phoneNumberFocusNode.addListener(() => setState(() {}));
    _emailFocusNode.addListener(() => setState(() {}));
    _passwordFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Hide keyboard on tap
      },
      child: Form(
        key: _formKey, // 🔹 Wrap in Form for validation
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Container(
            color: AppColors.whiteColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                // _buildLabel(context, "Full Name"),
                CustomTextField(
                  controller: nameController,
                  focusNode: _nameFocusNode,
                  icon: Icons.person,
                  hintText: "Enter your full name",
                  title: "Full Name",
                  errorMessage: "Invalid Name",
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 10),
                // _buildLabel(context, "Full Name"),
                CustomTextField(
                  controller: phoneNumberController,
                  focusNode: _phoneNumberFocusNode,
                  icon: Icons.phone_android,
                  maxLength: 10,
                  hintText: "Enter your phone number",
                  title: "Phone Number",
                  errorMessage: "Invalid number",
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 10),
                // _buildLabel(context, "Email"),
                CustomTextField(
                  controller: emailController,
                  focusNode: _emailFocusNode,
                  icon: Icons.email_outlined,
                  hintText: "Enter your email",
                  title: "Email",
                  errorMessage: "Invalid Email",
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                // _buildLabel(context, "Password"),
                CustomTextField(
                  controller: passwordController,
                  focusNode: _passwordFocusNode,
                  icon: Icons.lock_open,
                  hintText: "Enter your password",
                  title: "Password",
                  errorMessage: "Invalid Password",
                ),
                const SizedBox(height: 20),

                // ✅ Consumer Wrap kiya hai sirf Button ke upar taaki poora widget rebuild na ho
                Consumer<AuthApiProvider>(
                  builder: (context, signUpProvider, child) {
                    print("✅ Consumer call ho rha hai ");
                    return signUpProvider.isLoading
                        ? loadingIndicator() // Show loader
                        : SolidRoundedButton(
                            text: 'SignUp',
                            color: AppColors.primary,
                            borderRadius: 10.0,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                handleSubmit(); // Call submit only if valid
                              }
                            },
                            textStyle: const TextStyle(
                                color: Colors.white, fontSize: 18),
                          );
                  },
                ),
                ResponsiveHelper.sizeBoxHeightSpace(context, 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: AppTextStyles.heading1(
                        context,
                        overrideStyle: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(context, 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        // showSignupBottomSheet(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Login",
                        style: AppTextStyles.heading1(
                          context,
                          overrideStyle: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                            fontSize: ResponsiveHelper.fontSize(context, 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
