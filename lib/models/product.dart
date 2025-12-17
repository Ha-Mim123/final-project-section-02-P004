class Product {
  final String id;      // Firestore document id (auto/random)
  final String pID;        // Firestore field: pID
  final String name;
  final double price;
  final String imageUrl;
  final String description;
  final String category;
  final int stock;

  Product({
    required this.id,
    required this.pID,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.category,
    required this.stock,
  });

  Map<String, dynamic> toMap() {
    return {
      'pID': pID,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'description': description,
      'category': category,
      'stock': stock,
    };
  }

  factory Product.fromMap(String id, Map<String, dynamic> data) {
    return Product(
      id: id,
      pID: (data['pID'] as String?) ?? '',
      name: (data['name'] ?? '') as String,
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: (data['imageUrl'] ?? '') as String,
      description: (data['description'] ?? '') as String,
      category: (data['category'] ?? '') as String,
      stock: (data['stock'] as num?)?.toInt() ?? 0,
    );
  }
}
