class ProductModel {
  final String code;
  final String name;
  int quantity; // Mutable quantity to allow changes
  final double price;
  final String imageUrl; // For product images

  ProductModel({
    required this.code,
    required this.name,
    this.quantity = 1, // Default quantity is 1
    required this.price,
    required this.imageUrl,
  });

  // To convert ProductModel to a map (if needed for storage or database)
  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'quantity': quantity,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  // To create ProductModel from a map (if needed for retrieval from storage or database)
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      code: map['code'],
      name: map['name'],
      quantity: map['quantity'],
      price: map['price'],
      imageUrl: map['imageUrl'],
    );
  }
}
