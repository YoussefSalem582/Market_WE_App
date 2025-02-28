// import 'package:flutter/material.dart';
// import '../product_model.dart';
//
// class CartProvider extends ChangeNotifier {
//   List<ProductModel> _cart = [];
//
//   List<ProductModel> get cart => _cart;
//
//   double get totalPrice =>
//       _cart.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
//
//   // Add product to cart
//   void addToCart(ProductModel product) {
//     ProductModel? existingProduct = _cart.firstWhere(
//           (item) => item.code == product.code,
//       //orElse: () => null, // Handle null case properly
//     );
//
//     if (existingProduct != null) {
//       incrementQuantity(existingProduct); // Increase quantity if product exists
//     } else {
//       _cart.add(product); // Add new product to cart if not found
//     }
//
//     notifyListeners();
//   }
//
//   // Remove product from cart
//   void removeFromCart(ProductModel product) {
//     _cart.remove(product);
//     notifyListeners();
//   }
//
//   // Clear all items in cart
//   void clearCart() {
//     _cart.clear();
//     notifyListeners();
//   }
//
//   // Increment product quantity
//   void incrementQuantity(ProductModel product) {
//     product.quantity += 1; // Increase quantity
//     notifyListeners();
//   }
//
//   // Decrement product quantity (remove if it reaches 0)
//   void decrementQuantity(ProductModel product) {
//     if (product.quantity > 1) {
//       product.quantity -= 1;
//     } else {
//       removeFromCart(product); // Remove product if quantity becomes 0
//     }
//     notifyListeners();
//   }
// }

import 'package:flutter/material.dart';
import '../admin/product.dart';

class CartProvider with ChangeNotifier {
  final List<Product> _cart = [];

  List<Product> get cart => _cart;

  double get totalPrice => _cart.fold(
      0, (total, current) => total + (current.price * current.quantity));

  void addToCart(Product product) {
    _cart.add(product);
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _cart.remove(product);
    notifyListeners();
  }

  void incrementQuantity(Product product) {
    product.quantity++;
    notifyListeners();
  }

  void decrementQuantity(Product product) {
    if (product.quantity > 1) {
      product.quantity--;
      notifyListeners();
    }
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
}
