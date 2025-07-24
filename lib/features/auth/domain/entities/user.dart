import 'package:equatable/equatable.dart';

class User extends Equatable {
  // Factory constructor for JSON deserialization
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      address: json['address'],
      role: json['role'] ?? 'user',
      wishlist: List<String>.from(json['wishlist'] ?? []),
      cart: (json['cart'] as List<dynamic>? ?? [])
          .map((item) => CartItem.fromJson(item))
          .toList(),
      orders: List<String>.from(json['orders'] ?? []),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  // Method to convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'role': role,
      'wishlist': wishlist,
      'cart': cart.map((item) => item.toJson()).toList(),
      'orders': orders,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final String role;
  final List<String> wishlist;
  final List<CartItem> cart;
  final List<String> orders;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.role = 'user',
    this.wishlist = const [],
    this.cart = const [],
    this.orders = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        address,
        role,
        wishlist,
        cart,
        orders,
        createdAt,
        updatedAt,
      ];

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? role,
    List<String>? wishlist,
    List<CartItem>? cart,
    List<String>? orders,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      role: role ?? this.role,
      wishlist: wishlist ?? this.wishlist,
      cart: cart ?? this.cart,
      orders: orders ?? this.orders,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CartItem extends Equatable {
  final String bikeId;
  final int quantity;

  const CartItem({
    required this.bikeId,
    required this.quantity,
  });

  // Factory constructor for JSON deserialization
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      bikeId: json['bikeId'] ?? '',
      quantity: json['quantity'] ?? 0,
    );
  }

  // Method to convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'bikeId': bikeId,
      'quantity': quantity,
    };
  }

  @override
  List<Object?> get props => [bikeId, quantity];

  CartItem copyWith({
    String? bikeId,
    int? quantity,
  }) {
    return CartItem(
      bikeId: bikeId ?? this.bikeId,
      quantity: quantity ?? this.quantity,
    );
  }
} 