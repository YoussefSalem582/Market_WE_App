import 'package:flutter/material.dart';
import '../admin/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;


  ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(product.imageUrl, height: 200, fit: BoxFit.cover),
            SizedBox(height: 20),
            Text('Code: ${product.code}', style: TextStyle(fontSize: 18)),
            Text('Quantity: ${product.quantity}', style: TextStyle(fontSize: 18)),
            Text('Price: \$${product.price}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement add to cart functionality here
              },
              child: Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}
