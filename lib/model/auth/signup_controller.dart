// lib/modules/auth/signup_controller.dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../core/services/auth_api_service.dart';

class SignupController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  bool validateInputs(BuildContext context) {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      showMessage(context, 'Please fill in all fields');
      return false;
    }

    if (!email.contains('@')) {
      showMessage(context, 'Please enter a valid email');
      return false;
    }

    if (password.length < 6) {
      showMessage(context, 'Password must be at least 6 characters');
      return false;
    }

    if (password != confirmPassword) {
      showMessage(context, 'Passwords do not match');
      return false;
    }

    return true;
  }

  Future<void> signup(BuildContext context) async {
    if (validateInputs(context)) {
      final email = emailController.text.trim();
      final password = passwordController.text;
      final authApi = GetIt.instance<AuthApiService>();
      try {
        // Show loading indicator
        showMessage(context, 'Creating account...');
        final result = await authApi.signup(email, password);
        if (result['success'] == true) {
          // Clear the form
          emailController.clear();
          passwordController.clear();
          confirmPasswordController.clear();
          // Show success message
          showMessage(context, result['message'] ?? 'Account created successfully!');
          // Navigate to login page after a short delay
          await Future.delayed(const Duration(seconds: 1));
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, '/login');
          }
        } else {
          showMessage(context, result['message'] ?? 'Signup failed. Please try again.');
        }
      } catch (e) {
        String errorMsg = 'Signup failed. Please try again.';
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