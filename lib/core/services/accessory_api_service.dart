import 'package:dio/dio.dart';

class AccessoryApiService {
  final Dio _dio;
  final String baseUrl = 'http://localhost:5050/api';

  AccessoryApiService({Dio? dio}) : _dio = dio ?? Dio();

  Future<List<Map<String, dynamic>>> getAllAccessories() async {
    final response = await _dio.get('$baseUrl/accessories');
    final data = response.data as List;
    return data.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>?> getAccessoryById(String id) async {
    try {
      final response = await _dio.get('$baseUrl/accessories/$id');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }
} 