import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/order_api_service.dart';
import '../../../../core/theme/app_theme.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<Map<String, dynamic>> orders = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh orders when the page becomes visible
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      final api = OrderApiService();
      final ordersData = await api.getOrders();
      setState(() {
        orders = ordersData;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load orders: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _cancelOrder(String orderId) async {
    try {
      final api = OrderApiService();
      final success = await api.cancelOrder(orderId);
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order cancelled successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        await _loadOrders(); // Refresh the orders list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to cancel order'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error cancelling order: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _createSampleOrder() async {
    try {
      final api = OrderApiService();
      // Create a sample bike for testing
      final sampleBike = {
        'id': 'sample_bike_1',
        'name': 'Sample Bike',
        'price': 250000.0,
      };
      
      await api.createOrderForBike('', sampleBike, 1);
      await _loadOrders(); // Refresh the orders list
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sample order created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create sample order: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _resetUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userId');
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User ID reset. New orders will be created with a fresh user ID.'),
          backgroundColor: Colors.orange,
        ),
      );
      
      await _loadOrders(); // Refresh to show empty state
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error resetting user ID: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadOrders,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : orders.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          const Text('No orders yet', style: TextStyle(fontSize: 18, color: Colors.grey)),
                          const SizedBox(height: 8),
                          const Text('Your orders will appear here', style: TextStyle(color: Colors.grey)),
                          const SizedBox(height: 24),
                          // Temporary buttons for testing - remove in production
                          ElevatedButton(
                            onPressed: _createSampleOrder,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Create Sample Order (Testing)'),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _resetUserId,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Reset User ID (Testing)'),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadOrders,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                        final order = orders[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Order #${order['_id']?.toString().substring(0, 8) ?? 'N/A'}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(order['status']),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        order['status']?.toString().toUpperCase() ?? 'PENDING',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Date: ${_formatDate(order['createdAt'])}',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 8),
                                // Display bike information
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${order['packageName']} x${order['quantity']}',
                                        style: const TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Text(
                                      '₹${(order['totalAmount'] ?? 0).toStringAsFixed(2)}',
                                      style: const TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                const Divider(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      '₹${(order['totalAmount'] ?? 0).toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: primaryGreen,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                // Cancel button (only for pending orders)
                                if (order['status']?.toString().toLowerCase() == 'pending')
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () => _cancelOrder(order['_id']),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text(
                                        'Cancel Order',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'N/A';
    try {
      final dateTime = DateTime.parse(date.toString());
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      return 'N/A';
    }
  }
} 