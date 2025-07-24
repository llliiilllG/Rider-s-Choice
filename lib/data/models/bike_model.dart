import '../../domain/entities/bike.dart';

class BikeModel extends Bike {
  const BikeModel({
    required String id,
    required String name,
    required String brand,
    required double price,
    required String category,
    required String imageUrl,
    required String description,
    required BikeSpecifications specifications,
    required int stock,
    required bool isFeatured,
    required double rating,
    required List<Review> reviews,
  }) : super(
          id: id,
          name: name,
          brand: brand,
          price: price,
          category: category,
          imageUrl: imageUrl,
          description: description,
          specifications: specifications,
          stock: stock,
          isFeatured: isFeatured,
          rating: rating,
          reviews: reviews,
        );

  factory BikeModel.fromJson(Map<String, dynamic> json) {
    return BikeModel(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      brand: json['brand'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      description: json['description'] ?? '',
      specifications: BikeSpecifications(
        engine: json['specifications']?['engine'] ?? '',
        power: json['specifications']?['power'] ?? '',
        torque: json['specifications']?['torque'] ?? '',
        transmission: json['specifications']?['transmission'] ?? '',
        weight: json['specifications']?['weight'] ?? '',
        fuelCapacity: json['specifications']?['fuelCapacity'] ?? '',
      ),
      stock: json['stock'] ?? 0,
      isFeatured: json['isFeatured'] ?? false,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviews: (json['reviews'] as List?)?.map((r) => Review(
        userId: r['userId'] ?? '',
        userName: r['userName'] ?? '',
        rating: r['rating'] ?? 0,
        comment: r['comment'] ?? '',
        date: DateTime.tryParse(r['date'] ?? '') ?? DateTime.now(),
      )).toList() ?? [],
    );
  }
}

extension BikeFromJson on Bike {
  static Bike fromJson(Map<String, dynamic> json) {
    return BikeModel.fromJson(json);
  }
} 