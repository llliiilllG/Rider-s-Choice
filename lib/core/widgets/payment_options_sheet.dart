import 'package:flutter/material.dart';
import '../services/payment_service.dart';
import '../services/cart_service.dart';
import '../theme/app_theme.dart';

class PaymentOptionsSheet extends StatefulWidget {
  final List<CartItem> cartItems;
  final double totalAmount;
  final VoidCallback onPaymentComplete;

  const PaymentOptionsSheet({
    Key? key,
    required this.cartItems,
    required this.totalAmount,
    required this.onPaymentComplete,
  }) : super(key: key);

  @override
  State<PaymentOptionsSheet> createState() => _PaymentOptionsSheetState();
}

class _PaymentOptionsSheetState extends State<PaymentOptionsSheet> {
  final PaymentService _paymentService = PaymentService();
  PaymentMethod? _selectedMethod;
  bool _isProcessing = false;
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    if (_selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a payment method')),
      );
      return;
    }

    if (_addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter delivery address')),
      );
      return;
    }

    if (_phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter phone number')),
      );
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final result = await _paymentService.processPayment(
        method: _selectedMethod!,
        items: widget.cartItems,
        totalAmount: widget.totalAmount,
        deliveryAddress: _addressController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
      );

      if (result.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: Colors.green,
          ),
        );
        widget.onPaymentComplete();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Checkout',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Order Summary
                  _buildOrderSummary(),
                  const SizedBox(height: 24),
                  
                  // Delivery Information
                  _buildDeliveryInfo(),
                  const SizedBox(height: 24),
                  
                  // Payment Methods
                  _buildPaymentMethods(),
                  const SizedBox(height: 32),
                  
                  // Pay Button
                  _buildPayButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...widget.cartItems.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${item.bikeName} x${item.quantity}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  Text(
                    '₹${(item.price * item.quantity).toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            )),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '₹${widget.totalAmount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: primaryGreen,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Delivery Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Delivery Address',
                border: OutlineInputBorder(),
                hintText: 'Enter your delivery address',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
                hintText: 'Enter your phone number',
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethods() {
    final methods = _paymentService.getPaymentMethods();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...methods.map((method) => Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: RadioListTile<PaymentMethod>(
            value: method.method,
            groupValue: _selectedMethod,
            onChanged: (value) {
              setState(() => _selectedMethod = value);
            },
            title: Row(
              children: [
                Icon(method.icon, color: method.color),
                const SizedBox(width: 12),
                Text(method.title),
              ],
            ),
            subtitle: Text(method.description),
            activeColor: primaryGreen,
          ),
        )),
      ],
    );
  }

  Widget _buildPayButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isProcessing ? null : _processPayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: _isProcessing
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                'Pay ₹${widget.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
} 