import 'package:flutter/material.dart';

class OrderFailedScreen extends StatelessWidget {
  final String reason;
  const OrderFailedScreen({required this.reason});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Order Failed")),
      body: Center(
        child: Text(reason, style: TextStyle(fontSize: 18, color: Colors.red)),
      ),
    );
  }
}
