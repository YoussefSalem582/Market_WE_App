class Product {
  final String code;
  final String name;
  int quantity; // Mutable quantity
  final double price;
  final String imageUrl;

  Product({
    required this.code,
    required this.name,
    this.quantity = 1, // Default quantity to 1
    required this.price,
    required this.imageUrl,
  });

  // A method to convert a Product to a map (if necessary)
  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'quantity': quantity,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  // Factory to create Product from a map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      code: map['code'],
      name: map['name'],
      quantity: map['quantity'],
      price: map['price'],
      imageUrl: map['imageUrl'],
    );
  }
}
