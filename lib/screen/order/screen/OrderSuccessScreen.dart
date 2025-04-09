import 'package:flutter/material.dart';
import 'package:shanya_scans/bottom_navigation_screen.dart';
import 'package:shanya_scans/ui_helper/app_colors.dart';
import 'package:shanya_scans/ui_helper/app_text_styles.dart';
import 'package:shanya_scans/ui_helper/responsive_helper.dart';
import 'package:lottie/lottie.dart';

class OrderSuccessScreen extends StatefulWidget {
  @override
  _OrderSuccessScreenState createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();

    // Animation Controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Delay the animation effect
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isVisible = true;
      });
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Lottie animation (You need to replace this with your own animation)
            ResponsiveHelper.sizeBoxHeightSpace(context, 10),
            Center(
              child: Lottie.asset(
                reverse: false,
                repeat: false,
                'assets/lottie/order_success.json',
                // Replace with your animation file
                width: ResponsiveHelper.containerWidth(context, 70),
                height: ResponsiveHelper.containerWidth(context, 70),
                fit: BoxFit.cover,
              ),
            ),

            ResponsiveHelper.sizeBoxHeightSpace(context, 8),

            // Order Confirmation Text with Slide Animation
            SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    Text(
                      "Your test has been\nbooked successfully",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.heading1(context,
                          overrideStyle:
                              new TextStyle(fontSize: 18, color: Colors.black)),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Thank you for booking your test with Shanya Scans! Feel free to continue exploring our health packages and services.Wishing you good health and wellness!",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyText1(context,
                          overrideStyle:
                              new TextStyle(fontSize: 16, color: Colors.black)),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Continue Shopping Button with Fade Animation
            AnimatedOpacity(
              duration: const Duration(milliseconds: 1000),
              opacity: _isVisible ? 1.0 : 0.0,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to home or shopping screen
                  /// **Navigate to Bottom Navigation Screen after successful OTP verification**
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BottomNavigationScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                ),
                child: Text(
                  "Continue Shopping",
                  style: AppTextStyles.heading2(context,
                      overrideStyle:
                          new TextStyle(fontSize: 14, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
