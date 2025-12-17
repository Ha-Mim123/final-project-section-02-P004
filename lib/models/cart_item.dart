import '../models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'pID': product.pID,
      'name': product.name,
      'price': product.price,
      'imageUrl': product.imageUrl,
      'description': product.description,
      'category': product.category,
      'stock': product.stock,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> data, String docId) {
    return CartItem(
      product: Product(
        id: docId,
        pID: (data['pID'] as String?) ?? '',
        name: (data['name'] ?? '') as String,
        price: (data['price'] as num?)?.toDouble() ?? 0.0,
        imageUrl: (data['imageUrl'] ?? '') as String,
        description: (data['description'] ?? '') as String,
        category: (data['category'] ?? '') as String,
        stock: (data['stock'] as num?)?.toInt() ?? 0,
      ),
      quantity: (data['quantity'] as num?)?.toInt() ?? 1,
    );
  }
}
