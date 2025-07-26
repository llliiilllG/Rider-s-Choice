import 'package:dio/dio.dart';

class AuthApiService {
  final Dio _dio;
  // final String baseUrl = 'http://localhost:5050/api';
  final String baseUrl = 'http://127.0.0.1:5050/api';

  AuthApiService({Dio? dio}) : _dio = dio ?? Dio();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post('$baseUrl/auth/login', data: {
        'email': email,
        'password': password,
      });
      return response.data as Map<String, dynamic>;
    } catch (e) {
      // Fallback for demo purposes when backend is not available
      print('API Error: $e, using fallback login');
      
      // Demo login - accept any email/password combination
      if (email.isNotEmpty && password.isNotEmpty) {
        return {
          'success': true,
          'token': 'demo_token_${DateTime.now().millisecondsSinceEpoch}',
          'user': {
            'id': '1',
            'email': email,
            'name': 'Demo User',
          },
          'message': 'Login successful (demo mode)'
        };
      } else {
        return {
          'success': false,
          'message': 'Please enter email and password'
        };
      }
    }
  }

  Future<Map<String, dynamic>> signup(String email, String password) async {
    try {
      final response = await _dio.post('$baseUrl/auth/signup', data: {
        'email': email,
        'password': password,
      });
      return response.data as Map<String, dynamic>;
    } catch (e) {
      // Fallback for demo purposes when backend is not available
      print('API Error: $e, using fallback signup');
      
      // Demo signup - always succeed
      return {
        'success': true,
        'message': 'Account created successfully (demo mode)',
        'user': {
          'id': '1',
          'email': email,
          'name': 'Demo User',
        }
      };
    }
  }
} 