class OrderModel {
  final String orderId;
  final String uid;
  final List<Map<String, dynamic>> items;
  final double total;
  final DateTime date;
  final String status;
  final String customerName;
  final String customerPhone;
  final String customerAddress;

  OrderModel({
    required this.orderId,
    required this.uid,
    required this.items,
    required this.total,
    required this.date,
    required this.status,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
  });

  // ✅ FIRESTORE MAP
  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'uid': uid,
      'items': items,
      'total': total,
      'date': date,
      'status': status,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
    };
  }

  // ✅ FROM FIRESTORE
  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderModel(
      // orderId: map['orderId'],
      orderId: (map['orderId'] as String?)?.isNotEmpty == true ? map['orderId'] : id,
      uid: map['uid'],
      items: List<Map<String, dynamic>>.from(map['items']),
      total: (map['total'] as num).toDouble(),
      date: map['date'].toDate(),
      status: map['status'],
      customerName: map['customerName'],
      customerPhone: map['customerPhone'],
      customerAddress: map['customerAddress'],
    );
  }

  // ✅ ORDER CARD COMPATIBILITY GETTERS
  String get id => orderId;
  double get totalAmount => total;
  List get products => items;

  String get formattedDate {
    return "${date.day}/${date.month}/${date.year}";
  }
}
