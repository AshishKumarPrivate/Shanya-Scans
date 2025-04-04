import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:healthians/ui_helper/app_colors.dart';

import '../ui_helper/app_text_styles.dart';
import '../ui_helper/responsive_helper.dart';

class InstructionCard extends StatefulWidget {
  final String instructionEnglish;
  final String instructionHindi;

  InstructionCard({
    required this.instructionEnglish,
    required this.instructionHindi,
  });

  @override
  _InstructionCardState createState() => _InstructionCardState();
}

class _InstructionCardState extends State<InstructionCard> {
  bool isHindi = false; // 🔹 Default: Switch OFF (English Instructions)

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: ResponsiveHelper.padding(context, 3, 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Header with Language Toggle
            Container(
              padding: ResponsiveHelper.padding(context, 2, 1),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "Instruction",
                        style: AppTextStyles.heading1(
                          context,
                          overrideStyle: TextStyle(
                              color: Colors.white,
                              fontSize: ResponsiveHelper.fontSize(context, 14)),
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        "/ निर्देश",
                        style: AppTextStyles.heading1(
                          context,
                          overrideStyle: TextStyle(
                              color: Colors.white,
                              fontSize: ResponsiveHelper.fontSize(context, 14)),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "English",
                        style: AppTextStyles.heading1(
                          context,
                          overrideStyle: TextStyle(
                              color: Colors.white,
                              fontSize: ResponsiveHelper.fontSize(context, 12)),
                        ),
                      ),
                      SizedBox(
                        height: ResponsiveHelper.containerWidth(context, 8),
                        child: Transform.scale(
                          scale: 0.6, // Adjust the scale (1.0 is default)
                          child: Switch(
                            value: isHindi,
                            onChanged: (value) {
                              setState(() {
                                isHindi = value;
                              });
                            },
                            activeColor: Colors.white,
                          ),
                        ),

                      ),
                      Text(
                        "हिंदी",
                        style: AppTextStyles.heading1(
                          context,
                          overrideStyle: TextStyle(
                              color: Colors.white,
                              fontSize: ResponsiveHelper.fontSize(context, 12)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: InstructionContent(
                instructions: isHindi
                    ? widget.instructionHindi // 🔹 Show Hindi when switch is ON
                    : widget .instructionEnglish, // 🔹 Show English when switch is OFF
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InstructionContent extends StatelessWidget {
  final String instructions;

  InstructionContent({required this.instructions});

  @override
  Widget build(BuildContext context) {
    var fontSize = ResponsiveHelper.fontSize(context, 14.0);
    return SingleChildScrollView(
      child: Html(
        data: instructions,
        style: {
          "p": Style(
            fontFamily: "Poppins",
            color: Colors.black,
            fontSize: FontSize(ResponsiveHelper.fontSize(context, 5)),
            textAlign: TextAlign.justify,
          ),
          "strong": Style(fontWeight: FontWeight.bold, color: Colors.black),
          "em": Style(fontStyle: FontStyle.italic),
          "h1": Style(
              fontFamily: "Poppins",
              fontSize: FontSize(ResponsiveHelper.fontSize(context, 5)),
              fontWeight: FontWeight.bold,
              color: Colors.blue),
          "h2": Style(
              fontFamily: "Poppins",
              fontSize: FontSize(ResponsiveHelper.fontSize(context, 5)),
              fontWeight: FontWeight.bold,
              color: Colors.blue),
          "ul": Style(
              fontFamily: "Poppins",
              fontSize: FontSize(ResponsiveHelper.fontSize(context, 12)),
              padding: HtmlPaddings.all(0), listStyleType: ListStyleType.none),
          "li": Style(
              fontFamily: "Poppins",
              fontSize: FontSize(ResponsiveHelper.fontSize(context, 12)),margin: Margins.only(bottom: 5)),
          "a": Style(
              color: Colors.blue, textDecoration: TextDecoration.underline),
        },
      ),
    );
  }
}
