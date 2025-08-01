import 'package:dio/dio.dart';
import '../../features/bikes/domain/entities/bike.dart';

class BikeApiService {
  final Dio _dio;
  final String baseUrl;

  BikeApiService({Dio? dio, this.baseUrl = 'http://localhost:3000/api/v1'}) : _dio = dio ?? Dio();

  Future<List<Bike>> getAllBikes() async {
    final response = await _dio.get('$baseUrl/package');
    final data = response.data as List;
    return data.map((json) => Bike.fromJson(json)).toList();
  }

  Future<List<Bike>> getFeaturedBikes() async {
    // If you have a featured endpoint, use it. Otherwise, filter featured bikes from all bikes.
    final bikes = await getAllBikes();
    return bikes.where((bike) => bike.isFeatured).toList();
  }

  Future<Bike?> getBikeById(String id) async {
    final response = await _dio.get('$baseUrl/package/$id');
    return Bike.fromJson(response.data);
  }

  Future<List<Bike>> getBikesByCategory(String category) async {
    final response = await _dio.get('$baseUrl/package', queryParameters: {'category': category});
    final data = response.data as List;
    return data.map((json) => Bike.fromJson(json)).toList();
  }

  Future<List<Bike>> getRecentlyAddedBikes() async {
    final response = await _dio.get('$baseUrl/package');
    final data = response.data as List;
    // Sort by createdAt to get recently added bikes
    data.sort((a, b) => DateTime.parse(b['createdAt']).compareTo(DateTime.parse(a['createdAt'])));
    return data.take(5).map((json) => Bike.fromJson(json)).toList();
  }

  // TODO: Implement cart functionality when backend supports it
  Future<void> addToCart(String userId, String productId, int quantity) async {
    // Cart functionality not yet implemented in new backend
    throw UnimplementedError('Cart functionality not yet available');
  }

  Future<List<Map<String, dynamic>>> getCart(String userId) async {
    // Cart functionality not yet implemented in new backend
    return [];
  }

  Future<void> removeFromCart(String userId, String productId) async {
    // Cart functionality not yet implemented in new backend
    throw UnimplementedError('Cart functionality not yet available');
  }

  Future<void> clearCart(String userId) async {
    // Cart functionality not yet implemented in new backend
    throw UnimplementedError('Cart functionality not yet available');
  }
} 