import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riders_choice/features/bikes/domain/entities/bike.dart';

class TestHelpers {
  static Bike createTestBike({
    String id = '1',
    String name = 'Test Bike',
    String brand = 'Test Brand',
    double price = 10000,
    String category = 'Sport',
    String imageUrl = 'assets/motorcycles/test.jpg',
    String description = 'Test description',
    int stock = 5,
    bool isFeatured = true,
    double rating = 4.5,
    List<Review> reviews = const [],
  }) {
    return Bike(
      id: id,
      name: name,
      brand: brand,
      price: price,
      category: category,
      imageUrl: imageUrl,
      description: description,
      specifications: const BikeSpecifications(
        engine: 'Test Engine',
        power: '100 hp',
        torque: '50 lb-ft',
        transmission: '6-speed',
        weight: '400 lbs',
        fuelCapacity: '4.0 gallons',
      ),
      stock: stock,
      isFeatured: isFeatured,
      rating: rating,
      reviews: reviews,
    );
  }

  static List<Bike> createTestBikes(int count) {
    return List.generate(
      count,
      (index) => createTestBike(
        id: '${index + 1}',
        name: 'Test Bike ${index + 1}',
        brand: 'Test Brand ${index + 1}',
        price: 10000 + (index * 1000),
      ),
    );
  }

  static Review createTestReview({
    String userId = 'user1',
    String userName = 'Test User',
    int rating = 5,
    String comment = 'Test comment',
    DateTime? date,
  }) {
    return Review(
      userId: userId,
      userName: userName,
      rating: rating,
      comment: comment,
      date: date ?? DateTime(2024, 1, 1),
    );
  }

  static Widget createTestApp({
    required Widget child,
    List<NavigatorObserver> navigatorObservers = const [],
  }) {
    return MaterialApp(
      home: child,
      navigatorObservers: navigatorObservers,
    );
  }

  static Widget createTestAppWithBloc<T extends StateStreamableSource<S>, S>({
    required T bloc,
    required Widget child,
  }) {
    return MaterialApp(
      home: BlocProvider.value(
        value: bloc,
        child: child,
      ),
    );
  }

  static Future<void> pumpWidgetWithDelay(
    WidgetTester tester,
    Widget widget, {
    Duration delay = const Duration(milliseconds: 500),
  }) async {
    await tester.pumpWidget(widget);
    await tester.pump(delay);
  }

  static Future<void> tapAndWait(
    WidgetTester tester,
    Finder finder, {
    Duration wait = const Duration(milliseconds: 300),
  }) async {
    await tester.tap(finder);
    await tester.pumpAndSettle(wait);
  }

  static Future<void> scrollAndWait(
    WidgetTester tester,
    Finder finder, {
    Duration wait = const Duration(milliseconds: 300),
  }) async {
    await tester.drag(finder, const Offset(0, -500));
    await tester.pumpAndSettle(wait);
  }

  static void expectTextPresent(WidgetTester tester, String text) {
    expect(find.text(text), findsOneWidget);
  }

  static void expectTextNotPresent(WidgetTester tester, String text) {
    expect(find.text(text), findsNothing);
  }

  static void expectWidgetPresent(WidgetTester tester, Type widgetType) {
    expect(find.byType(widgetType), findsOneWidget);
  }

  static void expectWidgetNotPresent(WidgetTester tester, Type widgetType) {
    expect(find.byType(widgetType), findsNothing);
  }

  static void expectIconPresent(WidgetTester tester, IconData icon) {
    expect(find.byIcon(icon), findsOneWidget);
  }

  static void expectIconNotPresent(WidgetTester tester, IconData icon) {
    expect(find.byIcon(icon), findsNothing);
  }
} 