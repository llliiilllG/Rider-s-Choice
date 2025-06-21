import 'package:equatable/equatable.dart';

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
  List<Object?> get props => [
        userId,
        userName,
        rating,
        comment,
        date,
      ];
}

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
    required this.isFeatured,
    required this.rating,
    required this.reviews,
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
      ];
} 