import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../core/services/order_api_service.dart';

class CartItem {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  int quantity;
  final String type; // 'bike' or 'accessory'

  CartItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'imageUrl': imageUrl,
    'price': price,
    'quantity': quantity,
    'type': type,
  };
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  void addItem(CartItem item) {
    final index = _items.indexWhere((i) => i.id == item.id && i.type == item.type);
    if (index >= 0) {
      _items[index].quantity += item.quantity;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void removeItem(CartItem item) {
    _items.removeWhere((i) => i.id == item.id && i.type == item.type);
    notifyListeners();
  }

  void updateQuantity(CartItem item, int quantity) {
    final index = _items.indexWhere((i) => i.id == item.id && i.type == item.type);
    if (index >= 0) {
      _items[index].quantity = quantity;
      if (_items[index].quantity < 1) {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  double get totalPrice => _items.fold(0, (sum, item) => sum + item.price * item.quantity);

  Future<Map<String, dynamic>> checkout() async {
    final orderApi = GetIt.instance<OrderApiService>();
    final orderData = {
      'items': _items.map((item) => item.toJson()).toList(),
      'total': totalPrice,
    };
    final response = await orderApi.createOrder(orderData);
    if (response['success'] == true || response['id'] != null) {
      clearCart();
    }
    return response;
  }
} 