import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

enum AuthState { initial, loading, authenticated, unauthenticated, error }

class AuthViewModel extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;

  AuthViewModel(this._loginUseCase, this._registerUseCase);

  AuthState _state = AuthState.initial;
  User? _user;
  String? _errorMessage;
  bool _isLoading = false;

  // Getters
  AuthState get state => _state;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _state == AuthState.authenticated;

  // Login method
  Future<void> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final user = await _loginUseCase(email, password);
      _user = user;
      _state = AuthState.authenticated;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Register method
  Future<void> register(String name, String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final user = await _registerUseCase(name, email, password);
      _user = user;
      _state = AuthState.authenticated;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Logout method
  void logout() {
    _user = null;
    _state = AuthState.unauthenticated;
    _clearError();
    notifyListeners();
  }

  // Set user (for app initialization)
  void setUser(User user) {
    _user = user;
    _state = AuthState.authenticated;
    notifyListeners();
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    if (loading) {
      _state = AuthState.loading;
    }
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    _state = AuthState.error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
} 