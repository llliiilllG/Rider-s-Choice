import 'package:flutter_test/flutter_test.dart';
import 'package:riders_choice/data/bike_data.dart';
import 'package:riders_choice/features/bikes/domain/entities/bike.dart';

void main() {
  group('BikeData', () {
    test('should return featured bikes', () {
      final featuredBikes = BikeData.getFeaturedBikes();
      
      expect(featuredBikes, isNotEmpty);
      expect(featuredBikes.every((bike) => bike.isFeatured), true);
    });

    test('should return bike by id when exists', () {
      // Use a real id from the current data, e.g., 'b1' or whatever is present
      final allBikes = BikeData.getAllBikes();
      final testId = allBikes.first.id;
      final bike = BikeData.getBikeById(testId);
      expect(bike, isNotNull);
      expect(bike!.id, testId);
    });

    test('should return null when bike id does not exist', () {
      final bike = BikeData.getBikeById('999');
      
      expect(bike, isNull);
    });

    test('should return bikes by category', () {
      // Use a real category from the current data, e.g., 'Superbike'
      final allBikes = BikeData.getAllBikes();
      final testCategory = allBikes.first.category;
      final bikes = BikeData.getBikesByCategory(testCategory);
      expect(bikes, isNotEmpty);
      expect(bikes.every((bike) => bike.category.toLowerCase() == testCategory.toLowerCase()), true);
    });

    test('should return empty list for non-existent category', () {
      final bikes = BikeData.getBikesByCategory('NonExistent');
      
      expect(bikes, isEmpty);
    });

    test('should return all bikes', () {
      final allBikes = BikeData.getAllBikes();
      
      expect(allBikes, isNotEmpty);
      expect(allBikes.length, greaterThan(0));
    });

    test('should handle case-insensitive category search', () {
      final sportBikes = BikeData.getBikesByCategory('sport');
      final SportBikes = BikeData.getBikesByCategory('Sport');
      final SPORTBikes = BikeData.getBikesByCategory('SPORT');
      
      expect(sportBikes.length, SportBikes.length);
      expect(SportBikes.length, SPORTBikes.length);
    });
  });

  group('Accessories List', () {
    test('should contain accessories', () {
      expect(accessories, isNotEmpty);
      expect(accessories.length, greaterThan(0));
    });

    test('should have required fields', () {
      final accessory = accessories.first;
      expect(accessory, contains('id'));
      expect(accessory, contains('name'));
      expect(accessory, contains('price'));
      expect(accessory, contains('imageUrl'));
      expect(accessory, contains('description'));
    });

    test('should have valid price values', () {
      expect(accessories.every((a) => a['price'] is num && a['price'] > 0), true);
    });
  });
} 