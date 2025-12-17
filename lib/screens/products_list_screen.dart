import 'package:e_commerce_mini_shopping_cart/models/cart_item.dart';
import 'package:e_commerce_mini_shopping_cart/providers/cart_provider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/product_details_dialog.dart';

class ProductsListScreen extends StatefulWidget {
  const ProductsListScreen({super.key});

  @override
  State<ProductsListScreen> createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductsProvider>().fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductsProvider>();

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return Center(child: Text(provider.error!));
    }

    // ✅ IMPORTANT: search + category filter apply
    final products = provider.filteredProducts;

    if (products.isEmpty) {
      return const Center(
        child: Text(
          "No product found",
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final product = products[index];

        return Consumer<CartProvider>(
          builder: (context, cartProvider, _) {
            return ProductCard(
              product: product,
              onCartTap: () {
                cartProvider.addProductToList(CartItem(product: product));

                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Added to cart")),
                );
              },
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => ProductDetailsDialog(product: product),
                );
              },
            );
          },
        );
      },
    );
  }
}
