import 'package:injectable/injectable.dart';
import 'package:riders_choice/features/bikes/domain/entities/bike.dart';
import '../../domain/repositories/bike_repository.dart';
import '../../../../core/services/bike_api_service.dart';

@Injectable(as: BikeRepository)
class BikeRepositoryImpl implements BikeRepository {
  final BikeApiService _apiService;

  BikeRepositoryImpl(this._apiService);

  @override
  Future<List<Bike>> getAllBikes() async {
    return await _apiService.getAllBikes();
  }

  @override
  Future<List<Bike>> getFeaturedBikes() async {
    return await _apiService.getFeaturedBikes();
  }

  @override
  Future<Bike> getBikeById(String id) async {
    final bike = await _apiService.getBikeById(id);
    if (bike == null) throw Exception('Bike not found');
    return bike;
  }

  @override
  Future<List<Bike>> getBikesByCategory(String category) async {
    return await _apiService.getBikesByCategory(category);
  }

  @override
  Future<Bike> createBike(Bike bike) async {
    throw UnimplementedError();
  }

  @override
  Future<Bike> updateBike(String id, Bike bike) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteBike(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<Bike> addReview(String bikeId, Review review) async {
    throw UnimplementedError();
  }
} 