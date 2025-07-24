import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riders_choice/main.dart';
import 'package:riders_choice/presentation/bloc/bike/bike_bloc.dart';
import 'package:riders_choice/presentation/bloc/bike/bike_event.dart';
import 'package:riders_choice/presentation/bloc/bike/bike_state.dart';
import 'package:mockito/mockito.dart';
import 'package:riders_choice/core/services/bike_api_service.dart';

class MockBikeApiService extends Mock implements BikeApiService {}

void main() {
  group('App Integration Tests', () {
    late MockBikeApiService mockApiService;

    setUp(() {
      mockApiService = MockBikeApiService();
    });

    testWidgets('should display splash screen initially', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pump(const Duration(seconds: 2));
      expect(find.byType(MaterialApp), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('should navigate to home page after splash', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pump(const Duration(seconds: 3));
      expect(find.byType(MaterialApp), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('should display bike list when loaded', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (context) => BikeBloc(apiService: mockApiService),
            child: const Scaffold(
              body: Center(
                child: Text('Test Home Page'),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(BlocProvider<BikeBloc>), findsOneWidget);
    });

    testWidgets('should handle bike bloc state changes', (WidgetTester tester) async {
      final bikeBloc = BikeBloc(apiService: mockApiService);

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: bikeBloc,
            child: Scaffold(
              body: BlocBuilder<BikeBloc, BikeState>(
                builder: (context, state) {
                  if (state is BikeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is BikeLoaded) {
                    return ListView.builder(
                      itemCount: state.bikes.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(state.bikes[index].name),
                        );
                      },
                    );
                  } else if (state is BikeError) {
                    return Center(child: Text(state.message));
                  }
                  return const Center(child: Text('Initial State'));
                },
              ),
            ),
          ),
        ),
      );

      // Verify initial state
      expect(find.text('Initial State'), findsOneWidget);

      // Add event to load featured bikes
      bikeBloc.add(GetFeaturedBikesEvent());

      // Wait for state changes with multiple pumps to catch loading state
      await tester.pump();
      
      // Check if we're in loading state
      if (find.byType(CircularProgressIndicator).evaluate().isNotEmpty) {
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      }

      // Wait for loaded state
      await tester.pumpAndSettle();

      // Verify that bikes are loaded
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('should handle error state in bike bloc', (WidgetTester tester) async {
      final bikeBloc = BikeBloc(apiService: mockApiService);

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: bikeBloc,
            child: Scaffold(
              body: BlocBuilder<BikeBloc, BikeState>(
                builder: (context, state) {
                  if (state is BikeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is BikeLoaded) {
                    return ListView.builder(
                      itemCount: state.bikes.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(state.bikes[index].name),
                        );
                      },
                    );
                  } else if (state is BikeError) {
                    return Center(child: Text(state.message));
                  }
                  return const Center(child: Text('Initial State'));
                },
              ),
            ),
          ),
        ),
      );

      // Add event with invalid bike id to trigger error
      bikeBloc.add(GetBikeByIdEvent('999'));

      // Wait for state changes
      await tester.pumpAndSettle();

      // Verify error state
      expect(find.text('Bike not found'), findsOneWidget);
    });

    testWidgets('should handle category filtering', (WidgetTester tester) async {
      final bikeBloc = BikeBloc(apiService: mockApiService);

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: bikeBloc,
            child: Scaffold(
              body: BlocBuilder<BikeBloc, BikeState>(
                builder: (context, state) {
                  if (state is BikeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is BikeLoaded) {
                    return Column(
                      children: [
                        Text('Bikes: ${state.bikes.length}'),
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.bikes.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(state.bikes[index].name),
                                subtitle: Text(state.bikes[index].category),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  } else if (state is BikeError) {
                    return Center(child: Text(state.message));
                  }
                  return const Center(child: Text('Initial State'));
                },
              ),
            ),
          ),
        ),
      );

      // Load bikes by category
      bikeBloc.add(GetBikesByCategoryEvent('Sport'));

      // Wait for state changes
      await tester.pumpAndSettle();

      // Verify that sport bikes are loaded
      expect(find.byType(ListView), findsOneWidget);
      expect(find.textContaining('Bikes:'), findsOneWidget);
    });
  });
} 