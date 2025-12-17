import 'package:e_commerce_mini_shopping_cart/widgets/info_row.dart';
import 'package:e_commerce_mini_shopping_cart/widgets/status_chip.dart';
import 'package:flutter/material.dart';


class OrderDetailsDialog extends StatelessWidget {
  final dynamic order; // তোমার OrderModel type চাইলে OrderModel লিখো

  const OrderDetailsDialog({required this.order});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Header: Title + Status chip
            Row(
              children: [
                const Expanded(
                  child: Text(
                    "Order Details",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                ),
                StatusChip(status: order.status),
              ],
            ),

            const SizedBox(height: 12),
            Divider(color: Colors.grey.shade300),

            // ✅ Customer Info Section
            const Text(
              "Customer Info",
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),

            InfoRow(label: "Name", value: order.customerName),
            InfoRow(label: "Phone", value: order.customerPhone),
            InfoRow(label: "Address", value: order.customerAddress),

            const SizedBox(height: 12),
            Divider(color: Colors.grey.shade300),

            // ✅ Order Summary Section
            const Text(
              "Order Summary",
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),

            InfoRow(label: "Order ID", value: order.orderId),
            InfoRow(label: "Date", value: order.formattedDate),
            InfoRow(label: "Total", value: "৳ ${order.total.toStringAsFixed(2)}"),

            const SizedBox(height: 12),
            Divider(color: Colors.grey.shade300),

            // ✅ Items List Section
            const Text(
              "Items",
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),

            SizedBox(
              height: 180,
              child: ListView.separated(
                itemCount: order.items.length,
                separatorBuilder: (_, __) => Divider(color: Colors.grey.shade200),
                itemBuilder: (context, i) {
                  final it = order.items[i];
                  final name = (it['name'] ?? '').toString();
                  final qty = (it['quantity'] ?? 1).toString();
                  final price = (it['price'] ?? 0).toString();

                  return Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      Text("x$qty", style: TextStyle(color: Colors.grey.shade700)),
                      const SizedBox(width: 12),
                      Text("৳ $price", style: const TextStyle(fontWeight: FontWeight.w800)),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 14),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
