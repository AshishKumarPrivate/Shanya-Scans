import 'package:flutter/material.dart';
import 'package:shanya_scans/base_widgets/common/custom_text_field.dart';
import 'package:provider/provider.dart';
import '../../../base_widgets/loading_indicator.dart';
import '../../../base_widgets/solid_rounded_button.dart';
import '../../../ui_helper/app_colors.dart';
import '../../controller/delivery_boy_auth_provider.dart';

class DeliveryBoyLoginFormWidget extends StatefulWidget {
  DeliveryBoyLoginFormWidget();

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
  _DeliveryBoyLoginFormWidgetState createState() => _DeliveryBoyLoginFormWidgetState();
}

class _DeliveryBoyLoginFormWidgetState extends State<DeliveryBoyLoginFormWidget> {
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
    final loginProvider = context.read<DeliveryBoyAuthApiProvider>();
    print("🟢 Login Button Clicked");
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      print("🔴 Validation Failed: Fields are empty");
      return;
    }
    loginProvider.deliveryBoyLogin( context, emailController.text,  passwordController.text);
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
      child: SingleChildScrollView(
        child: Form(
          key: _formKey, // 🔹 Wrap in Form for validation
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0),
            child: Container(
              color: AppColors.whiteColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    iconColor: AppColors.deliveryPrimary,
                    shadowColor: AppColors.deliveryPrimary.withAlpha(70),
                    borderColor: AppColors.deliveryPrimary,
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
                    iconColor: AppColors.deliveryPrimary,
                    shadowColor: AppColors.deliveryPrimary.withAlpha(70),
                    borderColor: AppColors.deliveryPrimary,
                    controller: passwordController,
                    focusNode: _passwordFocusNode,
                    icon: Icons.lock_open,
                    isPassword: true,
                    hintText: "Enter your password",
                    title: "Password",
                    errorMessage: "Invalid Password",
                  ),
                  const SizedBox(height: 20),

                  // ✅ Consumer Wrap kiya hai sirf Button ke upar taaki poora widget rebuild na ho
                  Consumer<DeliveryBoyAuthApiProvider>(
                    builder: (context, loginProvider, child) {
                      print("✅ Consumer call ho rha hai ");
                      return loginProvider.isLoading
                          ? loadingIndicator(color: AppColors.deliveryPrimary) // Show loader
                          : SolidRoundedButton(
                              text: 'Login',
                              color: AppColors.deliveryPrimary,
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

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
