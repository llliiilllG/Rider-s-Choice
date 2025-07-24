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