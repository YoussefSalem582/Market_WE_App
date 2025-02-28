import 'package:flutter/material.dart';
import '../db_helper.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _discountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _addProduct() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final price = double.tryParse(_priceController.text) ?? 0;
      final quantity = int.tryParse(_quantityController.text) ?? 0;
      final imageUrl = _imageUrlController.text;
      final discount = double.tryParse(_discountController.text) ?? 0;

      await DBHelper().database.then((db) => db.insert('product', {
            'product_name': name,
            'price': price,
            'qu': quantity,
            'image_url': imageUrl,
            'discount': discount,
          }));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added successfully!')),
      );
      Navigator.pop(context); // Go back to the admin dashboard
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Product',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Add New Product',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Product Name',
                            prefixIcon: const Icon(Icons.label),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the product name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _priceController,
                          decoration: InputDecoration(
                            labelText: 'Price',
                            prefixIcon: const Icon(Icons.attach_money),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the product price';
                            }
                            if (double.tryParse(value) == null ||
                                double.parse(value) <= 0) {
                              return 'Please enter a valid price';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _quantityController,
                          decoration: InputDecoration(
                            labelText: 'Quantity',
                            prefixIcon:
                                const Icon(Icons.production_quantity_limits),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the quantity';
                            }
                            if (int.tryParse(value) == null ||
                                int.parse(value) < 0) {
                              return 'Please enter a valid quantity';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        // TextFormField(
                        //   controller: _imageUrlController,
                        //   decoration: InputDecoration(
                        //     labelText: 'Image URL',
                        //     prefixIcon: const Icon(Icons.image),
                        //     border: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //   ),
                        //   validator: (value) {
                        //     if (value == null || value.isEmpty) {
                        //       return 'Please enter the image URL';
                        //     }
                        //     return null;
                        //   },
                        // ),
                        TextFormField(
                          controller: _imageUrlController,
                          decoration: InputDecoration(
                            labelText: 'Image URL',
                            hintText:
                                'Enter a valid image URL (e.g., https://)',
                            prefixIcon: const Icon(Icons.image),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          keyboardType: TextInputType.url,
                          // Use appropriate keyboard for URLs
                          validator: (value) {
                            final urlPattern =
                                r'(http(s?):)([/|.|\w|\s|-])*\.(?:jpg|jpeg|png|gif|svg)';
                            final regex = RegExp(urlPattern);

                            if (value == null || value.isEmpty) {
                              return 'Please enter the image URL';
                            } else if (!regex.hasMatch(value)) {
                              return 'Please enter a valid image URL';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _discountController,
                          decoration: InputDecoration(
                            labelText: 'Discount (%)',
                            prefixIcon: const Icon(Icons.percent),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              if (double.tryParse(value) == null ||
                                  double.parse(value) < 0 ||
                                  double.parse(value) > 100) {
                                return 'Please enter a valid discount between 0 and 100';
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: _addProduct,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 22),
                            textStyle: const TextStyle(fontSize: 18),
                          ),
                          child: const Text(
                            'Add Product',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
