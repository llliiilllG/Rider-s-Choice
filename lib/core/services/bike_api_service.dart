import 'package:dio/dio.dart';
import '../../features/bikes/domain/entities/bike.dart';

class BikeApiService {
  final Dio _dio;
  final String baseUrl;

  BikeApiService({Dio? dio, this.baseUrl = 'http://localhost:5050/api'}) : _dio = dio ?? Dio();

  Future<List<Bike>> getAllBikes() async {
    final response = await _dio.get('$baseUrl/products');
    final data = response.data['data'] as List;
    return data.map((json) => Bike.fromJson(json)).toList();
  }

  Future<List<Bike>> getFeaturedBikes() async {
    // If you have a featured endpoint, use it. Otherwise, filter featured bikes from all bikes.
    final bikes = await getAllBikes();
    return bikes.where((bike) => bike.isFeatured).toList();
  }

  Future<Bike?> getBikeById(String id) async {
    final response = await _dio.get('$baseUrl/products');
    final data = response.data['data'] as List;
    final bikeJson = data.firstWhere((json) => json['_id'] == id, orElse: () => null);
    if (bikeJson == null) return null;
    return Bike.fromJson(bikeJson);
  }

  Future<List<Bike>> getBikesByCategory(String category) async {
    final response = await _dio.get('$baseUrl/products', queryParameters: {'category': category});
    final data = response.data['data'] as List;
    return data.map((json) => Bike.fromJson(json)).toList();
  }

  Future<List<Bike>> getRecentlyAddedBikes() async {
    final response = await _dio.get('$baseUrl/products', queryParameters: {'recent': true});
    final data = response.data['data'] as List;
    return data.map((json) => Bike.fromJson(json)).toList();
  }

  Future<void> addToCart(String userId, String productId, int quantity) async {
    await _dio.post(
      '$baseUrl/cart/$userId/add',
      data: {
        'productId': productId,
        'quantity': quantity,
      },
    );
  }

  Future<List<Map<String, dynamic>>> getCart(String userId) async {
    final response = await _dio.get('$baseUrl/cart/$userId');
    final data = response.data;
    if (data == null || data['products'] == null) return [];
    
    final products = data['products'] as List;
    return products.map((product) {
      final productData = product['productId'] is Map ? product['productId'] : {};
      return {
        'productId': product['productId'] is String ? product['productId'] : productData['_id'] ?? '',
        'name': productData['model'] ?? productData['name'] ?? 'Unknown Product',
        'price': product['price'] ?? 0.0,
        'quantity': product['quantity'] ?? 1,
        'imageUrl': productData['productImage'] ?? '',
      };
    }).toList();
  }

  Future<void> removeFromCart(String userId, String productId) async {
    await _dio.post(
      '$baseUrl/cart/$userId/remove',
      data: {
        'productId': productId,
      },
    );
  }

  Future<void> clearCart(String userId) async {
    await _dio.post('$baseUrl/cart/$userId/clear');
  }
} 