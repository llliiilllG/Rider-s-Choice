import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:riders_choice/features/bikes/domain/entities/bike.dart';
import '../../domain/usecases/get_bikes_usecase.dart';
import '../../domain/usecases/get_featured_bikes_usecase.dart';

enum BikesState { initial, loading, loaded, error }

class BikesViewModel extends ChangeNotifier {
  final GetBikesUseCase _getBikesUseCase;
  final GetFeaturedBikesUseCase _getFeaturedBikesUseCase;

  BikesViewModel(this._getBikesUseCase, this._getFeaturedBikesUseCase);

  BikesState _state = BikesState.initial;
  List<Bike> _bikes = [];
  List<Bike> _featuredBikes = [];
  String? _errorMessage;
  bool _isLoading = false;

  // Getters
  BikesState get state => _state;
  List<Bike> get bikes => _bikes;
  List<Bike> get featuredBikes => _featuredBikes;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  // Load all bikes
  Future<void> loadBikes() async {
    _setLoading(true);
    _clearError();

    try {
      final bikes = await _getBikesUseCase();
      _bikes = bikes;
      _state = BikesState.loaded;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Load featured bikes
  Future<void> loadFeaturedBikes() async {
    _setLoading(true);
    _clearError();

    try {
      final featuredBikes = await _getFeaturedBikesUseCase();
      _featuredBikes = featuredBikes;
      _state = BikesState.loaded;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Get bike by id
  Bike? getBikeById(String id) {
    try {
      return _bikes.firstWhere((bike) => bike.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get bikes by category
  List<Bike> getBikesByCategory(String category) {
    return _bikes.where((bike) => bike.category == category).toList();
  }

  // Search bikes
  List<Bike> searchBikes(String query) {
    if (query.isEmpty) return _bikes;
    
    return _bikes.where((bike) =>
        bike.name.toLowerCase().contains(query.toLowerCase()) ||
        bike.brand.toLowerCase().contains(query.toLowerCase()) ||
        bike.category.toLowerCase().contains(query.toLowerCase())).toList();
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    if (loading) {
      _state = BikesState.loading;
    }
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    _state = BikesState.error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
} 