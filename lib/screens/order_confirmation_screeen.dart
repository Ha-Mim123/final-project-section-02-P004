import 'package:flutter/material.dart';
import 'package:practices/providers/orders_provider.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final String orderId;
// widget er id super.key...inherite kore use kortasi
  const OrderConfirmationScreen({super.key, required this.orderId});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Success')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 16),
            const Text(
              'Your order has been placed!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Order ID: $orderId'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/home', (route) => false);
              },
              child: const Text('Back to Shop'),
            ),
          ],
        ),
      ),
    );
  }
}
