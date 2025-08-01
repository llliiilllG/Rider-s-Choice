import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderApiService {
  final Dio _dio;
  final String baseUrl = 'http://localhost:3000/api/v1';

  OrderApiService({Dio? dio}) : _dio = dio ?? Dio();

  Future<List<Map<String, dynamic>>> getOrders() async {
    final token = await _getToken();
    final response = await _dio.get('$baseUrl/bookings', options: Options(headers: {'Authorization': 'Bearer $token'}));
    final data = response.data as List;
    return data.cast<Map<String, dynamic>>();
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
    await _dio.post('$baseUrl/bookings', data: {
      'customerId': userId,
      'packageId': bike.id,
      'packageName': bike.name,
      'quantity': quantity,
      'totalAmount': bike.price * quantity,
      'status': 'pending',
      'bookingDate': DateTime.now().toIso8601String(),
    });
  }

  Future<void> createOrderFromCart(String userId, List<Map<String, dynamic>> cartItems, double totalPrice) async {
    // Since cart is not implemented yet, this will create individual bookings
    for (final item in cartItems) {
      await _dio.post('$baseUrl/bookings', data: {
        'customerId': userId,
        'packageId': item['productId'],
        'packageName': item['name'],
        'quantity': item['quantity'],
        'totalAmount': item['price'] * item['quantity'],
        'status': 'pending',
        'bookingDate': DateTime.now().toIso8601String(),
      });
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }
} 