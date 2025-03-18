class CartItem {
  final String id;
  final String name;
  final String category;
  final double price;
  final String imageUrl;
  final String packageDetail;
  final String orderType;
  final int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.packageDetail,
    required this.orderType,
    this.quantity = 1,
  });

  // ✅ Add a factory constructor for an empty CartItem
  factory CartItem.empty() {
    return CartItem(
      id: '',
      name: '',
      category: '',
      price: 0.0,
      imageUrl: '',
      packageDetail: '',
      orderType: '',
      quantity: 0,
    );
  }

  // 🟢 Convert CartItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'imageUrl': imageUrl,
      'packageDetail': packageDetail,
      'orderType': orderType,
      'quantity': quantity,
    };
  }

  // 🟢 Convert JSON to CartItem
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      price: json['price'],
      imageUrl: json['imageUrl'],
      packageDetail: json['packageDetail'],
      orderType: json['orderType'],
      quantity: json['quantity'],
    );
  }
}
