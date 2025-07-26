import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riders_choice/presentation/bloc/bike/bike_bloc.dart';
import 'package:riders_choice/presentation/bloc/bike/bike_event.dart';
import 'package:riders_choice/presentation/bloc/bike/bike_state.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:riders_choice/core/services/bike_api_service.dart';
import 'package:riders_choice/features/bikes/domain/entities/bike.dart';

class MockBikeApiService extends Mock implements BikeApiService {}

final sampleBike = Bike(
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

void main() {
  group('BikeBloc', () {
    late BikeBloc bikeBloc;
    late MockBikeApiService mockApiService;
    late String testId;
    late String testCategory;

    setUp(() {
      mockApiService = MockBikeApiService();
      bikeBloc = BikeBloc(apiService: mockApiService);
      testId = 'b1';
      testCategory = 'Superbike';
      // Mock API responses
      when(mockApiService.getBikeById(any)).thenAnswer((invocation) async {
        String id = '';
        if (invocation.positionalArguments.isNotEmpty) {
          final arg = invocation.positionalArguments[0];
          if (arg is String) id = arg;
        }
        if (id == 'b1') return sampleBike;
        throw Exception('Bike not found');
      });
      when(mockApiService.getBikesByCategory(any)).thenAnswer((invocation) async {
        String category = '';
        if (invocation.positionalArguments.isNotEmpty) {
          final arg = invocation.positionalArguments[0];
          if (arg is String) category = arg;
        }
        if (category == 'NonExistent') return <Bike>[];
        return [sampleBike];
      });
    });

    tearDown(() {
      bikeBloc.close();
    });

    test('initial state should be BikeInitial', () {
      expect(bikeBloc.state, isA<BikeInitial>());
    });

    blocTest<BikeBloc, BikeState>(
      'emits [BikeLoading, BikeLoaded] when GetFeaturedBikesEvent is added',
      build: () => bikeBloc,
      act: (bloc) => bloc.add(GetFeaturedBikesEvent()),
      expect: () => [
        isA<BikeLoading>(),
        isA<BikeLoaded>(),
      ],
      verify: (bloc) {
        final state = bloc.state as BikeLoaded;
        expect(state.bikes, isNotEmpty);
        expect(state.bikes.every((bike) => bike.isFeatured), true);
      },
    );

    blocTest<BikeBloc, BikeState>(
      'emits [BikeLoading, SingleBikeLoaded] when GetBikeByIdEvent is added with valid id',
      build: () => bikeBloc,
      act: (bloc) => bloc.add(GetBikeByIdEvent('b1')),
      expect: () => [
        isA<BikeLoading>(),
        isA<SingleBikeLoaded>(),
      ],
      verify: (bloc) {
        final state = bloc.state as SingleBikeLoaded;
        expect(state.bike.id, testId);
      },
    );

    blocTest<BikeBloc, BikeState>(
      'emits [BikeLoading, BikeError] when GetBikeByIdEvent is added with invalid id',
      build: () => bikeBloc,
      act: (bloc) => bloc.add(GetBikeByIdEvent('invalid_id')), // Use an id that doesn't exist
      expect: () => [
        isA<BikeLoading>(),
        isA<BikeError>(),
      ],
      verify: (bloc) {
        final state = bloc.state as BikeError;
        expect(state.message, 'Bike not found');
      },
    );

    blocTest<BikeBloc, BikeState>(
      'emits [BikeLoading, BikeLoaded] when GetBikesByCategoryEvent is added with valid category',
      build: () => bikeBloc,
      act: (bloc) => bloc.add(GetBikesByCategoryEvent('Superbike')),
      expect: () => [
        isA<BikeLoading>(),
        isA<BikeLoaded>(),
      ],
      verify: (bloc) {
        final state = bloc.state as BikeLoaded;
        expect(state.bikes, isNotEmpty);
        expect(state.bikes.every((bike) => bike.category.toLowerCase() == testCategory.toLowerCase()), true);
      },
    );

    blocTest<BikeBloc, BikeState>(
      'emits [BikeLoading, BikeLoaded] when GetBikesByCategoryEvent is added with empty category',
      build: () => bikeBloc,
      act: (bloc) => bloc.add(GetBikesByCategoryEvent('NonExistent')), // Use a category that doesn't exist
      expect: () => [
        isA<BikeLoading>(),
        isA<BikeLoaded>(),
      ],
      verify: (bloc) {
        final state = bloc.state as BikeLoaded;
        expect(state.bikes, isEmpty);
      },
    );

    blocTest<BikeBloc, BikeState>(
      'emits [BikeLoading, BikeLoaded] when GetBikesByCategoryEvent is added with case-insensitive category',
      build: () => bikeBloc,
      act: (bloc) => bloc.add(GetBikesByCategoryEvent(testCategory.toUpperCase())),
      expect: () => [
        isA<BikeLoading>(),
        isA<BikeLoaded>(),
      ],
      verify: (bloc) {
        final state = bloc.state as BikeLoaded;
        expect(state.bikes, isNotEmpty);
        expect(state.bikes.every((bike) => bike.category.toLowerCase() == testCategory.toLowerCase()), true);
      },
    );
  });
} 