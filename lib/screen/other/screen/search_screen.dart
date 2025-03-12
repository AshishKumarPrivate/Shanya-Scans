import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthians/ui_helper/app_colors.dart';
import 'package:provider/provider.dart';
import '../controller/SearchProvider.dart';

class SearchScreen extends StatefulWidget {
  final String title;
  final String hintText;

  const SearchScreen({Key? key, required this.title, required this.hintText})
      : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {

    // Status bar color fix
    // _setStatusBarColor();

    searchController.addListener(() {
      Provider.of<SearchProvider>(context, listen: false)
          .filterSearch(searchController.text);
    });

    super.initState();
  }

  void _setStatusBarColor() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColors.primary, // Status bar color fixed to primary
        statusBarIconBrightness: Brightness.light, // Status bar icons white
      ),
    );
  }

  @override
  void dispose() {
    // Status bar color reset if needed
    // _setStatusBarColor();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);
    final primaryColor = AppColors.primary;

    return Scaffold(

      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: primaryColor, // Search bar background color set to primary
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TextField(
                controller: searchController,
                onTap: () => _setStatusBarColor(), // Ensure status bar remains primary
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  prefixIcon:  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black), // ✅ Back Arrow
                    onPressed: () => Navigator.pop(context), // ✅ Close on tap
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintStyle: TextStyle(color: Colors.black54),
                ),
                style: TextStyle(color: Colors.black),
                cursorColor: primaryColor,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: searchProvider.filteredItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(searchProvider.filteredItems[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
