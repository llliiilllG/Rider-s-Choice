import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/bike_api_service.dart';
import '../../../../core/services/order_api_service.dart';
import '../../../../core/theme/app_theme.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> cartItems = [];
  bool _isLoading = true;
  String? _errorMessage;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _initCart();
  }

  Future<void> _initCart() async {
    await _getUserId();
    await _loadCart();
  }

  Future<void> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    print('DEBUG: Cart page - Retrieved userId: $userId');
    setState(() {
      _userId = userId;
    });
  }

  Future<void> _loadCart() async {
    if (_userId == null || _userId!.isEmpty) {
      setState(() {
        _errorMessage = 'User not logged in. Please login again.';
        _isLoading = false;
      });
      return;
    }

    try {
      final api = BikeApiService();
      final cartData = await api.getCart(_userId!);
      setState(() {
        cartItems = cartData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load cart: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _increaseQuantity(int index) async {
    if (_userId == null) return;
    
    try {
      final api = BikeApiService();
      await api.addToCart(_userId!, cartItems[index]['productId'], cartItems[index]['quantity'] + 1);
      await _loadCart(); // Reload cart data
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update quantity: $e')),
      );
    }
  }

  Future<void> _decreaseQuantity(int index) async {
    if (_userId == null || cartItems[index]['quantity'] <= 1) return;
    
    try {
      final api = BikeApiService();
      await api.addToCart(_userId!, cartItems[index]['productId'], cartItems[index]['quantity'] - 1);
      await _loadCart(); // Reload cart data
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update quantity: $e')),
      );
    }
  }

  Future<void> _removeItem(int index) async {
    if (_userId == null) return;
    
    try {
      final api = BikeApiService();
      await api.removeFromCart(_userId!, cartItems[index]['productId']);
      await _loadCart(); // Reload cart data
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove item: $e')),
      );
    }
  }

  double get totalPrice => cartItems.fold(0, (sum, item) => sum + (item['price'] ?? 0.0) * (item['quantity'] ?? 1));

  Future<void> _checkout() async {
    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to checkout')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Payment Option'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('Khalti'),
              onTap: () {
                Navigator.pop(context);
                _showKhaltiDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.money),
              title: const Text('Cash on Delivery'),
              onTap: () {
                Navigator.pop(context);
                _showCODConfirmation();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showKhaltiDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Khalti Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('To complete your payment, visit the following URL:'),
            SizedBox(height: 8),
            SelectableText('https://khalti.com/pay/placeholder', style: TextStyle(color: Colors.blue)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _showCODConfirmation() async {
    if (_userId == null) return;

    try {
      final api = OrderApiService();
      await api.createOrderFromCart(_userId!, cartItems, totalPrice);
      
      // Clear cart after successful order
      final bikeApi = BikeApiService();
      await bikeApi.clearCart(_userId!);
      
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/orders');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order placed successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to place order: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
        ),
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
                            onPressed: () async {
                              await _getUserId();
                              await _loadCart();
                            },
                            child: const Text('Retry'),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () async {
                              // Test: Manually set the user ID
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setString('userId', '6884f2db87e974d50868f9fe');
                              print('DEBUG: Manually set userId for testing');
                              await _getUserId();
                              await _loadCart();
                            },
                            child: const Text('Test: Set User ID'),
                          ),
                        ],
                      ),
                    )
              : cartItems.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('Your cart is empty', style: TextStyle(fontSize: 18, color: Colors.grey)),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: cartItems.length,
                            itemBuilder: (context, index) {
                              final item = cartItems[index];
                              return Card(
                                margin: const EdgeInsets.all(8),
                                child: ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      item['imageUrl'] ?? 'assets/logo/profile_placeholder.jpg',
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/logo/profile_placeholder.jpg',
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                                  ),
                                  title: Text(item['name'] ?? 'Unknown Product'),
                                  subtitle: Text('\$${(item['price'] ?? 0.0).toStringAsFixed(2)}'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () => _decreaseQuantity(index),
                                        icon: const Icon(Icons.remove),
                                      ),
                                      Text('${item['quantity'] ?? 1}'),
                                      IconButton(
                                        onPressed: () => _increaseQuantity(index),
                                        icon: const Icon(Icons.add),
                                      ),
                                      IconButton(
                                        onPressed: () => _removeItem(index),
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, -2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total:',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '\$${totalPrice.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: primaryGreen,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _checkout,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryGreen,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Proceed to Checkout',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
    );
  }
} 