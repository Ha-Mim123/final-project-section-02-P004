import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../models/cart_item.dart';

class ProductDetailsDialog extends StatefulWidget {
  final Product product;

  const ProductDetailsDialog({super.key, required this.product});

  @override
  State<ProductDetailsDialog> createState() => _ProductDetailsDialogState();
}

class _ProductDetailsDialogState extends State<ProductDetailsDialog> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    final bool isOutOfStock = product.stock <= 0;

    // stock 0 হলে quantity 1 fixed রাখি
    if (isOutOfStock && quantity != 1) {
      quantity = 1;
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 900,
            height: 600,
            constraints: const BoxConstraints(maxWidth: 900, maxHeight: 600),
            padding: const EdgeInsets.all(0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  return _webLayout(product, cartProvider, isOutOfStock);
                } else {
                  return _mobileLayout(product, cartProvider, isOutOfStock);
                }
              },
            ),
          ),

          // Close Button
          Positioned(
            right: 10,
            top: 10,
            child: IconButton(
              icon: const Icon(Icons.close, size: 28, color: Colors.grey),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }

  // WEB / TABLET
  Widget _webLayout(Product product, CartProvider cartProvider, bool isOutOfStock) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Image
        Expanded(
          flex: 4,
          child: Container(
            color: Colors.grey[100],
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (ctx, _, __) =>
                    const Icon(Icons.broken_image, size: 50),
              ),
            ),
          ),
        ),

        // Details
        Expanded(
          flex: 5,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(30, 40, 30, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 10),

                Text(
                  "৳ ${product.price.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),

                // ✅ Available stock
                Text(
                  isOutOfStock ? "No product available" : "Available: ${product.stock}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isOutOfStock ? Colors.red : Colors.grey[700],
                  ),
                ),

                const SizedBox(height: 20),

                // Add to Cart Row
                Row(
                  children: [
                    _quantitySelector(isOutOfStock: isOutOfStock),
                    const SizedBox(width: 15),

                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC0392B),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        onPressed: isOutOfStock
                            ? null
                            : () {
                                // ✅ extra safety: cart qty must not exceed stock
                                if (quantity > product.stock) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Only ${product.stock} available",
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                _addToCart(cartProvider, product);
                              },
                        child: Text(
                          isOutOfStock ? "OUT OF STOCK" : "ADD TO CART",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),
                Divider(color: Colors.grey[300]),
                const SizedBox(height: 15),

                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // MOBILE
  Widget _mobileLayout(Product product, CartProvider cartProvider, bool isOutOfStock) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 250,
            color: Colors.grey[100],
            child: Image.network(product.imageUrl, fit: BoxFit.contain),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 10),

                Text(
                  "৳ ${product.price.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                // ✅ Available stock
                Text(
                  isOutOfStock ? "No product available" : "Available: ${product.stock}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isOutOfStock ? Colors.red : Colors.grey[700],
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    _quantitySelector(isOutOfStock: isOutOfStock),
                    const SizedBox(width: 10),

                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC0392B),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        onPressed: isOutOfStock
                            ? null
                            : () {
                                if (quantity > product.stock) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Only ${product.stock} available",
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                _addToCart(cartProvider, product);
                              },
                        child: Text(
                          isOutOfStock ? "OUT OF STOCK" : "ADD TO CART",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Text(
                  product.description,
                  style: TextStyle(color: Colors.grey[600], height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Quantity Selector (disable when out of stock)
  Widget _quantitySelector({required bool isOutOfStock}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
      ),
      height: 45,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove, size: 16),
            onPressed: isOutOfStock
                ? null
                : () {
                    if (quantity > 1) setState(() => quantity--);
                  },
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "$quantity",
              style: TextStyle(
                fontSize: 16,
                color: isOutOfStock ? Colors.grey : Colors.black,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 16),
            onPressed: isOutOfStock
                ? null
                : () {
                    setState(() => quantity++);
                  },
          ),
        ],
      ),
    );
  }

  void _addToCart(CartProvider provider, Product product) {
    provider.addProductToList(
      CartItem(product: product, quantity: quantity),
    );

    if (!mounted) return;

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$quantity ${product.name} added to cart")),
    );
  }
}
