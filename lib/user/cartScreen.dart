// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'CartProvider.dart';
//
// class CartScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final cart = Provider.of<CartProvider>(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Cart'),
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: cart.cart.isEmpty
//           ? const Center(
//         child: Text(
//           'Your cart is empty!',
//           style: TextStyle(fontSize: 20, color: Colors.deepPurple),
//         ),
//       )
//           : Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: cart.cart.length,
//               itemBuilder: (context, index) {
//                 final product = cart.cart[index];
//                 return Card(
//                   margin: const EdgeInsets.symmetric(
//                       vertical: 10, horizontal: 16),
//                   child: ListTile(
//                     leading: product.imageUrl.isNotEmpty
//                         ? Image.network(
//                       product.imageUrl,
//                       width: 50,
//                       height: 50,
//                       fit: BoxFit.cover,
//                     )
//                         : const Icon(Icons.image_not_supported),
//                     title: Text(product.name),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Price: \$${product.price}'),
//                         Row(
//                           children: [
//                             IconButton(
//                               icon: const Icon(Icons.remove_circle,
//                                   color: Colors.red),
//                               onPressed: () {
//                                 //cart.decrementQuantity(product);
//                               },
//                             ),
//                             Text(
//                               '${product.quantity}',
//                               style: const TextStyle(fontSize: 18),
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.add_circle,
//                                   color: Colors.green),
//                               onPressed: () {
//                                // cart.incrementQuantity(product);
//                               },
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     trailing: IconButton(
//                       icon: const Icon(Icons.delete, color: Colors.red),
//                       onPressed: () {
//                         cart.removeFromCart(product);
//                       },
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 Text(
//                   'Total: \$${cart.totalPrice.toStringAsFixed(2)}',
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: () {
//                     _confirmCheckout(context, cart);
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.deepPurple,
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 16, horizontal: 32),
//                   ),
//                   child: const Text('Checkout'),
//                 ),
//                 const SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: () {
//                     _confirmClearCart(context, cart);
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red,
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 16, horizontal: 32),
//                   ),
//                   child: const Text('Clear Cart'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Checkout confirmation
//   void _confirmCheckout(BuildContext context, CartProvider cart) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Checkout Confirmation'),
//           content: const Text('Are you sure you want to proceed to checkout?'),
//           actions: [
//             TextButton(
//               child: const Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: const Text('Proceed'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Proceeding to Checkout...')),
//                 );
//                 // Implement your checkout logic here
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   // Clear cart confirmation
//   void _confirmClearCart(BuildContext context, CartProvider cart) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Clear Cart Confirmation'),
//           content: const Text('Are you sure you want to clear the cart?'),
//           actions: [
//             TextButton(
//               child: const Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: const Text('Clear'),
//               onPressed: () {
//                 cart.clearCart();
//                 Navigator.of(context).pop();
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Cart cleared')),
//                 );
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'CartProvider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: Colors.deepPurple,
      ),
      body: cart.cart.isEmpty
          ? const Center(
        child: Text(
          'Your cart is empty!',
          style: TextStyle(fontSize: 20, color: Colors.deepPurple),
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.cart.length,
              itemBuilder: (context, index) {
                final product = cart.cart[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 16),
                  child: ListTile(
                    leading: product.imageUrl.isNotEmpty
                        ? Image.network(
                      product.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                        : const Icon(Icons.image_not_supported),
                    title: Text(product.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Price: \$${product.price.toStringAsFixed(2)}'),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                cart.decrementQuantity(product);
                              },
                            ),
                            Text(
                              '${product.quantity}',
                              style: const TextStyle(fontSize: 18),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.add_circle,
                                color: Colors.green,
                              ),
                              onPressed: () {
                                cart.incrementQuantity(product);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        cart.removeFromCart(product);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Total: \$${cart.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _confirmCheckout(context, cart);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 32),
                  ),
                  child: const Text('Checkout'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _confirmClearCart(context, cart);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 32),
                  ),
                  child: const Text('Clear Cart'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Checkout confirmation
  void _confirmCheckout(BuildContext context, CartProvider cart) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Checkout Confirmation'),
          content: const Text('Are you sure you want to proceed to checkout?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Proceed'),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Proceeding to Checkout...')),
                );
                // Clear cart after checkout
                cart.clearCart();
              },
            ),
          ],
        );
      },
    );
  }

  // Clear cart confirmation
  void _confirmClearCart(BuildContext context, CartProvider cart) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Cart Confirmation'),
          content: const Text('Are you sure you want to clear the cart?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Clear'),
              onPressed: () {
                cart.clearCart();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cart cleared')),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
