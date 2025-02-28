import 'package:flutter/material.dart';
import 'package:market_we/login_screen.dart';
import '../db_helper.dart';
import 'UpdateProductScreen.dart';
import 'add_product_screen.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _users = [];

  Future<void> _fetchData() async {
    final db = DBHelper();
    _products = await db.database.then((db) => db.query('product'));
    _users = await db.database.then((db) => db.query('users'));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Row(
          children: [
            Icon(
              Icons.dashboard,
              size: 28,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              'Admin Dashboard',
              style: TextStyle(
                  color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout,color: Colors.white,),
            onPressed: () => LoginScreen(),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddProductScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 22),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text(
                  'Add Product',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'All Products',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              _buildProductList(),
              const SizedBox(height: 30),
              const Text(
                'All Users',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              _buildUserList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            title: Text(product['product_name']),
            subtitle: Text('Price: ${product['price']}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                await DBHelper().database.then((db) => db.delete(
                    'product', where: 'code = ?', whereArgs: [product['code']]));
                _fetchData(); // Refresh data after deletion
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateProductScreen(product: product),
                ),
              ).then((value) {
                _fetchData(); // Refresh the product list after returning from the update screen
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildUserList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _users.length,
      itemBuilder: (context, index) {
        final user = _users[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            title: Text(user['fullname']),
            subtitle: Text('Type: ${user['type']}'),
          ),
        );
      },
    );
  }
}
