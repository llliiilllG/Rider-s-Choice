import 'package:dio/dio.dart';
import '../../domain/entities/bike.dart';
import '../../data/bike_data.dart';

class BikeApiService {
  final Dio _dio;
  final String baseUrl;

  BikeApiService({Dio? dio, this.baseUrl = 'http://localhost:3000/api'}) : _dio = dio ?? Dio();

  Future<List<Bike>> getAllBikes() async {
    try {
      final response = await _dio.get('$baseUrl/bikes');
      final data = response.data as List;
      return data.map((json) => Bike.fromJson(json)).toList();
    } catch (e) {
      // Fallback to local data if API is not available
      print('API Error: $e, falling back to local data');
      return BikeData.getAllBikes();
    }
  }

  Future<List<Bike>> getFeaturedBikes() async {
    try {
      final response = await _dio.get('$baseUrl/bikes/featured');
      final data = response.data as List;
      return data.map((json) => Bike.fromJson(json)).toList();
    } catch (e) {
      // Fallback to local data if API is not available
      print('API Error: $e, falling back to local data');
      return BikeData.getFeaturedBikes();
    }
  }

  Future<Bike?> getBikeById(String id) async {
    try {
      final response = await _dio.get('$baseUrl/bikes/$id');
      return Bike.fromJson(response.data);
    } catch (e) {
      // Fallback to local data if API is not available
      print('API Error: $e, falling back to local data');
      return BikeData.getBikeById(id);
    }
  }

  Future<List<Bike>> getBikesByCategory(String category) async {
    try {
      final response = await _dio.get('$baseUrl/bikes', queryParameters: {'category': category});
      final data = response.data as List;
      return data.map((json) => Bike.fromJson(json)).toList();
    } catch (e) {
      // Fallback to local data if API is not available
      print('API Error: $e, falling back to local data');
      return BikeData.getBikesByCategory(category);
    }
  }
} 