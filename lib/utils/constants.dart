import 'package:flutter/material.dart';

class AppConstants {
  // ==============================
  // ✅ PRODUCT CATEGORIES
  // ==============================
  static const List<String> categories = [
    'Women',
    'Men',
    'Kids',
    'Bags',
    'Beauty',
    'Shoes',
  ];

  // ==============================
  // ✅ ORDER STATUS
  // ==============================
  static const String statusAll = 'All';
  static const String statusPlaced = 'Order Placed';
  static const String statusProcessing = 'Processing';
  static const String statusDelivered = 'Delivered';
  static const String statusCancelled = 'Cancelled';

  static const List<String> orderStatusList = [
    statusAll,
    statusPlaced,
    statusProcessing,
    statusDelivered,
    statusCancelled,
  ];

  // ==============================
  // ✅ PAYMENT STATUS
  // ==============================
  static const String paymentPending = 'Pending';
  static const String paymentPaid = 'Paid';
  static const String paymentFailed = 'Failed';

  static const List<String> paymentStatusList = [
    paymentPending,
    paymentPaid,
    paymentFailed,
  ];

  // ==============================
  // ✅ APP COLORS
  // ==============================
  static const Color primaryColor = Colors.blue;
  static const Color secondaryColor = Colors.orange;
  static const Color successColor = Colors.green;
  static const Color dangerColor = Colors.red;
  static const Color warningColor = Colors.orange; // ✅ optional but useful

  // ==============================
  // ✅ CURRENCY
  // ==============================
  static const String currencySymbol = '৳';

  // ==============================
  // ✅ FIRESTORE COLLECTION NAMES
  // ==============================
  static const String productsCollection = 'products';
  static const String ordersCollection = 'orders';
  static const String usersCollection = 'users';

  // ==============================
  // ✅ DUMMY IMAGE
  // ==============================
  static const String dummyProductImage =
      'https://via.placeholder.com/300x300.png?text=No+Image';

  // ==============================
  // ✅ APP TEXT
  // ==============================
  static const String appName = 'Smart Shop';

  // ==============================
  // ✅ VALIDATION MESSAGES
  // ==============================
  static const String emptyFieldError = 'This field cannot be empty';
  static const String invalidPhoneError = 'Enter a valid phone number';
  static const String invalidEmailError = 'Enter a valid email address';
}
