import 'package:injectable/injectable.dart';
import '../../domain/entities/bike.dart';
import '../../domain/repositories/bike_repository.dart';

@Injectable(as: BikeRepository)
class BikeRepositoryImpl implements BikeRepository {
  // Mock data for now - will be replaced with API calls later
  final List<Bike> _mockBikes = [
    Bike(
      id: '1',
      name: 'Ducati Panigale V4',
      brand: 'Ducati',
      price: 24999.0,
      category: 'Sport',
      imageUrl: 'assets/motorcycles/ducati_panigale.jpg',
      description: 'The Ducati Panigale V4 is the most powerful production Ducati motorcycle ever built.',
      specifications: const BikeSpecifications(
        engine: '1103cc V4',
        power: '214 hp',
        torque: '91.5 lb-ft',
        transmission: '6-speed',
        weight: '430 lbs',
        fuelCapacity: '4.2 gallons',
      ),
      stock: 5,
      isFeatured: true,
      rating: 4.8,
      reviews: [
        Review(
          userId: 'user1',
          userName: 'John Rider',
          rating: 5,
          comment: 'Amazing bike! The power delivery is incredible.',
          date: DateTime(2024, 1, 1),
        ),
      ],
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    ),
    Bike(
      id: '2',
      name: 'BMW S1000RR',
      brand: 'BMW',
      price: 18995.0,
      category: 'Sport',
      imageUrl: 'assets/motorcycles/bmw_s1000rr.jpg',
      description: 'The BMW S1000RR is a high-performance sport bike with advanced electronics.',
      specifications: const BikeSpecifications(
        engine: '999cc Inline-4',
        power: '205 hp',
        torque: '83 lb-ft',
        transmission: '6-speed',
        weight: '434 lbs',
        fuelCapacity: '4.4 gallons',
      ),
      stock: 8,
      isFeatured: true,
      rating: 4.7,
      reviews: [],
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    ),
    Bike(
      id: '3',
      name: 'Kawasaki H2',
      brand: 'Kawasaki',
      price: 32000.0,
      category: 'Sport',
      imageUrl: 'assets/motorcycles/kawasaki_h2.jpg',
      description: 'The Kawasaki H2 is a supercharged sport bike with incredible power.',
      specifications: const BikeSpecifications(
        engine: '998cc Supercharged Inline-4',
        power: '310 hp',
        torque: '165 lb-ft',
        transmission: '6-speed',
        weight: '476 lbs',
        fuelCapacity: '4.5 gallons',
      ),
      stock: 3,
      isFeatured: true,
      rating: 4.9,
      reviews: [],
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    ),
    Bike(
      id: '4',
      name: 'Yamaha R1',
      brand: 'Yamaha',
      price: 17499.0,
      category: 'Sport',
      imageUrl: 'assets/motorcycles/yamaha_r1.jpg',
      description: 'The Yamaha R1 is a track-focused sport bike with MotoGP technology.',
      specifications: const BikeSpecifications(
        engine: '998cc Crossplane Inline-4',
        power: '200 hp',
        torque: '83 lb-ft',
        transmission: '6-speed',
        weight: '448 lbs',
        fuelCapacity: '4.5 gallons',
      ),
      stock: 6,
      isFeatured: false,
      rating: 4.6,
      reviews: [],
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    ),
  ];

  @override
  Future<List<Bike>> getAllBikes() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockBikes;
  }

  @override
  Future<List<Bike>> getFeaturedBikes() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockBikes.where((bike) => bike.isFeatured).toList();
  }

  @override
  Future<Bike> getBikeById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final bike = _mockBikes.firstWhere((bike) => bike.id == id);
    return bike;
  }

  @override
  Future<List<Bike>> getBikesByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockBikes.where((bike) => bike.category == category).toList();
  }

  @override
  Future<Bike> createBike(Bike bike) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // In a real implementation, this would save to the backend
    return bike;
  }

  @override
  Future<Bike> updateBike(String id, Bike bike) async {
    await Future.delayed(const Duration(milliseconds: 400));
    // In a real implementation, this would update the backend
    return bike;
  }

  @override
  Future<void> deleteBike(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // In a real implementation, this would delete from the backend
  }

  @override
  Future<Bike> addReview(String bikeId, Review review) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final bikeIndex = _mockBikes.indexWhere((bike) => bike.id == bikeId);
    if (bikeIndex != -1) {
      final bike = _mockBikes[bikeIndex];
      final updatedReviews = List<Review>.from(bike.reviews)..add(review);
      final updatedBike = bike.copyWith(reviews: updatedReviews);
      _mockBikes[bikeIndex] = updatedBike;
      return updatedBike;
    }
    throw Exception('Bike not found');
  }
} 