import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shanya_scans/deliveryBoy/controller/DeliveryOrdersProvider.dart';
import 'package:shanya_scans/deliveryBoy/controller/delivery_boy_auth_provider.dart';
import 'package:shanya_scans/deliveryBoy/controller/socket_provider.dart';
import 'package:shanya_scans/screen/auth/controller/auth_provider.dart';
import 'package:shanya_scans/screen/cart/controller/cart_list_api_provider.dart';
import 'package:shanya_scans/screen/checkout/controller/checkout_api_provider.dart';
import 'package:shanya_scans/screen/nav/nav_home/frquently_pathalogy_test/controller/frequently_pathalogy_test_provider.dart';
import 'package:shanya_scans/screen/nav/nav_home/health_concern/controller/health_concern_provider.dart';
import 'package:shanya_scans/screen/nav/nav_home/slider/controller/home_banner_api_provider.dart';
import 'package:shanya_scans/screen/nav/nav_lab/controller/pathalogy_test_provider.dart';
import 'package:shanya_scans/screen/order/controller/order_provider.dart';
import 'package:shanya_scans/screen/other/controller/SearchProvider.dart';
import 'package:shanya_scans/screen/packages/controller/health_package_list_api_provider.dart';
import 'package:shanya_scans/screen/profile/controller/need_help_api_provider.dart';
import 'package:shanya_scans/screen/profile/controller/term_condition_provider.dart';
import 'package:shanya_scans/screen/service/controller/service_scans_provider.dart';
import 'package:shanya_scans/screen/splash/SplashScreen.dart';
import 'package:shanya_scans/screen/splash/controller/network_provider_controller.dart';
import 'package:shanya_scans/ui_helper/app_colors.dart';
import 'package:shanya_scans/ui_helper/storage_helper.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized(); // ✅ Ensure Flutter binding is initialized
//   await Firebase.initializeApp();
//
//   await StorageHelper().init(); // ✅ Initialize SharedPreferences
//   await PackageInfo.fromPlatform(); // Ensures package is loaded
//
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (context) => NetworkProvider()),
//         ChangeNotifierProvider(create: (context) => AuthApiProvider()),
//         ChangeNotifierProvider(create: (context) => ServiceApiProvider()),
//         ChangeNotifierProvider(create: (context) => PathalogyTestApiProvider()),
//         ChangeNotifierProvider(create: (context) => HealthConcernApiProvider()),
//         ChangeNotifierProvider(create: (context) => FrequentlyPathalogyTagApiProvider()),
//         ChangeNotifierProvider(create: (context) => HealthPacakgeListApiProvider()),
//         ChangeNotifierProvider(create: (context) => HomeBannerApiProvider()),
//         ChangeNotifierProvider(create: (context) => CartProvider()),
//         ChangeNotifierProvider(create: (context) => SearchProvider()),
//         ChangeNotifierProvider(create: (context) => TermConditionPrivacyPolicyApiProvider()),
//         ChangeNotifierProvider(create: (context) => OrderApiProvider()),
//         ChangeNotifierProvider(create: (context) => NeedHelpApiProvider()),
//         ChangeNotifierProvider(create: (context) => CheckoutProvider()),
//
//         /// &&&&&&&&&&& Delivery Boy ***********
//         ChangeNotifierProvider(create: (context) => DeliveryOrdersProvider()),
//         ChangeNotifierProvider(create: (context) => DeliveryBoyAuthApiProvider()),
//         ChangeNotifierProvider(create: (context) => SocketProvider()),
//       ],
//       child: MyApp(),
//     ),
//   );
// }



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ Ensure Flutter binding is initialized
  await Firebase.initializeApp();

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

        /// &&&&&&&&&&& Delivery Boy ***********
        ChangeNotifierProvider(create: (context) => DeliveryOrdersProvider()),
        ChangeNotifierProvider(create: (context) => DeliveryBoyAuthApiProvider()),
        ChangeNotifierProvider(create: (context) => SocketProvider()),
      ],
      child: MyApp(),
    ),
  );
}



// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized(); // ✅ Ensure Flutter binding is initialized
//   await Firebase.initializeApp();
//
//   StorageHelper().init(); // ✅ Initialize SharedPreferences
//   await PackageInfo.fromPlatform(); // Ensures package is loaded
//
//   runApp(
//     DevicePreview(
//       enabled: !kReleaseMode, // Enable DevicePreview in non-release mode
//       builder: (context) => MultiProvider(
//         providers: [
//           ChangeNotifierProvider(create: (context) => NetworkProvider()),
//           ChangeNotifierProvider(create: (context) => AuthApiProvider()),
//           ChangeNotifierProvider(create: (context) => ServiceApiProvider()),
//           ChangeNotifierProvider(create: (context) => PathalogyTestApiProvider()),
//           ChangeNotifierProvider(create: (context) => HealthConcernApiProvider()),
//           ChangeNotifierProvider(create: (context) => FrequentlyPathalogyTagApiProvider()),
//           ChangeNotifierProvider(create: (context) => HealthPacakgeListApiProvider()),
//           ChangeNotifierProvider(create: (context) => HomeBannerApiProvider()),
//           ChangeNotifierProvider(create: (context) => CartProvider()),
//           ChangeNotifierProvider(create: (context) => SearchProvider()),
//           ChangeNotifierProvider(create: (context) => TermConditionPrivacyPolicyApiProvider()),
//           ChangeNotifierProvider(create: (context) => OrderApiProvider()),
//           ChangeNotifierProvider(create: (context) => NeedHelpApiProvider()),
//           ChangeNotifierProvider(create: (context) => CheckoutProvider()),
//
//           /// &&&&&&&&&&& Delivery Boy ***********
//           ChangeNotifierProvider(create: (context) => DeliveryOrdersProvider()),
//           ChangeNotifierProvider(create: (context) => DeliveryBoyAuthApiProvider()),
//           ChangeNotifierProvider(create: (context) => SocketProvider()),
//         ],
//         child: MyApp(),
//       ),
//     ),
//   );
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shanya Scans',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData(
        brightness: Brightness.light, // Light theme
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.white,
        ),
        fontFamily: "Poppins"
      ),
      darkTheme: ThemeData(
        brightness: Brightness.light,
      ),
      themeMode: ThemeMode.light,
      builder: (context, child) {
        return Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (context) {
                SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle(
                  statusBarColor: AppColors.primary,
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


