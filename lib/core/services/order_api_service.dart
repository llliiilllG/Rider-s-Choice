import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderApiService {
  final Dio _dio;
  final String baseUrl = 'http://localhost:5050/api';

  OrderApiService({Dio? dio}) : _dio = dio ?? Dio();

  Future<List<Map<String, dynamic>>> getOrders() async {
    final token = await _getToken();
    final response = await _dio.get('$baseUrl/orders', options: Options(headers: {'Authorization': 'Bearer $token'}));
    final data = response.data as List;
    return data.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>?> getOrderById(String id) async {
    final token = await _getToken();
    try {
      final response = await _dio.get('$baseUrl/orders/$id', options: Options(headers: {'Authorization': 'Bearer $token'}));
      return response.data as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> orderData) async {
    final token = await _getToken();
    final response = await _dio.post('$baseUrl/orders', data: orderData, options: Options(headers: {'Authorization': 'Bearer $token'}));
    return response.data as Map<String, dynamic>;
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }
} 