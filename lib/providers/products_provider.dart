import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/product.dart';

class ProductsProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Product> products = [];
  bool isLoading = false;
  String? error;

  // ✅ ADD (search + category memory)
  String _searchQuery = '';
  String? _selectedCategory;

  // ✅ ADD (UI always use this)
  List<Product> get filteredProducts {
    final q = _searchQuery.trim().toLowerCase();

    // first category filter
    final byCategory = (_selectedCategory == null || _selectedCategory!.isEmpty)
        ? products
        : products.where((p) => p.category == _selectedCategory).toList();

    // then search filter
    if (q.isEmpty) return byCategory;

    return byCategory.where((p) {
      final name = p.name.toLowerCase();
      return name.contains(q);
    }).toList();
  }

  Future<void> fetchProducts({String? category}) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      if (category != null) {
        final snapshot = await _firestore
            .collection('products')
            .where('category', isEqualTo: category)
            .get();
        products =
            snapshot.docs.map((doc) => Product.fromMap(doc.id, doc.data())).toList();
      } else {
        final snapshot = await _firestore.collection('products').get();
        products =
            snapshot.docs.map((doc) => Product.fromMap(doc.id, doc.data())).toList();
      }
    } catch (e) {
      error = 'Failed to load products: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addProduct({required Product product}) async {
    try {
      final docRef = await _firestore.collection('products').add(product.toMap());
      final productId = docRef.id;
      print(productId);

      await _firestore.collection('products').doc(productId).update({'id': productId});
      await fetchProducts(); // Refresh the list after adding
    } catch (e) {
      error = 'Failed to add product: $e';
    }
  }

  // ✅ FIXED: setCategory
  void setCategory(String? category) {
    _selectedCategory = category; // null দিলে All হবে
    notifyListeners();
  }

  // ✅ FIXED: setSearchQuery
  void setSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }
}
