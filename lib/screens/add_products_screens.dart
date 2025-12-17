import 'package:e_commerce_mini_shopping_cart/models/product.dart';
import 'package:e_commerce_mini_shopping_cart/providers/products_provider.dart';
import 'package:e_commerce_mini_shopping_cart/utils/constants.dart';
import 'package:flutter/material.dart';

import 'dart:core';

import 'package:provider/provider.dart';

class AddProductsScreens extends StatefulWidget {
  const AddProductsScreens({super.key});

  @override
  State<AddProductsScreens> createState() => _AddProductsScreensState();
}

class _AddProductsScreensState extends State<AddProductsScreens> {
  final _formKey = GlobalKey<FormState>();
  final pIDController = TextEditingController();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final imageUrlController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();
  final stockController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Products')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Container(
                height: 400,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: imageUrlController.text.isEmpty
                    ? const Center(child: Text('Image Preview'))
                    : Image.network(
                        imageUrlController.text,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Center(child: Text('Invalid Image URL')),
                      ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    imageUrlController.text = value;
                  });
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: pIDController,
                decoration: const InputDecoration(labelText: 'Product ID'),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product ID';
                  } else if (value.length < 1) {
                    return 'Product ID must be at least 1 character ';
                  }
                  return null;
                },
              ),

              SizedBox(height: 10),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  // Check if the input is a valid number than price will be set to value
                  // else it will be set to null
                  final price = double.tryParse(value);

                  if (price == null || price <= 0) {
                    return 'Please enter a valid positive number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: stockController,
                decoration: const InputDecoration(
                  labelText: 'Stock / Available Quantity',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please enter stock';
                  final s = int.tryParse(value);
                  if (s == null || s < 0)
                    return 'Enter a valid stock (0 or more)';
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                keyboardType: TextInputType.multiline,
                maxLines: 4,

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  } else if (value.length < 10) {
                    return 'Description must be at least 10 characters long';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Category'),

                items: AppConstants.categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),

                onChanged: (String? newValue) {
                  categoryController.text = newValue ?? '';
                  //?? --> jodi eta null hoy thle empty thkbe. ar jodi null na hoy thle newValue thkbe
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              Consumer<ProductsProvider>(
                builder: (context, productsProvider, _) {
                  return ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final newProduct = Product(
                          id: "11111", // This will be auto-generated by Firestore
                          pID: pIDController.text,
                          name: nameController.text,
                          price: double.tryParse(priceController.text) ?? 0.0,
                          imageUrl: imageUrlController.text,
                          description: descriptionController.text,
                          category: categoryController.text,
                          stock: int.tryParse(stockController.text) ?? 0,
                        );
                        productsProvider.addProduct(product: newProduct);

                        // You can now use these values to add the product to your database or perform other actions

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Product Added Successfully'),
                          ),
                        );

                        // Clear the form
                        pIDController.clear();
                        nameController.clear();
                        priceController.clear();
                        descriptionController.clear();
                        categoryController.clear();
                        imageUrlController.clear();

                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Add Product'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      minimumSize: Size(double.infinity, 45),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
