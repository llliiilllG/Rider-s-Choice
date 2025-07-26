import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:dio/dio.dart';

enum PaymentMethod { stripe, razorpay }

class PaymentResult {
  final bool success;
  final String? transactionId;
  final String? error;
  final Map<String, dynamic>? data;

  PaymentResult({
    required this.success,
    this.transactionId,
    this.error,
    this.data,
  });
}

class EnhancedPaymentService {
  static final EnhancedPaymentService _instance = EnhancedPaymentService._internal();
  factory EnhancedPaymentService() => _instance;
  EnhancedPaymentService._internal();

  final Dio _dio = Dio();
  late Razorpay _razorpay;
  
  // Initialize payment services
  Future<void> initialize({
    required String stripePublishableKey,
    required String razorpayKeyId,
  }) async {
    // Initialize Stripe
    Stripe.publishableKey = stripePublishableKey;
    await Stripe.instance.applySettings();
    
    // Initialize Razorpay
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleRazorpaySuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handleRazorpayError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleRazorpayWallet);
  }

  // Process payment based on selected method
  Future<PaymentResult> processPayment({
    required PaymentMethod method,
    required double amount,
    required String currency,
    required String description,
    Map<String, dynamic>? metadata,
    String? customerEmail,
    String? customerPhone,
  }) async {
    try {
      switch (method) {
        case PaymentMethod.stripe:
          return await _processStripePayment(
            amount: amount,
            currency: currency,
            description: description,
            metadata: metadata,
            customerEmail: customerEmail,
          );
        case PaymentMethod.razorpay:
          return await _processRazorpayPayment(
            amount: amount,
            currency: currency,
            description: description,
            customerEmail: customerEmail,
            customerPhone: customerPhone,
          );
      }
    } catch (e) {
      return PaymentResult(
        success: false,
        error: 'Payment processing failed: ${e.toString()}',
      );
    }
  }

  // Stripe Payment Processing
  Future<PaymentResult> _processStripePayment({
    required double amount,
    required String currency,
    required String description,
    Map<String, dynamic>? metadata,
    String? customerEmail,
  }) async {
    try {
      // Create payment intent on your backend
      final paymentIntentData = await _createStripePaymentIntent(
        amount: (amount * 100).toInt(), // Convert to cents
        currency: currency,
        description: description,
        metadata: metadata,
        customerEmail: customerEmail,
      );

      // Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData['client_secret'],
          merchantDisplayName: 'Rider\'s Choice',
          customerEphemeralKeySecret: paymentIntentData['ephemeral_key'],
          customerId: paymentIntentData['customer_id'],
          style: ThemeMode.system,
          billingDetails: BillingDetails(
            email: customerEmail,
          ),
        ),
      );

      // Present payment sheet
      await Stripe.instance.presentPaymentSheet();

      return PaymentResult(
        success: true,
        transactionId: paymentIntentData['payment_intent_id'],
        data: paymentIntentData,
      );
    } on StripeException catch (e) {
      return PaymentResult(
        success: false,
        error: 'Stripe error: ${e.error.localizedMessage}',
      );
    } catch (e) {
      return PaymentResult(
        success: false,
        error: 'Payment failed: ${e.toString()}',
      );
    }
  }

  // Razorpay Payment Processing
  Future<PaymentResult> _processRazorpayPayment({
    required double amount,
    required String currency,
    required String description,
    String? customerEmail,
    String? customerPhone,
  }) async {
    try {
      final options = {
        'key': 'rzp_test_1DP5mmOlF5G5ag', // Replace with your Razorpay key
        'amount': (amount * 100).toInt(), // Convert to paise
        'name': 'Rider\'s Choice',
        'description': description,
        'prefill': {
          'contact': customerPhone ?? '',
          'email': customerEmail ?? '',
        },
        'theme': {
          'color': '#FF6B35',
        },
      };

      _razorpay.open(options);
      
      // Return pending result - actual result will be handled by callbacks
      return PaymentResult(
        success: false,
        error: 'Payment in progress',
      );
    } catch (e) {
      return PaymentResult(
        success: false,
        error: 'Razorpay initialization failed: ${e.toString()}',
      );
    }
  }

  // Create Stripe Payment Intent (Backend call)
  Future<Map<String, dynamic>> _createStripePaymentIntent({
    required int amount,
    required String currency,
    required String description,
    Map<String, dynamic>? metadata,
    String? customerEmail,
  }) async {
    try {
      final response = await _dio.post(
        'http://localhost:5050/api/payments/create-payment-intent',
        data: {
          'amount': amount,
          'currency': currency,
          'description': description,
          'metadata': metadata,
          'customer_email': customerEmail,
        },
      );

      if (response.statusCode == 200 && response.data['success']) {
        return response.data['data'];
      } else {
        throw Exception('Failed to create payment intent');
      }
    } catch (e) {
      throw Exception('Backend communication failed: ${e.toString()}');
    }
  }

  // Razorpay Event Handlers
  void _handleRazorpaySuccess(PaymentSuccessResponse response) {
    // Handle successful payment
    debugPrint('Razorpay Success: ${response.paymentId}');
    // You can use a stream controller or callback to notify the UI
  }

  void _handleRazorpayError(PaymentFailureResponse response) {
    // Handle payment failure
    debugPrint('Razorpay Error: ${response.code} - ${response.message}');
  }

  void _handleRazorpayWallet(ExternalWalletResponse response) {
    // Handle external wallet
    debugPrint('Razorpay Wallet: ${response.walletName}');
  }

  // Verify payment on backend
  Future<bool> verifyPayment({
    required String transactionId,
    required PaymentMethod method,
  }) async {
    try {
      final response = await _dio.post(
        'http://localhost:5050/api/payments/verify',
        data: {
          'transaction_id': transactionId,
          'method': method.toString().split('.').last,
        },
      );

      return response.statusCode == 200 && response.data['success'];
    } catch (e) {
      debugPrint('Payment verification failed: ${e.toString()}');
      return false;
    }
  }

  // Get payment history
  Future<List<Map<String, dynamic>>> getPaymentHistory({
    required String userId,
  }) async {
    try {
      final response = await _dio.get(
        'http://localhost:5050/api/payments/history/$userId',
      );

      if (response.statusCode == 200 && response.data['success']) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      }
      return [];
    } catch (e) {
      debugPrint('Failed to fetch payment history: ${e.toString()}');
      return [];
    }
  }

  // Dispose resources
  void dispose() {
    _razorpay.clear();
  }
}
