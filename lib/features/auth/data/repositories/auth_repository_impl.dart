import 'package:injectable/injectable.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/local_storage.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;
  final LocalStorage _localStorage;

  AuthRepositoryImpl(this._apiClient, this._localStorage);

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await _apiClient.post('/auth/login', {
        'email': email,
        'password': password,
      });

      final user = User.fromJson(response['user']);
      final token = response['token'];

      await _localStorage.setString('token', token);
      await _localStorage.setString('user', response['user'].toString());
      await _localStorage.setString('userId', user.id); // Save user ID specifically

      return user;
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<User> register(String name, String email, String password) async {
    try {
      final response = await _apiClient.post('/auth/register', {
        'name': name,
        'email': email,
        'password': password,
      });

      final user = User.fromJson(response['user']);
      final token = response['token'];

      await _localStorage.setString('token', token);
      await _localStorage.setString('user', response['user'].toString());
      await _localStorage.setString('userId', user.id); // Save user ID specifically

      return user;
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<User> getCurrentUser() async {
    try {
      final token = await _localStorage.getString('token');
      if (token == null) {
        throw Exception('No token found');
      }

      final response = await _apiClient.get('/auth/me');
      return User.fromJson(response['user']);
    } catch (e) {
      throw Exception('Failed to get current user: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _apiClient.post('/auth/logout', {});
    } catch (e) {
      // Continue with logout even if API call fails
    } finally {
      await _localStorage.removeString('token');
      await _localStorage.removeString('user');
      await _localStorage.removeString('userId');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await _localStorage.getString('token');
    return token != null;
  }

  @override
  Future<void> saveToken(String token) async {
    await _localStorage.setString('token', token);
  }

  @override
  Future<String?> getToken() async {
    return await _localStorage.getString('token');
  }

  @override
  Future<void> clearToken() async {
    await _localStorage.removeString('token');
  }
} 