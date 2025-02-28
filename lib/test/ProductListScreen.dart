// import 'package:flutter/material.dart';
//
// import '../admin/UpdateProductScreen.dart';
// import '../db_helper.dart';
//
// class ProductListScreen extends StatefulWidget {
//   final bool isAdmin;
//   ProductListScreen({required this.isAdmin}); // Different views for Admin and User
//
//   @override
//   _ProductListScreenState createState() => _ProductListScreenState();
// }
//
// class _ProductListScreenState extends State<ProductListScreen> {
//   List<Map<String, dynamic>> _products = [];
//
//   Future<void> fetchProducts() async {
//     final db = await DBHelper.database;
//     final data = await db.query('product');
//     setState(() {
//       _products = data;
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     fetchProducts();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.isAdmin ? 'Manage Products' : 'Products'),
//       ),
//       body: _products.isEmpty
//           ? Center(child: Text('No products available.'))
//           : ListView.builder(
//         itemCount: _products.length,
//         itemBuilder: (context, index) {
//           final product = _products[index];
//           return ListTile(
//             leading: Image.network(
//               product['image_url'],
//               width: 50,
//               height: 50,
//               fit: BoxFit.cover,
//             ),
//             title: Text(product['product_name']),
//             subtitle: Text('Price: \$${product['price']}'),
//             trailing: widget.isAdmin
//                 ? Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.edit, color: Colors.blue),
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             UpdateProductScreen(product: product),
//                       ),
//                     ).then((_) => fetchProducts());
//                   },
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.delete, color: Colors.red),
//                   onPressed: () async {
//                     final db = await DBHelper.database;
//                     await db.delete(
//                       'product',
//                       where: 'code = ?',
//                       whereArgs: [product['code']],
//                     );
//                     fetchProducts();
//                   },
//                 ),
//               ],
//             )
//                 : IconButton(
//               icon: Icon(Icons.add_shopping_cart, color: Colors.green),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => UserProductDetails(
//                       product: product,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../db_helper.dart';
import 'UserProductDetails.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts(); // Fetch products when the screen loads
  }

  // Fetch products from the database
  Future<void> fetchProducts() async {
    final db = await DBHelper().database;  // ✅ Correct database access
    final data = await db.query('product');
    setState(() {
      _products = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        backgroundColor: Colors.deepPurple,
      ),
      body: _products.isEmpty
          ? const Center(
        child: Text('No products available.'),
      )
          : ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return ListTile(
            leading: product['image_url'] != null &&
                product['image_url'].isNotEmpty
                ? Image.network(
              product['image_url'],
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            )
                : const Icon(Icons.image_not_supported),
            title: Text(product['product_name']),
            subtitle: Text('Price: \$${product['price']}'),
            onTap: () {
              // Navigate to UserProductDetails screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProductDetails(product: product),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
