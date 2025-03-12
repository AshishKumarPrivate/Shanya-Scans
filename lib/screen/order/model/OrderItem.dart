class OrderItem {
  final String id;
  final String name;
  final String category;
  final double price;
  final String imageUrl;
  final String packageDetail;
  final int quantity;

  static String defaultImage = "assets/images/common_scan_image.png";

  OrderItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    String? imageUrl, // Nullable to handle default value
    required this.packageDetail,
    this.quantity = 1,
  }) : imageUrl = imageUrl ?? defaultImage; // Assign default image if null

  // ✅ Factory constructor for an empty OrderItem
  factory OrderItem.empty() {
    return OrderItem(
      id: '',
      name: '',
      category: '',
      price: 0.00,
      imageUrl: defaultImage, // Ensuring default image
      packageDetail: '',
      quantity: 0,
    );
  }

  // 🟢 Convert OrderItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'imageUrl': imageUrl,
      'packageDetail': packageDetail,
      'quantity': quantity,
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      price: json['price'] ?? '',
      imageUrl: (json['imageUrl'] == null || json['imageUrl']!.isEmpty)
          ? OrderItem.defaultImage  // ✅ Use default image if missing
          : json['imageUrl'],
      packageDetail: json['packageDetail'] ?? '',
      quantity: json['quantity'] ?? 1,
    );
  }

}
