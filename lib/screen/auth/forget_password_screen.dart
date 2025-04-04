import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healthians/screen/auth/controller/auth_provider.dart';
import 'package:healthians/ui_helper/app_colors.dart';
import '../../base_widgets/common/custom_text_field.dart';
import '../../base_widgets/loading_indicator.dart';
import '../../base_widgets/solid_rounded_button.dart';
import '../../ui_helper/responsive_helper.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  final FocusNode _otpFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  String? _emailError, _otpError, _passwordError;

  void _requestOtp() async {
    final provider = context.read<AuthApiProvider>();
    String email = _emailController.text.trim();

    setState(() => _emailError = null);

    if (email.isEmpty || !_isValidEmail(email)) {
      setState(() => _emailError = "Enter a valid email address");
      return;
    }

    bool success = await provider.forgetPassword(context, _emailController.text.toString());
    if (success) {
      setState(() {}); // Ensure UI updates
    }
  }

  void _resetPassword() async {
    final provider = context.read<AuthApiProvider>();
    String otp = _otpController.text.trim();
    String newPassword = _newPasswordController.text.trim();

    setState(() {
      _otpError = _passwordError = null;
    });

    if (otp.isEmpty) {
      setState(() => _otpError = "Enter the OTP");
      return;
    }
    if (newPassword.isEmpty) {
      setState(() => _passwordError = "Invalid Password");
      return;
    }

    await provider.resetPassword( context,_emailController.text.toString() , otp, newPassword);
    setState(() {}); // Ensure UI updates
  }

  bool _isValidEmail(String email) {
    final emailRegex =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return emailRegex.hasMatch(email);
  }

  @override
  void initState() {
    super.initState();
    _otpFocusNode.addListener(() => setState(() {}));
    _passwordFocusNode.addListener(() => setState(() {}));
  }


  @override
  void dispose() {
    _otpController.dispose();
    _newPasswordController.dispose();
    _otpFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<AuthApiProvider>(
        builder: (context, provider, child) {
          return Container(
            color: Colors.white,
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.isOtpSent ? "Reset Password" : "Forgot Password",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  provider.isOtpSent
                      ? "Enter OTP and new password"
                      : "Enter your email to receive OTP",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: ResponsiveHelper.padding(context, 1, 0.2),
                        child:  CustomTextField(
                          controller: _emailController,
                          iconColor: AppColors.primary,
                          shadowColor: AppColors.primary.withAlpha(70),
                          borderColor: AppColors.primary,
                          focusNode: _otpFocusNode,
                          icon: Icons.email,
                          hintText: "Enter email",
                          title: "Email",
                          // errorMessage: "Invalid Email",
                          errorMessage: _emailError.toString(),
                          keyboardType: TextInputType.emailAddress,
                        ),

                        // Text(
                        //   "${StorageHelper().getEmail()}",
                        //   // "\u20B9${widget.pathalogyTestSlug}",
                        //   style: AppTextStyles.bodyText1(context,
                        //       overrideStyle: TextStyle(
                        //           fontSize: ResponsiveHelper.fontSize(
                        //               context, 12))),
                        // ),



                      ),

                      SizedBox(height: 10),
                      if (provider.isOtpSent) ...[

                        CustomTextField(
                          controller: _otpController,
                          maxLength: 6,
                          iconColor: AppColors.primary,
                          shadowColor: AppColors.primary.withAlpha(70),
                          borderColor: AppColors.primary,
                          focusNode: _otpFocusNode,
                          icon: Icons.keyboard_alt_outlined,
                          hintText: "Enter Otp Code",
                          title: "OTP",
                          // errorMessage: "Invalid OTP",
                          errorMessage: _otpError.toString(),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 10),
                        CustomTextField(
                          controller: _newPasswordController,
                          iconColor: AppColors.primary,
                          shadowColor: AppColors.primary.withAlpha(70),
                          borderColor: AppColors.primary,
                          focusNode: _passwordFocusNode,
                          icon: Icons.lock_clock_outlined,
                          hintText: "Enter new password",
                          title: "Password",
                          // errorMessage: "Invalid password",
                          errorMessage: _passwordError.toString(),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  // height: 50,
                  child: provider.isLoading
                      ? loadingIndicator()
                      : SolidRoundedButton(
                          onPressed: (){
                            print("🟢 Button Clicked");
                            provider.isOtpSent ? _resetPassword() : _requestOtp();
                          },
                          text: provider.isOtpSent? 'Reset Password' : 'Request OTP',
                          color: AppColors.primary,
                          borderRadius: 10.0,
                          textStyle:
                              TextStyle(color: Colors.white, fontSize: 18),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
