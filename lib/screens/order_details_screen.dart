import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/order.dart';
import '../providers/orders_provider.dart';
import '../utils/constants.dart';
import '../widgets/info_row.dart';
import '../widgets/status_chip.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderModel order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late String selectedStatus;
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.order.status;
  }

  Future<void> _updateStatus(String newStatus) async {
    if (newStatus == selectedStatus) return;

    setState(() {
      isUpdating = true;
      selectedStatus = newStatus;
    });

    try {
      await context.read<OrdersProvider>().updateOrderStatus(
            orderId: widget.order.orderId,
            newStatus: newStatus,
          );
    } catch (e) {
      setState(() {
        selectedStatus = widget.order.status;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update status")),
      );
    } finally {
      if (mounted) setState(() => isUpdating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ✅ CUSTOMER + STATUS
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.customerName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),

                  StatusChip(status: selectedStatus),

                  const SizedBox(height: 12),
                  InfoRow(label: "Phone", value: order.customerPhone),
                  InfoRow(label: "Address", value: order.customerAddress),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // ✅ STATUS UPDATE
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Update Status",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  DropdownButtonFormField<String>(
                    initialValue: selectedStatus,
                    decoration: const InputDecoration(
                      labelText: "Order Status",
                    ),
                    items: AppConstants.orderStatusList
                        .where((s) => s != AppConstants.statusAll)
                        .map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: isUpdating
                        ? null
                        : (value) {
                            if (value != null) {
                              _updateStatus(value);
                            }
                          },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // ✅ ORDER SUMMARY
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Order Summary",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  InfoRow(label: "Order ID", value: order.orderId),
                  InfoRow(label: "Date", value: order.formattedDate),
                  InfoRow(
                    label: "Total",
                    value: "৳ ${order.total.toStringAsFixed(2)}",
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // ✅ ITEMS
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Items",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  ...order.items.map((it) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              it['name'] ?? '',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Text("x${it['quantity']}"),
                          const SizedBox(width: 10),
                          Text("৳ ${it['price']}"),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
