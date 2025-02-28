import 'package:flutter/material.dart';
import 'db_helper.dart';

Future<void> addToCart(BuildContext context, int productId, int userId, int quantity) async {
  final db = await DBHelper().database;  // Access DBHelper singleton
  await db.insert('cart', {
    'product_code': productId,
    'user_id': userId,
    'qu': quantity,
  });

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Product added to cart!')),
  );
}
