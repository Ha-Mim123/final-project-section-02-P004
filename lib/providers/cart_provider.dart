import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:practices/models/product.dart';
import 'package:practices/providers/auth_provider.dart';
import '../models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final AuthProvider? _authProvider;
  List<CartItem> _items = [];

  CartProvider(this._authProvider, this._items) {
    if (_authProvider?.currentUser != null) {
      loadCart();
    }
  }

  List<CartItem> get items => _items;

  int get itemCount => _items.length;
  int get totalQuantity =>
    productList.fold<int>(0, (sum, item) => sum + item.quantity);

  Future<void> loadCart() async {
    if (_authProvider?.currentUser == null) return;

    final userId = _authProvider!.currentUser!.uid;
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cart')
        .get();

    _items = snapshot.docs
        .map((doc) => CartItem.fromMap(doc.data(), doc.id))
        .toList();

    notifyListeners();
  }

  Future<void> addToCart(CartItem item) async {
    if (_authProvider?.currentUser == null) return;

    final userId = _authProvider!.currentUser!.uid;
    final cartItemRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(item.product.id);

    final existingDoc = await cartItemRef.get();

    if (existingDoc.exists) {
      await cartItemRef.update({
        'quantity': FieldValue.increment(item.quantity),
      });
    } else {
      await cartItemRef.set(item.toMap()); // flat structure stays same
    }

    await loadCart();
  }

  Future<void> removeFromCart(String productId) async {
    if (_authProvider?.currentUser == null) return;

    final userId = _authProvider!.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(productId)
        .delete();
    await loadCart();
  }


  Future<void> clearCart() async {
    if (_authProvider?.currentUser == null) return;

    final userId = _authProvider!.currentUser!.uid;
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cart')
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
    _items = [];
    notifyListeners();
  }

  // ekhan theke code kaz korte pare.
  List<CartItem>productList = [];
  void addProductToList(CartItem item) {
    
    if (!productList.any((cartItem) => cartItem.product.id == item.product.id)) {
      productList.add(item);
      notifyListeners();
    }
    else{
      
      final existingItem = productList.firstWhere((cartItem) => cartItem.product.id == item.product.id);
      existingItem.quantity += item.quantity;
      notifyListeners();
    }
  }

  void removeProductFromList(Product product) {
  productList.removeWhere((item) => item.product.id == product.id);
  notifyListeners();
}


  void reduceProductQuantity(Product product) {
    final existingItem = productList.firstWhere((cartItem) => cartItem.product.id == product.id, orElse: () => CartItem(product: product, quantity: 0));
    if (existingItem.quantity > 1) {
      existingItem.quantity -= 1;
    } else {
      productList.remove(existingItem);
    }
    notifyListeners();
  }
  void clearProductList() {
    productList.clear();
    notifyListeners();
  }





  // ➕ Increase quantity (+ button)
  // ===================================================
  void increaseQuantity(Product product) {
    final index = productList.indexWhere(
      (cartItem) => cartItem.product.id == product.id,
    );

    if (index == -1) return;

    productList[index].quantity += 1;
    notifyListeners();
  }
  // ➖ Decrease quantity (- button)
  // ===================================================
  void decreaseQuantity(Product product) {
    final index = productList.indexWhere(
      (cartItem) => cartItem.product.id == product.id,
    );

    if (index == -1) return;

    // quantity > 1 হলে শুধু কমাও
    if (productList[index].quantity > 1) {
      productList[index].quantity -= 1;
    }
    
    else {
      productList.removeAt(index);
    }

    notifyListeners();
  }
}

