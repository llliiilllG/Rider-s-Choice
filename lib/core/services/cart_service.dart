import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/bikes/domain/entities/bike.dart';

class CartItem {
  final String id;
  final String bikeId;
  final String bikeName;
  final String bikeBrand;
  final double price;
  final String imageUrl;
  final int quantity;
  final DateTime addedAt;

  CartItem({
    required this.id,
    required this.bikeId,
    required this.bikeName,
    required this.bikeBrand,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    required this.addedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'bikeId': bikeId,
    'bikeName': bikeName,
    'bikeBrand': bikeBrand,
    'price': price,
    'imageUrl': imageUrl,
    'quantity': quantity,
    'addedAt': addedAt.toIso8601String(),
  };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    id: json['id'],
    bikeId: json['bikeId'],
    bikeName: json['bikeName'],
    bikeBrand: json['bikeBrand'],
    price: json['price'].toDouble(),
    imageUrl: json['imageUrl'],
    quantity: json['quantity'],
    addedAt: DateTime.parse(json['addedAt']),
  );

  CartItem copyWith({
    String? id,
    String? bikeId,
    String? bikeName,
    String? bikeBrand,
    double? price,
    String? imageUrl,
    int? quantity,
    DateTime? addedAt,
  }) {
    return CartItem(
      id: id ?? this.id,
      bikeId: bikeId ?? this.bikeId,
      bikeName: bikeName ?? this.bikeName,
      bikeBrand: bikeBrand ?? this.bikeBrand,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}

class CartService {
  static const String _cartKey = 'cart_items';

  // Get all cart items
  Future<List<CartItem>> getCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getString(_cartKey);
    if (cartJson == null) return [];
    
    final List<dynamic> cartList = json.decode(cartJson);
    return cartList.map((item) => CartItem.fromJson(item)).toList();
  }

  // Add item to cart
  Future<void> addToCart(Bike bike, int quantity) async {
    final prefs = await SharedPreferences.getInstance();
    final cartItems = await getCartItems();
    
    // Check if bike already exists in cart
    final existingIndex = cartItems.indexWhere((item) => item.bikeId == bike.id);
    
    if (existingIndex != -1) {
      // Update quantity if bike already exists
      final existingItem = cartItems[existingIndex];
      cartItems[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
      );
    } else {
      // Add new item
      final newItem = CartItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        bikeId: bike.id,
        bikeName: bike.name,
        bikeBrand: bike.brand,
        price: bike.price,
        imageUrl: bike.imageUrl,
        quantity: quantity,
        addedAt: DateTime.now(),
      );
      cartItems.add(newItem);
    }
    
    // Save to storage
    final cartJson = json.encode(cartItems.map((item) => item.toJson()).toList());
    await prefs.setString(_cartKey, cartJson);
  }

  // Remove item from cart
  Future<void> removeFromCart(String itemId) async {
    final prefs = await SharedPreferences.getInstance();
    final cartItems = await getCartItems();
    
    cartItems.removeWhere((item) => item.id == itemId);
    
    final cartJson = json.encode(cartItems.map((item) => item.toJson()).toList());
    await prefs.setString(_cartKey, cartJson);
  }

  // Update item quantity
  Future<void> updateQuantity(String itemId, int quantity) async {
    final prefs = await SharedPreferences.getInstance();
    final cartItems = await getCartItems();
    
    final index = cartItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      if (quantity <= 0) {
        cartItems.removeAt(index);
      } else {
        cartItems[index] = cartItems[index].copyWith(quantity: quantity);
      }
    }
    
    final cartJson = json.encode(cartItems.map((item) => item.toJson()).toList());
    await prefs.setString(_cartKey, cartJson);
  }

  // Clear cart
  Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
  }

  // Get cart total
  Future<double> getCartTotal() async {
    final cartItems = await getCartItems();
    double total = 0.0;
    for (final item in cartItems) {
      total += item.price * item.quantity;
    }
    return total;
  }

  // Get cart item count
  Future<int> getCartItemCount() async {
    final cartItems = await getCartItems();
    int total = 0;
    for (final item in cartItems) {
      total += item.quantity;
    }
    return total;
  }

  // Add sample data for testing (remove this in production)
  Future<void> addSampleData() async {
    final sampleBike = Bike(
      id: 'sample_bike_1',
      name: 'Sample Bike',
      brand: 'Test Brand',
      price: 250000.0,
      category: 'Sports',
      imageUrl: '',
      description: 'A sample bike for testing',
      specifications: const BikeSpecifications(
        engine: '1000cc',
        power: '150 HP',
        torque: '100 Nm',
        transmission: 'Manual',
        weight: '200 kg',
        fuelCapacity: '15L',
      ),
      stock: 5,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    await addToCart(sampleBike, 1);
  }
} 