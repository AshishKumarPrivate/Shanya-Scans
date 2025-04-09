import 'package:flutter/material.dart';
import 'package:shanya_scans/ui_helper/responsive_helper.dart';
import 'package:shanya_scans/ui_helper/app_colors.dart';
import 'package:shanya_scans/ui_helper/app_text_styles.dart';

class BottomSheetWithList extends StatefulWidget {
  final int selectedIndex;
  final Function(int, String) onSelected;

  BottomSheetWithList({required this.selectedIndex, required this.onSelected});

  @override
  _BottomSheetWithListState createState() => _BottomSheetWithListState();
}

class _BottomSheetWithListState extends State<BottomSheetWithList> {
  late int selectedPatientCount;

  @override
  void initState() {
    super.initState();
    selectedPatientCount =
        widget.selectedIndex; // Initialize with the passed selected index
  }

  final List<Map<String, String>> options = [
    {'title': '1', 'price': '1149', 'details': 'with coupon'},
    {
      'title': '2',
      'price': '1898',
      'details': '₹949 per person • with coupon'
    },
    {
      'title': '3',
      'price': '3147',
      'details': '₹1049 per person • with coupon'
    },
    {
      'title': '4',
      'price': '3796',
      'details': '₹949 per person • with coupon'
    },
    {
      'title': '5',
      'price': '5072',
      'details': '₹1014 per person • with coupon'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        height: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close Icon and Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Book For",
                    style: AppTextStyles.heading2(context,
                      overrideStyle: TextStyle(fontSize: ResponsiveHelper.fontSize(context, 16)),

                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final item = options[index];
                  final isSelected = selectedPatientCount == index;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedPatientCount = index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Patients ${item['title']!}',
                                  style: AppTextStyles.bodyText1(
                                    context,
                                    overrideStyle: TextStyle(color: Colors.black, fontSize: ResponsiveHelper.fontSize(context, 14)),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      item['price']!,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      item['details']!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Radio<int>(
                            value: index,
                            groupValue: selectedPatientCount,
                            onChanged: (value) {
                              setState(() {
                                selectedPatientCount = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    final selectedOption = options[selectedPatientCount];
                    widget.onSelected(
                      selectedPatientCount,
                      selectedOption['price']!, // Pass the price
                    ); // Pass selected index to parent
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 20),
                  ),
                  child: Text("Continue"),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }
}
