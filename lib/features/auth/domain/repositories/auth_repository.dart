import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(String name, String email, String password);
  Future<User> getCurrentUser();
  Future<void> logout();
  Future<bool> isLoggedIn();
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
} 