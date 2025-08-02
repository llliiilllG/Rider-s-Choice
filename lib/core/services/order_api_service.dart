import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderApiService {
  final Dio _dio;
  final String baseUrl = 'http://localhost:3000/api/v1';

  OrderApiService({Dio? dio}) : _dio = dio ?? Dio();

  Future<List<Map<String, dynamic>>> getOrders() async {
    try {
      final userId = await _getUserId();
      print('Fetching orders for user ID: $userId');
      
      if (userId.isEmpty) {
        print('User ID is empty, returning empty list');
        return [];
      }
      
      final response = await _dio.get('$baseUrl/bookings/user/$userId');
      final data = response.data as List;
      print('Found ${data.length} orders for user $userId');
      return data.cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error fetching orders: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getOrderById(String id) async {
    final token = await _getToken();
    try {
      final response = await _dio.get('$baseUrl/bookings/$id', options: Options(headers: {'Authorization': 'Bearer $token'}));
      return response.data as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> orderData) async {
    final token = await _getToken();
    final response = await _dio.post('$baseUrl/bookings', data: orderData, options: Options(headers: {'Authorization': 'Bearer $token'}));
    return response.data as Map<String, dynamic>;
  }

  Future<void> createOrderForBike(String userId, dynamic bike, int quantity) async {
    try {
      final userId = await _getUserId();
      print('Creating order for user ID: $userId, bike: ${bike.name}');
      
      await _dio.post('$baseUrl/bookings/bike', data: {
        'userId': userId,
        'packageId': bike.id,
        'packageName': bike.name,
        'quantity': quantity,
        'totalAmount': bike.price * quantity,
        'fullName': 'Demo User', // TODO: Get from user profile
        'email': 'demo@example.com', // TODO: Get from user profile
        'phone': '+1234567890', // TODO: Get from user profile
        'paymentMethod': 'credit-card', // TODO: Get from payment selection
        'status': 'pending',
      });
      
      print('Order created successfully for user $userId');
    } catch (e) {
      print('Error creating order: $e');
      throw e;
    }
  }

  Future<void> createOrderFromCart(String userId, List<Map<String, dynamic>> cartItems, double totalPrice) async {
    try {
      final userId = await _getUserId();
      // Create individual bookings for each cart item
      for (final item in cartItems) {
        await _dio.post('$baseUrl/bookings/bike', data: {
          'userId': userId,
          'packageId': item['bikeId'],
          'packageName': item['bikeName'],
          'quantity': item['quantity'],
          'totalAmount': item['price'] * item['quantity'],
          'fullName': 'Demo User', // TODO: Get from user profile
          'email': 'demo@example.com', // TODO: Get from user profile
          'phone': '+1234567890', // TODO: Get from user profile
          'paymentMethod': 'credit-card', // TODO: Get from payment selection
          'status': 'pending',
        });
      }
    } catch (e) {
      print('Error creating orders from cart: $e');
      throw e;
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<String> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? '';
    
    // If no user is logged in, use a consistent demo user ID for testing
    if (userId.isEmpty) {
      userId = 'demo_user_12345'; // Use a consistent ID
      await prefs.setString('userId', userId);
    }
    
    return userId;
  }

  // Cancel order
  Future<bool> cancelOrder(String orderId) async {
    try {
      await _dio.put('$baseUrl/bookings/$orderId/cancel');
      return true;
    } catch (e) {
      print('Error cancelling order: $e');
      return false;
    }
  }
} 