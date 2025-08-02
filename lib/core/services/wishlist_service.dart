import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistService {
  final Dio _dio;
  final String baseUrl = 'http://localhost:3000/api/v1';

  WishlistService({Dio? dio}) : _dio = dio ?? Dio();

  // Get user ID for wishlist operations
  Future<String> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? '';
    
    // If no user is logged in, use a consistent demo user ID for testing
    if (userId.isEmpty) {
      userId = 'demo_user_12345'; // Use the same ID as orders
      await prefs.setString('userId', userId);
    }
    
    return userId;
  }

  // Add bike to wishlist
  Future<bool> addToWishlist(String bikeId) async {
    try {
      final userId = await _getUserId();
      print('Adding bike $bikeId to wishlist for user $userId');
      
      final response = await _dio.post('$baseUrl/wishlist/add', data: {
        'customerId': userId,
        'packageId': bikeId,
      });
      
      print('Response: ${response.data}');
      print('Successfully added bike to wishlist');
      return true;
    } catch (e) {
      print('Error adding to wishlist: $e');
      if (e is DioException) {
        print('Dio error response: ${e.response?.data}');
        print('Dio error status: ${e.response?.statusCode}');
      }
      return false;
    }
  }

  // Remove bike from wishlist
  Future<bool> removeFromWishlist(String bikeId) async {
    try {
      final userId = await _getUserId();
      print('Removing bike $bikeId from wishlist for user $userId');
      
      await _dio.delete('$baseUrl/wishlist/remove/$bikeId');
      
      print('Successfully removed bike from wishlist');
      return true;
    } catch (e) {
      print('Error removing from wishlist: $e');
      return false;
    }
  }

  // Get user's wishlist
  Future<List<Map<String, dynamic>>> getWishlist() async {
    try {
      final userId = await _getUserId();
      print('Fetching wishlist for user $userId');
      
      final response = await _dio.get('$baseUrl/wishlist');
      final data = response.data;
      
      if (data['success'] && data['wishlist'] != null) {
        final packages = data['wishlist']['packages'] as List;
        print('Found ${packages.length} items in wishlist');
        return packages.cast<Map<String, dynamic>>();
      }
      
      return [];
    } catch (e) {
      print('Error fetching wishlist: $e');
      return [];
    }
  }

  // Get wishlist count
  Future<int> getWishlistCount() async {
    try {
      final userId = await _getUserId();
      final response = await _dio.get('$baseUrl/wishlist/count');
      final data = response.data;
      
      if (data['success']) {
        return data['count'] ?? 0;
      }
      
      return 0;
    } catch (e) {
      print('Error fetching wishlist count: $e');
      return 0;
    }
  }

  // Check if bike is in wishlist
  Future<bool> isInWishlist(String bikeId) async {
    try {
      final wishlist = await getWishlist();
      return wishlist.any((item) => item['_id'] == bikeId);
    } catch (e) {
      print('Error checking wishlist status: $e');
      return false;
    }
  }
} 