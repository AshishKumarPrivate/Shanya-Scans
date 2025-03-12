import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart';
import '../ui_helper/app_colors.dart';
import '../ui_helper/responsive_helper.dart';

class HtmlTextWidget extends StatelessWidget {
  final String htmlContent;
  final bool extractPlainText; // Flag to toggle between HTML and plain text

  const HtmlTextWidget({
    Key? key,
    required this.htmlContent,
    this.extractPlainText = false, // Default: Render as HTML
  }) : super(key: key);

  /// Function to extract plain text from HTML string
  String _extractPlainText(String htmlString) {
    var document = parse(htmlString);
    return document.body?.text ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return extractPlainText
        ? Text(
      _extractPlainText(htmlContent), // Show plain text
      style: TextStyle(
        fontSize: ResponsiveHelper.fontSize(context, 12),
        color: AppColors.txtGreyColor,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    )
        : Html(
      data: htmlContent, // Show HTML formatted text
      shrinkWrap: true,
      style: {
        "body": Style(margin: Margins.zero, padding: HtmlPaddings.zero),
        "p": Style(
          textAlign: TextAlign.start,
          alignment: Alignment.topLeft,
          maxLines: 2,
          color: AppColors.txtGreyColor,
          fontSize: FontSize(ResponsiveHelper.fontSize(context, 10)),
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          lineHeight: LineHeight(1.4),
        ),
        "pre": Style(margin: Margins.zero, padding: HtmlPaddings.zero, lineHeight: LineHeight(1)),
        "div": Style(margin: Margins.zero, padding: HtmlPaddings.zero),
        "span": Style(margin: Margins.zero, padding: HtmlPaddings.zero),
        "ul": Style(margin: Margins.zero, padding: HtmlPaddings.zero),
        "li": Style(margin: Margins.zero, padding: HtmlPaddings.zero),
      },
    );
  }
}
