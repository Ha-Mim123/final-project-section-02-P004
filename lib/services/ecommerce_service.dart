import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';
import '../models/order.dart';

class EcommerceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  Future<List<Product>> getAllProducts() async {
    final snapshot = await _firestore.collection('products').get();
    return snapshot.docs
        .map((doc) => Product.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<Product> getProductById(String productId) async {
    final doc = await _firestore.collection('products').doc(productId).get();
    return Product.fromMap(doc.id, doc.data()!);
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    final snapshot = await _firestore
        .collection('products')
        .where('category', isEqualTo: category)
        .get();

    return snapshot.docs
        .map((doc) => Product.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<List<Product>> searchProducts(String query) async {
    final snapshot = await _firestore.collection('products').get();
    final all = snapshot.docs
        .map((doc) => Product.fromMap(doc.id, doc.data()))
        .toList();

    final q = query.toLowerCase().trim();
    return all.where((p) => p.name.toLowerCase().contains(q)).toList();
  }

  Future<String> placeOrder(OrderModel order) async {
    if (_uid == null) throw Exception('User not logged in');
    final docRef = await _firestore.collection('orders').add(order.toMap());
    return docRef.id;
  }

  Future<List<OrderModel>> getUserOrders() async {
    if (_uid == null) return [];
    final snapshot = await _firestore
        .collection('orders')
        .where('uid', isEqualTo: _uid)
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs.map((doc) => OrderModel.fromMap(doc.data(),doc.id)).toList();
  }

  Future<List<OrderModel>> getOrdersByStatus(String status) async {
    if (_uid == null) return [];
    final snapshot = await _firestore
        .collection('orders')
        .where('uid', isEqualTo: _uid)
        .where('status', isEqualTo: status)
        .get();

    return snapshot.docs.map((doc) => OrderModel.fromMap(doc.data(),doc.id)).toList();
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': status,
    });
  }
}
