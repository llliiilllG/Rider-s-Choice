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
} 