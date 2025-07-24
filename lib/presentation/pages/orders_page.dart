import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../core/services/order_api_service.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orderApi = GetIt.instance<OrderApiService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: orderApi.getOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load orders'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No orders found'));
          }
          final orders = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: isDark ? const Color(0xFF23242B) : Colors.white,
                margin: const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Order #${order['orderNumber'] ?? order['id']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('Status: ${order['status'] ?? 'N/A'}', style: const TextStyle(fontSize: 14, color: Colors.blue)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Date: ${order['date'] ?? ''}', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                      const SizedBox(height: 8),
                      if (order['items'] != null && order['items'] is List)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
                            ...List.generate((order['items'] as List).length, (i) {
                              final item = order['items'][i];
                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                                leading: item['imageUrl'] != null && item['imageUrl'].toString().isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          item['imageUrl'],
                                          width: 48,
                                          height: 48,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Container(
                                            width: 48,
                                            height: 48,
                                            color: Colors.grey[200],
                                            child: const Icon(Icons.image, size: 24),
                                          ),
                                        ),
                                      )
                                    : const Icon(Icons.image, size: 24),
                                title: Text(item['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.w500)),
                                subtitle: Text('Price: 24${item['price']?.toStringAsFixed(2) ?? '0.00'}'),
                                trailing: Text('x${item['quantity']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              );
                            }),
                          ],
                        ),
                      const SizedBox(height: 8),
                      Text('Total: 24${order['total']?.toStringAsFixed(2) ?? '0.00'}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      backgroundColor: isDark ? const Color(0xFF181A20) : Colors.white,
    );
  }
} 