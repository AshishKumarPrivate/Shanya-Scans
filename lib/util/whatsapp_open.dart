import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

// Function to open WhatsApp based on the platform
Future<void> openWhatsApp(String message) async {
  String contact = "+919161066154"; // The target phone number
  // String message = 'Hello, this is a test message!'; // The message to send
  String androidUrl = "whatsapp://send?phone=$contact&text=hello!"; // Android URL scheme
  // String androidUrl = "whatsapp://send?phone=$contact&text=${Uri.encodeComponent(message)}"; // Android URL scheme
  String iosUrl = "https://wa.me/$contact?text=${Uri.encodeComponent(message)}"; // iOS URL for WhatsApp Web link
  String webUrl = "https://api.whatsapp.com/send/?phone=$contact&text=${Uri.encodeComponent(message)}"; // Web link fallback

  try {
    print("Attempting to launch WhatsApp...");

    if (Platform.isIOS) {
      print("Attempting to open iOS URL: $iosUrl");
      // If it's iOS, use the wa.me URL
      if (await canLaunch(iosUrl)) {
        await launch(iosUrl);
      } else {
        throw 'Could not launch WhatsApp on iOS.';
      }
    } else if (Platform.isAndroid) {
      await launchUrl(Uri.parse(androidUrl));

      print("Attempting to open Android URL: $androidUrl");
      // If it's Android, use the whatsapp://send scheme
      // if (await canLaunch(androidUrl)) {
      //   await launch(androidUrl);
      // } else {
      //   // If WhatsApp isn't installed, open the web link
      //   print("WhatsApp not installed, opening web version...");
      //   if (await canLaunch(webUrl)) {
      //     await launch(webUrl);
      //   } else {
      //     throw 'Could not launch WhatsApp or WhatsApp Web.';
      //   }
      // }
    }
  } catch (e) {
    print('Error: $e'); // Print error if anything fails
  }
}
