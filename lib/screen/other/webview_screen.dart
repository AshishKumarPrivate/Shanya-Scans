import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:healthians/base_widgets/loading_indicator.dart';
import 'package:healthians/base_widgets/solid_rounded_button.dart';
import 'package:healthians/screen/profile/controller/term_condition_provider.dart';
import 'package:healthians/ui_helper/app_text_styles.dart';
import 'package:healthians/ui_helper/responsive_helper.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../ui_helper/app_colors.dart';
import '../../base_widgets/expandable_text_widget.dart';

class WebViewScreen extends StatefulWidget {
  final String aciviyName;
  final String url;
  final bool isTermAndConditions;
  final bool isPrivacyPolicy;
  final bool isRefundPolicy;

  WebViewScreen({
    required this.aciviyName,
    required this.url,
    required this.isTermAndConditions,
    required this.isPrivacyPolicy,
    required this.isRefundPolicy,
  });

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {

  @override
  void initState() {
    super.initState();

    if (widget.isTermAndConditions) {
      Provider.of<TermConditionPrivacyPolicyApiProvider>(context, listen: false)
          .getTermAndConditions(context);
    }
    if (widget.isPrivacyPolicy) {
      Provider.of<TermConditionPrivacyPolicyApiProvider>(context, listen: false)
          .getPrivacyPolicy(context);
    }
    if (widget.isRefundPolicy) {
      Provider.of<TermConditionPrivacyPolicyApiProvider>(context, listen: false)
          .getRefundPolicy(context);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          "${widget.aciviyName}",
          style: AppTextStyles.bodyText1(context,
              overrideStyle: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.fontSize(context, 14))),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<TermConditionPrivacyPolicyApiProvider>(
        builder: (context, provider, child) {
          print("API Response: ${provider.termAndConditionsModel?.data}");

          if (provider.isLoading) {
            return loadingIndicator();
          }
          if (provider.errorMessage.isNotEmpty) {
            return Center(
                child: Text(provider.errorMessage,
                    style: TextStyle(color: Colors.red)));
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16), // Add some padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExpandableTextWidget(
                  text: provider.termAndConditionsModel!.data!.description
                      .toString(),
                  customStyles: {
                    "span": Style(
                      fontSize: FontSize(ResponsiveHelper.fontSize(context, 20)), // Make headings bigger
                      // color: Colors.green, // Change heading color
                    ),
                    "strong": Style(
                      fontWeight: FontWeight.w700, // Make bold text even heavier
                      // color: Colors.black, // Change bold text color
                    ),
                  },
                ),
                SizedBox(height: 20), // Add some spacing at the bottom
              ],
            ),
          );
        },
      ),
    );
  }
}
