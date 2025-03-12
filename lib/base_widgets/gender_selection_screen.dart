import 'package:flutter/material.dart';
import 'package:healthians/ui_helper/responsive_helper.dart';
import 'package:healthians/ui_helper/app_colors.dart';
import 'package:healthians/base_widgets/custom_rounded_container.dart'; // Import the custom container widget
import 'package:healthians/ui_helper/app_text_styles.dart'; // Assuming you have a text style for the titles

class GenderSelectionScreen extends StatefulWidget {
  final Function(String) onGenderSelected; // Callback function

  GenderSelectionScreen({required this.onGenderSelected}); // Constructor with callback

  @override
  _GenderSelectionScreenState createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> {
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedGender = 'Male';
            });
            widget.onGenderSelected('Male'); // Pass the selected gender back to the parent
          },
          child: CustomRoundedContainer(
            borderRadius: 10.0,
            borderColor: Colors.black,
            borderWidth: 0.1,
            elevation: 3.0,
            backgroundColor: _selectedGender == 'Male' ? AppColors.primary : Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 8),
            child: Center(
              child: Row(
                children: [
                  Icon(Icons.person,size: 16,color: _selectedGender == 'Male' ? AppColors.whiteColor : Colors.black,),
                  SizedBox(width: 5,),
                  Text(
                    "Male",
                    // style: AppTextStyles.bodyText1.copyWith(
                    //   fontSize: 14,
                    //   color: _selectedGender == 'Male' ? Colors.white : Colors.black,
                    // ),
                    style:  AppTextStyles.bodyText1(
                      context,
                      overrideStyle: AppTextStyles.bodyText1(context,
                          overrideStyle: TextStyle(
                              color: _selectedGender == 'Male' ? Colors.white : Colors.black,
                              fontSize: ResponsiveHelper.fontSize(
                                  context, 14))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 20), // Space between the two options
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedGender = 'Female';
            });
            widget.onGenderSelected('Female'); // Pass the selected gender back to the parent
          },
          child: CustomRoundedContainer(
            borderRadius: 10.0,
            borderColor: Colors.black,
            borderWidth: 0.1,
            elevation: 3.0,
            backgroundColor: _selectedGender == 'Female' ? AppColors.primary : Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 8),            child: Center(
              child: Row(
                children: [
                  Icon(Icons.person_pin,size: 16,color: _selectedGender == 'Female' ? AppColors.whiteColor : Colors.black),
                  SizedBox(width: 5,),
                  Text(
                    "Female",
                    // style: AppTextStyles.bodyText1.copyWith(
                    //   fontSize: 14,
                    //   color: _selectedGender == 'Female' ? Colors.white : Colors.black,
                    // ),
                    style:  AppTextStyles.bodyText1(
                      context,
                      overrideStyle: AppTextStyles.bodyText1(context,
                          overrideStyle: TextStyle(
                              color: _selectedGender == 'Female' ? Colors.white : Colors.black,
                              fontSize: ResponsiveHelper.fontSize(
                                  context, 14))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
