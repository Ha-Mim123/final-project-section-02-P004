import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:practices/providers/auth_provider.dart';
import '../models/order.dart';

class OrdersProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthProvider? _authProvider;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<OrderModel> _orders = [];
  List<OrderModel> get orders => _orders;

  OrdersProvider(this._authProvider, this._orders) {
    if (_authProvider?.currentUser != null) {
      loadOrders();
    }
  }

  // ✅ PLACE ORDER + DECREASE STOCK (TRANSACTION)
  Future<String> placeOrder(OrderModel order) async {
    final user = _authProvider?.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    try {
      _isLoading = true;
      notifyListeners();

      final orderId = await placeOrderWithoutTransaction(order);
      // ✅ instant UI update
      final savedOrder = OrderModel(
        orderId: orderId,
        uid: order.uid,
        items: order.items,
        total: order.total,
        date: order.date,
        status: order.status,
        customerName: order.customerName,
        customerPhone: order.customerPhone,
        customerAddress: order.customerAddress,
      );

      _orders.insert(0, savedOrder);
      notifyListeners();

      return orderId;
    } catch (e) {
      throw Exception('Order save failed: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
Future<String> placeOrderWithoutTransaction(OrderModel order) async {
  // 0) create order doc ref আগে বানিয়ে রাখি
  final docRef = _firestore.collection('orders').doc();

  // 1) Stock check + decrease (normal get + update)
  for (final item in order.items) {
    final productId = item['productId'] as String;
    final qty = (item['quantity'] as num?)?.toInt() ?? 1;

    final productRef = _firestore.collection('products').doc(productId);
    final snap = await productRef.get();

    if (!snap.exists) {
      throw Exception("Product not found: $productId");
    }

    final data = snap.data() as Map<String, dynamic>;
    final currentStock = (data['stock'] as num?)?.toInt() ?? 0;

    if (currentStock < qty) {
      final name = item['name'] ?? 'Unknown';
      throw Exception("Not enough stock for $name (Available: $currentStock)");
    }

    // decrease stock
    await productRef.update({'stock': currentStock - qty});
  }

  // 2) create order doc
  await docRef.set(order.toMap());

  // 3) store orderId inside doc
  await docRef.update({'orderId': docRef.id});

  return docRef.id;
}

  // ✅ LOAD USER ORDERS
  Future<void> loadOrders() async {
    final user = _authProvider?.currentUser;
    if (user == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      final snapshot = await _firestore
          .collection('orders')
          .where('uid', isEqualTo: user.uid)
          // ✅ index error avoid: orderBy না দিলে composite index লাগবে না
          .get();

      _orders = snapshot.docs
          .map((e) => OrderModel.fromMap(e.data(), e.id))
          .toList();

      // ✅ latest order first (client-side sort)
      _orders.sort((a, b) => b.date.compareTo(a.date));
    } catch (e) {
      throw Exception('Failed to load orders: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateOrderStatus({
    required String orderId,
    required String newStatus,
  }) async {
    

    try {
      _isLoading = true;
      notifyListeners();

      await _firestore.collection('orders').doc(orderId).update({
      'status': newStatus,
    });
    await loadOrders();
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
