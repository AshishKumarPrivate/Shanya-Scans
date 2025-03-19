import 'package:flutter/material.dart';
import 'package:healthians/base_widgets/common/custom_text_field.dart';
import 'package:healthians/screen/auth/controller/auth_provider.dart';
import 'package:healthians/screen/auth/signup_screen.dart';
import 'package:provider/provider.dart';
import '../../../base_widgets/loading_indicator.dart';
import '../../../base_widgets/solid_rounded_button.dart';
import '../../../ui_helper/app_colors.dart';
import '../../../ui_helper/app_text_styles.dart';
import '../../../ui_helper/responsive_helper.dart';

class LoginFormWidget extends StatefulWidget {
  LoginFormWidget();

  // final VoidCallback onSubmit;
  // final TextEditingController emailController;
  // final TextEditingController passwordController;
  //
  // const LoginFormWidget({
  //   Key? key,
  //   required this.onSubmit,
  //   required this.emailController,
  //   required this.passwordController,
  // }) : super(key: key);

  @override
  _LoginFormWidgetState createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>(); // 🔹 Add Form Key for validation

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() => setState(() {}));
    _passwordFocusNode.addListener(() => setState(() {}));
  }

  // handle the login api here
  void handleSubmit() {
    final loginProvider = context.read<AuthApiProvider>();
    print("🟢 Login Button Clicked");
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      print("🔴 Validation Failed: Fields are empty");
      return;
    }
    loginProvider.loginUser(
        context, emailController.text, passwordController.text);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
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
                  builder: (context, loginProvider, child) {
                    print("✅ Consumer call ho rha hai ");
                    return loginProvider.isLoading
                        ? loadingIndicator() // Show loader
                        : SolidRoundedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                handleSubmit(); // Call submit only if valid
                              }
                            },
                            text: 'Login',
                            color: AppColors.primary,
                            borderRadius: 10.0,
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
                      "Don't have an account?",
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
                        Navigator.of(context).pushReplacement(
                          // MaterialPageRoute(builder: (context) => TestingScreen()),
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()),
                        );
                      },
                      child: Text(
                        "SignUp",
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

  // void showSignupBottomSheet(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius:
  //       BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
  //     ),
  //     builder: (context) => SignupForm(),
  //   );
  // }

  Widget _buildLabel(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: AppTextStyles.bodyText1(
          context,
          overrideStyle: TextStyle(
            color: Colors.black,
            fontSize: ResponsiveHelper.fontSize(context, 14),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required IconData icon,
    required String hintText,
    required String errorMessage,
    TextInputType keyboardType = TextInputType.text,
  }) {
    bool isFocused = focusNode.hasFocus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormField<String>(
          validator: (value) {
            if (controller.text.isEmpty) {
              return errorMessage;
            }
            return null;
          },
          builder: (FormFieldState<String> fieldState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: isFocused
                            ? AppColors.primary.withAlpha(70)
                            : Colors.black12,
                        blurRadius: isFocused ? 10 : 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    border: Border.all(
                      color: isFocused ? AppColors.primary : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: ResponsiveHelper.padding(context, 2, 0.02),
                        child: Icon(
                          icon,
                          size: ResponsiveHelper.fontSize(context, 20),
                          color: isFocused
                              ? AppColors.primary
                              : AppColors.txtLightGreyColor,
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: controller,
                          focusNode: focusNode,
                          keyboardType: keyboardType,
                          decoration: InputDecoration(
                            hintText: hintText,
                            border: InputBorder.none,
                            contentPadding:
                                ResponsiveHelper.padding(context, 0, 0.2),
                          ),
                          style: TextStyle(
                              fontSize: ResponsiveHelper.fontSize(context, 14)),
                          onChanged: (value) {
                            fieldState.didChange(value); // Trigger validation
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                if (fieldState
                    .hasError) // 🔹 Show error message outside container
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: Text(
                      fieldState.errorText!,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: ResponsiveHelper.fontSize(context, 12),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
