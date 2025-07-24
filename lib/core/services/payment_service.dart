import 'dart:async';
import 'dart:convert';
import 'package:injectable/injectable.dart';
import '../network/api_client.dart';
import '../storage/local_storage.dart';

@injectable
class PaymentService {
  final ApiClient _apiClient;
  final LocalStorage _localStorage;

  PaymentService(this._apiClient, this._localStorage);

  // Create payment intent for a purchase
  Future<PaymentIntent> createPaymentIntent({
    required double amount,
    required String currency,
    required String bikeId,
    required int quantity,
  }) async {
    try {
      final response = await _apiClient.post('/payments/create-intent', {
        'amount': (amount * 100).round(), // Convert to cents
        'currency': currency,
        'bikeId': bikeId,
        'quantity': quantity,
        'metadata': {
          'bikeId': bikeId,
          'quantity': quantity.toString(),
        },
      });

      return PaymentIntent.fromJson(response);
    } catch (e) {
      throw PaymentException('Failed to create payment intent: ${e.toString()}');
    }
  }

  // Confirm payment with payment method
  Future<PaymentResult> confirmPayment({
    required String paymentIntentId,
    required String paymentMethodId,
  }) async {
    try {
      final response = await _apiClient.post('/payments/confirm', {
        'paymentIntentId': paymentIntentId,
        'paymentMethodId': paymentMethodId,
      });

      return PaymentResult.fromJson(response);
    } catch (e) {
      throw PaymentException('Failed to confirm payment: ${e.toString()}');
    }
  }

  // Create a subscription
  Future<Subscription> createSubscription({
    required String priceId,
    required String customerId,
    String? paymentMethodId,
  }) async {
    try {
      final response = await _apiClient.post('/payments/create-subscription', {
        'priceId': priceId,
        'customerId': customerId,
        'paymentMethodId': paymentMethodId,
      });

      return Subscription.fromJson(response);
    } catch (e) {
      throw PaymentException('Failed to create subscription: ${e.toString()}');
    }
  }

  // Cancel a subscription
  Future<void> cancelSubscription(String subscriptionId) async {
    try {
      await _apiClient.post('/payments/cancel-subscription', {
        'subscriptionId': subscriptionId,
      });
    } catch (e) {
      throw PaymentException('Failed to cancel subscription: ${e.toString()}');
    }
  }

  // Get customer's payment methods
  Future<List<PaymentMethod>> getPaymentMethods(String customerId) async {
    try {
      final response = await _apiClient.get('/payments/payment-methods/$customerId');
      final List<dynamic> methods = response['paymentMethods'] ?? [];
      return methods.map((method) => PaymentMethod.fromJson(method)).toList();
    } catch (e) {
      throw PaymentException('Failed to get payment methods: ${e.toString()}');
    }
  }

  // Add a new payment method
  Future<PaymentMethod> addPaymentMethod({
    required String customerId,
    required String paymentMethodId,
  }) async {
    try {
      final response = await _apiClient.post('/payments/add-payment-method', {
        'customerId': customerId,
        'paymentMethodId': paymentMethodId,
      });

      return PaymentMethod.fromJson(response);
    } catch (e) {
      throw PaymentException('Failed to add payment method: ${e.toString()}');
    }
  }

  // Remove a payment method
  Future<void> removePaymentMethod(String paymentMethodId) async {
    try {
      await _apiClient.delete('/payments/payment-methods/$paymentMethodId');
    } catch (e) {
      throw PaymentException('Failed to remove payment method: ${e.toString()}');
    }
  }

  // Get customer's subscriptions
  Future<List<Subscription>> getSubscriptions(String customerId) async {
    try {
      final response = await _apiClient.get('/payments/subscriptions/$customerId');
      final List<dynamic> subscriptions = response['subscriptions'] ?? [];
      return subscriptions.map((sub) => Subscription.fromJson(sub)).toList();
    } catch (e) {
      throw PaymentException('Failed to get subscriptions: ${e.toString()}');
    }
  }

  // Get payment history
  Future<List<PaymentHistory>> getPaymentHistory(String customerId) async {
    try {
      final response = await _apiClient.get('/payments/history/$customerId');
      final List<dynamic> history = response['payments'] ?? [];
      return history.map((payment) => PaymentHistory.fromJson(payment)).toList();
    } catch (e) {
      throw PaymentException('Failed to get payment history: ${e.toString()}');
    }
  }

  // Save payment method to local storage
  Future<void> saveDefaultPaymentMethod(String paymentMethodId) async {
    await _localStorage.setString('default_payment_method', paymentMethodId);
  }

  // Get default payment method from local storage
  Future<String?> getDefaultPaymentMethod() async {
    return await _localStorage.getString('default_payment_method');
  }

  // Clear default payment method
  Future<void> clearDefaultPaymentMethod() async {
    await _localStorage.removeString('default_payment_method');
  }
}

// Payment models
class PaymentIntent {
  final String id;
  final int amount;
  final String currency;
  final String status;
  final String clientSecret;
  final Map<String, dynamic> metadata;

  PaymentIntent({
    required this.id,
    required this.amount,
    required this.currency,
    required this.status,
    required this.clientSecret,
    required this.metadata,
  });

  factory PaymentIntent.fromJson(Map<String, dynamic> json) {
    return PaymentIntent(
      id: json['id'] ?? '',
      amount: json['amount'] ?? 0,
      currency: json['currency'] ?? 'usd',
      status: json['status'] ?? '',
      clientSecret: json['client_secret'] ?? '',
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }
}

class PaymentResult {
  final String id;
  final String status;
  final String? errorMessage;
  final DateTime createdAt;

  PaymentResult({
    required this.id,
    required this.status,
    this.errorMessage,
    required this.createdAt,
  });

  factory PaymentResult.fromJson(Map<String, dynamic> json) {
    return PaymentResult(
      id: json['id'] ?? '',
      status: json['status'] ?? '',
      errorMessage: json['error_message'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  bool get isSuccessful => status == 'succeeded';
}

class PaymentMethod {
  final String id;
  final String type;
  final String last4;
  final String brand;
  final int expMonth;
  final int expYear;
  final bool isDefault;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.last4,
    required this.brand,
    required this.expMonth,
    required this.expYear,
    this.isDefault = false,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      last4: json['card']?['last4'] ?? '',
      brand: json['card']?['brand'] ?? '',
      expMonth: json['card']?['exp_month'] ?? 0,
      expYear: json['card']?['exp_year'] ?? 0,
      isDefault: json['is_default'] ?? false,
    );
  }
}

class Subscription {
  final String id;
  final String status;
  final String priceId;
  final DateTime currentPeriodStart;
  final DateTime currentPeriodEnd;
  final bool cancelAtPeriodEnd;

  Subscription({
    required this.id,
    required this.status,
    required this.priceId,
    required this.currentPeriodStart,
    required this.currentPeriodEnd,
    this.cancelAtPeriodEnd = false,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'] ?? '',
      status: json['status'] ?? '',
      priceId: json['items']?['data']?[0]?['price']?['id'] ?? '',
      currentPeriodStart: DateTime.parse(json['current_period_start'] ?? DateTime.now().toIso8601String()),
      currentPeriodEnd: DateTime.parse(json['current_period_end'] ?? DateTime.now().toIso8601String()),
      cancelAtPeriodEnd: json['cancel_at_period_end'] ?? false,
    );
  }

  bool get isActive => status == 'active';
}

class PaymentHistory {
  final String id;
  final int amount;
  final String currency;
  final String status;
  final String description;
  final DateTime createdAt;

  PaymentHistory({
    required this.id,
    required this.amount,
    required this.currency,
    required this.status,
    required this.description,
    required this.createdAt,
  });

  factory PaymentHistory.fromJson(Map<String, dynamic> json) {
    return PaymentHistory(
      id: json['id'] ?? '',
      amount: json['amount'] ?? 0,
      currency: json['currency'] ?? 'usd',
      status: json['status'] ?? '',
      description: json['description'] ?? '',
      createdAt: DateTime.parse(json['created'] ?? DateTime.now().toIso8601String()),
    );
  }
}

// Custom exception for payment errors
class PaymentException implements Exception {
  final String message;
  PaymentException(this.message);

  @override
  String toString() => message;
} 