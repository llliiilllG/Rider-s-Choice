import 'package:flutter/material.dart';
import '../../features/bikes/domain/entities/bike.dart';
import 'cart_service.dart';
import 'order_api_service.dart';

enum PaymentMethod {
  cashOnDelivery,
  khalti,
}

class PaymentService {
  final CartService _cartService = CartService();
  final OrderApiService _orderApiService = OrderApiService();

  // Process payment
  Future<PaymentResult> processPayment({
    required PaymentMethod method,
    required List<CartItem> items,
    required double totalAmount,
    String? deliveryAddress,
    String? phoneNumber,
  }) async {
    try {
      switch (method) {
        case PaymentMethod.cashOnDelivery:
          return await _processCashOnDelivery(
            items: items,
            totalAmount: totalAmount,
            deliveryAddress: deliveryAddress,
            phoneNumber: phoneNumber,
          );
        case PaymentMethod.khalti:
          return await _processKhaltiPayment(
            items: items,
            totalAmount: totalAmount,
            deliveryAddress: deliveryAddress,
            phoneNumber: phoneNumber,
          );
      }
    } catch (e) {
      return PaymentResult(
        success: false,
        message: 'Payment failed: ${e.toString()}',
        orderId: null,
      );
    }
  }

  // Process Cash on Delivery
  Future<PaymentResult> _processCashOnDelivery({
    required List<CartItem> items,
    required double totalAmount,
    String? deliveryAddress,
    String? phoneNumber,
  }) async {
    try {
      // Create orders in backend for each cart item
      final cartItemsData = items.map((item) => {
        'bikeId': item.bikeId,
        'bikeName': item.bikeName,
        'quantity': item.quantity,
        'price': item.price,
      }).toList();
      
      await _orderApiService.createOrderFromCart('', cartItemsData, totalAmount);
      
      // Clear cart after successful order
      await _cartService.clearCart();
      
      return PaymentResult(
        success: true,
        message: 'Order placed successfully! Pay ₹${totalAmount.toStringAsFixed(2)} on delivery.',
        orderId: 'COD_${DateTime.now().millisecondsSinceEpoch}',
      );
    } catch (e) {
      return PaymentResult(
        success: false,
        message: 'Failed to create order: ${e.toString()}',
        orderId: null,
      );
    }
  }

  // Process Khalti Payment
  Future<PaymentResult> _processKhaltiPayment({
    required List<CartItem> items,
    required double totalAmount,
    String? deliveryAddress,
    String? phoneNumber,
  }) async {
    try {
      // Create orders in backend for each cart item
      final cartItemsData = items.map((item) => {
        'bikeId': item.bikeId,
        'bikeName': item.bikeName,
        'quantity': item.quantity,
        'price': item.price,
      }).toList();
      
      await _orderApiService.createOrderFromCart('', cartItemsData, totalAmount);
      
      // Clear cart after successful payment
      await _cartService.clearCart();
      
      return PaymentResult(
        success: true,
        message: 'Payment successful! Order ID: Khalti_${DateTime.now().millisecondsSinceEpoch}',
        orderId: 'Khalti_${DateTime.now().millisecondsSinceEpoch}',
      );
    } catch (e) {
      return PaymentResult(
        success: false,
        message: 'Failed to create order: ${e.toString()}',
        orderId: null,
      );
    }
  }

  // Get payment methods
  List<PaymentMethodOption> getPaymentMethods() {
    return [
      PaymentMethodOption(
        method: PaymentMethod.cashOnDelivery,
        title: 'Cash on Delivery',
        description: 'Pay when you receive your order',
        icon: Icons.money,
        color: Colors.green,
      ),
      PaymentMethodOption(
        method: PaymentMethod.khalti,
        title: 'Khalti',
        description: 'Pay securely with Khalti',
        icon: Icons.payment,
        color: Colors.purple,
      ),
    ];
  }
}

class PaymentMethodOption {
  final PaymentMethod method;
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  PaymentMethodOption({
    required this.method,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class PaymentResult {
  final bool success;
  final String message;
  final String? orderId;

  PaymentResult({
    required this.success,
    required this.message,
    this.orderId,
  });
} 