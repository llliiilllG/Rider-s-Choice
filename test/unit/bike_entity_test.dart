import 'package:flutter_test/flutter_test.dart';
import 'package:riders_choice/domain/entities/bike.dart';

void main() {
  group('BikeSpecifications', () {
    test('should create BikeSpecifications with all required fields', () {
      const specs = BikeSpecifications(
        engine: '1103cc V4',
        power: '214 hp',
        torque: '91.5 lb-ft',
        transmission: '6-speed',
        weight: '430 lbs',
        fuelCapacity: '4.2 gallons',
      );

      expect(specs.engine, '1103cc V4');
      expect(specs.power, '214 hp');
      expect(specs.torque, '91.5 lb-ft');
      expect(specs.transmission, '6-speed');
      expect(specs.weight, '430 lbs');
      expect(specs.fuelCapacity, '4.2 gallons');
    });

    test('should be equal when all properties are the same', () {
      const specs1 = BikeSpecifications(
        engine: '1103cc V4',
        power: '214 hp',
        torque: '91.5 lb-ft',
        transmission: '6-speed',
        weight: '430 lbs',
        fuelCapacity: '4.2 gallons',
      );

      const specs2 = BikeSpecifications(
        engine: '1103cc V4',
        power: '214 hp',
        torque: '91.5 lb-ft',
        transmission: '6-speed',
        weight: '430 lbs',
        fuelCapacity: '4.2 gallons',
      );

      expect(specs1, equals(specs2));
    });

    test('should not be equal when properties are different', () {
      const specs1 = BikeSpecifications(
        engine: '1103cc V4',
        power: '214 hp',
        torque: '91.5 lb-ft',
        transmission: '6-speed',
        weight: '430 lbs',
        fuelCapacity: '4.2 gallons',
      );

      const specs2 = BikeSpecifications(
        engine: '999cc Inline-4',
        power: '205 hp',
        torque: '83 lb-ft',
        transmission: '6-speed',
        weight: '434 lbs',
        fuelCapacity: '4.4 gallons',
      );

      expect(specs1, isNot(equals(specs2)));
    });
  });

  group('Review', () {
    test('should create Review with all required fields', () {
      final date = DateTime(2024, 1, 1);
      final review = Review(
        userId: 'user1',
        userName: 'John Rider',
        rating: 5,
        comment: 'Amazing bike!',
        date: date,
      );

      expect(review.userId, 'user1');
      expect(review.userName, 'John Rider');
      expect(review.rating, 5);
      expect(review.comment, 'Amazing bike!');
      expect(review.date, date);
    });

    test('should be equal when all properties are the same', () {
      final date = DateTime(2024, 1, 1);
      final review1 = Review(
        userId: 'user1',
        userName: 'John Rider',
        rating: 5,
        comment: 'Amazing bike!',
        date: date,
      );

      final review2 = Review(
        userId: 'user1',
        userName: 'John Rider',
        rating: 5,
        comment: 'Amazing bike!',
        date: date,
      );

      expect(review1, equals(review2));
    });

    test('should not be equal when properties are different', () {
      final date = DateTime(2024, 1, 1);
      final review1 = Review(
        userId: 'user1',
        userName: 'John Rider',
        rating: 5,
        comment: 'Amazing bike!',
        date: date,
      );

      final review2 = Review(
        userId: 'user2',
        userName: 'Sarah Speed',
        rating: 4,
        comment: 'Great bike!',
        date: date,
      );

      expect(review1, isNot(equals(review2)));
    });
  });

  group('Bike', () {
    late Bike testBike;
    late BikeSpecifications testSpecs;
    late List<Review> testReviews;

    setUp(() {
      testSpecs = const BikeSpecifications(
        engine: '1103cc V4',
        power: '214 hp',
        torque: '91.5 lb-ft',
        transmission: '6-speed',
        weight: '430 lbs',
        fuelCapacity: '4.2 gallons',
      );

      testReviews = [
        Review(
          userId: 'user1',
          userName: 'John Rider',
          rating: 5,
          comment: 'Amazing bike!',
          date: DateTime(2024, 1, 1),
        ),
      ];

      testBike = Bike(
        id: '1',
        name: 'Ducati Panigale V4',
        brand: 'Ducati',
        price: 24999,
        category: 'Sport',
        imageUrl: 'assets/motorcycles/ducati_panigale.jpg',
        description: 'The Ducati Panigale V4 is amazing.',
        specifications: testSpecs,
        stock: 5,
        isFeatured: true,
        rating: 4.8,
        reviews: testReviews,
      );
    });

    test('should create Bike with all required fields', () {
      expect(testBike.id, '1');
      expect(testBike.name, 'Ducati Panigale V4');
      expect(testBike.brand, 'Ducati');
      expect(testBike.price, 24999);
      expect(testBike.category, 'Sport');
      expect(testBike.imageUrl, 'assets/motorcycles/ducati_panigale.jpg');
      expect(testBike.description, 'The Ducati Panigale V4 is amazing.');
      expect(testBike.specifications, testSpecs);
      expect(testBike.stock, 5);
      expect(testBike.isFeatured, true);
      expect(testBike.rating, 4.8);
      expect(testBike.reviews, testReviews);
    });

    test('should be equal when all properties are the same', () {
      final bike1 = Bike(
        id: '1',
        name: 'Ducati Panigale V4',
        brand: 'Ducati',
        price: 24999,
        category: 'Sport',
        imageUrl: 'assets/motorcycles/ducati_panigale.jpg',
        description: 'The Ducati Panigale V4 is amazing.',
        specifications: testSpecs,
        stock: 5,
        isFeatured: true,
        rating: 4.8,
        reviews: testReviews,
      );

      final bike2 = Bike(
        id: '1',
        name: 'Ducati Panigale V4',
        brand: 'Ducati',
        price: 24999,
        category: 'Sport',
        imageUrl: 'assets/motorcycles/ducati_panigale.jpg',
        description: 'The Ducati Panigale V4 is amazing.',
        specifications: testSpecs,
        stock: 5,
        isFeatured: true,
        rating: 4.8,
        reviews: testReviews,
      );

      expect(bike1, equals(bike2));
    });

    test('should not be equal when properties are different', () {
      final bike1 = Bike(
        id: '1',
        name: 'Ducati Panigale V4',
        brand: 'Ducati',
        price: 24999,
        category: 'Sport',
        imageUrl: 'assets/motorcycles/ducati_panigale.jpg',
        description: 'The Ducati Panigale V4 is amazing.',
        specifications: testSpecs,
        stock: 5,
        isFeatured: true,
        rating: 4.8,
        reviews: testReviews,
      );

      final bike2 = Bike(
        id: '2',
        name: 'BMW S1000RR',
        brand: 'BMW',
        price: 18995,
        category: 'Sport',
        imageUrl: 'assets/motorcycles/bmw_s1000rr.jpg',
        description: 'The BMW S1000RR is amazing.',
        specifications: testSpecs,
        stock: 8,
        isFeatured: true,
        rating: 4.7,
        reviews: testReviews,
      );

      expect(bike1, isNot(equals(bike2)));
    });

    test('should have correct props for Equatable', () {
      final props = testBike.props;
      expect(props.length, 12);
      expect(props.contains('1'), true);
      expect(props.contains('Ducati Panigale V4'), true);
      expect(props.contains('Ducati'), true);
      expect(props.contains(24999), true);
      expect(props.contains('Sport'), true);
      expect(props.contains('assets/motorcycles/ducati_panigale.jpg'), true);
      expect(props.contains('The Ducati Panigale V4 is amazing.'), true);
      expect(props.contains(testSpecs), true);
      expect(props.contains(5), true);
      expect(props.contains(true), true);
      expect(props.contains(4.8), true);
      expect(props.contains(testReviews), true);
    });
  });
} 