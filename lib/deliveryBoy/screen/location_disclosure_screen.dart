import 'package:flutter/material.dart';

class LocationDisclosureScreen extends StatelessWidget {
  final VoidCallback onAgree;

  const LocationDisclosureScreen({Key? key, required this.onAgree}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Location Permission")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Why we need your location:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text(
              "To allow our delivery personnel to navigate and collect test samples from your location, "
                  "we need access to your precise location data. This includes background access for real-time updates.",
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onAgree,
              child: const Text("I Understand & Agree"),
            ),
          ],
        ),
      ),
    );
  }
}
