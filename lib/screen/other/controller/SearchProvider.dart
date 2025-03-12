import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {
  List<String> _items = ["Laptop", "Phone", "Watch", "Tablet", "Headphones"];
  List<String> _filteredItems = [];

  SearchProvider() {
    _filteredItems = List.from(_items); // Initialize filtered list
  }

  List<String> get filteredItems => _filteredItems;

  void filterSearch(String query) {
    if (query.isEmpty) {
      _filteredItems = List.from(_items);
    } else {
      _filteredItems = _items
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners(); // Notify UI
  }
}
