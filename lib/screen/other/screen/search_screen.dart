import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import '../../../ui_helper/app_text_styles.dart';
import '../../../ui_helper/responsive_helper.dart';

class GoogleMapSearchPlacesApi extends StatefulWidget {
  const GoogleMapSearchPlacesApi({Key? key}) : super(key: key);


  @override
  _GoogleMapSearchPlacesApiState createState() => _GoogleMapSearchPlacesApiState();
}

class _GoogleMapSearchPlacesApiState extends State<GoogleMapSearchPlacesApi> {


  final _controller =  TextEditingController(text: "Lucknow");
  var uuid =  const Uuid();
  String _sessionToken = '1234567890';
  List<dynamic> _placeList = [];

  @override
  void initState() {
    super.initState();
    getSuggestion(_controller.text);
    _controller.addListener(() {
      _onChanged();
    });
  }

  _onChanged() {
    getSuggestion(_controller.text);
  }

  void getSuggestion(String input) async {


    const String PLACES_API_KEY = "AIzaSyC9ZOZHwHmyTWXqACqpZY2TL7wX2_Zn05U";

    try{
      String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
      String request = '$baseURL?input=$input&key=$PLACES_API_KEY&sessiontoken=$_sessionToken&components=country:IN';
      var response = await http.get(Uri.parse(request));
      var data = json.decode(response.body);
      if (kDebugMode) {
        print('mydata');
        print(data);
      }
      if (response.statusCode == 200) {
        setState(() {
          _placeList = json.decode(response.body)['predictions'];
        });
      } else {
        throw Exception('Failed to load predictions');
      }
    }catch(e){
      print(e);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title:  Text('Choose Location' ,
          style: AppTextStyles.heading1(
            context,
            overrideStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: ResponsiveHelper.fontSize(context, 16)),
          ),

        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: 15.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Search your location here",
                  focusColor: Colors.white,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  prefixIcon: const Icon(Icons.map),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.cancel), onPressed: () {
                    _controller.clear() ;
                  },
                  ),

                  // ✅ Rounded Borders
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), // ✅ Rounded corners
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), // ✅ Rounded corners
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), // ✅ Rounded corners
                    borderSide: BorderSide(color: Colors.blue, width: 0.5),
                  ),
                  filled: true,
                  fillColor: Colors.white, // ✅ Background white for better visibility
                ),

              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _placeList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // ✅ Selected place ka data return karke previous screen par bhejna
                    Navigator.pop(context, _placeList[index]["description"]);
                  },
                  child: ListTile(
                    leading: Icon(Icons.location_on, color: Colors.blue),
                    title: Text(_placeList[index]["description"]),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}