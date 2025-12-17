import 'package:flutter/material.dart';
import 'package:practices/providers/products_provider.dart';
import 'package:practices/utils/constants.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/orders_provider.dart';
import '../providers/auth_provider.dart';
import '../models/order.dart';
import 'order_confirmation_screeen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  bool _isPlacingOrder = false;
// getter method er special type eta diye akta function er direct return kora hoy 
  bool get _allFilled =>
      nameController.text.trim().isNotEmpty &&
      phoneController.text.trim().isNotEmpty &&
      addressController.text.trim().isNotEmpty;

  Future<void> _placeOrder() async {
    if (_isPlacingOrder) return;
    if (!_formKey.currentState!.validate()) return;  // pura form ta validate hole  ..return kore dibe..

    final cart = context.read<CartProvider>();
    final auth = context.read<AuthProvider>();
    final ordersProvider = context.read<OrdersProvider>();
// local provider er instance auth ta ekhane..
    final user = auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please login first")),
      );
      return;
    }

    if (cart.productList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cart is empty")),
      );
      return;
    }

    setState(() => _isPlacingOrder = true);

    try {
      // ✅ local cart items -> order items
      final items = cart.productList.map((item) {
        return {
          'productId': item.product.id,
          'name': item.product.name,
          'price': item.product.price,
          'quantity': item.quantity,
        };
      }).toList();

      // ✅ always calculate total from productList (safe)

      // fold method--> 
      final totalAmount = cart.productList.fold<double>(
        0.0,
        (sum, item) => sum + item.totalPrice,
      );
// constructor method diye object bananor structure
      final order = OrderModel(
        orderId: '', // Firestore docId দিয়ে পরে সেট হবে (OrdersProvider এ)
        uid: user.uid,
        items: items,
        total: totalAmount,
        date: DateTime.now(),
        status: AppConstants.statusPlaced,
        customerName: nameController.text.trim(),
        customerPhone: phoneController.text.trim(),
        customerAddress: addressController.text.trim(),
      );

      final orderId = await ordersProvider.placeOrder(order);

      // ✅ clear local cart
      cart.clearProductList();

      // ✅ refresh orders list so Orders tab shows instantly
      await ordersProvider.loadOrders();



      await context.read<ProductsProvider>().fetchProducts();

// current widget  er context ta beche ase kina etai mounted check kore
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OrderConfirmationScreen(orderId: orderId),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Order failed: $e")),
      );
    } finally {
      if (mounted) {
        setState(() => _isPlacingOrder = false);
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    // ✅✅ এখানেই totalAmount declare করবে (তোমার missing ছিল)
    final totalAmount = cart.productList.fold<double>(
      0.0,
      (sum, item) => sum + item.totalPrice,
    );

    final canPlaceOrder =
        cart.productList.isNotEmpty && _allFilled && !_isPlacingOrder;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                keyboardType: TextInputType.text,
                onChanged: (_) => setState(() {}),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                onChanged: (_) => setState(() {}),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (value.trim().length < 8) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                keyboardType: TextInputType.text,
                onChanged: (_) => setState(() {}),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              Text(
                'Total: ৳ ${totalAmount.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: canPlaceOrder ? _placeOrder : null,
                  child: _isPlacingOrder
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Place Order'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
