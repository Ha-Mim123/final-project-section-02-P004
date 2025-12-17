import 'package:e_commerce_mini_shopping_cart/utils/constants.dart';
import 'package:flutter/material.dart';


class StatusChip extends StatelessWidget {
  final String status;
  const StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case AppConstants.statusPlaced:
        color = Colors.orange;
        break;
      case AppConstants.statusProcessing:
        color = Colors.blue;
        break;
      case AppConstants.statusDelivered:
        color = Colors.green;
        break;
      case AppConstants.statusCancelled:
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
