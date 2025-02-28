import 'package:flutter/material.dart';
import '../db_helper.dart';

class FavoritesScreen extends StatefulWidget {
  final int userId; // Pass the userId dynamically

  FavoritesScreen({required this.userId});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, dynamic>> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final db = await DBHelper().database;
    final data = await db.rawQuery(
      'SELECT * FROM product INNER JOIN fav ON product.code = fav.product_code WHERE fav.user_id = ?',
      [widget.userId], // Use the passed userId
    );
    setState(() {
      _favorites = data;
    });
  }

  Future<void> _removeFromFavorites(int productCode) async {
    final db = await DBHelper().database;
    await db.delete(
      'fav',
      where: 'product_code = ? AND user_id = ?',
      whereArgs: [productCode, widget.userId], // Use the passed userId
    );
    _loadFavorites();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Removed from Favorites')),
    );
  }

  Future<void> _confirmRemove(int productCode) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove from Favorites'),
          content: const Text('Are you sure you want to remove this product from favorites?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Remove'),
              onPressed: () {
                _removeFromFavorites(productCode);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: Colors.deepPurple,
      ),
      body: _favorites.isEmpty
          ? const Center(
        child: Text(
          'No favorites yet!',
          style: TextStyle(fontSize: 18, color: Colors.deepPurple),
        ),
      )
          : ListView.builder(
        itemCount: _favorites.length,
        itemBuilder: (context, index) {
          final product = _favorites[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              leading: product['image_url'] != null && product['image_url'].isNotEmpty
                  ? Image.network(
                product['image_url'],
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              )
                  : const Icon(Icons.image_not_supported, size: 50),
              title: Text(
                product['product_name'],
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Price: \$${product['price']}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _confirmRemove(product['code']),
              ),
            ),
          );
        },
      ),
    );
  }
}
