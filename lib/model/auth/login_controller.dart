// lib/modules/auth/login_controller.dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/auth_api_service.dart';

class LoginController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }

  bool validateInputs(BuildContext context) {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      showMessage(context, 'Please fill in all fields');
      return false;
    }
    return true;
  }

  Future<void> login(BuildContext context) async {
    if (validateInputs(context)) {
      final email = emailController.text.trim();
      final password = passwordController.text;
      final authApi = GetIt.instance<AuthApiService>();
      try {
        final result = await authApi.login(email, password);
        final token = result['token'];
        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt_token', token);
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          showMessage(context, result['message'] ?? 'Login failed. Please check your credentials.');
        }
      } catch (e) {
        String errorMsg = 'Login failed. Please try again.';
        if (e is Exception && e.toString().contains('SocketException')) {
          errorMsg = 'Network error. Please check your connection.';
        }
        showMessage(context, errorMsg);
      }
    }
  }

  void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}