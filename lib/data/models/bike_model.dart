import '../../domain/entities/bike.dart';

class BikeModel extends Bike {
  const BikeModel({
    required super.id,
    required super.name,
    required super.brand,
    required super.price,
    required super.category,
    required super.imageUrl,
    required super.description,
    required super.specifications,
    required super.stock,
    required super.isFeatured,
    required super.rating,
    required super.reviews,
  });

  factory BikeModel.fromJson(Map<String, dynamic> json) {
    // Parse specifications from the new backend structure
    final specifications = BikeSpecifications(
      engine: json['cc']?.toString() ?? 'N/A',
      power: 'N/A', // Not available in new backend
      torque: 'N/A', // Not available in new backend
      transmission: json['transmission'] ?? 'Manual',
      weight: 'N/A', // Not available in new backend
      fuelCapacity: 'N/A', // Not available in new backend
    );

    // Parse reviews if available
    final reviews = <Review>[];
    if (json['reviews'] != null) {
      final reviewsList = json['reviews'] as List;
      reviews.addAll(reviewsList.map((reviewJson) => Review(
        userId: reviewJson['userId'] ?? '',
        userName: reviewJson['userName'] ?? 'Anonymous',
        rating: reviewJson['rating'] ?? 0,
        comment: reviewJson['comment'] ?? '',
        date: DateTime.tryParse(reviewJson['date'] ?? '') ?? DateTime.now(),
      )));
    }



    return BikeModel(
      id: json['_id'] ?? '',
      name: json['title'] ?? 'Unknown Bike',
      brand: json['brand'] ?? 'Unknown Brand',
      price: (json['price'] ?? 0).toDouble(),
      category: json['category'] ?? 'Sports',
      imageUrl: json['image'] ?? 'default-bike.jpg',
      description: json['description'] ?? '',
      specifications: specifications,
      stock: json['stockAvailable']?.length ?? 0,
      isFeatured: false, // Default to false, can be updated later
      rating: 0.0, // Default rating, can be calculated from reviews later
      reviews: reviews,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': name,
      'brand': brand,
      'price': price,
      'category': category,
      'image': imageUrl,
      'description': description,
      'cc': int.tryParse(specifications.engine) ?? 0,
      'transmission': specifications.transmission,
      'fuelType': 'Petrol', // Default value
      'modelYear': DateTime.now().year, // Default value
      'mileage': 'N/A',
      'color': 'N/A',
      'stockAvailable': List.generate(stock, (index) => 'Available'),
      'reviews': reviews.map((review) => {
        'userId': review.userId,
        'userName': review.userName,
        'rating': review.rating,
        'comment': review.comment,
        'date': review.date.toIso8601String(),
      }).toList(),
    };
  }
} 