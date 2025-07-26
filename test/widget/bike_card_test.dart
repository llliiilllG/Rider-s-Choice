import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riders_choice/features/bikes/domain/entities/bike.dart';
import 'package:riders_choice/presentation/widgets/bike_card.dart';
import 'package:riders_choice/data/bike_data.dart';

void main() {
  group('BikeCard', () {
    late Bike testBike;

    setUp(() {
      // Use a real bike from the current data
      testBike = Bike(
        id: '1',
        name: 'Test Bike',
        brand: 'Test Brand',
        price: 1000.0,
        category: 'Test Category',
        imageUrl: '',
        description: '',
        specifications: BikeSpecifications(engine: '', power: '', torque: '', transmission: '', weight: '', fuelCapacity: ''),
        stock: 1,
        isFeatured: false,
        rating: 0.0,
        reviews: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    });

    testWidgets('should display bike information correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BikeCard(bike: testBike),
          ),
        ),
      );

      // Check if bike name is displayed
      expect(find.text(testBike.name), findsOneWidget);

      // Check if brand is displayed
      expect(find.text(testBike.brand), findsOneWidget);

      // Check if price is displayed (format: ' 4{price}')
      expect(find.text(' 4${testBike.price.toStringAsFixed(0)}'), findsOneWidget);

      // Check if "View Details" button is displayed
      expect(find.text('View Details'), findsOneWidget);

      // Check if "Add to Cart" and "Buy Now" buttons are displayed
      expect(find.text('Add to Cart'), findsOneWidget);
      expect(find.text('Buy Now'), findsOneWidget);
    });

    testWidgets('should display View Details button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BikeCard(bike: testBike),
          ),
        ),
      );

      // Verify the button is present
      expect(find.text('View Details'), findsOneWidget);
    });

    testWidgets('should display bike image', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BikeCard(bike: testBike),
          ),
        ),
      );

      // Check if image is displayed
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should handle different bike data', (WidgetTester tester) async {
      final differentBike = BikeData.getAllBikes().last;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BikeCard(bike: differentBike),
          ),
        ),
      );

      // Check if different bike name is displayed
      expect(find.text(differentBike.name), findsOneWidget);

      // Check if different brand is displayed
      expect(find.text(differentBike.brand), findsOneWidget);

      // Check if different price is displayed (format: ' 4{price}')
      expect(find.text(' 4${differentBike.price.toStringAsFixed(0)}'), findsOneWidget);
    });

    testWidgets('should display card with proper styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BikeCard(bike: testBike),
          ),
        ),
      );

      // Check if Card widget is present
      expect(find.byType(Card), findsOneWidget);

      // Check if Column is present (main layout)
      expect(find.byType(Column), findsWidgets);

      // Check if ClipRRect is present (for image)
      expect(find.byType(ClipRRect), findsOneWidget);
    });
  });
} 