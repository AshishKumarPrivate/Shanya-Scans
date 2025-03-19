import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healthians/deliveryBoy/screen/widget/delivery_boy_login_form_widget.dart';
import 'package:healthians/util/dimensions.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../ui_helper/responsive_helper.dart';
import '../../ui_helper/app_colors.dart';
import '../../ui_helper/app_text_styles.dart';

class DeliveryLoginScreen extends StatefulWidget {
  @override
  _DeliveryLoginScreenState createState() => _DeliveryLoginScreenState();
}

class _DeliveryLoginScreenState extends State<DeliveryLoginScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final Uri _url = Uri.parse('https://codecrafter.co.in/');

  Future<void> _launchURL() async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFF58a9c7),
      statusBarIconBrightness: Brightness.light,
    ));
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // ✅ Allows content to resize when keyboard is open
      backgroundColor: AppColors.whiteColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        child: SafeArea(
          top: false,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            // ✅ Dismiss keyboard on tap
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildTopSection(),
                            Padding(
                              padding: ResponsiveHelper.padding(context,
                                  Dimensions.paddingHorizontalSmall_5, 0),
                              child: DeliveryBoyLoginFormWidget(),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                _buildBottomSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return ClipPath(
      clipper: BottomCurveClipper(),
      child: Container(
        height: ResponsiveHelper.containerHeight(context, 50),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.lightBrown_color,
              AppColors.deliveryPrimary.withAlpha(50)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            ResponsiveHelper.sizeBoxHeightSpace(context, 5),
            SizedBox(
              width: ResponsiveHelper.containerHeight(context, 25),
              height: ResponsiveHelper.containerHeight(context, 25),
              child: SvgPicture.asset(
                'assets/svg/img_delivery_boy_login.svg',
                width: ResponsiveHelper.containerWidth(context, 40),
                height: ResponsiveHelper.containerWidth(context, 60),
                fit: BoxFit.fill,
              ),
            ),
            ResponsiveHelper.sizeBoxHeightSpace(
                context, Dimensions.sizeBoxVerticalSpace_2),
            Padding(
              padding: ResponsiveHelper.padding(
                  context, Dimensions.paddingHorizontalSmall_5, 0),
              child: Text(
                "Welcome to the HealthCare Delivery App!",
                textAlign: TextAlign.center,
                style: AppTextStyles.heading1(
                  context,
                  overrideStyle: TextStyle(
                    color: Colors.black,
                    fontSize: ResponsiveHelper.fontSize(context, 20),
                  ),
                ),
              ),
            ),
            ResponsiveHelper.sizeBoxHeightSpace(context, 5),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      height: ResponsiveHelper.containerHeight(context, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Powered By",
            style: AppTextStyles.heading1(
              context,
              overrideStyle: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(
                      context, Dimensions.fontSize10)),
            ),
          ),
          ResponsiveHelper.sizeboxWidthlSpace(
              context, Dimensions.sizeBoxHorizontalSpace_2),
          GestureDetector(
            onTap: _launchURL,
            child: Container(
              width: ResponsiveHelper.containerWidth(context, 20),
              child: Image.asset("assets/images/code_crafter_logo.png"),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.95,
        size.width * 0.5, size.height * 0.92);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.89, size.width, size.height * 0.8);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
