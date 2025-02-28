import 'package:flutter/material.dart';
import '../db_helper.dart';

class UpdateProductScreen extends StatefulWidget {
  final Map product;

  UpdateProductScreen({required this.product});

  @override
  _UpdateProductScreenState createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  late TextEditingController productNameController;
  late TextEditingController priceController;
  late TextEditingController quantityController;
  late TextEditingController imageUrlController;
  late TextEditingController discountController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    productNameController =
        TextEditingController(text: widget.product['product_name']);
    priceController =
        TextEditingController(text: widget.product['price'].toString());
    quantityController =
        TextEditingController(text: widget.product['qu'].toString());
    imageUrlController =
        TextEditingController(text: widget.product['image_url']);
    discountController =
        TextEditingController(text: widget.product['discount'].toString());
  }

  Future<void> updateProduct() async {
    if (_formKey.currentState!.validate()) {
      final db = await DBHelper().database;
      await db.update(
        'product',
        {
          'product_name': productNameController.text,
          'price': double.parse(priceController.text),
          'qu': int.parse(quantityController.text),
          'image_url': imageUrlController.text,
          'discount': double.parse(discountController.text),
        },
        where: 'code = ?',
        whereArgs: [widget.product['code']],
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product updated successfully!')),
      );
      Navigator.pop(context);
    }
  }

  Future<void> deleteProduct() async {
    final db = await DBHelper().database;
    await db.delete(
      'product',
      where: 'code = ?',
      whereArgs: [widget.product['code']],
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product deleted successfully!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update Product',
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
                          'Edit Product Details',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: productNameController,
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
                          controller: priceController,
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
                          controller: quantityController,
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
                        TextFormField(
                          controller: imageUrlController,
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
                          controller: discountController,
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
                          onPressed: updateProduct,
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
                            'Update Product',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: deleteProduct,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 22),
                            textStyle: const TextStyle(fontSize: 18),
                          ),
                          child: const Text(
                            'Delete Product',
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
