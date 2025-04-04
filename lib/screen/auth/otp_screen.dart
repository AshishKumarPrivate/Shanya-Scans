import 'package:flutter/material.dart';
import 'package:healthians/screen/auth/controller/auth_provider.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';
import '../../base_widgets/loading_indicator.dart';
import '../../base_widgets/solid_rounded_button.dart';
import '../../ui_helper/app_colors.dart';
import '../../ui_helper/app_text_styles.dart';

class OTPScreen extends StatefulWidget {
  final String email;

  OTPScreen(this.email);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  OtpFieldController otpController = OtpFieldController();
  String otpCode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children:[
                SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.minHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Align(
                          //   alignment: Alignment.topLeft,
                          //   child: IconButton(
                          //     icon: Icon(Icons.arrow_back, color: Colors.black, size: 30),
                          //     onPressed: () => Navigator.pop(context),
                          //   ),
                          // ),
                          // SizedBox(height: 20),
                          Image.asset('assets/images/otp_image.png', height: 120),
                          Text('Verification', style: AppTextStyles.heading1(context)),
                          SizedBox(height: 10),
                          Text("Otp has been sent to", style: AppTextStyles.bodyText1(context), textAlign: TextAlign.center),
                          SizedBox(height: 5),
                          Text(
                            widget.email,
                            style: AppTextStyles.heading2(context, overrideStyle: TextStyle(fontSize: 12)),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 28),
                          OTPTextField(
                            controller: otpController,
                            length: 6,
                            width: MediaQuery.of(context).size.width,
                            fieldWidth: 40,
                            fieldStyle: FieldStyle.box,
                            outlineBorderRadius: 5,
                            textFieldAlignment: MainAxisAlignment.spaceAround,
                            onChanged: (pin) => setState(() => otpCode = pin),
                            onCompleted: (pin) => setState(() => otpCode = pin),
                          ),
                          SizedBox(height: 18),
                          Consumer<AuthApiProvider>(
                            builder: (context, otpProvider, child) {
                              return Column(
                                children: [
                                  if (otpProvider.isLoading) loadingIndicator(),
                                  if (!otpProvider.isLoading)
                                    SizedBox(
                                      width: double.infinity,
                                      child: SolidRoundedButton(
                                        text: 'Verify OTP',
                                        color: AppColors.primary,
                                        borderRadius: 10.0,
                                        onPressed: () async {
                                          if (otpCode.isEmpty) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text("Please enter OTP")),
                                            );
                                            return;
                                          }
                                          otpProvider.getOtp(context, widget.email, otpCode);
                                        },
                                        textStyle: TextStyle(color: Colors.white, fontSize: 18),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                          SizedBox(height: 18),
                          Text("Didn't receive any code?", style: AppTextStyles.bodyText1(context)),
                          SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              Provider.of<AuthApiProvider>(context, listen: false).getResendOtp(context, widget.email);
                            },
                            child: Text("Resend New Code", style: AppTextStyles.heading2(context)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ] ,
            );
          },
        ),
      ),
    );
  }
}
