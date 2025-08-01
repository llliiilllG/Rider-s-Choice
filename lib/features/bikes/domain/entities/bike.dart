import 'package:equatable/equatable.dart';

class Bike extends Equatable {
  final String id;
  final String name;
  final String brand;
  final double price;
  final String category;
  final String imageUrl;
  final String description;
  final BikeSpecifications specifications;
  final int stock;
  final bool isFeatured;
  final double rating;
  final List<Review> reviews;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Bike({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.description,
    required this.specifications,
    required this.stock,
    this.isFeatured = false,
    this.rating = 0.0,
    this.reviews = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        brand,
        price,
        category,
        imageUrl,
        description,
        specifications,
        stock,
        isFeatured,
        rating,
        reviews,
        createdAt,
        updatedAt,
      ];

  Bike copyWith({
    String? id,
    String? name,
    String? brand,
    double? price,
    String? category,
    String? imageUrl,
    String? description,
    BikeSpecifications? specifications,
    int? stock,
    bool? isFeatured,
    double? rating,
    List<Review>? reviews,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Bike(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      price: price ?? this.price,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      specifications: specifications ?? this.specifications,
      stock: stock ?? this.stock,
      isFeatured: isFeatured ?? this.isFeatured,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Bike.fromJson(Map<String, dynamic> json) {
    // Map the new backend structure
    String? imageUrl = json['image'];
    if (imageUrl != null && imageUrl.isNotEmpty && !imageUrl.startsWith('http')) {
      imageUrl = 'http://localhost:3000/uploads/$imageUrl';
    }
    
    return Bike(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['title'] ?? json['name'] ?? json['model'] ?? 'Unknown Bike',
      brand: json['brand'] ?? 'Unknown Brand',
      price: (json['price'] is int) ? (json['price'] as int).toDouble() : (json['price'] ?? 0.0),
      category: json['category'] ?? 'Sports',
      imageUrl: imageUrl ?? '',
      description: json['description'] ?? '',
      specifications: BikeSpecifications(
        engine: json['cc']?.toString() ?? 'N/A',
        power: 'N/A', // Not available in new backend
        torque: 'N/A', // Not available in new backend
        transmission: json['transmission'] ?? 'Manual',
        weight: 'N/A', // Not available in new backend
        fuelCapacity: 'N/A', // Not available in new backend
      ),
      stock: json['stockAvailable']?.length ?? 0,
      isFeatured: json['isFeatured'] ?? false,
      rating: (json['rating'] is int) ? (json['rating'] as int).toDouble() : (json['rating'] ?? 0.0),
      reviews: [],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'brand': brand,
    'price': price,
    'category': category,
    'imageUrl': imageUrl,
    'description': description,
    'specifications': {
      'engine': specifications.engine,
      'power': specifications.power,
      'torque': specifications.torque,
      'transmission': specifications.transmission,
      'weight': specifications.weight,
      'fuelCapacity': specifications.fuelCapacity,
    },
    'stock': stock,
    'isFeatured': isFeatured,
    'rating': rating,
    'reviews': [],
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}

class BikeSpecifications extends Equatable {
  final String engine;
  final String power;
  final String torque;
  final String transmission;
  final String weight;
  final String fuelCapacity;

  const BikeSpecifications({
    required this.engine,
    required this.power,
    required this.torque,
    required this.transmission,
    required this.weight,
    required this.fuelCapacity,
  });

  @override
  List<Object?> get props => [
        engine,
        power,
        torque,
        transmission,
        weight,
        fuelCapacity,
      ];
}

class Review extends Equatable {
  final String userId;
  final String userName;
  final int rating;
  final String comment;
  final DateTime date;

  const Review({
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
  });

  @override
  List<Object?> get props => [userId, userName, rating, comment, date];
} 