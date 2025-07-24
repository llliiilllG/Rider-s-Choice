import '../entities/bike.dart';

abstract class BikeRepository {
  Future<List<Bike>> getAllBikes();
  Future<List<Bike>> getFeaturedBikes();
  Future<Bike> getBikeById(String id);
  Future<List<Bike>> getBikesByCategory(String category);
  Future<Bike> createBike(Bike bike);
  Future<Bike> updateBike(String id, Bike bike);
  Future<void> deleteBike(String id);
  Future<Bike> addReview(String bikeId, Review review);
} 