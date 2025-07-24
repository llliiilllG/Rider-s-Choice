import 'package:injectable/injectable.dart';
import '../entities/bike.dart';
import '../repositories/bike_repository.dart';

@injectable
class GetBikesUseCase {
  final BikeRepository _bikeRepository;

  GetBikesUseCase(this._bikeRepository);

  Future<List<Bike>> call() async {
    return await _bikeRepository.getAllBikes();
  }
} 