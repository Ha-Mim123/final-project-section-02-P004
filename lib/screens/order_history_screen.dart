import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/orders_provider.dart';
import '../utils/constants.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  String selectedStatus = AppConstants.statusAll;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrdersProvider>().loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrdersProvider>();

    final allOrders = provider.orders;

    final filteredOrders = (selectedStatus == AppConstants.statusAll)
        ? allOrders
        : allOrders.where((o) => o.status == selectedStatus).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: DropdownButtonFormField<String>(
              initialValue: selectedStatus,
              decoration: const InputDecoration(labelText: 'Filter by status'),
              items: AppConstants.orderStatusList.map((e) {
                return DropdownMenuItem<String>(value: e, child: Text(e));
              }).toList(),
              onChanged: (value) {
                if (value == null) {
                  print(value);
                  return;
                }

                setState(() => selectedStatus = value);
              },
            ),
          ),

          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : allOrders.isEmpty
                ? const Center(child: Text('No Orders Found'))
                : filteredOrders.isEmpty
                ? Center(child: Text('No "$selectedStatus" orders found'))
                : RefreshIndicator(
                    onRefresh: () async {
                      await provider.loadOrders();
                    },
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: filteredOrders.length,
                      itemBuilder: (context, index) {
                        final order = filteredOrders[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () {
                              
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => OrderDetailsScreen(
                                    order: order,
                                  ),
                                ),
                              );
                                
                              
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // ✅ Top Row: Name + Status Chip
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          order.customerName.isNotEmpty
                                              ? order.customerName
                                              : "Customer",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      StatusChip(status: order.status),
                                    ],
                                  ),

                                  const SizedBox(height: 10),

                                  // ✅ Order ID
                                  Text(
                                    "Order ID: ${order.orderId.isNotEmpty ? order.orderId : "-"}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 12,
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  // ✅ Bottom Row: Total + Date + Arrow
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.payments_outlined,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        "৳ ${order.total.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const Spacer(),
                                      const Icon(
                                        Icons.calendar_month_outlined,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        order.formattedDate,
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                        color: Colors.black45,
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 8),

                                  // ✅ Items count (optional)
                                  Text(
                                    "Items: ${order.items.length}",
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
