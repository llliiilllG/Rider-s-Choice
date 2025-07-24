import 'package:injectable/injectable.dart';
import '../entities/bike.dart';
import '../repositories/bike_repository.dart';

@injectable
class GetFeaturedBikesUseCase {
  final BikeRepository _bikeRepository;

  GetFeaturedBikesUseCase(this._bikeRepository);

  Future<List<Bike>> call() async {
    return await _bikeRepository.getFeaturedBikes();
  }
} 