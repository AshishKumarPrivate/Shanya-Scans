import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthians/bottom_navigation_screen.dart';
import 'package:healthians/deliveryBoy/controller/DeliveryOrdersProvider.dart';
import 'package:healthians/deliveryBoy/controller/delivery_boy_auth_provider.dart';
import 'package:healthians/screen/auth/controller/auth_provider.dart';
import 'package:healthians/screen/auth/login_screen.dart';
import 'package:healthians/screen/cart/controller/cart_list_api_provider.dart';
import 'package:healthians/screen/checkout/controller/checkout_api_provider.dart';
import 'package:healthians/screen/nav/nav_home/frquently_pathalogy_test/controller/frequently_pathalogy_test_provider.dart';
import 'package:healthians/screen/nav/nav_home/health_concern/controller/health_concern_provider.dart';
import 'package:healthians/screen/nav/nav_home/slider/controller/home_banner_api_provider.dart';
import 'package:healthians/screen/nav/nav_lab/controller/pathalogy_test_provider.dart';
import 'package:healthians/screen/order/controller/order_provider.dart';
import 'package:healthians/screen/other/controller/SearchProvider.dart';
import 'package:healthians/screen/packages/controller/health_package_list_api_provider.dart';
import 'package:healthians/screen/profile/controller/need_help_api_provider.dart';
import 'package:healthians/screen/profile/controller/term_condition_provider.dart';
import 'package:healthians/screen/service/controller/service_scans_provider.dart';
import 'package:healthians/screen/splash/SplashScreen.dart';
import 'package:healthians/screen/splash/controller/network_provider_controller.dart';
import 'package:healthians/screen/testing_file.dart';
import 'package:healthians/ui_helper/app_text_styles.dart';
import 'package:healthians/ui_helper/responsive_helper.dart';
import 'package:healthians/ui_helper/app_colors.dart';
import 'package:healthians/ui_helper/storage_helper.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ Ensure Flutter binding is initialized
  StorageHelper().init(); // ✅ Initialize SharedPreferences
  await PackageInfo.fromPlatform(); // Ensures package is loaded
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NetworkProvider()),
        ChangeNotifierProvider(create: (context) => AuthApiProvider()),
        ChangeNotifierProvider(create: (context) => ServiceApiProvider()),
        ChangeNotifierProvider(create: (context) => PathalogyTestApiProvider()),
        ChangeNotifierProvider(create: (context) => HealthConcernApiProvider()),
        ChangeNotifierProvider(create: (context) => FrequentlyPathalogyTagApiProvider()),
        ChangeNotifierProvider(create: (context) => HealthPacakgeListApiProvider()),
        ChangeNotifierProvider(create: (context) => HomeBannerApiProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => SearchProvider()),
        ChangeNotifierProvider(create: (context) => TermConditionPrivacyPolicyApiProvider()),
        ChangeNotifierProvider(create: (context) => OrderApiProvider()),
        ChangeNotifierProvider(create: (context) => NeedHelpApiProvider()),
        ChangeNotifierProvider(create: (context) => CheckoutProvider()),


        /// &&&&&&&&&&& Dellivery BOy ***********
        ChangeNotifierProvider(create: (context) => DeliveryOrdersProvider()),
        ChangeNotifierProvider(create: (context) => DeliveryBoyAuthApiProvider()),


      ],
      child: MyApp(),
    ),
  );
}

// void main() => runApp(
//     DevicePreview(
//       enabled: !kReleaseMode,
//       builder: (context) => MyApp(), // Wrap your app
//     ),
//     );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shanya',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light, // Light theme
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        fontFamily: "Poppins"
      ),
      // Agar darkTheme specify karna ho, to use bhi light theme hi rakhein
      darkTheme: ThemeData(
        brightness: Brightness.light,
      ),
      themeMode: ThemeMode.light,
      // Hamesha light mode use karein

      /// ✅ **Global Default White Status Bar for Other Screens**
      builder: (context, child) {
        return Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (context) {
                /// ✅ Har screen push hone par default white status bar
                SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
                  statusBarColor: Color(0xFF58a9c7),
                  // statusBarColor: Colors.white,
                  statusBarIconBrightness: Brightness.light,
                ));

                return child!;
              },
            ),
          ],
        );
      },
      home: SplashScreen(),
      // home:BottomNavigationScreen(),
    );
  }
}


