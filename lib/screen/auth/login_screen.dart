import 'package:flutter/material.dart';
import 'package:healthians/screen/auth/widget/login_form_widget.dart';
import 'package:healthians/util/dimensions.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../ui_helper/responsive_helper.dart';
import '../../ui_helper/app_colors.dart';
import '../../ui_helper/app_text_styles.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("🔄 LoginScreen rebuild ho raha hai!"); // 👀 Debugging ke liye

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: MediaQuery.removePadding(
                      context: context,
                      removeBottom: true,
                      // 👈 Keyboard open hone par rebuild prevent karega
                      child: Column(
                        children: [
                          _buildTopSection(),
                          Padding(
                            padding: ResponsiveHelper.padding(context,
                                Dimensions.paddingHorizontalSmall_5, 0),
                            child: LoginFormWidget(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                _buildBottomSection(),
              ],
            );
          },
        ),
      ),
    );
  }

  /// ✅ Top Section (Static, Rebuild Avoid Karne Ke Liye)
  Widget _buildTopSection() {
    return ClipPath(
      clipper: BottomCurveClipper(),
      child: Container(
        color: AppColors.lightYellowColor,
        height: ResponsiveHelper.containerHeight(context, 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: ResponsiveHelper.containerHeight(context, 15),
              child:  Image.asset('assets/images/loginimage.png',width: ResponsiveHelper.containerWidth(context, 40),height:  ResponsiveHelper.containerWidth(context, 60),fit: BoxFit.fill,),

              // PageView(
              //   controller: _pageController,
              //   onPageChanged: (int page) {
              //     setState(() {
              //       _currentPage = page;
              //     });
              //   },
              //   children: [
              //     Image.asset('assets/images/loginimage.png',width: 100,height: 100,),
              //     // Image.asset('assets/images/user.png'),
              //     // Image.asset('assets/images/user.png'),
              //   ],
              // ),
            ),
            ResponsiveHelper.sizeBoxHeightSpace(
                context, Dimensions.sizeBoxVerticalSpace_2),
            Padding(
              padding: ResponsiveHelper.padding(
                  context, Dimensions.paddingHorizontalSmall_5, 0),
              child: Text(
                "Join over 8 million satisfied users who trust us for accurate and reliable health tests",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(context, Dimensions.fontSize14),
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     _buildDot(0),
            //     _buildDot(1),
            //     _buildDot(2),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  // Helper for dots indicator
  Widget _buildDot(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
      width: ResponsiveHelper.containerWidth(context, 2),
      height: ResponsiveHelper.containerHeight(context, 2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            _currentPage == index ? const Color(0xFFFCB42C) : Colors.grey[300],
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
          // const SizedBox(width: 8),
          ResponsiveHelper.sizeboxWidthlSpace(
              context, Dimensions.sizeBoxHorizontalSpace_2),
          GestureDetector(
            onTap: () {
              _launchURL();
              print("logo clicked ");
            },
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
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 30); // Adjust the curve depth
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
