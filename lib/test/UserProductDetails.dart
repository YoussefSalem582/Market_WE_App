// import 'package:flutter/material.dart';
//
// import '../db_helper.dart';
//
// class UserProductDetails extends StatelessWidget {
//   final Map product;
//   UserProductDetails({required this.product});
//
//   Future<void> addToCart() async {
//     final db = await DBHelper.database;
//     await db.insert('cart', {
//       'product_code': product['code'],
//       'user_id': currentUserId,
//       'qu': 1, // Default quantity is 1
//     });
//
//     print('Added to cart!');
//   }
//
//   Future<void> addToFavorites() async {
//     final db = await DBHelper.database;
//     await db.insert('fav', {
//       'product_code': product['code'],
//       'user_id': currentUserId,
//     });
//
//     print('Added to favorites!');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(product['product_name'])),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.network(product['image_url'], height: 200, fit: BoxFit.cover),
//             SizedBox(height: 10),
//             Text('Price: \$${product['price']}',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             SizedBox(height: 10),
//             Text('Discount: ${product['discount']}%'),
//             SizedBox(height: 10),
//             Text('Quantity: ${product['qu']}'),
//             Spacer(),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                   onPressed: addToCart,
//                   child: Text('Add to Cart'),
//                 ),
//                 ElevatedButton(
//                   onPressed: addToFavorites,
//                   child: Text('Add to Favorites'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class UserProductDetails extends StatelessWidget {
  final Map<String, dynamic> product;

  UserProductDetails({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['product_name']),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              product['image_url'] ?? '',
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            Text(
              product['product_name'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Price: \$${product['price']}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Quantity Available: ${product['qu']}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
